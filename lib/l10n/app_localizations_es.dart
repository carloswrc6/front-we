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
  String get menuProfile => "Perfil";
  @override
  String get menuProfileSubtitle => "Tu información personal";
  @override
  String get menuSubscription => "Suscripción";
  @override
  String get menuSubscriptionSubtitle => "Tu plan actual";
  @override
  String get menuTheme => "Tema";
  @override
  String get menuThemeSubtitle => "Personaliza la app";
  @override
  String get menuLogout => "Cerrar sesión";

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
}
