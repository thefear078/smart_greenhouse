import 'package:flutter/material.dart';
import 'package:smart_greenhouse/theme/app_theme.dart';

/// Логотип застосунку (іконка + назва).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.eco, size: size * 0.55, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Smart Greenhouse',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
