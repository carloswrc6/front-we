import 'package:frontwe/providers/lang/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return IconButton(
      icon: Text(
        locale.languageCode.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        final newLocale = locale.languageCode == 'es'
            ? const Locale('en')
            : const Locale('es');

        ref.read(localeProvider.notifier).changeLocale(newLocale);
      },
    );
  }
}
