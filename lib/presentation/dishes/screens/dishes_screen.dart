import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/dishes/widgets/detail_sheet.dart';
import 'package:frontwe/presentation/dishes/widgets/filter_bar.dart';
import 'package:frontwe/presentation/shared/widgets/BottomNavBar.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:frontwe/presentation/shared/widgets/country_selector.dart';

class PlatosScreen extends ConsumerStatefulWidget {
  const PlatosScreen({super.key});

  @override
  ConsumerState<PlatosScreen> createState() => _PlatosScreenState();
}

class _PlatosScreenState extends ConsumerState<PlatosScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCountryId;
  String? _selectedMealType;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final dishesAsync = ref.watch(localDishesProvider);
    final countriesAsync = ref.watch(localCountriesProvider);

    return dishesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('$err')),
      data: (dishes) {
        return Scaffold(
          drawer: const SideMenu(),
          appBar: AppBar(title: Text(t.platosTitle)),
          bottomNavigationBar: const BottomNavBar(),
          body: countriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (countries) {
              final filtered = _filter(dishes).where((d) {
                if (_searchQuery.isEmpty) return true;
                return d.name.toLowerCase().contains(_searchQuery);
              }).toList();

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow,
                      border: Border(bottom: BorderSide(color: cs.outlineVariant, width: 0.5)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: t.searchDishes,
                                  prefixIcon: const Icon(Icons.search, size: 20),
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
                              flex: 2,
                              child: CountrySelector(
                                showAll: true,
                                countries: countries,
                                selectedCountryId: _selectedCountryId,
                                onChanged: (v) => setState(() => _selectedCountryId = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        DishFilterBar(
                          selectedMealType: _selectedMealType,
                          dishCount: filtered.length,
                          onMealTypeChanged: (v) => setState(() => _selectedMealType = v),
                        ),
                      ],
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
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () => DishDetailSheet.show(context, dish),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: _dishImage(dish, cs),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                        child: Row(
                                          children: [
                                            Expanded(
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
                                                  Text(
                                                    dish.country.name,
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      color: cs.onSurfaceVariant,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
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

  Widget _dishImage(Dish dish, ColorScheme cs) {
    if (dish.image.isEmpty) {
      return Container(
        color: cs.surfaceContainerHigh,
        child: Center(
          child: Icon(Icons.restaurant, size: 48, color: cs.onSurfaceVariant),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          dish.image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: cs.surfaceContainerHigh,
            child: Center(
              child: Icon(Icons.restaurant, size: 48, color: cs.onSurfaceVariant),
            ),
          ),
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
}
