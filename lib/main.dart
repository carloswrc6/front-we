import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontwe/config/router/app_router.dart';
import 'package:frontwe/infrastructure/datasource/google_auth_datasource.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/providers/lang/locale_provider.dart';
import 'package:frontwe/providers/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final googleSignIn = GoogleSignIn.instance;
  await GoogleSignInService(googleSignIn).init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Front We',

      // NUEVO THEME
      theme: theme.getTheme(),

      // LOCALE
      locale: locale,

      supportedLocales: const [Locale('es'), Locale('en')],

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
    );
  }
}
