import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/auth/widgets/custom_header.dart';
import 'package:frontwe/presentation/shared/widgets/CustomButton.dart';
import 'package:frontwe/presentation/shared/widgets/LanguageButton.dart';
import 'package:frontwe/presentation/shared/widgets/TextFieldWidget.dart';
import 'package:frontwe/presentation/shared/widgets/ThemeButton.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  String? emailError;
  bool isLoading = false;

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  Future<void> _sendCode() async {
    final email = emailController.text.trim();
    final t = AppLocalizations.of(context)!;

    setState(() {
      emailError = null;
    });

    if (email.isEmpty) {
      setState(() {
        emailError = t.valRequiredEmail;
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        emailError = t.valEmailInvalid;
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // TODO:
      // await ref.read(authProvider.notifier)
      //     .sendResetCode(email);

      await Future.delayed(
        const Duration(seconds: 1),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Código enviado al correo',
          ),
        ),
      );

      context.push(
        '/reset-password',
        extra: email,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
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
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        actions: const [
          LanguageButton(),
          ThemeButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomHeader(
              icon: const Icon(
                Icons.lock_reset,
                size: 32,
              ),
              title: t.title,
              subtitle: 'Recuperar contraseña',
            ),

            const SizedBox(height: 30),

            CustomTextField(
              label: t.email,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              errorText: emailError,
              onChanged: (_) {
                setState(() {
                  emailError = null;
                });
              },
            ),

            const SizedBox(height: 25),

            CustomButton(
              label: 'Enviar código',
              isLoading: isLoading,
              onPressed: isLoading ? null : _sendCode,
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                'Volver al login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}