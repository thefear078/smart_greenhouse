import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/di/injector.dart';
import 'package:smart_greenhouse/logic/auth/auth_cubit.dart';
import 'package:smart_greenhouse/logic/network/network_cubit.dart';
import 'package:smart_greenhouse/ui/routes.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  // Автологін: збережена сесія -> одразу головний екран.
  runApp(
    SmartGreenhouseApp(
      initialRoute: hasSession ? AppRoutes.dashboard : AppRoutes.login,
    ),
  );
}

class SmartGreenhouseApp extends StatelessWidget {
  const SmartGreenhouseApp({super.key, this.initialRoute = AppRoutes.login});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: sl<AuthCubit>()),
        BlocProvider<NetworkCubit>(create: (_) => sl<NetworkCubit>()..start()),
      ],
      child: MaterialApp(
        title: 'Smart Greenhouse',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: initialRoute,
        routes: AppRoutes.table,
      ),
    );
  }
}
