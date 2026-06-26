import 'package:flutter/material.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/wheel/widgets/detail_sheet.dart';

class DishListPreview extends StatelessWidget {
  final List<Dish> dishes;
  final VoidCallback? onViewList;
  final int maxItems;

  const DishListPreview({
    super.key,
    required this.dishes,
    this.onViewList,
    this.maxItems = 5,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        GestureDetector(
          onTap: onViewList,
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! < -200) {
              onViewList?.call();
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${t.menuDishes} (${dishes.length})',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_double_arrow_right_outlined,
                  size: 18,
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        ...dishes.take(maxItems).map((d) => ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 16,
            backgroundImage: d.image.isNotEmpty ? NetworkImage(d.image) : null,
            child: d.image.isEmpty
                ? Text(d.name[0], style: const TextStyle(fontSize: 12))
                : null,
            onBackgroundImageError: (_, __) {},
          ),
          title: Text(d.name, style: const TextStyle(fontSize: 14)),
          subtitle: Text(d.country.name, style: const TextStyle(fontSize: 12)),
          onTap: () => DishDetailSheet.show(context, d),
        )),
      ],
    );
  }
}
