import 'package:frontwe/domain/entities/auth.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/auth/SocialLoginRow.dart';
import 'package:frontwe/presentation/auth/widgets/CustomHeader.dart';
import 'package:frontwe/presentation/providers/auth/auth_providers.dart';
import 'package:frontwe/presentation/shared/widgets/CustomButton.dart';
import 'package:frontwe/presentation/shared/widgets/LanguageButton.dart';
import 'package:frontwe/presentation/shared/widgets/TextFieldWidget.dart';
import 'package:frontwe/presentation/shared/widgets/ThemeButton.dart';
import 'package:frontwe/presentation/subscription/SubscriptionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(actions: [LanguageButton(), ThemeButton()]),
      // drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomHeader(
              icon: Icon(Icons.touch_app, size: 32),
              title: t!.title,
              subtitle: t.subtitle,
            ),
            const SizedBox(height: 30),
            CustomTextField(label: t.fullName, controller: fullNameController),
            const SizedBox(height: 30),
            CustomTextField(label: t.email, controller: emailController),
            const SizedBox(height: 15),
            CustomTextField(
              label: t.password,
              obscureText: true,
              controller: passwordController,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: t.loginButton,
                onPressed: () async {
                  final email = emailController.text;
                  final password = passwordController.text;
                  final fullName = fullNameController.text;

                  final user = AuthRegisterInput(
                    email: email,
                    password: password,
                    fullName: fullName,
                  );

                  await ref.read(authProvider.notifier).register(user);

                  final updatedState = ref.read(authProvider);

                  if (updatedState.registerUser != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SubscriptionScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(updatedState.errorMessage ?? 'Error'),
                      ),
                    );
                  }
                },
              ),
            ),
            //TODO: implementar mas adelante olvidaste tu contraseña?
            const SizedBox(height: 20),
            const SocialLoginRow(),
          ],
        ),
      ),
    );
  }
}
