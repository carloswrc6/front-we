import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/dishes/widgets/filter_bar.dart';
import 'package:frontwe/presentation/dishes/widgets/double_tap_favorite_image.dart';
import 'package:frontwe/presentation/shared/widgets/avoid_reason_dialog.dart';
import 'package:frontwe/presentation/shared/providers/avoid_reason_provider.dart';
import 'package:frontwe/presentation/shared/widgets/BottomNavBar.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:frontwe/presentation/shared/widgets/CountrySelector.dart';
import 'package:go_router/go_router.dart';

String _codeToFlag(String code) {
  return code.toUpperCase().split('').map((c) {
    return String.fromCharCode(c.codeUnitAt(0) - 0x41 + 0x1F1E6);
  }).join('');
}


class PlatosScreen extends ConsumerStatefulWidget {
  const PlatosScreen({super.key});

  @override
  ConsumerState<PlatosScreen> createState() => _PlatosScreenState();
}

class _PlatosScreenState extends ConsumerState<PlatosScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  List<String> _customReasons = [];
  bool _sugerenciasExpanded = true;
  bool _tusMotivosExpanded = true;

  @override
  void initState() {
    super.initState();
    _loadCustomReasons();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final dishesAsync = ref.watch(localDishesProvider);
    final countriesAsync = ref.watch(localCountriesProvider);
    final filterState = ref.watch(dishesFilterProvider);
    ref.watch(avoidReasonsProvider);

    return dishesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('$err')),
      data: (dishes) {
        return Scaffold(
          drawer: const SideMenu(),
          appBar: AppBar(title: Text(t.platosTitle)),
          floatingActionButton: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primary,
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => context.push('/crear-plato'),
                    icon: const Icon(Icons.add),
                    color: cs.onPrimary,
                    tooltip: 'Add dish',
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: const BottomNavBar(),
          body: countriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (countries) {
              final filtered = _filter(dishes, filterState.selectedCountryId, filterState.selectedMealType).where((d) {
                if (_searchQuery.isEmpty) return true;
                return d.name.toLowerCase().contains(_searchQuery);
              }).toList();

              return Column(
                children: [
                  FilterContainer(
                    topChild: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: t.searchDishes,
                              prefixIcon: const Icon(Icons.search, size: 20),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: cs.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              isDense: true,
                            ),
                            onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: CountrySelector(
                            compact: true,
                            showAll: true,
                            countries: countries,
                            selectedCountryId: filterState.selectedCountryId,
                            onChanged: (v) => ref.read(dishesFilterProvider.notifier).state = DishesFilterState(
                    selectedCountryId: v,
                    selectedMealType: filterState.selectedMealType,
                  ),
                          ),
                        ),
                      ],
                    ),
                    bottomChild: DishFilterBar(
                      selectedMealType: filterState.selectedMealType,
                      dishCount: filtered.length,
                      onMealTypeChanged: (v) => ref.read(dishesFilterProvider.notifier).state = DishesFilterState(
                        selectedCountryId: filterState.selectedCountryId,
                        selectedMealType: v,
                      ),
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off, size: 48, color: cs.onSurfaceVariant),
                                const SizedBox(height: 8),
                                Text(t.filterEmpty, style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final dish = filtered[index];
                              final dishCountry = countries.where((c) => c.id == dish.country.id).firstOrNull;
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: FavoriteDoubleTapImage(
                                          onDoubleTap: () => _toggleFavorite(dish),
                                          child: _dishImage(dish, cs, t),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dish.name,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(_codeToFlag(dishCountry?.code ?? ''), style: const TextStyle(fontSize: 20)),
                                                const SizedBox(width: 6),
                                                Icon(_mealTypeIcon(dish.mealType), size: 16, color: cs.onSurfaceVariant),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    '${_mealTypeLabel(t, dish.mealType)} · ${dishCountry?.name ?? dish.country.name}',
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      color: cs.onSurfaceVariant,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () => _toggleFavorite(dish),
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: dish.isFavorite
                                                          ? Theme.of(context).colorScheme.error.withValues(alpha: 0.85)
                                                          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Icon(
                                                      dish.isFavorite ? Icons.favorite : Icons.favorite_border,
                                                      size: 20,
                                                      color: dish.isFavorite ? Theme.of(context).colorScheme.onError : Theme.of(context).colorScheme.outline,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                InkWell(
                                                  onTap: () => _toggleAvoided(dish),
                                                  onLongPress: () => _showAvoidReasonDialog(dish),
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: dish.isAvoided
                                                          ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.85)
                                                          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Icon(
                                                      dish.isAvoided ? Icons.thumb_down : Icons.thumb_down_outlined,
                                                      size: 20,
                                                      color: dish.isAvoided ? Theme.of(context).colorScheme.onTertiary : Theme.of(context).colorScheme.outline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  List<Dish> _filter(List<Dish> dishes, String? countryId, String? mealType) {
    return dishes.where((d) {
      if (countryId != null && d.country.id != countryId) {
        return false;
      }
      if (mealType != null && d.mealType != mealType) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _toggleFavorite(Dish dish) async {
    await ref.read(dishRepositoryProvider).toggleFavorite(dish.id);
    ref.invalidate(localDishesProvider);
  }

  Future<void> _toggleAvoided(Dish dish) async {
    await ref.read(dishRepositoryProvider).toggleAvoided(dish.id);
    ref.invalidate(localDishesProvider);
  }

  Future<void> _showAvoidReasonDialog(Dish dish) async {
    final repo = ref.read(dishRepositoryProvider);
    final apiReasonsAsync = ref.read(avoidReasonsProvider);
    final apiReasons = apiReasonsAsync.whenOrNull(
      data: (list) => list.map((m) => AvoidReason(m.key, m.label, m.description)).toList(),
    );
    final reason = await showAvoidReasonDialog(
      context,
      initialReason: dish.avoidReason,
      predefined: apiReasons ?? [],
      customReasons: _customReasons,
      onSaveCustomReason: (label) => repo.saveCustomAvoidReason(label),
      sugerenciasExpanded: _sugerenciasExpanded,
      tusMotivosExpanded: _tusMotivosExpanded,
      onSugerenciasExpandedChanged: (v) => _sugerenciasExpanded = v,
      onTusMotivosExpandedChanged: (v) => _tusMotivosExpanded = v,
    );
    if (reason != null) {
      if (!dish.isAvoided) {
        await repo.toggleAvoided(dish.id);
      }
      await repo.setAvoidReason(
        dish.id,
        reason == '__clear__' ? null : reason,
      );
      ref.invalidate(localDishesProvider);
    }
    _loadCustomReasons();
  }

  Future<void> _loadCustomReasons() async {
    final reasons = await ref.read(dishRepositoryProvider).getCustomAvoidReasons();
    if (mounted) setState(() => _customReasons = reasons);
  }

  String _mealTypeLabel(AppLocalizations t, String mealType) {
    switch (mealType) {
      case 'breakfast':
        return t.mealTypeBreakfast;
      case 'lunch':
        return t.mealTypeLunch;
      case 'dinner':
        return t.mealTypeDinner;
      default:
        return mealType;
    }
  }

  IconData _mealTypeIcon(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.restaurant;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  Widget _dishImage(Dish dish, ColorScheme cs, AppLocalizations t) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (dish.image.isEmpty)
          _imagePlaceholder(cs)
        else
          Image.network(
            dish.image,
            fit: BoxFit.cover,
            errorBuilder: (_, error, __) {
              debugPrint('[dishes_screen] image error for ${dish.name}: $error');
              return _imagePlaceholder(cs);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: cs.surfaceContainerHigh,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        if (dish.isUserCreated)
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 11, color: Colors.white70),
                  const SizedBox(width: 3),
                  Text(
                    t.youLabel,
                    style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _imagePlaceholder(ColorScheme cs) {
    return Container(
      color: cs.surfaceContainerHigh,
      child: Center(
        child: Icon(Icons.restaurant, size: 48, color: cs.onSurfaceVariant),
      ),
    );
  }
}
