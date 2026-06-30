import 'package:frontwe/config/menu/menu_items.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/auth/providers/auth_providers.dart';
import 'package:frontwe/providers/menu/side_menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends ConsumerStatefulWidget {
  const SideMenu({super.key});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  @override
  void initState() {
    super.initState();
    _ensureUserData();
  }

  Future<void> _ensureUserData() async {
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && authState.loginUser == null) {
      await ref.read(authProvider.notifier).checkAuthStatus();
    }
  }

  void _navigate(int index) {
    HapticFeedback.lightImpact();
    ref.read(navDrawerIndexProvider.notifier).state = index;
    context.go(appMenuItems[index].link);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final navDrawerIndex = ref.watch(navDrawerIndexProvider);
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final t = AppLocalizations.of(context)!;

    return NavigationDrawer(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 10 : 30, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 25, child: Icon(Icons.person)),
              const SizedBox(height: 10),
              Text(
                authState.loginUser?.fullName ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                authState.loginUser?.email ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        const Divider(),

        _sectionHeader(t.sectionNavigation),

        _menuItem(0, Icons.casino, t.menuWheel, t.menuWheelSubtitle, navDrawerIndex),
        _menuItem(1, Icons.dining, t.menuDishes, t.menuDishesSubtitle, navDrawerIndex),
        _menuItem(2, Icons.favorite_border, t.menuFavorites, t.menuFavoritesSubtitle, navDrawerIndex),
        _menuItem(3, Icons.thumb_down, t.menuAvoid, t.menuAvoidSubtitle, navDrawerIndex),
        _menuItem(4, Icons.history, t.menuHistory, t.menuHistorySubtitle, navDrawerIndex),

        const Divider(),

        _sectionHeader(t.sectionSettings),

        _menuItem(5, Icons.person_outline, t.menuProfile, t.menuProfileSubtitle, navDrawerIndex),
        _menuItem(6, Icons.palette_outlined, t.menuTheme, t.menuThemeSubtitle, navDrawerIndex),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(t.menuLogout),
          onTap: () async {
            await ref.read(authProvider.notifier).logout();
            if (context.mounted) {
              context.go('/login');
            }
          },
        ),
      ],
    );
  }

  Widget _sectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _menuItem(int index, IconData icon, String title, String subtitle, int selectedIndex) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = index == selectedIndex;

    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20, color: isSelected ? cs.primary : null),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: isSelected ? cs.primary : null,
        fontWeight: isSelected ? FontWeight.w600 : null,
      )),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
      selected: isSelected,
      selectedTileColor: cs.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      visualDensity: VisualDensity.compact,
      onTap: () => _navigate(index),
    );
  }
}
