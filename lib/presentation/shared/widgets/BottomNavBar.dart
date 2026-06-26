import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  int _indexFromRoute(String location) {
    if (location.startsWith('/platos')) return 0;
    if (location.startsWith('/favoritos')) return 1;
    if (location.startsWith('/historial')) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromRoute(location);
    final t = AppLocalizations.of(context)!;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        final routes = ['/platos', '/favoritos', '/ruleta', '/historial'];
        context.go(routes[index]);
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.dining_outlined),
          selectedIcon: const Icon(Icons.dining),
          label: t.navPlatos,
        ),
        NavigationDestination(
          icon: const Icon(Icons.favorite_border),
          selectedIcon: const Icon(Icons.favorite),
          label: t.navFavoritos,
        ),
        NavigationDestination(
          icon: const Icon(Icons.casino_outlined),
          selectedIcon: const Icon(Icons.casino),
          label: t.navRuleta,
        ),
        NavigationDestination(
          icon: const Icon(Icons.history_outlined),
          selectedIcon: const Icon(Icons.history),
          label: t.navHistorial,
        ),
      ],
    );
  }
}
