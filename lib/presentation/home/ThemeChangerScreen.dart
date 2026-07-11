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

  @override
  Widget build(BuildContext context, ref) {
    final t = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final themeState = ref.watch(themeNotifierProvider);
    final isDarkmode = themeState.isDarkmode;
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
      ],
    );
  }
}
