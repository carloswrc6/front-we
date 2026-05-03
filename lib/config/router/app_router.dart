import 'package:frontwe/presentation/auth/LoginScreen.dart';
import 'package:frontwe/presentation/home/HomeScreen.dart';
import 'package:frontwe/presentation/home/ThemeChangerScreen.dart';
import 'package:frontwe/presentation/others_screens/OtherScreen1.dart';
import 'package:frontwe/presentation/others_screens/OtherScreen2.dart';
import 'package:frontwe/presentation/others_screens/OtherScreen3.dart';
import 'package:frontwe/presentation/subscription/SubscriptionScreen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  // initialLocation: '/home',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
  ],
);
