import 'package:flutter/material.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/shared/widgets/country_selector.dart';

class DishFilterBar extends StatelessWidget {
  final List<Country> countries;
  final String? selectedCountryId;
  final String? selectedMealType;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onMealTypeChanged;

  const DishFilterBar({
    super.key,
    required this.countries,
    required this.selectedCountryId,
    required this.selectedMealType,
    required this.onCountryChanged,
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

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
      ),
      child: Column(
        children: [
          CountrySelector(
            showAll: false,
            countries: countries,
            selectedCountryId: selectedCountryId,
            onChanged: onCountryChanged,
          ),
          const SizedBox(height: 8),
          Center(
            child: Wrap(
              spacing: 8,
              children: mealTypes.map((mt) {
                final selected = selectedMealType == mt;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(mealTypeIcons[mt], size: 16),
                      const SizedBox(width: 4),
                      Text(_mealTypeLabel(t, mt)),
                    ],
                  ),
                  selected: selected,
                  visualDensity: VisualDensity.compact,
                  onSelected: (_) => onMealTypeChanged(selected ? null : mt),
                );
              }).toList(),
            ),
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
