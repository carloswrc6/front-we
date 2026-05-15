import 'package:frontwe/infrastructure/datasource/google_auth_datasource.dart';
import 'package:frontwe/presentation/shared/widgets/CustomButton.dart';
import 'package:flutter/material.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              label: 'Google',
              icon: Image.asset('assets/login/google.png', height: 20),
              onPressed: () {
                GoogleSignInService.signInWithGoogle();
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: CustomButton(
              label: 'Apple',
              icon: Image.asset('assets/login/apple.png', height: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
