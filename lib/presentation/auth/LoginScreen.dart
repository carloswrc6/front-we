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

  void _setError(String message) {
    ref.read(authProvider.notifier).setError(message);
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  bool _validateInputs({
    required String email,
    required String password,
    required String fullName,
  }) {
    if (email.isEmpty) {
      _setError("El email es obligatorio");
      return false;
    }

    if (!_isValidEmail(email)) {
      _setError("El email no es válido");
      return false;
    }

    if (password.isEmpty) {
      _setError("La contraseña es obligatoria");
      return false;
    }

    if (password.length < 6) {
      _setError("Mínimo 6 caracteres en la contraseña");
      return false;
    }

    if (isRegister && fullName.isEmpty) {
      _setError("El nombre completo es obligatorio");
      return false;
    }

    return true;
  }

  Future<void> _handleAuth(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();

    if (!_validateInputs(email: email, password: password, fullName: fullName))
      return;

    final notifier = ref.read(authProvider.notifier);

    if (isRegister) {
      print('en el register');
      await notifier.register(
        AuthRegisterInput(email: email, password: password, fullName: fullName),
      );
    } else {
      print('en el login');
      await notifier.login(AuthLoginInput(email: email, password: password));
    }

    if (!mounted) return;

    final state = ref.read(authProvider);

    final success = isRegister
        ? state.registerUser != null
        : state.loginUser != null;

    if (success) {
      print('a subscription');
      // context.go('/subscription');
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
