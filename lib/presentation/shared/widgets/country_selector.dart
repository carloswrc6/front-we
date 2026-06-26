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
  final double horizontalPadding;

  const CountrySelector({
    super.key,
    required this.countries,
    required this.selectedCountryId,
    required this.onChanged,
    this.showAll = true,
    this.compact = false,
    this.horizontalPadding = 4,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    final items = <DropdownMenuItem<String?>>[];
    final selectedWidgets = <Widget>[];

    const textStyle = TextStyle(fontSize: 14);

    if (showAll) {
      items.add(DropdownMenuItem<String?>(value: null, child: Text(t.filterAll, style: textStyle)));
      selectedWidgets.add(Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: horizontalPadding),
          child: Text(t.filterAll, style: textStyle),
        ),
      ));
    }

    for (final c in countries) {
      items.add(DropdownMenuItem<String?>(value: c.id, child: Text('${_codeToFlag(c.code)} ${c.name}', style: textStyle)));
      selectedWidgets.add(Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: horizontalPadding),
          child: Text('${_codeToFlag(c.code)} ${compact ? c.code : c.name}', style: textStyle),
        ),
      ));
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cs.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          key: ValueKey('country_selector_${countries.length}'),
          value: selectedCountryId,
          isExpanded: true,
          menuWidth: screenWidth - 32,
          hint: Padding(
            padding: EdgeInsets.only(left: horizontalPadding),
            child: Text(t.filterCountry, style: const TextStyle(fontSize: 14)),
          ),
          icon: Padding(
            padding: EdgeInsets.only(right: horizontalPadding),
            child: const Icon(Icons.expand_more, size: 18),
          ),
          items: items,
          selectedItemBuilder: (context) => selectedWidgets,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
