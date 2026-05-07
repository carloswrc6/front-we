// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authTitleLogin => 'Log in';
  @override
  String get authTitleRegister => 'Create an account';
  @override
  String get authDescriptionLogin => "Don't have an account? Register";
  @override
  String get authDescriptionRegister => 'Already have an account? Log in';

  @override
  String get loginButton => 'Login';
  @override
  String get fullName => 'Full Name';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';

  @override
  String get title => 'Title app EN';
  @override
  String get subtitle => 'Subtitle app EN';

  // Validation auth
  @override
  String get valFullname => "Name is required";
  @override
  String get valMayusMinusNumber =>
      "Uppercase letter, a lowercase letter, and a number.";
  @override
  String get valMinSixStr => "Minimum 6 characters";
  @override
  String get valPwd => "A password is required";
  @override
  String get valEmailInvalid => "Invalid email";
  @override
  String get valRequiredEmail => "Email is required";

  // Menu
  @override
  String get menuProfile => "Profile";
  @override
  String get menuProfileSubtitle => "Your personal info";
  @override
  String get menuSubscription => "Subscription";
  @override
  String get menuSubscriptionSubtitle => "Your plan";
  @override
  String get menuTheme => "Theme";
  @override
  String get menuThemeSubtitle => "Customize app";
  @override
  String get menuLogout => "Logout";

  // Susb
  @override
  String get subsTitleMenu => "Subscription plans";
  @override
  String get subsTitle => "Choose your plan";
  @override
  String get subsDescription => "Unlock all features";
  @override
  String get subsRecommended => "Recommended";
}
