import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

class CustomToast {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    IconData icon;
    Color backgroundColor;

    switch (type) {
      case ToastType.success:
        icon = Icons.check_circle;
        backgroundColor = Colors.green;
        break;
      case ToastType.error:
        icon = Icons.error;
        backgroundColor = Colors.red;
        break;
      case ToastType.warning:
        icon = Icons.warning;
        backgroundColor = Colors.orange;
        break;
      case ToastType.info:
        icon = Icons.info;
        backgroundColor = Colors.blue;
        break;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: backgroundColor,
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
