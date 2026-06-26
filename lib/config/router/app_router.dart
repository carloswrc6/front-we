import 'package:frontwe/presentation/auth/screens/forgot_password_screen.dart';
import 'package:frontwe/presentation/auth/screens/login_screen.dart';
import 'package:frontwe/presentation/auth/screens/register_screen.dart';
import 'package:frontwe/presentation/auth/screens/reset_password_screen.dart';
import 'package:frontwe/presentation/auth/screens/verify_code_screen.dart';
import 'package:frontwe/presentation/dishes/screens/dishes_screen.dart';
import 'package:frontwe/presentation/favorites/screens/favorites_screen.dart';
import 'package:frontwe/presentation/history/screens/history_screen.dart';
import 'package:frontwe/presentation/home/ThemeChangerScreen.dart';
import 'package:frontwe/presentation/dishes/screens/wheel_screen.dart';
import 'package:frontwe/presentation/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/platos',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const PlatosScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/favoritos',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const FavoritesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/ruleta',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DishesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/historial',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HistoryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
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
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/theme_changer',
      builder: (context, state) => const ThemeChangerScreen(),
    ),
  ],
);
