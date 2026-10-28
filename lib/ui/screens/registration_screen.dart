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

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      await AppScope.of(context).auth.register(
        name: _name.text,
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;
      Snack.success(context, 'Акаунт створено');
      await Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (_) => false,
      );
    } on AuthException catch (e) {
      if (mounted) Snack.error(context, e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Реєстрація',
      subtitle: 'Створіть акаунт, щоб підключити свою теплицю',
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: "Ім'я",
                icon: Icons.person_outline,
                controller: _name,
                validator: Validators.name,
              ),
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
                validator: Validators.password,
              ),
              AppTextField(
                label: 'Підтвердіть пароль',
                icon: Icons.lock_reset,
                obscure: true,
                textInputAction: TextInputAction.done,
                validator: Validators.confirm(() => _password.text),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: 'Створити акаунт',
          icon: Icons.person_add_alt_1,
          isLoading: _loading,
          onPressed: _register,
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
