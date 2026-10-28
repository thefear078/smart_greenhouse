import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/data/mock_data.dart';
import 'package:smart_greenhouse/domain/validators.dart';
import 'package:smart_greenhouse/logic/auth/auth_cubit.dart';
import 'package:smart_greenhouse/logic/auth/auth_state.dart';
import 'package:smart_greenhouse/ui/routes.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';
import 'package:smart_greenhouse/ui/widgets/confirm_dialog.dart';
import 'package:smart_greenhouse/ui/widgets/info_row.dart';
import 'package:smart_greenhouse/ui/widgets/page_container.dart';
import 'package:smart_greenhouse/ui/widgets/primary_button.dart';
import 'package:smart_greenhouse/ui/widgets/profile_avatar.dart';
import 'package:smart_greenhouse/ui/widgets/section_header.dart';
import 'package:smart_greenhouse/ui/widgets/snack.dart';
import 'package:smart_greenhouse/ui/widgets/text_prompt_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(BuildContext context, String current) async {
    final cubit = context.read<AuthCubit>();
    final name = await textPromptDialog(
      context,
      title: "Змінити ім'я",
      initial: current,
      validator: Validators.name,
    );
    if (name != null) await cubit.updateName(name);
  }

  Future<void> _logout(BuildContext context) async {
    final cubit = context.read<AuthCubit>();
    final ok = await confirmDialog(
      context,
      title: 'Вийти з акаунта?',
      message: 'Збережену сесію буде видалено, потрібно буде увійти знову.',
      confirmLabel: 'Вийти',
    );
    if (ok) await cubit.logout();
  }

  void _onState(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.unauthenticated) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    } else if (state.message != null) {
      Snack.success(context, state.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: _onState,
      builder: (context, state) {
        final user = state.user;
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Профіль')),
          body: PageContainer(
            children: [
              ProfileAvatar(name: user.name, email: user.email),
              const SectionHeader(title: 'Обліковий запис'),
              Card(
                child: Column(
                  children: [
                    InfoRow(
                      icon: Icons.person_outline,
                      label: "Ім'я",
                      value: user.name,
                    ),
                    InfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user.email,
                    ),
                    const InfoRow(
                      icon: Icons.house_siding,
                      label: 'Теплиця',
                      value: MockData.greenhouseName,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Редагувати профіль',
                icon: Icons.edit_outlined,
                onPressed: () => _editName(context, user.name),
              ),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton(
                label: 'Вийти',
                icon: Icons.logout,
                outlined: true,
                onPressed: () => _logout(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
