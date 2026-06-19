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

class VerifyCodeScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  final codeController = TextEditingController();

  String? codeError;
  bool isLoading = false;

  bool _validateInputs(AppLocalizations t) {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        codeError = t.enterVerificationCode;
      });
      return false;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      setState(() {
        codeError = t.verificationCodeMustBeSixDigits;
      });
      return false;
    }

    return true;
  }

  Future<void> _verifyCode() async {
    final t = AppLocalizations.of(context)!;

    if (!_validateInputs(t)) return;

    final code = codeController.text.trim();

    setState(() {
      codeError = null;
    });

    try {
      setState(() {
        isLoading = true;
      });

      await ref.read(authProvider.notifier).verifyResetCode(
            email: widget.email,
            code: code,
          );

      final authState = ref.read(authProvider);

      if (!mounted) return;

      if (authState.errorMessage != null) {
        await CustomDialog.show(
          context: context,
          title: 'Error',
          message: authState.errorMessage!,
          type: DialogType.error,
          acceptText: 'Ok',
        );
        return;
      }

      context.push('/reset-password', extra: {
        'email': widget.email,
        'code': code,
      });
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

  Future<void> _resendCode() async {
    final t = AppLocalizations.of(context)!;

    try {
      setState(() {
        isLoading = true;
      });

      await ref.read(authProvider.notifier).forgotPassword(widget.email);

      final authState = ref.read(authProvider);

      if (!authState.forgotPasswordSuccess) {
        if (!mounted) return;
        await CustomDialog.show(
          context: context,
          title: 'Error',
          message: authState.errorMessage ?? t.forgotPasswordCodeSendError,
          type: DialogType.error,
          acceptText: 'Ok',
        );
        return;
      }

      if (!mounted) return;
      CustomToast.show(
        context,
        message: t.forgotPasswordCodeSentSuccess,
        type: ToastType.success,
      );
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
              icon: const Icon(Icons.pin, size: 32),
              title: t.verificationCode,
              subtitle: t.subtitleForgotPassword,
            ),

            const SizedBox(height: 30),

            Text(
              t.codeSentToEmail,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              widget.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const SizedBox(height: 8),

            Text(
              t.enterCodeDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: t.verificationCode,
              controller: codeController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              errorText: codeError,
              onChanged: (_) {
                setState(() {
                  codeError = null;
                });
              },
            ),

            const SizedBox(height: 25),

            CustomButton(
              label: t.verifyCodeButton,
              isLoading: isLoading,
              onPressed: isLoading ? null : _verifyCode,
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: isLoading ? null : _resendCode,
              child: Text(t.resendCode),
            ),

            const SizedBox(height: 5),

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
