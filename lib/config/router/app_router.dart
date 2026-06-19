import 'package:frontwe/presentation/auth/screens/forgot_password_screen.dart';
import 'package:frontwe/presentation/auth/screens/login_screen.dart';
import 'package:frontwe/presentation/auth/screens/register_screen.dart';
import 'package:frontwe/presentation/auth/screens/reset_password_screen.dart';
import 'package:frontwe/presentation/auth/screens/verify_code_screen.dart';
import 'package:frontwe/presentation/home/HomeScreen.dart';
import 'package:frontwe/presentation/home/ThemeChangerScreen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/verify-code',
      builder: (context, state) {
        final email = state.extra as String;
        return VerifyCodeScreen(email: email);
      },
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>;
        return ResetPasswordScreen(
          email: extra['email']!,
          code: extra['code']!,
        );
      },
    ),
    GoRoute(
      path: '/theme_changer',
      builder: (context, state) => const ThemeChangerScreen(),
    ),
  ],
);
