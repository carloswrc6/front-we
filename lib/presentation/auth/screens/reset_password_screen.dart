import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/presentation/auth/providers/auth_providers.dart';
import 'package:frontwe/presentation/shared/widgets/CustomDialog.dart';
import 'package:frontwe/presentation/shared/widgets/CustomToast.dart';
import 'package:go_router/go_router.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/auth/widgets/custom_header.dart';
import 'package:frontwe/presentation/shared/widgets/CustomButton.dart';
import 'package:frontwe/presentation/shared/widgets/LanguageButton.dart';
import 'package:frontwe/presentation/shared/widgets/TextFieldWidget.dart';
import 'package:frontwe/presentation/shared/widgets/ThemeButton.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? codeError;
  String? passwordError;
  String? confirmPasswordError;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  bool _isValidPassword(String password) {
    final regex = RegExp(r'(?:(?=.*\d)|(?=.*\W+))(?=.*[A-Z])(?=.*[a-z]).*');

    return regex.hasMatch(password);
  }

  bool _validateInputs(AppLocalizations t) {
    codeError = null;
    passwordError = null;
    confirmPasswordError = null;

    bool isValid = true;

    final code = codeController.text.trim();

    if (code.isEmpty) {
      codeError = t.enterVerificationCode;
      isValid = false;
    } else if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      codeError = t.verificationCodeMustBeSixDigits;
      isValid = false;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError = t.valPwd;
      isValid = false;
    } else if (passwordController.text.trim().length < 6) {
      passwordError = t.valMinSixStr;
      isValid = false;
    } else if (!_isValidPassword(passwordController.text.trim())) {
      passwordError = t.valMayusMinusNumber;
      isValid = false;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      confirmPasswordError = t.confirmPassword;
      isValid = false;
    } else if (confirmPasswordController.text.trim() !=
        passwordController.text.trim()) {
      confirmPasswordError = t.passwordsDoNotMatch;
      isValid = false;
    }

    setState(() {});

    return isValid;
  }

  Future<void> _changePassword() async {
    final t = AppLocalizations.of(context)!;

    if (!_validateInputs(t)) return;

    try {
      setState(() {
        isLoading = true;
      });

      final code = codeController.text.trim();
      final password = passwordController.text.trim();

      await ref.read(authProvider.notifier).resetPassword(
            email: widget.email,
            code: code,
            newPassword: password,
          );
      final authState = ref.read(authProvider);

      if (!mounted) return;

      if (!authState.resetPasswordSuccess) {

        await CustomDialog.show(
          context: context,
          title: 'Error',
          message:
              authState.errorMessage ?? t.passwordUpdateError,
          type: DialogType.error,
          acceptText: 'Ok',
        );
        return;
      }

      CustomToast.show(
        context,
        message: t.passwordUpdatedSuccessfully,
        type: ToastType.success,
      );

      context.go('/login');
    } catch (e) {
      if (!mounted) return;

      await CustomDialog.show(
        context: context,
        title: 'Error',
        message: e.toString(),
        type: DialogType.error,
        acceptText: 'Ok',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(actions: const [LanguageButton(), ThemeButton()]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomHeader(
              icon: const Icon(Icons.password, size: 32),
              title: t.title,
              subtitle: t.subtitleChangePassword,
            ),

            const SizedBox(height: 30),

            Text(
              t.sixDigitCodeSentTo,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            Text(widget.email, style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 20),

            CustomTextField(
              label: t.verificationCode,
              controller: codeController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              errorText: codeError,
              onChanged: (_) {
                setState(() {
                  codeError = null;
                });
              },
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: t.password,
              controller: passwordController,
              obscureText: obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              errorText: passwordError,
              onChanged: (_) {
                setState(() {
                  passwordError = null;
                });
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

            const SizedBox(height: 15),

            CustomTextField(
              label: t.confirmPasswordLabel,
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              errorText: confirmPasswordError,
              onChanged: (_) {
                setState(() {
                  confirmPasswordError = null;
                });
              },
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscureConfirmPassword = !obscureConfirmPassword;
                  });
                },
              ),
            ),

            const SizedBox(height: 25),

            CustomButton(
              label: t.updatePassword,
              isLoading: isLoading,
              onPressed: isLoading ? null : _changePassword,
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: Text(t.backToLogin),
            ),
          ],
        ),
      ),
    );
  }
}
