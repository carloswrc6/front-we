import 'package:flutter/material.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/l10n/app_localizations.dart';

String _codeToFlag(String code) {
  return code.toUpperCase().split('').map((c) {
    return String.fromCharCode(c.codeUnitAt(0) - 0x41 + 0x1F1E6);
  }).join('');
}

const _allValue = '__all__';

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

    final items = <PopupMenuItem<String>>[];
    final displayTexts = <Widget>[];

    if (showAll) {
      items.add(PopupMenuItem<String>(value: _allValue, child: Text(t.filterAll, style: textStyle)));
      displayTexts.add(Text(t.filterAll, style: textStyle));
    }

    for (final c in countries) {
      items.add(PopupMenuItem<String>(value: c.id, child: Text('${_codeToFlag(c.code)} ${c.name}', style: textStyle)));
      displayTexts.add(Text('${_codeToFlag(c.code)} ${compact ? c.code : c.name}', style: textStyle));
    }

    final double effectiveMenuWidth = menuWidth ?? MediaQuery.of(context).size.width - 32;

    final selectedIdx = selectedCountryId == null
        ? (showAll ? 0 : -1)
        : countries.indexWhere((c) => c.id == selectedCountryId) + (showAll ? 1 : 0);

    final Widget currentDisplay = selectedIdx >= 0 && selectedIdx < displayTexts.length
        ? displayTexts[selectedIdx]
        : Text(t.filterCountry, style: textStyle);

    return GestureDetector(
      onTap: () {
        final RenderBox box = context.findRenderObject()! as RenderBox;
        final Offset bottomRight = box.localToGlobal(
          Offset(box.size.width, box.size.height),
        );
        final Offset bottomLeft = box.localToGlobal(
          Offset(0, box.size.height),
        );
        showMenu<String>(
          context: context,
          position: rightAligned
              ? RelativeRect.fromLTRB(
                  bottomRight.dx - effectiveMenuWidth,
                  bottomRight.dy,
                  bottomRight.dx,
                  bottomRight.dy,
                )
              : RelativeRect.fromLTRB(
                  bottomLeft.dx,
                  bottomLeft.dy,
                  bottomLeft.dx + effectiveMenuWidth,
                  bottomLeft.dy,
                ),
          items: items,
          initialValue: selectedCountryId ?? _allValue,
        ).then((v) {
          if (v != null) onChanged(v == _allValue ? null : v);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: cs.outline),
          borderRadius: BorderRadius.circular(4),
        ),
        width: rightAligned ? double.infinity : null,
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
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
      ),
    );
  }
}
