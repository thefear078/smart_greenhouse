import 'package:flutter/material.dart';
import 'package:smart_greenhouse/data/local/json_store.dart';
import 'package:smart_greenhouse/data/local/local_auth_repository.dart';
import 'package:smart_greenhouse/data/local/local_device_repository.dart';
import 'package:smart_greenhouse/data/services/connectivity_network_monitor.dart';
import 'package:smart_greenhouse/data/services/mqtt_sensor_service.dart';
import 'package:smart_greenhouse/domain/repositories/auth_repository.dart';
import 'package:smart_greenhouse/domain/repositories/device_repository.dart';
import 'package:smart_greenhouse/domain/services/network_monitor.dart';
import 'package:smart_greenhouse/domain/services/sensor_service.dart';
import 'package:smart_greenhouse/ui/app_scope.dart';
import 'package:smart_greenhouse/ui/routes.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await JsonStore.create();
  final auth = LocalAuthRepository(store);
  // Автологін: якщо сесія збережена — одразу на головний екран
  // (навіть без мережі; про обмежений режим попередить NetworkBanner).
  final loggedIn = await auth.currentUser() != null;
  runApp(
    SmartGreenhouseApp(
      auth: auth,
      devices: LocalDeviceRepository(store),
      network: ConnectivityNetworkMonitor(),
      sensors: MqttSensorService(),
      initialRoute: loggedIn ? AppRoutes.dashboard : AppRoutes.login,
    ),
  );
}

class SmartGreenhouseApp extends StatelessWidget {
  const SmartGreenhouseApp({
    required this.auth,
    required this.devices,
    required this.network,
    required this.sensors,
    super.key,
    this.initialRoute = AppRoutes.login,
  });

  final IAuthRepository auth;
  final IDeviceRepository devices;
  final INetworkMonitor network;
  final ISensorService sensors;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      auth: auth,
      devices: devices,
      network: network,
      sensors: sensors,
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
