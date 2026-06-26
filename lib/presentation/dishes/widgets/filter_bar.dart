import 'package:flutter/material.dart';
import 'package:frontwe/l10n/app_localizations.dart';

class DishFilterBar extends StatelessWidget {
  final String? selectedMealType;
  final int dishCount;
  final ValueChanged<String?> onMealTypeChanged;

  const DishFilterBar({
    super.key,
    required this.selectedMealType,
    this.dishCount = 0,
    required this.onMealTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final mealTypes = ['breakfast', 'lunch', 'dinner'];
    final mealTypeIcons = <String, IconData>{
      'breakfast': Icons.free_breakfast,
      'lunch': Icons.restaurant,
      'dinner': Icons.dinner_dining,
    };

    return Row(
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
                      Text(_mealTypeLabel(t, mt), style: const TextStyle(fontSize: 12)),
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
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$dishCount',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onPrimaryContainer),
          ),
        ),
      ],
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

class FilterContainer extends StatelessWidget {
  final Widget topChild;
  final Widget bottomChild;

  const FilterContainer({
    super.key,
    required this.topChild,
    required this.bottomChild,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: cs.outlineVariant, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          topChild,
          const SizedBox(height: 8),
          bottomChild,
        ],
      ),
    );
  }
}
