import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/di/injector.dart';
import 'package:smart_greenhouse/logic/devices/devices_cubit.dart';
import 'package:smart_greenhouse/logic/flashlight/flashlight_cubit.dart';
import 'package:smart_greenhouse/logic/telemetry/telemetry_cubit.dart';
import 'package:smart_greenhouse/ui/screens/dashboard_screen.dart';
import 'package:smart_greenhouse/ui/screens/login_screen.dart';
import 'package:smart_greenhouse/ui/screens/profile_screen.dart';
import 'package:smart_greenhouse/ui/screens/registration_screen.dart';

/// Іменовані маршрути. Cubit-и головного екрана живуть, поки відкритий
/// маршрут, і закриваються разом з ним (закриваючи підписки).
abstract final class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get table => {
    login: (_) => const LoginScreen(),
    register: (_) => const RegistrationScreen(),
    dashboard: (_) => MultiBlocProvider(
      providers: [
        BlocProvider<DevicesCubit>(create: (_) => sl<DevicesCubit>()..load()),
        BlocProvider<FlashlightCubit>(create: (_) => sl<FlashlightCubit>()),
        BlocProvider<TelemetryCubit>(
          create: (_) => sl<TelemetryCubit>()..start(),
        ),
      ],
      child: const DashboardScreen(),
    ),
    profile: (_) => const ProfileScreen(),
  };
}
