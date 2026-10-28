import 'package:flutter/material.dart';
import 'package:smart_greenhouse/theme/app_theme.dart';

/// Уніфіковане текстове поле форми.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.icon,
    super.key,
    this.controller,
    this.obscure = false,
    this.keyboardType,
    this.validator,
    this.initialValue,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        textInputAction: textInputAction,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }
}
