import 'package:flutter/material.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

/// Повідомлення про помилку з кнопкою «Повторити».
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          const Icon(Icons.cloud_off, size: 48, color: AppColors.danger),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Не вдалося завантажити пристрої',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Повторити'),
          ),
        ],
      ),
    );
  }
}
