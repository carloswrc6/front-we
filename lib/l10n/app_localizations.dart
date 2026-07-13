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

  // Auth — login, register
  String get authTitleLogin;
  String get authTitleRegister;
  String get authRegisterLink;
  String get authLoginLink;
  String get fullName;
  String get email;
  String get password;
  String get emailLabel;
  String get emailHint;
  String get or;

  // Auth — social login
  String get continueWithGoogle;
  String get continueWithApple;

  // Auth — forgot / reset password
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
  String get forgotPassword;
  String get sendCodeEmail;
  String get returnLogin;
  String get verifyCodeButton;
  String get resendCode;
  String get codeSentToEmail;
  String get enterCodeDescription;

  // App — general
  String get title;
  String get subtitle;

  // Validation
  String get valFullname;
  String get valMayusMinusNumber;
  String get valMinSixStr;
  String get valPwd;
  String get valEmailInvalid;
  String get valRequiredEmail;

  // Menu — sidebar
  String get menuDishes;
  String get menuDishesSubtitle;
  String get menuWheel;
  String get menuWheelSubtitle;
  String get menuFavorites;
  String get menuFavoritesSubtitle;
  String get menuAvoid;
  String get menuAvoidSubtitle;
  String get menuHistory;
  String get menuHistorySubtitle;
  String get sectionNavigation;
  String get sectionSettings;
  String get menuProfile;
  String get menuProfileSubtitle;
  String get menuSubscription;
  String get menuSubscriptionSubtitle;
  String get menuTheme;
  String get menuThemeSubtitle;
  String get menuLogout;

  // Dishes — list / search
  String get dishesEmpty;
  String get filterAll;
  String get filterCountry;
  String get filterMealType;
  String get searchDishes;
  String get filterEmpty;
  String get mealTypeBreakfast;
  String get mealTypeLunch;
  String get mealTypeDinner;
  String get spinButton;
  String get retryButton;
  String get errorLabel;
  String get ingredientsTitle;
  String get tapHint;
  String get viewList;
  String get dishWinner;
  String get dishSelected;

  // Create dish
  String get createDishTitle;
  String get dishName;
  String get dishIngredients;
  String get dishImage;
  String get dishMealType;
  String get createDish;
  String get dishCreated;

  // Bottom navigation
  String get navPlatos;
  String get navFavoritos;
  String get navRuleta;
  String get navAvoid;
  String get navHistorial;

  // Screen titles
  String get platosTitle;
  String get favoritosTitle;
  String get avoidTitle;
  String get historialTitle;
  String get favoritosEmpty;
  String get avoidEmpty;
  String get historialEmpty;

  // History
  String get historialToday;
  String get historialYesterday;
  String get historialThisWeek;
  String get historialPrevious;
  String get historialClearAll;
  String get historialClearConfirm;
  String get historialDelete;
  String get historialDeleteConfirm;
  String get historialCancel;
  String get historialSelectedCount;
  String get historialBoth;
  String get historialSpin;
  String get historialView;

  // Wheel — settings sheet
  String get wheelSettingsTitle;
  String get wheelSettingsRepetition;
  String get wheelSettingsAvoidRepeat;
  String get wheelSettingsAvoidThreeDays;
  String get wheelSettingsSpeed;
  String get wheelSettingsFast;
  String get wheelSettingsNormal;
  String get wheelSettingsSlow;
  String get wheelSettingsDifficulty;
  String get wheelSettingsEasy;
  String get wheelSettingsMedium;
  String get wheelSettingsHard;
  String get wheelSettingsPreferences;
  String get wheelSettingsPrioritizeFavorites;
  String get wheelSettingsSurpriseMode;
  String get wheelSettingsSurpriseModeDesc;
  String get wheelSettingsHealthyMode;
  String get wheelSettingsMaxTime;
  String get wheelSettingsMin;
  String get wheelSettingsCancel;
  String get wheelSettingsApply;

  // Theme
  String get themeTitle;
  String get themeDarkMode;
  String get themeLanguage;
  String get themeSelectColor;
  String get colorDeepPurple;
  String get colorBlue;
  String get colorTeal;
  String get colorGreen;
  String get colorRed;
  String get colorPurple;
  String get colorOrange;
  String get colorPink;
  String get colorPinkAccent;

  // Subscription
  String get subsTitleMenu;
  String get subsTitle;
  String get subsDescription;
  String get subsRecommended;
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
