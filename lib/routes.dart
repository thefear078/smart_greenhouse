import 'package:flutter/material.dart';
import 'package:smart_greenhouse/screens/dashboard_screen.dart';
import 'package:smart_greenhouse/screens/login_screen.dart';
import 'package:smart_greenhouse/screens/profile_screen.dart';
import 'package:smart_greenhouse/screens/registration_screen.dart';

/// Іменовані маршрути застосунку.
abstract final class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get table => {
    login: (_) => const LoginScreen(),
    register: (_) => const RegistrationScreen(),
    dashboard: (_) => const DashboardScreen(),
    profile: (_) => const ProfileScreen(),
  };
}
