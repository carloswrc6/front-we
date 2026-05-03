import 'package:frontwe/config/menu/menu_items.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/providers/menu/side_menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navDrawerIndex = ref.watch(navDrawerIndexProvider);
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final t = AppLocalizations.of(context)!;

    return NavigationDrawer(
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        HapticFeedback.lightImpact();

        ref.read(navDrawerIndexProvider.notifier).state = value;
        final menuItem = appMenuItems[value];

        context.push(menuItem.link);
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 10 : 30, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 25, child: Icon(Icons.person)),
              const SizedBox(height: 10),
              Text(
                'Carlos Rivas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'carlos@email.com',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        const Divider(),

        ...appMenuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return NavigationDrawerDestination(
            icon: Icon(
              item.icon,
              color: navDrawerIndex == index
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            label: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(_translate(t, item.titleKey)),
                Text(
                  _translate(t, item.subTitleKey),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(t.menuLogout),
          onTap: () {
            context.go('/login');
          },
        ),
      ],
    );
  }

  String _translate(AppLocalizations t, String key) {
    switch (key) {
      case 'profile':
        return t.menuProfile;
      case 'profileSubtitle':
        return t.menuProfileSubtitle;
      case 'subscription':
        return t.menuSubscription;
      case 'subscriptionSubtitle':
        return t.menuSubscriptionSubtitle;
      case 'theme':
        return t.menuTheme;
      case 'themeSubtitle':
        return t.menuThemeSubtitle;
      default:
        return key;
    }
  }
}
