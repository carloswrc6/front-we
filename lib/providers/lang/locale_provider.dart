// import 'package:front_we/config/lang/locale_controller.dart';
// import 'package:flutter/material.dart';

// class LocaleProvider extends InheritedNotifier<LocaleController> {
//   const LocaleProvider({
//     super.key,
//     required LocaleController notifier,
//     required Widget child,
//   }) : super(notifier: notifier, child: child);

//   static LocaleController of(BuildContext context) {
//     final provider = context
//         .dependOnInheritedWidgetOfExactType<LocaleProvider>();

//     assert(provider != null, 'LocaleProvider no encontrado');

//     return provider!.notifier!;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('es'));

  void changeLocale(Locale locale) {
    state = locale;
  }
}
