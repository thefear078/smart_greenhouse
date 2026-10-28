import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/domain/validators.dart';
import 'package:smart_greenhouse/logic/auth/auth_cubit.dart';
import 'package:smart_greenhouse/logic/auth/auth_state.dart';
import 'package:smart_greenhouse/ui/routes.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';
import 'package:smart_greenhouse/ui/widgets/app_text_field.dart';
import 'package:smart_greenhouse/ui/widgets/auth_layout.dart';
import 'package:smart_greenhouse/ui/widgets/primary_button.dart';
import 'package:smart_greenhouse/ui/widgets/snack.dart';

/// StatefulWidget лише для TextEditingController (локальний UI-стан).
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

  @override
  void dispose() {
    for (final c in [_name, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        _name.text,
        _email.text,
        _password.text,
      );
    }
  }

  void _onState(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.authenticated) {
      if (state.message != null) Snack.success(context, state.message!);
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (_) => false,
      );
    } else if (state.status == AuthStatus.failure && state.message != null) {
      Snack.error(context, state.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (a, b) => a != b,
      listener: _onState,
      builder: (context, state) => AuthLayout(
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
            isLoading: state.isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Вже є акаунт? Увійти'),
          ),
        ],
      ),
    );
  }
}
