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
}
