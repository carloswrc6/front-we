import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/infrastructure/services/purchase_service.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/providers/premium/premium_providers.dart';
import 'package:go_router/go_router.dart';

Future<bool> showPremiumLockDialog(
  BuildContext context, {
  String? title,
  String? message,
}) async {
  final t = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.workspace_premium, size: 40),
      title: Text(title ?? t.subsPremiumLocked),
      content: Text(message ?? t.subsPremiumLockedMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(t.wheelSettingsCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(t.subsGoPremium),
        ),
      ],
    ),
  );
  if (result == true && context.mounted) {
    context.push('/subscription');
    return false;
  }
  return false;
}

/// Devuelve true si el usuario es premium. Si no lo es, muestra el diálogo
/// de bloqueo y navega al paywall al confirmar.
bool ensurePremium(
  BuildContext context, {
  String? title,
  String? message,
}) {
  final isPremium = PurchaseService.instance.isPremium;
  if (!isPremium) {
    showPremiumLockDialog(context, title: title, message: message);
  }
  return isPremium;
}

/// Muestra un diálogo con título/mensaje y CTA "Ver planes".
Future<void> showLimitDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final t = AppLocalizations.of(context)!;
  final go = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.lock_outline, size: 40),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(t.wheelSettingsCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(t.subsGoPremium),
        ),
      ],
    ),
  );
  if (go == true && context.mounted) {
    context.push('/subscription');
  }
}

/// Widget que escucha el estado premium en tiempo real.
class PremiumScope extends ConsumerWidget {
  final Widget Function(BuildContext context, bool isPremium) builder;

  const PremiumScope({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(purchaseServiceProvider);
    return StreamBuilder<bool>(
      initialData: service.isPremium,
      stream: service.premiumStream,
      builder: (context, snapshot) => builder(context, snapshot.data ?? false),
    );
  }
}
