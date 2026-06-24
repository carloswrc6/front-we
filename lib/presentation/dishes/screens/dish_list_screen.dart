import 'package:flutter/material.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/widgets/dish_detail_sheet.dart';

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
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
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
                                child: _dishImage(dish, cs, _mealTypeLabel(t, dish.mealType)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }

  Widget _dishImage(Dish dish, ColorScheme cs, String mealTypeLabel) {
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
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_mealTypeIcon(dish.mealType), size: 12, color: cs.onPrimaryContainer),
                const SizedBox(width: 4),
                Text(
                  mealTypeLabel,
                  style: TextStyle(fontSize: 11, color: cs.onPrimaryContainer),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
}
