import 'package:flutter/material.dart';
import 'package:smart_greenhouse/domain/repositories/auth_repository.dart';
import 'package:smart_greenhouse/domain/validators.dart';
import 'package:smart_greenhouse/ui/app_scope.dart';
import 'package:smart_greenhouse/ui/routes.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';
import 'package:smart_greenhouse/ui/widgets/app_text_field.dart';
import 'package:smart_greenhouse/ui/widgets/auth_layout.dart';
import 'package:smart_greenhouse/ui/widgets/primary_button.dart';
import 'package:smart_greenhouse/ui/widgets/snack.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!await AppScope.of(context).network.isOnline()) {
      if (mounted) {
        Snack.error(context, 'Немає інтернету — вхід неможливий');
      }
      return;
    }
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      await AppScope.of(
        context,
      ).auth.login(email: _email.text, password: _password.text);
      if (!mounted) return;
      await Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } on AuthException catch (e) {
      if (mounted) Snack.error(context, e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Вхід',
      subtitle: 'Керуйте теплицею з будь-якого місця',
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: 'Email',
                icon: Icons.email_outlined,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              AppTextField(
                label: 'Пароль',
                icon: Icons.lock_outline,
                controller: _password,
                obscure: true,
                textInputAction: TextInputAction.done,
                validator: Validators.password,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: 'Увійти',
          icon: Icons.login,
          isLoading: _loading,
          onPressed: _login,
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
