import 'package:flutter/material.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/l10n/app_localizations.dart';

class CountrySelector extends StatelessWidget {
  final List<Country> countries;
  final String? selectedCountryId;
  final ValueChanged<String?> onChanged;
  final bool showAll;

  const CountrySelector({
    super.key,
    required this.countries,
    required this.selectedCountryId,
    required this.onChanged,
    this.showAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return DropdownButtonFormField<String?>(
      key: ValueKey('country_selector_${countries.length}'),
      value: selectedCountryId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: t.filterCountry,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
      items: [
        if (showAll) DropdownMenuItem(value: null, child: Text(t.filterAll)),
        ...countries.map(
          (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
