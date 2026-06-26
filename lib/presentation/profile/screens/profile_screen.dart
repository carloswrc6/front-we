import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/auth/providers/auth_providers.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final user = authState.loginUser;

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(t.menuProfile)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    (user?.fullName ?? '?')[0].toUpperCase(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.fullName ?? '',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Column(
              children: [
                _OptionTile(
                  icon: Icons.palette_outlined,
                  title: t.menuTheme,
                  onTap: () => context.push('/theme_changer'),
                ),
                Divider(height: 1, indent: 56, color: cs.outlineVariant),
                _OptionTile(
                  icon: Icons.subscriptions_outlined,
                  title: t.menuSubscription,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: _OptionTile(
              icon: Icons.logout,
              title: t.menuLogout,
              color: cs.error,
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = color ?? cs.onSurface;

    return ListTile(
      leading: Icon(icon, color: c),
      title: Text(title, style: TextStyle(color: c)),
      trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
