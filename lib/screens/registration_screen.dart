import 'package:flutter/material.dart';
import 'package:smart_greenhouse/routes.dart';
import 'package:smart_greenhouse/theme/app_theme.dart';
import 'package:smart_greenhouse/widgets/app_text_field.dart';
import 'package:smart_greenhouse/widgets/auth_layout.dart';
import 'package:smart_greenhouse/widgets/primary_button.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Реєстрація',
      subtitle: 'Створіть акаунт, щоб підключити свою теплицю',
      children: [
        const AppTextField(label: "Ім'я", icon: Icons.person_outline),
        const AppTextField(
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const AppTextField(
          label: 'Пароль',
          icon: Icons.lock_outline,
          obscure: true,
        ),
        const AppTextField(
          label: 'Підтвердіть пароль',
          icon: Icons.lock_reset,
          obscure: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: 'Створити акаунт',
          icon: Icons.person_add_alt_1,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (_) => false,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Вже є акаунт? Увійти'),
        ),
      ],
    );
  }
}
