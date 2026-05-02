import 'package:frontwe/domain/entities/auth.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/auth/SocialLoginRow.dart';
import 'package:frontwe/presentation/auth/widgets/CustomHeader.dart';
import 'package:frontwe/presentation/providers/auth/auth_providers.dart';
import 'package:frontwe/presentation/shared/widgets/CustomButton.dart';
import 'package:frontwe/presentation/shared/widgets/LanguageButton.dart';
import 'package:frontwe/presentation/shared/widgets/TextFieldWidget.dart';
import 'package:frontwe/presentation/shared/widgets/ThemeButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isRegister = false;

  Future<void> _handleAuth(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ref
          .read(authProvider.notifier)
          .setError("Email y contraseña son obligatorios");
      return;
    }

    if (isRegister && fullName.isEmpty) {
      ref
          .read(authProvider.notifier)
          .setError("Email y contraseña son obligatorios");
      return;
    }

    if (isRegister) {
      final user = AuthRegisterInput(
        email: email,
        password: password,
        fullName: fullName,
      );

      await ref.read(authProvider.notifier).register(user);
    } else {
      final user = AuthLoginInput(email: email, password: password);

      await ref.read(authProvider.notifier).login(user);
    }

    if (!mounted) return;

    final updatedState = ref.read(authProvider);

    if (updatedState.loginUser != null) {
      context.go('/subscription');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(actions: [LanguageButton(), ThemeButton()]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomHeader(
              icon: const Icon(Icons.touch_app, size: 32),
              title: t!.title,
              subtitle: isRegister ? "Crear cuenta" : "Iniciar sesión",
            ),

            const SizedBox(height: 30),

            if (isRegister)
              CustomTextField(
                label: t.fullName,
                controller: fullNameController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              ),

            const SizedBox(height: 15),
            CustomTextField(
              label: t.email,
              controller: emailController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 15),

            CustomTextField(
              label: t.password,
              obscureText: true,
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 5),

            /// 🔁 Toggle login/register
            TextButton(
              onPressed: () {
                setState(() {
                  isRegister = !isRegister;
                });
              },
              child: Text(
                isRegister
                    ? "¿Ya tienes cuenta? Inicia sesión"
                    : "¿No tienes cuenta? Regístrate",
              ),
            ),

            const SizedBox(height: 5),

            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: authState.isLoading
                    ? "Cargando..."
                    : isRegister
                    ? "Registrarse"
                    : "Iniciar sesión",
                onPressed: () {
                  _handleAuth(context);
                },
              ),
            ),
            const SizedBox(height: 10),
            if (authState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  authState.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            if (authState.registerUser != null)
              const Text(
                "Login exitoso",
                style: TextStyle(color: Colors.green),
              ),
            const SocialLoginRow(),
          ],
        ),
      ),
    );
  }
}
