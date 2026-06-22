import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:frontwe/providers/lang/locale_provider.dart';
import 'package:frontwe/providers/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeChangerScreen extends ConsumerWidget {
  static const name = 'theme_changer_screen';

  const ThemeChangerScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: Text(t.themeTitle),
      ),
      body: const _ThemeChangerView(),
    );
  }
}

class _ThemeChangerView extends ConsumerWidget {
  const _ThemeChangerView();

  String _colorLabel(AppLocalizations t, int index) {
    const keys = [
      'colorDeepPurple',
      'colorBlue',
      'colorTeal',
      'colorGreen',
      'colorRed',
      'colorPurple',
      'colorOrange',
      'colorPink',
      'colorPinkAccent',
    ];
    if (index < 0 || index >= keys.length) return '';
    switch (keys[index]) {
      case 'colorDeepPurple': return t.colorDeepPurple;
      case 'colorBlue': return t.colorBlue;
      case 'colorTeal': return t.colorTeal;
      case 'colorGreen': return t.colorGreen;
      case 'colorRed': return t.colorRed;
      case 'colorPurple': return t.colorPurple;
      case 'colorOrange': return t.colorOrange;
      case 'colorPink': return t.colorPink;
      case 'colorPinkAccent': return t.colorPinkAccent;
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final t = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final List<Color> colors = ref.watch(colorListProvider);
    final themeState = ref.watch(themeNotifierProvider);
    final isDarkmode = themeState.isDarkmode;
    final selectedColor = themeState.selectedColor;
    final cs = Theme.of(context).colorScheme;

    return ListView(
      children: [
        SwitchListTile(
          value: isDarkmode,
          onChanged: (_) {
            ref.read(themeNotifierProvider.notifier).toggleDarkmode();
          },
          secondary: Icon(
            isDarkmode ? Icons.dark_mode : Icons.light_mode,
          ),
          title: Text(t.themeDarkMode),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(t.themeLanguage),
          trailing: Text(
            locale.languageCode.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          onTap: () {
            final newLocale = locale.languageCode == 'es'
                ? const Locale('en')
                : const Locale('es');
            ref.read(localeProvider.notifier).changeLocale(newLocale);
          },
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            t.themeSelectColor,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        ...colors.asMap().entries.map((entry) {
          final index = entry.key;
          final color = entry.value;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
              radius: 16,
            ),
            title: Text(_colorLabel(t, index)),
            trailing: index == selectedColor
                ? Icon(Icons.check_circle, color: color)
                : null,
            onTap: () {
              ref
                  .read(themeNotifierProvider.notifier)
                  .changeColorIndex(index);
            },
          );
        }),
      ],
    );
  }
}
