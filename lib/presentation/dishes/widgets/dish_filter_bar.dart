import 'package:flutter/material.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/shared/widgets/country_selector.dart';
import 'package:frontwe/presentation/shared/widgets/CustomButton.dart';

class DishFilterBar extends StatelessWidget {
  final List<Country> countries;
  final String? selectedCountryId;
  final String? selectedMealType;
  final int filteredCount;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onMealTypeChanged;
  final VoidCallback? onSpinPressed;

  const DishFilterBar({
    super.key,
    required this.countries,
    required this.selectedCountryId,
    required this.selectedMealType,
    required this.filteredCount,
    required this.onCountryChanged,
    required this.onMealTypeChanged,
    required this.onSpinPressed,
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

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CountrySelector(
            showAll: false,
            countries: countries,
            selectedCountryId: selectedCountryId,
            onChanged: onCountryChanged,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(
                label: Text('$filteredCount'),
                visualDensity: VisualDensity.compact,
                labelStyle: const TextStyle(fontSize: 12),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SegmentedButton<String>(
                  segments: mealTypes.map((mt) {
                    return ButtonSegment(
                      value: mt,
                      label: Text(_mealTypeLabel(t, mt)),
                      icon: Icon(mealTypeIcons[mt], size: 20),
                    );
                  }).toList(),
                  selected: selectedMealType != null
                      ? {selectedMealType!}
                      : <String>{},
                  onSelectionChanged: (Set<String> selection) {
                    onMealTypeChanged(
                      selection.isNotEmpty ? selection.first : null,
                    );
                  },
                  showSelectedIcon: false,
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: WidgetStatePropertyAll(
                      Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomButton(
                label: t.spinButton,
                onPressed: onSpinPressed,
                icon: const Icon(Icons.shuffle),
              ),
            ],
          ),
        ],
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
