import 'package:frontwe/domain/entities/auth.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/auth/providers/auth_providers.dart';
import 'package:frontwe/presentation/auth/state/auth_state.dart';
import 'package:frontwe/presentation/auth/widgets/custom_header.dart';
import 'package:frontwe/presentation/auth/widgets/social_login_row.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/shared/widgets/CustomButton.dart';
import 'package:frontwe/presentation/shared/widgets/CustomDialog.dart';
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  bool obscurePassword = true;

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
    required AppLocalizations t,
  }) {
    emailError = null;
    passwordError = null;

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

    setState(() {});

    return isValid;
  }

  Future<void> _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final t = AppLocalizations.of(context)!;

    if (!_validateInputs(email: email, password: password, t: t)) {
      return;
    }

    final notifier = ref.read(authProvider.notifier);

    await notifier.login(AuthLoginInput(email: email, password: password));

    if (!mounted) return;

    final state = ref.read(authProvider);

    if (state.loginUser != null) {
      ref.read(dishRepositoryProvider).syncDishes();
      context.go('/ruleta');
    }
  }

  late final ProviderSubscription<AuthState> _authSub;

  @override
  void initState() {
    super.initState();

    _authSub = ref.listenManual(authProvider, (previous, next) async {
      if (next.errorMessage != null) {
        setState(() {
          emailError = null;
          passwordError = null;
        });

        if (next.errorField == 'email') {
          setState(() => emailError = next.errorMessage);
        } else if (next.errorField == 'password') {
          setState(() => passwordError = next.errorMessage);
        } else if (ModalRoute.of(context)?.isCurrent ?? false) {
          await CustomDialog.show(
            context: context,
            title: 'Error',
            message: next.errorMessage!,
            type: DialogType.error,
            acceptText: 'Ok',
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _authSub.close();

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(actions: const [LanguageButton(), ThemeButton()]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomHeader(
              icon: const Icon(Icons.touch_app, size: 32),
              title: t.title,
              subtitle: t.authTitleLogin,
            ),

            const SizedBox(height: 30),

            CustomTextField(
              label: t.email,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              errorText: emailError,
              onChanged: (_) {
                setState(() => emailError = null);
              },
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: t.password,
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              obscureText: obscurePassword,
              errorText: passwordError,
              onChanged: (_) {
                setState(() => passwordError = null);
              },
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),

            const SizedBox(height: 5),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.push('/forgot-password');
                },
                child: Text(t.forgotPassword),
              ),
            ),

            const SizedBox(height: 10),

            CustomButton(
              label: t.authTitleLogin,
              isLoading: authState.isLoading,
              onPressed: authState.isLoading
                  ? null
                  : () => _handleLogin(context),
            ),

            const SizedBox(height: 20),

            const SocialLoginRow(),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                context.push('/register');
              },
              child: Text(t.authDescriptionLogin),
            ),
          ],
        ),
      ),
    );
  }
}
