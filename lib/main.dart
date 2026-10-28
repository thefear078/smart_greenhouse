import 'package:flutter/material.dart';
import 'package:smart_greenhouse/data/local/json_store.dart';
import 'package:smart_greenhouse/data/local/local_auth_repository.dart';
import 'package:smart_greenhouse/data/local/local_device_repository.dart';
import 'package:smart_greenhouse/domain/repositories/auth_repository.dart';
import 'package:smart_greenhouse/domain/repositories/device_repository.dart';
import 'package:smart_greenhouse/ui/app_scope.dart';
import 'package:smart_greenhouse/ui/routes.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await JsonStore.create();
  runApp(
    SmartGreenhouseApp(
      auth: LocalAuthRepository(store),
      devices: LocalDeviceRepository(store),
    ),
  );
}

class SmartGreenhouseApp extends StatelessWidget {
  const SmartGreenhouseApp({
    required this.auth,
    required this.devices,
    super.key,
  });

  final IAuthRepository auth;
  final IDeviceRepository devices;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      auth: auth,
      devices: devices,
      child: MaterialApp(
        title: 'Smart Greenhouse',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.table,
      ),
    );
  }
}
