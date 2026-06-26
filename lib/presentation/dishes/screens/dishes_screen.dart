import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/dishes/widgets/detail_sheet.dart';
import 'package:frontwe/presentation/shared/widgets/BottomNavBar.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';

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

              final mealTypes = ['breakfast', 'lunch', 'dinner'];
              final mealTypeIcons = <String, IconData>{
                'breakfast': Icons.free_breakfast,
                'lunch': Icons.restaurant,
                'dinner': Icons.dinner_dining,
              };

              return Column(
                children: [
                  _FilterHeader(
                    cs: cs,
                    t: t,
                    countries: countries,
                    searchController: _searchController,
                    selectedCountryId: _selectedCountryId,
                    selectedMealType: _selectedMealType,
                    mealTypes: mealTypes,
                    mealTypeIcons: mealTypeIcons,
                    dishCount: filtered.length,
                    onSearchChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                    onCountryChanged: (v) => setState(() => _selectedCountryId = v),
                    onMealTypeChanged: (v) => setState(() => _selectedMealType = v),
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

class _FilterHeader extends StatelessWidget {
  final ColorScheme cs;
  final AppLocalizations t;
  final List<Country> countries;
  final TextEditingController searchController;
  final String? selectedCountryId;
  final String? selectedMealType;
  final List<String> mealTypes;
  final Map<String, IconData> mealTypeIcons;
  final int dishCount;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onMealTypeChanged;

  const _FilterHeader({
    required this.cs,
    required this.t,
    required this.countries,
    required this.searchController,
    required this.selectedCountryId,
    required this.selectedMealType,
    required this.mealTypes,
    required this.mealTypeIcons,
    required this.dishCount,
    required this.onSearchChanged,
    required this.onCountryChanged,
    required this.onMealTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  controller: searchController,
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
                  onChanged: onSearchChanged,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCountryId,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    hint: Text(t.filterCountry, style: const TextStyle(fontSize: 13)),
                    icon: const Icon(Icons.expand_more, size: 18),
                    items: [
                      DropdownMenuItem(value: null, child: Text(t.filterAll, style: const TextStyle(fontSize: 13))),
                      ...countries.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name, style: const TextStyle(fontSize: 13)),
                      )),
                    ],
                    onChanged: onCountryChanged,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 6,
                    children: mealTypes.map((mt) {
                      final selected = selectedMealType == mt;
                      return FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(mealTypeIcons[mt], size: 14),
                            const SizedBox(width: 4),
                            Text(_mealTypeLabel(mt), style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        selected: selected,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onSelected: (_) => onMealTypeChanged(selected ? null : mt),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$dishCount',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cs.onPrimaryContainer),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _mealTypeLabel(String mealType) {
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
}
