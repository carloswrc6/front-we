import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/presentation/providers/auth/auth_providers.dart';
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
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              label: 'Google',
              icon: Image.asset(
                'assets/login/google.png',
                height: 20,
              ),
              onPressed: () async {

                await ref
                    .read(authProvider.notifier)
                    .loginGoogle();

                if (!context.mounted) return;

                final authState =
                    ref.read(authProvider);

                if (authState.isAuthenticated) {
                  context.go('/home');
                }
              },
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: CustomButton(
              label: 'Apple',
              icon: Image.asset(
                'assets/login/apple.png',
                height: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}