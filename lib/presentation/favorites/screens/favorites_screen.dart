import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/dishes/widgets/filter_bar.dart';
import 'package:frontwe/presentation/dishes/widgets/double_tap_favorite_image.dart';
import 'package:frontwe/presentation/shared/widgets/BottomNavBar.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<Dish> _dishes = [];
  final Set<String> _removingIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final favoritesAsync = ref.watch(favoriteDishesProvider);
    final countriesAsync = ref.watch(localCountriesProvider);

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(t.favoritosTitle)),
      bottomNavigationBar: const BottomNavBar(),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('$err')),
        data: (dishes) {
          _dishes = dishes;
          _removingIds.removeWhere((id) => !_dishes.any((d) => d.id == id));

          final filtered = _dishes.where((d) {
            if (_searchQuery.isEmpty) return true;
            return d.name.toLowerCase().contains(_searchQuery);
          }).toList();

          return countriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (countries) {
              return Column(
                children: [
                  FilterContainer(
                    topChild: TextField(
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
                    bottomChild: const SizedBox.shrink(),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _searchQuery.isNotEmpty ? Icons.search_off : Icons.favorite_border,
                                  size: 64,
                                  color: cs.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty ? t.filterEmpty : t.favoritosEmpty,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final dish = filtered[index];
                              final isRemoving = _removingIds.contains(dish.id);
                              final dishCountry = countries.where((c) => c.id == dish.country.id).firstOrNull;

                              return AnimatedOpacity(
                                duration: const Duration(milliseconds: 400),
                                opacity: isRemoving ? 0.0 : 1.0,
                                child: _buildCard(dish, dishCountry, cs, t),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCard(Dish dish, Country? dishCountry, ColorScheme cs, AppLocalizations t) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: FavoriteDoubleTapImage(
              onDoubleTap: () => _toggleFavorite(dish),
              child: _dishImage(dish, cs),
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
                          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 20,
                          color: Theme.of(context).colorScheme.onError,
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
    );
  }

  Future<void> _toggleFavorite(Dish dish) async {
    setState(() => _removingIds.add(dish.id));

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    await ref.read(dishRepositoryProvider).toggleFavorite(dish.id);
    ref.invalidate(localDishesProvider);
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

  Widget _dishImage(Dish dish, ColorScheme cs) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (dish.image.isEmpty)
          _imagePlaceholder(cs)
        else
          Image.network(
            dish.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _imagePlaceholder(cs),
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

String _codeToFlag(String code) {
  return code.toUpperCase().split('').map((c) {
    return String.fromCharCode(c.codeUnitAt(0) - 0x41 + 0x1F1E6);
  }).join('');
}
