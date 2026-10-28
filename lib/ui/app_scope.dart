import 'package:flutter/widgets.dart';
import 'package:smart_greenhouse/domain/repositories/auth_repository.dart';
import 'package:smart_greenhouse/domain/repositories/device_repository.dart';
import 'package:smart_greenhouse/domain/services/network_monitor.dart';
import 'package:smart_greenhouse/domain/services/sensor_service.dart';

/// Надає віджетам абстракції репозиторіїв (інверсія залежностей):
/// екрани не знають, яка реалізація сховища використовується.
class AppScope extends InheritedWidget {
  const AppScope({
    required this.auth,
    required this.devices,
    required this.network,
    required this.sensors,
    required super.child,
    super.key,
  });

  final IAuthRepository auth;
  final IDeviceRepository devices;
  final INetworkMonitor network;
  final ISensorService sensors;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope не знайдено в дереві віджетів');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      auth != oldWidget.auth ||
      devices != oldWidget.devices ||
      network != oldWidget.network ||
      sensors != oldWidget.sensors;
}
