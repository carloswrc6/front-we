import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/presentation/auth/providers/auth_providers.dart';
import 'package:frontwe/presentation/shared/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SocialLoginRow extends ConsumerWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final platform = Theme.of(context).platform;
    final showGoogle = platform == TargetPlatform.android || platform == TargetPlatform.iOS;
    final showApple = platform == TargetPlatform.iOS;

    final buttons = <Widget>[];

    if (showGoogle) {
      buttons.add(
        Expanded(
          child: CustomButton(
            label: 'Google',
            icon: const Icon(Icons.g_mobiledata, size: 22),
            onPressed: () async {
              await ref
                  .read(authProvider.notifier)
                  .loginGoogle();

              if (!context.mounted) return;

              final authState =
                  ref.read(authProvider);

              if (authState.isAuthenticated) {
                context.go('/ruleta');
              }
            },
          ),
        ),
      );
    }

    if (showApple) {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(width: 15));
      }
      buttons.add(
        Expanded(
          child: CustomButton(
            label: 'Apple',
            icon: const Icon(Icons.apple, size: 20),
            onPressed: () {},
          ),
        ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(children: buttons),
    );
  }
}
