import 'package:flutter/material.dart';
import 'package:smart_greenhouse/data/mock_data.dart';
import 'package:smart_greenhouse/routes.dart';
import 'package:smart_greenhouse/theme/app_theme.dart';
import 'package:smart_greenhouse/widgets/info_row.dart';
import 'package:smart_greenhouse/widgets/page_container.dart';
import 'package:smart_greenhouse/widgets/primary_button.dart';
import 'package:smart_greenhouse/widgets/profile_avatar.dart';
import 'package:smart_greenhouse/widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: PageContainer(
        children: [
          const ProfileAvatar(
            name: MockData.userName,
            email: MockData.userEmail,
          ),
          const SectionHeader(title: 'Обліковий запис'),
          const Card(
            child: Column(
              children: [
                InfoRow(
                  icon: Icons.person_outline,
                  label: "Ім'я",
                  value: MockData.userName,
                ),
                InfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: MockData.userEmail,
                ),
                InfoRow(
                  icon: Icons.house_siding,
                  label: 'Теплиця',
                  value: MockData.greenhouseName,
                ),
                InfoRow(
                  icon: Icons.sensors,
                  label: 'Пристроїв підключено',
                  value: '8',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Редагувати профіль',
            icon: Icons.edit_outlined,
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: 'Вийти',
            icon: Icons.logout,
            outlined: true,
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (_) => false,
            ),
          ),
        ],
      ),
    );
  }
}
