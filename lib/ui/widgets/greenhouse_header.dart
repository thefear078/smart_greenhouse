import 'package:flutter/material.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

/// Банер з назвою теплиці та загальним статусом.
class GreenhouseHeader extends StatelessWidget {
  const GreenhouseHeader({
    required this.name,
    required this.subtitle,
    super.key,
    this.trailing,
    this.onSecretLongPress,
  });

  final String name;
  final String subtitle;
  final Widget? trailing;

  /// Прихована дія (Easter egg) на довге натискання логотипа.
  final VoidCallback? onSecretLongPress;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Row(
        children: [
          GestureDetector(
            key: const Key('greenhouseLogo'),
            onLongPress: onSecretLongPress,
            child: const Icon(
              Icons.house_siding,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: text.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: text.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
