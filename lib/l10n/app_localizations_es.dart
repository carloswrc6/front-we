// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  // Auth — login, register
  @override
  String get authTitleLogin => 'Iniciar sesión';
  @override
  String get authTitleRegister => 'Crear cuenta';
  @override
  String get authRegisterLink => '¿No tienes cuenta? Regístrate';
  @override
  String get authLoginLink => 'Ya tienes cuenta? Inicia sesión';
  @override
  String get fullName => 'Nombre completo';
  @override
  String get email => 'Correo electrónico';
  @override
  String get password => 'Contraseña';
  @override
  String get emailLabel => "Correo electrónico";
  @override
  String get emailHint => "Ingresa tu correo";
  @override
  String get or => "o";

  @override
  String get continueWithGoogle => 'Continuar con Google';
  @override
  String get continueWithApple => 'Continuar con Apple';

  // Auth — forgot / reset password
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

  // App — general
  @override
  String get title => 'Title app ES';
  @override
  String get subtitle => 'Subtitle app ES';

  // Validation
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

  // Menu — sidebar
  @override
  String get menuDishes => "Platos";
  @override
  String get menuDishesSubtitle => "Explorar platos";
  @override
  String get menuWheel => "Ruleta";
  @override
  String get menuWheelSubtitle => "Gira y elige";
  @override
  String get menuFavorites => "Favoritos";
  @override
  String get menuFavoritesSubtitle => "Tus platos favoritos";
  @override
  String get menuAvoid => "Evitar";
  @override
  String get menuAvoidSubtitle => "Platos que evitas";
  @override
  String get menuHistory => "Historial";
  @override
  String get menuHistorySubtitle => "Platos vistos y seleccionados al azar";
  @override
  String get sectionNavigation => "Navegación";
  @override
  String get sectionSettings => "Configuración";
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

  // Dishes — list / search
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
  String get mealTypeBreakfast => "Desayuno";
  @override
  String get mealTypeLunch => "Almuerzo";
  @override
  String get mealTypeDinner => "Cena";
  @override
  String get spinButton => "Girar!";
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

  // Create dish
  @override
  String get createDishTitle => "Agregar plato";
  @override
  String get dishName => "Nombre";
  @override
  String get dishIngredients => "Ingredientes (separados por coma)";
  @override
  String get dishImage => "URL de la imagen";
  @override
  String get dishMealType => "Tipo de comida";
  @override
  String get createDish => "Guardar";
  @override
  String get dishCreated => "Plato creado exitosamente";
  @override
  String get imageLoadError => "No se pudo cargar la imagen";
  @override
  String get imageUrlHint => "Pega una URL directa de imagen (https://...)";
  @override
  String get youLabel => "Tú";

  // Bottom navigation
  @override
  String get navPlatos => "Platos";
  @override
  String get navFavoritos => "Favoritos";
  @override
  String get navRuleta => "Ruleta";
  @override
  String get navAvoid => "Evitar";
  @override
  String get navHistorial => "Historial";

  // Screen titles
  @override
  String get platosTitle => "Todos los platos";
  @override
  String get favoritosTitle => "Mis favoritos";
  @override
  String get avoidTitle => "Platos que evitas";
  @override
  String get historialTitle => "Historial";
  @override
  String get favoritosEmpty => "Aún no tienes favoritos";
  @override
  String get avoidEmpty => "Aún no tienes platos que evitar";
  @override
  String get historialEmpty => "Aún no tienes historial";

  // History
  @override
  String get historialToday => "Hoy";
  @override
  String get historialYesterday => "Ayer";
  @override
  String get historialThisWeek => "Esta semana";
  @override
  String get historialPrevious => "Anterior";
  @override
  String get historialClearAll => "Limpiar historial";
  @override
  String get historialClearConfirm => "¿Eliminar todo el historial?";
  @override
  String get historialDelete => "Eliminar";
  @override
  String get historialDeleteConfirm => "Eliminar del historial";
  @override
  String get historialCancel => "Cancelar";
  @override
  String get historialSelectedCount => "seleccionados";
  @override
  String get historialBoth => "Ambos";
  @override
  String get historialSpin => "Ruleta";
  @override
  String get historialView => "Visualizados";

  // Wheel — settings sheet
  @override
  String get wheelSettingsTitle => "Personalizar giro";
  @override
  String get wheelSettingsRepetition => "Repetición";
  @override
  String get wheelSettingsAvoidRepeat => "Evitar repetir último resultado";
  @override
  String get wheelSettingsAvoidThreeDays => "Evitar comer lo mismo 3 días seguidos";
  @override
  String get wheelSettingsSpeed => "Velocidad de giro";
  @override
  String get wheelSettingsFast => "Rápido";
  @override
  String get wheelSettingsNormal => "Normal";
  @override
  String get wheelSettingsSlow => "Lento";
  @override
  String get wheelSettingsDifficulty => "Dificultad de preparación";
  @override
  String get wheelSettingsEasy => "Fácil";
  @override
  String get wheelSettingsMedium => "Medio";
  @override
  String get wheelSettingsHard => "Difícil";
  @override
  String get wheelSettingsPreferences => "Preferencias";
  @override
  String get wheelSettingsPrioritizeFavorites => "Priorizar favoritos";
  @override
  String get wheelSettingsSurpriseMode => "Modo sorpresa";
  @override
  String get wheelSettingsSurpriseModeDesc => "Muestra platos aleatorios fuera de tus preferencias habituales para descubrir nuevas opciones.";
  @override
  String get wheelSettingsHealthyMode => "Modo saludable";
  @override
  String get wheelSettingsMaxTime => "Tiempo máximo";
  @override
  String get wheelSettingsMin => "min";
  @override
  String get wheelSettingsCancel => "Cancelar";
  @override
  String get wheelSettingsApply => "Aplicar";

  // Theme
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

  // Subscription
  @override
  String get subsTitleMenu => "Planes de suscripción";
  @override
  String get subsTitle => "Elige tu plan";
  @override
  String get subsDescription => "Desbloquea todas las funcionalidades";
  @override
  String get subsRecommended => "Recomendado";
  @override
  String get subsLoading => "Cargando planes...";
  @override
  String get subsNoProducts => "No hay planes disponibles";
  @override
  String get subsNoProductsHint => "Configura los productos en RevenueCat e inicia el proyecto.";
  @override
  String get subsRestore => "Restaurar compras";
  @override
  String get subsSubscribe => "Suscribirme";
  @override
  String get subsAlreadyPremium => "¡Ya eres Premium!";
  @override
  String get subsRestored => "Compras restauradas";
  @override
  String get subsPurchaseError => "No se pudo completar la compra. Inténtalo de nuevo.";
  @override
  String get subsPurchaseCanceled => "Compra cancelada";
  @override
  String get subsPremiumBadge => "PREMIUM";
  @override
  String get subsFreeBadge => "GRATIS";
  @override
  String get subsFreePlanTitle => "Plan Gratis";
  @override
  String get subsFreePlanDesc => "Perfecto para empezar a decidir qué comer.";
  @override
  String get subsFreeCurrent => "Plan actual";
  @override
  String get subsFreeQuotaDishes => "Hasta 15 platos creados";
  @override
  String get subsFreeQuotaFavorites => "Hasta 10 favoritos";
  @override
  String get subsFreeQuotaAvoid => "Hasta 5 platos evitados";
  @override
  String get subsFreeHistory => "Historial de los últimos 7 días";
  @override
  String get subsFreeBasicFilters => "Filtros básicos (país, comida, dificultad)";
  @override
  String get subsFeatureSurprise => "Modo sorpresa";
  @override
  String get subsFeatureNoRepeat => "Evitar repetir plato (no repetir / últimos 3 días)";
  @override
  String get subsFeaturePrioritize => "Priorizar favoritos en la rueda";
  @override
  String get subsFeatureHealthy => "Modo saludable";
  @override
  String get subsFeatureSpeed => "Velocidad y ajustes avanzados de la rueda";
  @override
  String get subsFeatureUnlimited => "Platos ilimitados y estadísticas de historial";
  @override
  String get subsPremiumLocked => "Solo Premium";
  @override
  String get subsPremiumLockedMessage => "Esta función está disponible solo para suscriptores Premium.";
  @override
  String get subsGoPremium => "Ver planes";
  @override
  String get subsUpgrade => "Mejorar a Premium";
  @override
  String get subsPerDay => "/día";
  @override
  String get subsFreeTrial => "Prueba gratis incluida";

  // Premium limits
  @override
  String get subsLimitDishesTitle => "Límite de platos alcanzado";
  @override
  String get subsLimitDishesMessage => "El plan gratis permite hasta 15 platos. Actualiza a Premium para crear platos ilimitados.";
  @override
  String get subsLimitFavoritesTitle => "Límite de favoritos alcanzado";
  @override
  String get subsLimitFavoritesMessage => "El plan gratis permite hasta 10 favoritos. Actualiza a Premium para guardar todos los que quieras.";
  @override
  String get subsLimitAvoidTitle => "Límite de evitados alcanzado";
  @override
  String get subsLimitAvoidMessage => "El plan gratis permite hasta 5 platos evitados. Actualiza a Premium para evitarlos todos.";
  @override
  String get subsHistoryLimitTitle => "Historial limitado";
  @override
  String get subsHistoryLimitMessage => "El plan gratis muestra los últimos 7 días. Actualiza a Premium para ver todo tu historial.";

  // Avoid reasons
  @override
  String get avoidReasonTitle => "¿Por qué lo evitas?";
  @override
  String get avoidReasonOther => "Otros";
  @override
  String get avoidReasonOtherHint => "Escribe tu motivo...";
  @override
  String get avoidReasonSave => "Guardar";
  @override
  String get avoidReasonClear => "Cancelar";
}
