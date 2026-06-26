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
  final double? menuWidth;
  final bool rightAligned;

  const CountrySelector({
    super.key,
    required this.countries,
    required this.selectedCountryId,
    required this.onChanged,
    this.showAll = true,
    this.compact = false,
    this.horizontalPadding = 4,
    this.menuWidth,
    this.rightAligned = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    const textStyle = TextStyle(fontSize: 14);

    final items = <DropdownMenuItem<String?>>[];
    final displayTexts = <Widget>[];

    if (showAll) {
      items.add(DropdownMenuItem<String?>(value: null, child: Text(t.filterAll, style: textStyle)));
      displayTexts.add(Text(t.filterAll, style: textStyle));
    }

    for (final c in countries) {
      items.add(DropdownMenuItem<String?>(value: c.id, child: Text('${_codeToFlag(c.code)} ${c.name}', style: textStyle)));
      displayTexts.add(Text('${_codeToFlag(c.code)} ${compact ? c.code : c.name}', style: textStyle));
    }

    final double? effectiveMenuWidth;
    if (menuWidth != null) {
      effectiveMenuWidth = menuWidth;
    } else {
      effectiveMenuWidth = MediaQuery.of(context).size.width - 32;
    }

    final selectedIdx = selectedCountryId == null
        ? (showAll ? 0 : -1)
        : countries.indexWhere((c) => c.id == selectedCountryId) + (showAll ? 1 : 0);

    final Widget currentDisplay = selectedIdx >= 0 && selectedIdx < displayTexts.length
        ? displayTexts[selectedIdx]
        : Text(t.filterCountry, style: textStyle);

    if (rightAligned) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: cs.outline),
          borderRadius: BorderRadius.circular(4),
        ),
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 48),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: horizontalPadding),
                  child: currentDisplay,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: horizontalPadding),
                  child: const Icon(Icons.expand_more, size: 18),
                ),
              ],
            ),
            Positioned.fill(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  key: ValueKey('country_selector_${countries.length}'),
                  value: selectedCountryId,
                  isExpanded: true,
                  menuWidth: effectiveMenuWidth,
                  hint: const SizedBox.shrink(),
                  icon: const SizedBox.shrink(),
                  items: items,
                  selectedItemBuilder: (_) =>
                      List.filled(items.length, const SizedBox.shrink()),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      );
    }

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
          menuWidth: effectiveMenuWidth,
          hint: Padding(
            padding: EdgeInsets.only(left: horizontalPadding),
            child: Text(t.filterCountry, style: const TextStyle(fontSize: 14)),
          ),
          icon: Padding(
            padding: EdgeInsets.only(right: horizontalPadding),
            child: const Icon(Icons.expand_more, size: 18),
          ),
          items: items,
          selectedItemBuilder: (context) => displayTexts.map((t) => Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: horizontalPadding),
              child: t,
            ),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
