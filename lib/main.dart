import 'package:flutter/material.dart';
import 'package:smart_greenhouse/routes.dart';
import 'package:smart_greenhouse/theme/app_theme.dart';

void main() {
  runApp(const SmartGreenhouseApp());
}

class SmartGreenhouseApp extends StatelessWidget {
  const SmartGreenhouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Greenhouse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.table,
    );
  }
}
