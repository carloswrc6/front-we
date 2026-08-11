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
    final historyAsync = ref.watch(historyProvider);

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
                        speed: wheelState.speed,
                        difficultyEasy: wheelState.difficultyEasy,
                        difficultyMedium: wheelState.difficultyMedium,
                        difficultyHard: wheelState.difficultyHard,
                        surpriseMode: wheelState.surpriseMode,
                        avoidRepeat: wheelState.avoidRepeat,
                        avoidThreeDays: wheelState.avoidThreeDays,
                        healthyMode: wheelState.healthyMode,
                        prioritizeFavorites: wheelState.prioritizeFavorites,
                        showFavorites: wheelState.showFavorites,
                      );
                    }
                  });
                }
              }
              final filtered = _filter(dishes, wheelState);
              final extraFavs = wheelState.showFavorites
                  ? dishes
                        .where(
                          (d) =>
                              d.isFavorite &&
                              !filtered.any((f) => f.id == d.id),
                        )
                        .toList()
                  : <Dish>[];
              final filteredByFav = [...filtered, ...extraFavs];
              if (wheelState.surpriseMode) {
                debugPrint('[SurpriseMode] ACTIVO - ignorando filtros de pais y mealType, total=${filtered.length}');
              }
              final history = historyAsync.valueOrNull ?? [];
              final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
              debugPrint('[ThreeDaysFilter] total history entries: ${history.length}');
              debugPrint('[ThreeDaysFilter] threeDaysAgo: ${threeDaysAgo.toIso8601String()}');
              final recentEntries = wheelState.avoidThreeDays
                  ? history.where((h) => h.fromSpin && h.selectedAt.isAfter(threeDaysAgo)).toList()
                  : [];
              debugPrint('[ThreeDaysFilter] recent spin entries (last 3 days): ${recentEntries.length}');
              for (final e in recentEntries) {
                debugPrint('[ThreeDaysFilter]   -> dishId=${e.dishId} dishName=${e.dishName} selectedAt=${e.selectedAt.toIso8601String()}');
              }
              final recentIds = recentEntries.map((h) => h.dishId).toSet();
              debugPrint('[ThreeDaysFilter] unique dishIds to exclude: $recentIds');
              final wheelList = recentIds.isNotEmpty
                  ? filteredByFav.where((d) => !recentIds.contains(d.id)).toList()
                  : filteredByFav;
              debugPrint('[ThreeDaysFilter] filtered count (antes de exclusion): ${filtered.length}');
              debugPrint('[ThreeDaysFilter] filtered count (despues de exclusion): ${wheelList.length}');
              debugPrint('[ThreeDaysFilter] IDs excluidos: ${filteredByFav.where((d) => recentIds.contains(d.id)).map((d) => "${d.id} - ${d.name}").toList()}');
              final effectiveWheel = wheelList.isNotEmpty ? wheelList : filteredByFav;
              if (wheelList.isEmpty && wheelState.avoidThreeDays) {
                debugPrint('[ThreeDaysFilter] ATENCION: no quedan platos, se usa la lista completa (fallback)');
              }
              final lastSpinEntry = history.where((h) => h.fromSpin).toList();
              final lastDishId = lastSpinEntry.isNotEmpty ? lastSpinEntry.first.dishId : null;
              final afterAvoidRepeat = wheelState.avoidRepeat && lastDishId != null
                  ? effectiveWheel.where((d) => d.id != lastDishId).toList()
                  : effectiveWheel;
              if (wheelState.avoidRepeat && lastDishId != null) {
                debugPrint('[AvoidRepeat] activo, excluyendo dishId=$lastDishId, antes=${effectiveWheel.length} despues=${afterAvoidRepeat.length}');
              }
              final finalWheel = afterAvoidRepeat.isNotEmpty ? afterAvoidRepeat : effectiveWheel;
              final sortedWheel = wheelState.prioritizeFavorites
                  ? _prioritizeFavoritesList(finalWheel)
                  : finalWheel;
              debugPrint('[PrioritizeFavorites] enabled=${wheelState.prioritizeFavorites} total=${sortedWheel.length} favorites=${sortedWheel.where((d) => d.isFavorite).length}');
              if (sortedWheel.length == 1) {
                _selectedDish ??= sortedWheel.first;
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
                            speed: wheelState.speed,
                            difficultyEasy: wheelState.difficultyEasy,
                            difficultyMedium: wheelState.difficultyMedium,
                            difficultyHard: wheelState.difficultyHard,
                            surpriseMode: wheelState.surpriseMode,
                            avoidRepeat: wheelState.avoidRepeat,
                            avoidThreeDays: wheelState.avoidThreeDays,
                            healthyMode: wheelState.healthyMode,
                            prioritizeFavorites: wheelState.prioritizeFavorites,
                            showFavorites: wheelState.showFavorites,
                          );
                        },
                        rightAligned: true,
                        menuWidth: 200,
                      ),
                      bottomChild: DishFilterBar(
                        selectedMealType: wheelState.selectedMealType,
                        dishCount: sortedWheel.length,
                        showFavorites: wheelState.showFavorites,
                        onFavoritesChanged: () {
                          ref.read(wheelStateProvider.notifier).state = WheelState(
                            selectedMealType: wheelState.selectedMealType,
                            selectedCountryId: wheelState.selectedCountryId,
                            speed: wheelState.speed,
                            difficultyEasy: wheelState.difficultyEasy,
                            difficultyMedium: wheelState.difficultyMedium,
                            difficultyHard: wheelState.difficultyHard,
                            surpriseMode: wheelState.surpriseMode,
                            avoidRepeat: wheelState.avoidRepeat,
                            avoidThreeDays: wheelState.avoidThreeDays,
                            healthyMode: wheelState.healthyMode,
                            prioritizeFavorites: wheelState.prioritizeFavorites,
                            showFavorites: !wheelState.showFavorites,
                          );
                        },
                        onMealTypeChanged: (v) {
                          setState(() => _selectedDish = null);
                          ref.read(wheelStateProvider.notifier).state = WheelState(
                            selectedMealType: v,
                            selectedCountryId: wheelState.selectedCountryId,
                            speed: wheelState.speed,
                            difficultyEasy: wheelState.difficultyEasy,
                            difficultyMedium: wheelState.difficultyMedium,
                            difficultyHard: wheelState.difficultyHard,
                            surpriseMode: wheelState.surpriseMode,
                            avoidRepeat: wheelState.avoidRepeat,
                            avoidThreeDays: wheelState.avoidThreeDays,
                            healthyMode: wheelState.healthyMode,
                            prioritizeFavorites: wheelState.prioritizeFavorites,
                            showFavorites: wheelState.showFavorites,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: DishWheel(
                        dishes: sortedWheel,
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
                        onCustomize: () => WheelSettingsSheet.show(
                          context,
                          initialSpeed: wheelState.speed,
                          initialDifficultyEasy: wheelState.difficultyEasy,
                          initialDifficultyMedium: wheelState.difficultyMedium,
                          initialDifficultyHard: wheelState.difficultyHard,
                          initialAvoidRepeat: wheelState.avoidRepeat,
                          initialAvoidThreeDays: wheelState.avoidThreeDays,
                          initialPrioritizeFavorites: wheelState.prioritizeFavorites,
                          initialSurpriseMode: wheelState.surpriseMode,
                          initialHealthyMode: wheelState.healthyMode,
                          onApply: ({
                            required speed,
                            required difficultyEasy,
                            required difficultyMedium,
                            required difficultyHard,
                            required surpriseMode,
                            required avoidRepeat,
                            required avoidThreeDays,
                            required healthyMode,
                            required prioritizeFavorites,
                          }) {
                            ref.read(wheelStateProvider.notifier).state = WheelState(
                              selectedCountryId: wheelState.selectedCountryId,
                              selectedMealType: wheelState.selectedMealType,
                              speed: speed,
                              difficultyEasy: difficultyEasy,
                              difficultyMedium: difficultyMedium,
                              difficultyHard: difficultyHard,
                              surpriseMode: surpriseMode,
                              avoidRepeat: avoidRepeat,
                              avoidThreeDays: avoidThreeDays,
                              healthyMode: healthyMode,
                              prioritizeFavorites: prioritizeFavorites,
                              showFavorites: wheelState.showFavorites,
                            );
                          },
                        ),
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
      if (!state.surpriseMode) {
        if (state.selectedCountryId != null && d.country.id != state.selectedCountryId) {
          return false;
        }
        if (state.selectedMealType != null && d.mealType != state.selectedMealType) {
          return false;
        }
      }
      if (state.healthyMode && !d.isHealthy) return false;
      if (d.difficulty != null) {
        if (!state.difficultyEasy && d.difficulty == 'easy') return false;
        if (!state.difficultyMedium && d.difficulty == 'medium') return false;
        if (!state.difficultyHard && d.difficulty == 'hard') return false;
      }
      return true;
    }).toList();
  }

  List<Dish> _prioritizeFavoritesList(List<Dish> dishes) {
    final favorites = dishes.where((d) => d.isFavorite).toList();
    final others = dishes.where((d) => !d.isFavorite).toList();
    return [...favorites, ...others];
  }
}
