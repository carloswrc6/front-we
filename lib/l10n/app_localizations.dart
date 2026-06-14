import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  String get authTitleLogin;
  String get authTitleRegister;
  String get authDescriptionLogin;
  String get authDescriptionRegister;
  String get loginButton;
  String get fullName;
  String get email;
  String get password;
  String get title;
  String get subtitle;
  String get subtitleForgotPassword;
  String get subtitleChangePassword;
  String get forgotPasswordCodeSendError;
  String get forgotPasswordCodeSentSuccess;
  String get enterVerificationCode;
  String get verificationCodeMustBeSixDigits;
  String get confirmPassword;
  String get passwordsDoNotMatch;
  String get passwordUpdateError;
  String get passwordUpdatedSuccessfully;
  String get sixDigitCodeSentTo;
  String get verificationCode;
  String get confirmPasswordLabel;
  String get updatePassword;
  String get backToLogin;
  String get valFullname;
  String get valMayusMinusNumber;
  String get valMinSixStr;
  String get valPwd;
  String get valEmailInvalid;
  String get valRequiredEmail;
  String get menuProfile;
  String get menuProfileSubtitle;
  String get menuSubscription;
  String get menuSubscriptionSubtitle;
  String get menuTheme;
  String get menuThemeSubtitle;
  String get menuLogout;
  String get subsTitleMenu;
  String get subsTitle;
  String get subsDescription;
  String get subsRecommended;
  String get forgotPassword;
  String get sendCodeEmail;
  String get returnLogin;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
