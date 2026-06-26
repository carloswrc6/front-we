import 'package:flutter/material.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/l10n/app_localizations.dart';

String _codeToFlag(String code) {
  return code.toUpperCase().split('').map((c) {
    return String.fromCharCode(c.codeUnitAt(0) - 0x41 + 0x1F1E6);
  }).join('');
}

class CountrySelector extends StatelessWidget {
  final List<Country> countries;
  final String? selectedCountryId;
  final ValueChanged<String?> onChanged;
  final bool showAll;
  final bool compact;

  const CountrySelector({
    super.key,
    required this.countries,
    required this.selectedCountryId,
    required this.onChanged,
    this.showAll = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final items = <DropdownMenuItem<String?>>[];
    final selectedWidgets = <Widget>[];

    const textStyle = TextStyle(fontSize: 14);

    if (showAll) {
      items.add(DropdownMenuItem<String?>(value: null, child: Text(t.filterAll, style: textStyle)));
      selectedWidgets.add(Text(t.filterAll, style: textStyle));
    }

    for (final c in countries) {
      items.add(DropdownMenuItem<String?>(value: c.id, child: Text('${_codeToFlag(c.code)} ${c.name}', style: textStyle)));
      selectedWidgets.add(Text('${_codeToFlag(c.code)} ${compact ? c.code : c.name}', style: textStyle));
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return InputDecorator(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          key: ValueKey('country_selector_${countries.length}'),
          value: selectedCountryId,
          isExpanded: true,
          isDense: true,
          menuWidth: screenWidth - 32,
          hint: Text(t.filterCountry, style: const TextStyle(fontSize: 14)),
          icon: const Icon(Icons.expand_more, size: 18),
          items: items,
          selectedItemBuilder: (context) => selectedWidgets,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
