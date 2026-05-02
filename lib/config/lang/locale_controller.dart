import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('es');

  Locale get locale => _locale;

  void toggleLocale() {
    if (_locale.languageCode == 'es') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('es');
    }
    notifyListeners();
  }

  void set(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
