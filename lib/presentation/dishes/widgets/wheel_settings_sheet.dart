import 'package:flutter/material.dart';
import 'package:frontwe/l10n/app_localizations.dart';

class WheelSettingsSheet {
  static void show(
    BuildContext context, {
    String initialSpeed = 'normal',
    bool initialDifficultyEasy = true,
    bool initialDifficultyMedium = true,
    bool initialDifficultyHard = false,
    bool initialAvoidRepeat = true,
    bool initialAvoidThreeDays = true,
    bool initialPrioritizeFavorites = true,
    bool initialSurpriseMode = false,
    bool initialHealthyMode = false,
    required void Function({
      required String speed,
      required bool difficultyEasy,
      required bool difficultyMedium,
      required bool difficultyHard,
      required bool surpriseMode,
      required bool avoidRepeat,
      required bool avoidThreeDays,
      required bool healthyMode,
      required bool prioritizeFavorites,
    }) onApply,
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _WheelSettingsContent(
        initialSpeed: initialSpeed,
        initialDifficultyEasy: initialDifficultyEasy,
        initialDifficultyMedium: initialDifficultyMedium,
        initialDifficultyHard: initialDifficultyHard,
        initialAvoidRepeat: initialAvoidRepeat,
        initialAvoidThreeDays: initialAvoidThreeDays,
        initialPrioritizeFavorites: initialPrioritizeFavorites,
        initialSurpriseMode: initialSurpriseMode,
        initialHealthyMode: initialHealthyMode,
        onApply: onApply,
      ),
    );
  }
}

class _WheelSettingsContent extends StatefulWidget {
  final String initialSpeed;
  final bool initialDifficultyEasy;
  final bool initialDifficultyMedium;
  final bool initialDifficultyHard;
  final bool initialAvoidRepeat;
  final bool initialAvoidThreeDays;
  final bool initialPrioritizeFavorites;
  final bool initialSurpriseMode;
  final bool initialHealthyMode;
  final void Function({
    required String speed,
    required bool difficultyEasy,
    required bool difficultyMedium,
    required bool difficultyHard,
    required bool surpriseMode,
    required bool avoidRepeat,
    required bool avoidThreeDays,
    required bool healthyMode,
    required bool prioritizeFavorites,
  }) onApply;
  const _WheelSettingsContent({
    required this.initialSpeed,
    required this.initialDifficultyEasy,
    required this.initialDifficultyMedium,
    required this.initialDifficultyHard,
    required this.initialAvoidRepeat,
    required this.initialAvoidThreeDays,
    required this.initialPrioritizeFavorites,
    required this.initialSurpriseMode,
    required this.initialHealthyMode,
    required this.onApply,
  });

  @override
  State<_WheelSettingsContent> createState() => _WheelSettingsContentState();
}

class _WheelSettingsContentState extends State<_WheelSettingsContent> {
  late String _speed;
  late bool _avoidRepeat;
  late bool _avoidThreeDays;
  late bool _easy;
  late bool _medium;
  late bool _hard;
  late bool _prioritizeFavorites;
  late bool _surpriseMode;
  late bool _healthyMode;

  @override
  void initState() {
    super.initState();
    _speed = widget.initialSpeed;
    _avoidRepeat = widget.initialAvoidRepeat;
    _avoidThreeDays = widget.initialAvoidThreeDays;
    _easy = widget.initialDifficultyEasy;
    _medium = widget.initialDifficultyMedium;
    _hard = widget.initialDifficultyHard;
    _prioritizeFavorites = widget.initialPrioritizeFavorites;
    _surpriseMode = widget.initialSurpriseMode;
    _healthyMode = widget.initialHealthyMode;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final bottom = MediaQuery.of(context).padding.bottom;
    final textTheme = Theme.of(context).textTheme;

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
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(t.wheelSettingsRepetition,
                    style: textTheme.titleSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _sectionCard(
                  context,
                  children: [
                    SwitchListTile(
                      value: _avoidRepeat,
                      onChanged: (v) => setState(() => _avoidRepeat = v),
                      title: Text(t.wheelSettingsAvoidRepeat),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    const Divider(height: 1, indent: 0),
                    SwitchListTile(
                      value: _avoidThreeDays,
                      onChanged: (v) => setState(() => _avoidThreeDays = v),
                      title: Text(t.wheelSettingsAvoidThreeDays),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(t.wheelSettingsSpeed,
                    style: textTheme.titleSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _sectionCard(
                  context,
                  children: [
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment(value: 'fast', label: Text(t.wheelSettingsFast), icon: const Icon(Icons.bolt)),
                        ButtonSegment(value: 'normal', label: Text(t.wheelSettingsNormal), icon: const Icon(Icons.speed)),
                        ButtonSegment(value: 'slow', label: Text(t.wheelSettingsSlow), icon: const Icon(Icons.timer_outlined)),
                      ],
                      selected: {_speed},
                      onSelectionChanged: (v) => setState(() => _speed = v.first),
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(t.wheelSettingsDifficulty,
                    style: textTheme.titleSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _sectionCard(
                  context,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          FilterChip(
                            label: Text(t.wheelSettingsEasy),
                            selected: _easy,
                            onSelected: (v) => setState(() => _easy = v),
                            visualDensity: VisualDensity.compact,
                            showCheckmark: false,
                          ),
                          FilterChip(
                            label: Text(t.wheelSettingsMedium),
                            selected: _medium,
                            onSelected: (v) => setState(() => _medium = v),
                            visualDensity: VisualDensity.compact,
                            showCheckmark: false,
                          ),
                          FilterChip(
                            label: Text(t.wheelSettingsHard),
                            selected: _hard,
                            onSelected: (v) => setState(() => _hard = v),
                            visualDensity: VisualDensity.compact,
                            showCheckmark: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(t.wheelSettingsPreferences,
                    style: textTheme.titleSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _sectionCard(
                  context,
                  children: [
                    SwitchListTile(
                      value: _prioritizeFavorites,
                      onChanged: (v) => setState(() => _prioritizeFavorites = v),
                      title: Text(t.wheelSettingsPrioritizeFavorites),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    const Divider(height: 1, indent: 0),
                    SwitchListTile(
                      value: _surpriseMode,
                      onChanged: (v) => setState(() => _surpriseMode = v),
                      title: Row(
                        children: [
                          Text(t.wheelSettingsSurpriseMode),
                          const SizedBox(width: 4),
                          Tooltip(
                            message: t.wheelSettingsSurpriseModeDesc,
                            child: Icon(Icons.help_outline, size: 18, color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    const Divider(height: 1, indent: 0),
                    SwitchListTile(
                      value: _healthyMode,
                      onChanged: (v) => setState(() => _healthyMode = v),
                      title: Text(t.wheelSettingsHealthyMode),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ],
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
                      widget.onApply(
                        speed: _speed,
                        difficultyEasy: _easy,
                        difficultyMedium: _medium,
                        difficultyHard: _hard,
                        surpriseMode: _surpriseMode,
                        avoidRepeat: _avoidRepeat,
                        avoidThreeDays: _avoidThreeDays,
                        healthyMode: _healthyMode,
                        prioritizeFavorites: _prioritizeFavorites,
                      );
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

  Widget _sectionCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}


