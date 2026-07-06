import 'package:flutter/material.dart';
import 'package:frontwe/l10n/app_localizations.dart';

class WheelSettingsSheet {
  static void show(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final bottom = MediaQuery.of(context).padding.bottom;

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            var avoidRepeat = true;
            var avoidThreeDays = true;
            var speed = 'normal';
            var easy = true;
            var medium = true;
            var hard = false;
            var prioritizeFavorites = true;
            var surpriseMode = false;
            var healthyMode = true;
            var maxTime = 30.0;

            return Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Icon(Icons.tune, color: cs.primary, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          t.wheelSettingsTitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      children: [
                        _CheckboxTile(
                          value: avoidRepeat,
                          label: t.wheelSettingsAvoidRepeat,
                          onChanged: (v) => setSheetState(() => avoidRepeat = v),
                        ),
                        _CheckboxTile(
                          value: avoidThreeDays,
                          label: t.wheelSettingsAvoidThreeDays,
                          onChanged: (v) => setSheetState(() => avoidThreeDays = v),
                        ),
                        const _SectionDivider(),
                        _sectionLabel(context, t.wheelSettingsSpeed),
                        _RadioGroup<String>(
                          value: speed,
                          options: [
                            _RadioOption(t.wheelSettingsFast, 'fast', Icons.bolt),
                            _RadioOption(t.wheelSettingsNormal, 'normal', Icons.speed),
                            _RadioOption(t.wheelSettingsSlow, 'slow', Icons.timer_outlined),
                          ],
                          onChanged: (v) => setSheetState(() => speed = v),
                        ),
                        const _SectionDivider(),
                        _sectionLabel(context, t.wheelSettingsDifficulty),
                        ..._buildDifficultyCheckboxes(context, easy, medium, hard, (e, m, h) {
                          setSheetState(() {
                            easy = e;
                            medium = m;
                            hard = h;
                          });
                        }),
                        const _SectionDivider(),
                        _sectionLabel(context, t.wheelSettingsPreferences),
                        _CheckboxTile(
                          value: prioritizeFavorites,
                          label: t.wheelSettingsPrioritizeFavorites,
                          onChanged: (v) => setSheetState(() => prioritizeFavorites = v),
                        ),
                        _CheckboxTile(
                          value: surpriseMode,
                          label: t.wheelSettingsSurpriseMode,
                          onChanged: (v) => setSheetState(() => surpriseMode = v),
                        ),
                        _CheckboxTile(
                          value: healthyMode,
                          label: t.wheelSettingsHealthyMode,
                          onChanged: (v) => setSheetState(() => healthyMode = v),
                        ),
                        const _SectionDivider(),
                        _sectionLabel(context, t.wheelSettingsMaxTime),
                        _MaxTimeSlider(
                          value: maxTime,
                          onChanged: (v) => setSheetState(() => maxTime = v),
                          label: '${maxTime.toInt()} ${t.wheelSettingsMin}',
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      border: Border(top: BorderSide(color: cs.outlineVariant, width: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(t.wheelSettingsCancel),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(t.wheelSettingsApply),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _sectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static List<Widget> _buildDifficultyCheckboxes(
    BuildContext context,
    bool easy,
    bool medium,
    bool hard,
    void Function(bool e, bool m, bool h) onChanged,
  ) {
    return [
      _CheckboxTile(
        value: easy,
        label: AppLocalizations.of(context)!.wheelSettingsEasy,
        onChanged: (v) => onChanged(v, medium, hard),
      ),
      _CheckboxTile(
        value: medium,
        label: AppLocalizations.of(context)!.wheelSettingsMedium,
        onChanged: (v) => onChanged(easy, v, hard),
      ),
      _CheckboxTile(
        value: hard,
        label: AppLocalizations.of(context)!.wheelSettingsHard,
        onChanged: (v) => onChanged(easy, medium, v),
      ),
    ];
  }
}

class _RadioOption<T> {
  final String label;
  final T value;
  final IconData icon;
  const _RadioOption(this.label, this.value, this.icon);
}

class _RadioGroup<T> extends StatelessWidget {
  final T value;
  final List<_RadioOption<T>> options;
  final ValueChanged<T> onChanged;

  const _RadioGroup({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioGroup<T>(
        groupValue: value,
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
        child: Column(
          children: options.map((opt) {
            final selected = value == opt.value;
            return RadioListTile<T>(
              title: Row(
                children: [
                  Icon(opt.icon, size: 18, color: selected ? cs.primary : cs.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(opt.label),
                ],
              ),
              value: opt.value,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selected: selected,
              activeColor: cs.primary,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CheckboxTile extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  const _CheckboxTile({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      title: Text(label),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class _MaxTimeSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final String label;

  const _MaxTimeSlider({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: value,
              min: 5,
              max: 120,
              divisions: 23,
              label: label,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
    );
  }
}
