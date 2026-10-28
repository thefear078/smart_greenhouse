import 'package:flutter/material.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

/// Показ коротких повідомлень користувачу.
abstract final class Snack {
  static void error(BuildContext context, String message) =>
      _show(context, message, AppColors.danger, Icons.error_outline);

  static void success(BuildContext context, String message) =>
      _show(context, message, AppColors.primary, Icons.check_circle_outline);

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
