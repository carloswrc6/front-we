import 'package:frontwe/presentation/auth/screens/login_screen.dart';
import 'package:frontwe/presentation/home/HomeScreen.dart';
import 'package:frontwe/presentation/home/ThemeChangerScreen.dart';
import 'package:frontwe/presentation/subscription/SubscriptionScreen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => SubscriptionScreen(),
    ),
    GoRoute(
      path: '/theme_changer',
      builder: (context, state) => const ThemeChangerScreen(),
    ),
  ],
);
