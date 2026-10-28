import 'package:flutter/material.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

/// Аватар з ініціалами, ім'ям та email.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({required this.name, required this.email, super.key});

  final String name;
  final String email;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((p) => p.isEmpty ? '' : p[0]).join();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: AppColors.primaryLight,
          child: Text(
            _initials.toUpperCase(),
            style: text.headlineMedium?.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          name,
          textAlign: TextAlign.center,
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          email,
          style: text.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
