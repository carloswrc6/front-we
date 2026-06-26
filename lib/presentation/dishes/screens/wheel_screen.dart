import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/dishes/screens/dish_list_screen.dart';
import 'package:frontwe/presentation/dishes/widgets/filter_bar.dart';
import 'package:frontwe/presentation/dishes/widgets/dish_wheel.dart';
import 'package:frontwe/presentation/dishes/widgets/skeleton/screen_skeleton.dart';
import 'package:frontwe/presentation/shared/widgets/BottomNavBar.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:frontwe/presentation/shared/widgets/country_selector.dart';


class DishesScreen extends ConsumerStatefulWidget {
  static const int maxWheelItems = 4;
  const DishesScreen({super.key});

  @override
  ConsumerState<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends ConsumerState<DishesScreen> {
  String? _selectedCountryId;
  String? _selectedMealType;
  Dish? _selectedDish;
  bool _defaultsInitialized = false;
  bool _fromSpin = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final dishesAsync = ref.watch(localDishesProvider);
    final countriesAsync = ref.watch(localCountriesProvider);

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(t.menuDishes)),
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
              if (!_defaultsInitialized) {
                _defaultsInitialized = true;
                _selectedMealType = 'lunch';
                final peru = countries.where((c) => c.code == 'PE').firstOrNull;
                if (peru != null) _selectedCountryId = peru.id;
              }
              final filtered = _filter(dishes);
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
                        showAll: true,
                        countries: countries,
                        selectedCountryId: _selectedCountryId,
                        onChanged: (v) => setState(() {
                          _selectedCountryId = v;
                          _selectedDish = null;
                        }),
                      ),
                      bottomChild: DishFilterBar(
                        selectedMealType: _selectedMealType,
                        dishCount: filtered.length,
                        onMealTypeChanged: (v) => setState(() {
                          _selectedMealType = v;
                          _selectedDish = null;
                        }),
                      ),
                    ),
                    Expanded(
                      child: DishWheel(
                        dishes: filtered,
                        maxWheelItems: DishesScreen.maxWheelItems,
                        selectedDish: _selectedDish,
                        fromSpin: _fromSpin,
                        onSpinResult: (dish) => setState(() {
                          _fromSpin = true;
                          _selectedDish = dish;
                        }),
                        onTapResult: (dish) => setState(() {
                          _fromSpin = false;
                          _selectedDish = dish;
                        }),
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

  List<Dish> _filter(List<Dish> dishes) {
    return dishes.where((d) {
      if (_selectedCountryId != null && d.country.id != _selectedCountryId) {
        return false;
      }
      if (_selectedMealType != null && d.mealType != _selectedMealType) {
        return false;
      }
      return true;
    }).toList();
  }
}
