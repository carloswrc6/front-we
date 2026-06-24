// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get authTitleLogin => 'Iniciar sesión';

  @override
  String get authTitleRegister => 'Crear cuenta';

  @override
  String get authDescriptionLogin => '¿No tienes cuenta? Regístrate';

  @override
  String get authDescriptionRegister => 'Ya tienes cuenta? Inicia sesión';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get title => 'Title app ES';

  @override
  String get subtitle => 'Subtitle app ES';

  @override
  String get subtitleForgotPassword => 'Recuperar contraseña';

  @override
  String get subtitleChangePassword => 'Cambiar contraseña';

  @override
  String get forgotPasswordCodeSendError => 'No se pudo enviar el código';

  @override
  String get forgotPasswordCodeSentSuccess =>
      'Código enviado, revisa tu correo electrónico';

  @override
  String get enterVerificationCode => 'Ingrese el código';

  @override
  String get verificationCodeMustBeSixDigits =>
      'El código debe tener 6 dígitos';

  @override
  String get confirmPassword => 'Confirme la contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get passwordUpdateError => 'No se pudo actualizar la contraseña';

  @override
  String get passwordUpdatedSuccessfully =>
      'Contraseña actualizada correctamente';

  @override
  String get sixDigitCodeSentTo => 'Se envió un código de 6 dígitos a:';

  @override
  String get verificationCode => 'Código';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get updatePassword => 'Actualizar contraseña';

  @override
  String get backToLogin => 'Volver al login';

  // Validation auth
  @override
  String get valFullname => "El nombre es obligatorio";
  @override
  String get valMayusMinusNumber => "mayúscula, minúscula y un número";
  @override
  String get valMinSixStr => "Mínimo 6 caracteres";

  @override
  String get valPwd => "La contraseña es obligatoria";

  @override
  String get valEmailInvalid => "Email no válido";

  @override
  String get valRequiredEmail => "El email es obligatorio";

  // Menu
  @override
  String get menuDishes => "Platos";
  @override
  String get menuDishesSubtitle => "Explorar platos";
  @override
  String get dishesEmpty => "No hay platos disponibles";
  @override
  String get filterAll => "Todos";
  @override
  String get filterCountry => "País";
  @override
  String get filterMealType => "Tipo de comida";
  @override
  String get searchDishes => "Buscar platos...";
  @override
  String get filterEmpty => "Ningún plato coincide con los filtros";
  @override
  String get spinButton => "Girar!";
  @override
  String get mealTypeBreakfast => "Desayuno";
  @override
  String get mealTypeLunch => "Almuerzo";
  @override
  String get mealTypeDinner => "Cena";
  @override
  String get menuProfile => "Perfil";
  @override
  String get menuProfileSubtitle => "Tu información personal";
  @override
  String get menuSubscription => "Suscripción";
  @override
  String get menuSubscriptionSubtitle => "Tu plan actual";
  @override
  String get menuTheme => "Tema y idioma";
  @override
  String get menuThemeSubtitle => "Personaliza la app";
  @override
  String get menuLogout => "Cerrar sesión";
  @override
  String get retryButton => "Reintentar";
  @override
  String get errorLabel => "Error";
  @override
  String get ingredientsTitle => "Ingredientes";
  @override
  String get tapHint => "Toca un segmento o gira la ruleta!";
  @override
  String get viewList => "Ver lista";
  @override
  String get dishWinner => "Plato ganador";
  @override
  String get dishSelected => "Plato seleccionado";
  @override
  String get themeTitle => "Preferencias";
  @override
  String get themeDarkMode => "Modo oscuro";
  @override
  String get themeLanguage => "Idioma";
  @override
  String get themeSelectColor => "Color de acento";
  @override
  String get colorDeepPurple => "Púrpura profundo";
  @override
  String get colorBlue => "Azul";
  @override
  String get colorTeal => "Verde azulado";
  @override
  String get colorGreen => "Verde";
  @override
  String get colorRed => "Rojo";
  @override
  String get colorPurple => "Púrpura";
  @override
  String get colorOrange => "Naranja";
  @override
  String get colorPink => "Rosa";
  @override
  String get colorPinkAccent => "Rosa acento";

  @override
  String get subsTitleMenu => "Planes de suscripción";
  @override
  String get subsTitle => "Elige tu plan";
  @override
  String get subsDescription => "Desbloquea todas las funcionalidades";
  @override
  String get subsRecommended => "Recomendado";
  @override
  String get forgotPassword => "Has olvidado tu contraseña?";

  @override
  String get sendCodeEmail => "Enviar codigo";
  @override
  String get returnLogin => "Regresar al login";

  @override
  String get verifyCodeButton => "Verificar código";

  @override
  String get resendCode => "Reenviar código";

  @override
  String get codeSentToEmail => "Hemos enviado un código de 6 dígitos a:";

  @override
  String get enterCodeDescription =>
      "Ingresa el código a continuación para continuar";
}
