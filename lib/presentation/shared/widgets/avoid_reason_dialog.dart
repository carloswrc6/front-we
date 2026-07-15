import 'package:flutter/material.dart';
import 'package:frontwe/l10n/app_localizations.dart';

class AvoidReason {
  final String key;
  final String label;
  final String description;

  const AvoidReason(this.key, this.label, this.description);
}

Future<String?> showAvoidReasonDialog(
  BuildContext context, {
  String? initialReason,
  required List<AvoidReason> predefined,
  List<String> customReasons = const [],
  Future<void> Function(String label)? onSaveCustomReason,
  bool sugerenciasExpanded = true,
  bool tusMotivosExpanded = true,
  void Function(bool)? onSugerenciasExpandedChanged,
  void Function(bool)? onTusMotivosExpandedChanged,
}) {
  final t = AppLocalizations.of(context)!;

  return showDialog<String>(
    context: context,
    builder: (_) => _AvoidReasonDialog(
      predefined: predefined,
      customReasons: customReasons,
      initialReason: initialReason,
      otherLabel: t.avoidReasonOther,
      otherHint: t.avoidReasonOtherHint,
      title: t.avoidReasonTitle,
      saveLabel: t.avoidReasonSave,
      clearLabel: t.avoidReasonClear,
      onSaveCustomReason: onSaveCustomReason,
      sugerenciasExpanded: sugerenciasExpanded,
      tusMotivosExpanded: tusMotivosExpanded,
      onSugerenciasExpandedChanged: onSugerenciasExpandedChanged,
      onTusMotivosExpandedChanged: onTusMotivosExpandedChanged,
    ),
  );
}

class _AvoidReasonDialog extends StatefulWidget {
  final List<AvoidReason> predefined;
  final List<String> customReasons;
  final String? initialReason;
  final String otherLabel;
  final String otherHint;
  final String title;
  final String saveLabel;
  final String clearLabel;
  final Future<void> Function(String label)? onSaveCustomReason;
  final bool sugerenciasExpanded;
  final bool tusMotivosExpanded;
  final void Function(bool)? onSugerenciasExpandedChanged;
  final void Function(bool)? onTusMotivosExpandedChanged;

  _AvoidReasonDialog({
    required this.predefined,
    required this.customReasons,
    this.initialReason,
    required this.otherLabel,
    required this.otherHint,
    required this.title,
    required this.saveLabel,
    required this.clearLabel,
    this.onSaveCustomReason,
    this.sugerenciasExpanded = true,
    this.tusMotivosExpanded = true,
    this.onSugerenciasExpandedChanged,
    this.onTusMotivosExpandedChanged,
  });

  @override
  State<_AvoidReasonDialog> createState() => _AvoidReasonDialogState();
}

class _AvoidReasonDialogState extends State<_AvoidReasonDialog> {
  String? _selected;
  final _otherController = TextEditingController();
  bool _showOtherField = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialReason != null && widget.initialReason!.isNotEmpty) {
      final isPredefined = widget.predefined.any((r) => r.key == widget.initialReason);
      final isCustom = widget.customReasons.contains(widget.initialReason);
      if (isPredefined) {
        _selected = widget.initialReason;
      } else if (isCustom) {
        _selected = widget.initialReason;
      } else {
        _selected = '__other__';
        _showOtherField = true;
        _otherController.text = widget.initialReason!;
      }
    }
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              initiallyExpanded: widget.sugerenciasExpanded,
              onExpansionChanged: (v) {
                widget.onSugerenciasExpandedChanged?.call(v);
              },
              title: Text('Sugerencias', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: cs.primary,
              )),
              childrenPadding: EdgeInsets.zero,
              collapsedShape: const Border(),
              shape: const Border(),
              tilePadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              children: [
                ...widget.predefined.map(
                  (r) => _ReasonTile(
                    selected: _selected == r.key,
                    label: r.label,
                    description: r.description,
                    onTap: () => setState(() {
                      _selected = r.key;
                      _showOtherField = false;
                    }),
                  ),
                ),
              ],
            ),
            if (widget.customReasons.isNotEmpty) ...[
              const SizedBox(height: 4),
              ExpansionTile(
                initiallyExpanded: widget.tusMotivosExpanded,
                onExpansionChanged: (v) {
                  widget.onTusMotivosExpandedChanged?.call(v);
                },
                title: Text('Tus motivos', style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                )),
                childrenPadding: EdgeInsets.zero,
                collapsedShape: const Border(),
                shape: const Border(),
                tilePadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                children: [
                  ...widget.customReasons.map(
                    (r) => _ReasonTile(
                      selected: _selected == r,
                      label: r,
                      description: null,
                      onTap: () => setState(() {
                        _selected = r;
                        _showOtherField = false;
                      }),
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 20),
            _ReasonTile(
              selected: _selected == '__other__',
              label: widget.otherLabel,
              description: null,
              onTap: () => setState(() {
                _selected = '__other__';
                _showOtherField = true;
              }),
            ),
            if (_showOtherField) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _otherController,
                decoration: InputDecoration(
                  hintText: widget.otherHint,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: cs.surfaceContainerLow,
                ),
                maxLines: 2,
                autofocus: true,
              ),
            ],
          ],
        ),
      ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, '__clear__'),
          child: Text(widget.clearLabel),
        ),
        FilledButton(
          onPressed: () {
            if (_selected == null) return;
            if (_selected == '__other__') {
              final text = _otherController.text.trim();
              if (text.isEmpty) return;
              widget.onSaveCustomReason?.call(text);
              Navigator.pop(context, text);
            } else {
              Navigator.pop(context, _selected);
            }
          },
          child: Text(widget.saveLabel),
        ),
      ],
    );
  }
}

class _ReasonTile extends StatelessWidget {
  final bool selected;
  final String label;
  final String? description;
  final VoidCallback onTap;

  const _ReasonTile({
    required this.selected,
    required this.label,
    this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? cs.primaryContainer.withValues(alpha: 0.5) : null,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 20,
                  color: selected ? cs.primary : cs.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          color: selected ? cs.primary : null,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          description!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
}
