import 'package:flutter/material.dart';
import 'package:smart_greenhouse/data/mock_data.dart';
import 'package:smart_greenhouse/domain/models/user.dart';
import 'package:smart_greenhouse/domain/validators.dart';
import 'package:smart_greenhouse/ui/app_scope.dart';
import 'package:smart_greenhouse/ui/routes.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';
import 'package:smart_greenhouse/ui/widgets/info_row.dart';
import 'package:smart_greenhouse/ui/widgets/page_container.dart';
import 'package:smart_greenhouse/ui/widgets/primary_button.dart';
import 'package:smart_greenhouse/ui/widgets/profile_avatar.dart';
import 'package:smart_greenhouse/ui/widgets/section_header.dart';
import 'package:smart_greenhouse/ui/widgets/snack.dart';
import 'package:smart_greenhouse/ui/widgets/text_prompt_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      AppScope.of(context).auth.currentUser().then((u) {
        if (mounted) setState(() => _user = u);
      });
    }
  }

  Future<void> _editName() async {
    final name = await textPromptDialog(
      context,
      title: "Змінити ім'я",
      initial: _user?.name ?? '',
      validator: Validators.name,
    );
    if (name == null || !mounted) return;
    final updated = await AppScope.of(context).auth.updateName(name);
    if (!mounted) return;
    setState(() => _user = updated);
    Snack.success(context, 'Профіль оновлено');
  }

  Future<void> _logout() async {
    await AppScope.of(context).auth.logout();
    if (!mounted) return;
    await Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
            onPressed: _editName,
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: 'Вийти',
            icon: Icons.logout,
            outlined: true,
            onPressed: _logout,
          ),
        ],
      ),
    );
  }
}
