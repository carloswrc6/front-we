import 'package:flutter/material.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';

class DishResultCard extends StatelessWidget {
  final Dish dish;
  final bool fromSpin;
  final VoidCallback onTap;

  const DishResultCard({
    super.key,
    required this.dish,
    required this.fromSpin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      key: const ValueKey('result'),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: fromSpin
              ? cs.secondaryContainer
              : cs.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      // backgroundImage: NetworkImage(dish.image),
                      backgroundImage: const NetworkImage(
                        'https://static.guruexplorers.com/uploads/2025/09/NPjfcIDb4kJ07mA5zKSKCBkftNYSYv3rCeQiVRjm.jpg',
                      ),
                      onBackgroundImageError: (_, __) =>
                          const Icon(Icons.restaurant),
                    ),
                    if (fromSpin)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.shuffle,
                            size: 14,
                            color: cs.onPrimary,
                          ),
                        ),
                      )
                    else
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.remove_red_eye,
                            size: 14,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              dish.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            fromSpin ? Icons.shuffle : Icons.remove_red_eye,
                            size: 16,
                            color: fromSpin
                                ? cs.primary
                                : cs.onSurfaceVariant,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dish.country.name} · ${_mealTypeLabel(t, dish.mealType)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (dish.ingredients.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          dish.ingredients.join(', '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
