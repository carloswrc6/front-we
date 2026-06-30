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

  @override
  String get subtitleForgotPassword => 'Forgot Password';

  @override
  String get subtitleChangePassword => 'Change Password';

  @override
  String get forgotPasswordCodeSendError => 'Failed to send the code';

  @override
  String get forgotPasswordCodeSentSuccess =>
      'Code sent, please check your email';

  @override
  String get enterVerificationCode => 'Enter the code';

  @override
  String get verificationCodeMustBeSixDigits =>
      'The code must contain 6 digits';

  @override
  String get confirmPassword => 'Confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordUpdateError => 'Failed to update password';

  @override
  String get passwordUpdatedSuccessfully => 'Password updated successfully';

  @override
  String get sixDigitCodeSentTo => 'A 6-digit code has been sent to:';

  @override
  String get verificationCode => 'Code';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get backToLogin => 'Back to Login';

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
  String get menuDishes => "Dishes";
  @override
  String get menuDishesSubtitle => "Browse dishes";
  @override
  String get menuWheel => "Wheel";
  @override
  String get menuWheelSubtitle => "Spin and choose";
  @override
  String get menuFavorites => "Favorites";
  @override
  String get menuFavoritesSubtitle => "Your favorite dishes";
  @override
  String get menuProhibidos => "Forbidden";
  @override
  String get menuProhibidosSubtitle => "Dishes you can't eat";
  @override
  String get sectionNavigation => "Navigation";
  @override
  String get sectionSettings => "Settings";
  @override
  String get menuHistory => "History";
  @override
  String get menuHistorySubtitle => "Viewed dishes";
  @override
  String get dishesEmpty => "No dishes available";
  @override
  String get filterAll => "All";
  @override
  String get filterCountry => "Country";
  @override
  String get filterMealType => "Meal type";
  @override
  String get searchDishes => "Search dishes...";
  @override
  String get filterEmpty => "No dishes match the filters";
  @override
  String get spinButton => "Spin!";
  @override
  String get mealTypeBreakfast => "Breakfast";
  @override
  String get mealTypeLunch => "Lunch";
  @override
  String get mealTypeDinner => "Dinner";
  @override
  String get menuProfile => "Profile";
  @override
  String get menuProfileSubtitle => "Your personal info";
  @override
  String get menuSubscription => "Subscription";
  @override
  String get menuSubscriptionSubtitle => "Your plan";
  @override
  String get menuTheme => "Theme and language";
  @override
  String get menuThemeSubtitle => "Customize app";
  @override
  String get menuLogout => "Logout";
  @override
  String get retryButton => "Retry";
  @override
  String get errorLabel => "Error";
  @override
  String get ingredientsTitle => "Ingredients";
  @override
  String get tapHint => "Tap a segment or spin the wheel!";
  @override
  String get viewList => "View list";
  @override
  String get dishWinner => "Winner dish";
  @override
  String get dishSelected => "Selected dish";
  @override
  String get themeTitle => "Preferences";
  @override
  String get themeDarkMode => "Dark mode";
  @override
  String get themeLanguage => "Language";
  @override
  String get themeSelectColor => "Accent color";
  @override
  String get colorDeepPurple => "Deep Purple";
  @override
  String get colorBlue => "Blue";
  @override
  String get colorTeal => "Teal";
  @override
  String get colorGreen => "Green";
  @override
  String get colorRed => "Red";
  @override
  String get colorPurple => "Purple";
  @override
  String get colorOrange => "Orange";
  @override
  String get colorPink => "Pink";
  @override
  String get colorPinkAccent => "Pink Accent";

  // Susb
  @override
  String get subsTitleMenu => "Subscription plans";
  @override
  String get subsTitle => "Choose your plan";
  @override
  String get subsDescription => "Unlock all features";
  @override
  String get subsRecommended => "Recommended";

  // Bottom nav
  @override
  String get navPlatos => "Dishes";
  @override
  String get navFavoritos => "Favorites";
  @override
  String get navRuleta => "Wheel";
  @override
  String get navProhibidos => "Forbidden";
  @override
  String get navHistorial => "History";
  @override
  String get platosTitle => "All dishes";
  @override
  String get favoritosTitle => "My favorites";
  @override
  String get prohibidosTitle => "Forbidden dishes";
  @override
  String get historialTitle => "History";
  @override
  String get favoritosEmpty => "No favorites yet";
  @override
  String get prohibidosEmpty => "No forbidden dishes yet";
  @override
  String get historialEmpty => "No history yet";

  @override
  String get forgotPassword => "You have forgotten your password";

  @override
  String get sendCodeEmail => "Send code";
  @override
  String get returnLogin => "Return to login";

  @override
  String get verifyCodeButton => "Verify Code";

  @override
  String get resendCode => "Resend code";

  @override
  String get codeSentToEmail => "We've sent a 6-digit code to:";

  @override
  String get enterCodeDescription => "Enter the code below to continue";

  @override
  String get createDishTitle => "Add dish";
  @override
  String get dishName => "Name";
  @override
  String get dishIngredients => "Ingredients (comma-separated)";
  @override
  String get dishImage => "Image URL";
  @override
  String get dishMealType => "Meal type";
  @override
  String get createDish => "Save";
  @override
  String get dishCreated => "Dish created successfully";
}
