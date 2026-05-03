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

  String? emailError;
  String? passwordError;
  String? fullNameError;

  bool isRegister = false;
  bool obscurePassword = true;

  void _setError(String message) {
    ref.read(authProvider.notifier).setError(message);
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final regex = RegExp(r'(?:(?=.*\d)|(?=.*\W+))(?=.*[A-Z])(?=.*[a-z]).*');
    return regex.hasMatch(password);
  }

  bool _validateInputs({
    required String email,
    required String password,
    required String fullName,
    required AppLocalizations t,
  }) {
    // limpiar errores antes de validar
    emailError = null;
    passwordError = null;
    fullNameError = null;

    bool isValid = true;

    if (email.isEmpty) {
      emailError = t.valRequiredEmail;
      isValid = false;
    } else if (!_isValidEmail(email)) {
      emailError = t.valEmailInvalid;
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError = t.valPwd;
      isValid = false;
    } else if (password.length < 6) {
      passwordError = t.valMinSixStr;
      isValid = false;
    } else if (!_isValidPassword(password)) {
      passwordError = t.valMayusMinusNumber;
      isValid = false;
    }

    if (isRegister && fullName.isEmpty) {
      fullNameError = t.valFullname;
      isValid = false;
    }

    setState(() {});

    return isValid;
  }

  Future<void> _handleAuth(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();
    final t = AppLocalizations.of(context)!;

    if (!_validateInputs(
      email: email,
      password: password,
      fullName: fullName,
      t: t,
    ))
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

  late final ProviderSubscription _authSub;

  @override
  void initState() {
    super.initState();

    _authSub = ref.listenManual(authProvider, (previous, next) {
      if (next.errorMessage != null) {
        setState(() {
          emailError = null;
          passwordError = null;
          fullNameError = null;
        });

        if (next.errorField == 'email') {
          setState(() => emailError = next.errorMessage);
        } else if (next.errorField == 'password') {
          setState(() => passwordError = next.errorMessage);
        } else if (next.errorField == 'fullName') {
          setState(() => fullNameError = next.errorMessage);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        }
      }
    });
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
              subtitle: isRegister ? t.authTitleRegister : t.authTitleLogin,
            ),

            const SizedBox(height: 30),

            if (isRegister)
              CustomTextField(
                label: t.fullName,
                controller: fullNameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                errorText: fullNameError,
                onChanged: (_) {
                  setState(() => fullNameError = null);
                },
              ),

            const SizedBox(height: 15),
            CustomTextField(
              label: t.email,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              errorText: emailError,
              onChanged: (value) {
                setState(() => emailError = null);
              },
            ),
            const SizedBox(height: 15),

            CustomTextField(
              label: t.password,
              obscureText: obscurePassword,
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              errorText: passwordError,
              onChanged: (_) {
                setState(() => passwordError = null);
              },
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => obscurePassword = !obscurePassword);
                },
              ),
            ),

            const SizedBox(height: 5),

            /// 🔁 Toggle login/register
            TextButton(
              onPressed: () {
                setState(() {
                  isRegister = !isRegister;

                  emailError = null;
                  passwordError = null;
                  fullNameError = null;

                  emailController.clear();
                  passwordController.clear();
                  fullNameController.clear();
                });
              },
              child: Text(
                isRegister ? t.authDescriptionRegister : t.authDescriptionLogin,
              ),
            ),

            const SizedBox(height: 5),

            CustomButton(
              label: isRegister ? t.authTitleRegister : t.authTitleLogin,
              isLoading: authState.isLoading,
              onPressed: authState.isLoading
                  ? null
                  : () => _handleAuth(context),
            ),

            const SizedBox(height: 20),
            if (authState.loginUser != null || authState.registerUser != null)
              const Text(
                "Autenticación exitosa",
                style: TextStyle(color: Colors.green),
              ),
            const SocialLoginRow(),
          ],
        ),
      ),
    );
  }
}
