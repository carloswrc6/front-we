import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/dishes/screens/dish_list_screen.dart';
import 'package:frontwe/presentation/dishes/widgets/filter_bar.dart';
import 'package:frontwe/presentation/dishes/widgets/dish_wheel.dart';
import 'package:frontwe/presentation/dishes/widgets/skeleton/screen_skeleton.dart';
import 'package:frontwe/infrastructure/services/local_db_service.dart';
import 'package:frontwe/presentation/history/providers/history_provider.dart';
import 'package:frontwe/presentation/shared/widgets/BottomNavBar.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:frontwe/presentation/shared/widgets/CountrySelector.dart';
import 'package:frontwe/presentation/dishes/widgets/wheel_settings_sheet.dart';


class DishesScreen extends ConsumerStatefulWidget {
  static const int maxWheelItems = 4;
  const DishesScreen({super.key});

  @override
  ConsumerState<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends ConsumerState<DishesScreen> {
  Dish? _selectedDish;
  bool _fromSpin = false;
  bool _defaultsInitialized = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final dishesAsync = ref.watch(localDishesProvider);
    final countriesAsync = ref.watch(localCountriesProvider);
    final wheelState = ref.watch(wheelStateProvider);

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(t.menuWheel)),
      bottomNavigationBar: const BottomNavBar(),
      // body: const DishesScreenSkeleton(),
      body: dishesAsync.when(
        loading: () => const DishesScreenSkeleton(),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('${t.errorLabel}: $err'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.invalidate(localDishesProvider),
                icon: const Icon(Icons.refresh),
                label: Text(t.retryButton),
              ),
            ],
          ),
        ),
        data: (dishes) {
          if (dishes.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.dishesEmpty,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
          return countriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (countries) {
              if (!_defaultsInitialized && wheelState.selectedCountryId == null) {
                _defaultsInitialized = true;
                final peru = countries.where((c) => c.code == 'PE').firstOrNull;
                if (peru != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      ref.read(wheelStateProvider.notifier).state = WheelState(
                        selectedMealType: wheelState.selectedMealType,
                        selectedCountryId: peru.id,
                      );
                    }
                  });
                }
              }
              final filtered = _filter(dishes, wheelState);
              if (filtered.length == 1) {
                _selectedDish ??= filtered.first;
              }
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(localDishesProvider);
                  await ref.read(localDishesProvider.future);
                },
                child: Column(
                  children: [
                    FilterContainer(
                      topChild: CountrySelector(
                        horizontalPadding: 12,
                        showAll: true,
                        countries: countries,
                        selectedCountryId: wheelState.selectedCountryId,
                        onChanged: (v) {
                          setState(() => _selectedDish = null);
                          ref.read(wheelStateProvider.notifier).state = WheelState(
                            selectedMealType: wheelState.selectedMealType,
                            selectedCountryId: v,
                          );
                        },
                        rightAligned: true,
                        menuWidth: 200,
                      ),
                      bottomChild: DishFilterBar(
                        selectedMealType: wheelState.selectedMealType,
                        dishCount: filtered.length,
                        onMealTypeChanged: (v) {
                          setState(() => _selectedDish = null);
                          ref.read(wheelStateProvider.notifier).state = WheelState(
                            selectedMealType: v,
                            selectedCountryId: wheelState.selectedCountryId,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: DishWheel(
                        dishes: filtered,
                        maxWheelItems: DishesScreen.maxWheelItems,
                        selectedDish: _selectedDish,
                        fromSpin: _fromSpin,
                        onSpinResult: (dish) {
                          setState(() {
                            _fromSpin = true;
                            _selectedDish = dish;
                          });
                          _saveToHistory(dish, true, countries);
                        },
                        onTapResult: (dish) {
                          setState(() {
                            _fromSpin = false;
                            _selectedDish = dish;
                          });
                          if (dish != null) _saveToHistory(dish, false, countries);
                        },
                        onSpinStart: () => setState(() {
                          _selectedDish = null;
                        }),
                        onViewList: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DishListScreen(
                                dishes: filtered,
                                title: '${t.menuDishes} (${filtered.length})',
                              ),
                            ),
                          );
                        },
                        onCustomize: () => WheelSettingsSheet.show(context),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _saveToHistory(Dish dish, bool fromSpin, List<Country> countries) async {
    final country = countries.where((c) => c.id == dish.country.id).firstOrNull;
    final code = country?.code ?? dish.country.code;
    final name = country?.name ?? dish.country.name;
    await LocalDbService.instance.insertHistory({
      'dish_id': dish.id,
      'dish_name': dish.name,
      'dish_image': dish.image,
      'meal_type': dish.mealType,
      'country_id': dish.country.id,
      'country_code': code,
      'country_name': name,
      'ingredients': dish.ingredients.join('||'),
      'from_spin': fromSpin ? 1 : 0,
      'selected_at': DateTime.now().toIso8601String(),
    });
    ref.invalidate(historyProvider);
  }

  List<Dish> _filter(List<Dish> dishes, WheelState state) {
    return dishes.where((d) {
      if (state.selectedCountryId != null && d.country.id != state.selectedCountryId) {
        return false;
      }
      if (state.selectedMealType != null && d.mealType != state.selectedMealType) {
        return false;
      }
      return true;
    }).toList();
  }
}
