import 'package:flutter/material.dart';
import 'package:smart_greenhouse/routes.dart';
import 'package:smart_greenhouse/theme/app_theme.dart';
import 'package:smart_greenhouse/widgets/app_text_field.dart';
import 'package:smart_greenhouse/widgets/auth_layout.dart';
import 'package:smart_greenhouse/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Вхід',
      subtitle: 'Керуйте теплицею з будь-якого місця',
      children: [
        const AppTextField(
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const AppTextField(
          label: 'Пароль',
          icon: Icons.lock_outline,
          obscure: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: 'Увійти',
          icon: Icons.login,
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
          child: const Text('Немає акаунта? Зареєструватися'),
        ),
      ],
    );
  }
}
