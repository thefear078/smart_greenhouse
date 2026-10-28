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
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(_email.text, _password.text);
    }
  }

  void _onState(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.authenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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
            isLoading: state.isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
            child: const Text('Немає акаунта? Зареєструватися'),
          ),
        ],
      ),
    );
  }
}
