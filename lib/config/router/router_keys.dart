import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> goToLogin() async {
  final ctx = rootNavigatorKey.currentContext;
  if (ctx != null && ctx.mounted) {
    GoRouter.of(ctx).go('/login');
  }
}