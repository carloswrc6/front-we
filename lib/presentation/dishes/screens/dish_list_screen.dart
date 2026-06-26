import 'package:flutter/material.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/widgets/dish_result_card.dart';

class DishListScreen extends StatefulWidget {
  final List<Dish> dishes;
  final String title;

  const DishListScreen({
    super.key,
    required this.dishes,
    this.title = '',
  });

  @override
  State<DishListScreen> createState() => _DishListScreenState();
}

class _DishListScreenState extends State<DishListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  Dish? _selectedDish;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Dish> get _filtered {
    if (_searchQuery.isEmpty) return widget.dishes;
    return widget.dishes.where((d) =>
      d.name.toLowerCase().contains(_searchQuery)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.isNotEmpty ? widget.title : t.menuDishes),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: t.searchDishes,
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
              ),
              onChanged: (v) => setState(() {
                _searchQuery = v.toLowerCase();
                _selectedDish = null;
              }),
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
                      final isSelected = _selectedDish == dish;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () => setState(() {
                            _selectedDish = _selectedDish == dish ? null : dish;
                          }),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: dish.image.isNotEmpty
                                      ? NetworkImage(dish.image)
                                      : null,
                                  child: dish.image.isEmpty
                                      ? Text(dish.name[0], style: const TextStyle(fontWeight: FontWeight.bold))
                                      : null,
                                  onBackgroundImageError: (_, __) =>
                                      const Icon(Icons.restaurant, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dish.name,
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        dish.country.name,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: cs.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  isSelected ? Icons.check_circle : Icons.chevron_right,
                                  color: isSelected ? cs.primary : cs.onSurfaceVariant,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_selectedDish != null)
            DishResultCard(
              dish: _selectedDish!,
              fromSpin: false,
            ),
        ],
      ),
    );
  }
}
