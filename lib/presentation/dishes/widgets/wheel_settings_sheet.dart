import 'package:flutter/material.dart';
import 'package:frontwe/l10n/app_localizations.dart';

class WheelSettingsSheet {
  static void show(BuildContext context, {String initialSpeed = 'normal', required ValueChanged<String> onApply}) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _WheelSettingsContent(initialSpeed: initialSpeed, onApply: onApply),
    );
  }
}

class _WheelSettingsContent extends StatefulWidget {
  final String initialSpeed;
  final ValueChanged<String> onApply;
  const _WheelSettingsContent({required this.initialSpeed, required this.onApply});

  @override
  State<_WheelSettingsContent> createState() => _WheelSettingsContentState();
}

class _WheelSettingsContentState extends State<_WheelSettingsContent> {
  late String _speed;
  bool _avoidRepeat = true;
  bool _avoidThreeDays = true;
  bool _easy = true;
  bool _medium = true;
  bool _hard = false;
  bool _prioritizeFavorites = true;
  bool _surpriseMode = false;
  bool _healthyMode = true;
  double _maxTime = 30;

  @override
  void initState() {
    super.initState();
    _speed = widget.initialSpeed;
    debugPrint('[WheelSettingsSheet] opened with initialSpeed=${widget.initialSpeed}');
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final bottom = MediaQuery.of(context).padding.bottom;

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
                  value: _avoidRepeat,
                  label: t.wheelSettingsAvoidRepeat,
                  onChanged: (v) => setState(() => _avoidRepeat = v),
                ),
                _CheckboxTile(
                  value: _avoidThreeDays,
                  label: t.wheelSettingsAvoidThreeDays,
                  onChanged: (v) => setState(() => _avoidThreeDays = v),
                ),
                const _SectionDivider(),
                _sectionLabel(context, t.wheelSettingsSpeed),
                _RadioGroup<String>(
                  value: _speed,
                  options: [
                    _RadioOption(t.wheelSettingsFast, 'fast', Icons.bolt),
                    _RadioOption(t.wheelSettingsNormal, 'normal', Icons.speed),
                    _RadioOption(t.wheelSettingsSlow, 'slow', Icons.timer_outlined),
                  ],
                  onChanged: (v) {
                    debugPrint('[WheelSettingsSheet] speed radio changed to: $v');
                    setState(() => _speed = v);
                  },
                ),
                const _SectionDivider(),
                _sectionLabel(context, t.wheelSettingsDifficulty),
                _buildDifficultyCheckboxes(),
                const _SectionDivider(),
                _sectionLabel(context, t.wheelSettingsPreferences),
                _CheckboxTile(
                  value: _prioritizeFavorites,
                  label: t.wheelSettingsPrioritizeFavorites,
                  onChanged: (v) => setState(() => _prioritizeFavorites = v),
                ),
                _CheckboxTile(
                  value: _surpriseMode,
                  label: t.wheelSettingsSurpriseMode,
                  onChanged: (v) => setState(() => _surpriseMode = v),
                ),
                _CheckboxTile(
                  value: _healthyMode,
                  label: t.wheelSettingsHealthyMode,
                  onChanged: (v) => setState(() => _healthyMode = v),
                ),
                const _SectionDivider(),
                _sectionLabel(context, t.wheelSettingsMaxTime),
                _MaxTimeSlider(
                  value: _maxTime,
                  onChanged: (v) => setState(() => _maxTime = v),
                  label: '${_maxTime.toInt()} ${t.wheelSettingsMin}',
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
                    onPressed: () {
                      debugPrint('[WheelSettingsSheet] Aplicar pressed, speed=$_speed');
                      widget.onApply(_speed);
                      Navigator.of(context).pop();
                    },
                    child: Text(t.wheelSettingsApply),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
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

  Widget _buildDifficultyCheckboxes() {
    return Column(
      children: [
        _CheckboxTile(
          value: _easy,
          label: AppLocalizations.of(context)!.wheelSettingsEasy,
          onChanged: (v) => setState(() => _easy = v),
        ),
        _CheckboxTile(
          value: _medium,
          label: AppLocalizations.of(context)!.wheelSettingsMedium,
          onChanged: (v) => setState(() => _medium = v),
        ),
        _CheckboxTile(
          value: _hard,
          label: AppLocalizations.of(context)!.wheelSettingsHard,
          onChanged: (v) => setState(() => _hard = v),
        ),
      ],
    );
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: cs.surfaceContainerLow,
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
            groupValue: value,
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
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
