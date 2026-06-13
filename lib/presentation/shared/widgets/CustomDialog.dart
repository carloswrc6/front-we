import 'dart:async';
import 'package:flutter/material.dart';

enum DialogType { success, error, warning, info }

class CustomDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    DialogType type = DialogType.info,
    String acceptText = 'Aceptar',
    String? cancelText,
    Duration? autoCloseDuration,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        if (autoCloseDuration != null) {
          Timer(autoCloseDuration, () {
            if (Navigator.of(dialogContext).canPop()) {
              Navigator.of(dialogContext).pop();
            }
          });
        }

        IconData icon;

        switch (type) {
          case DialogType.success:
            icon = Icons.check_circle;
            break;
          case DialogType.error:
            icon = Icons.error;
            break;
          case DialogType.warning:
            icon = Icons.warning;
            break;
          case DialogType.info:
            icon = Icons.info;
            break;
        }

        return AlertDialog(
          title: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(message),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(cancelText),
              ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(acceptText),
            ),
          ],
        );
      },
    );
  }
}
