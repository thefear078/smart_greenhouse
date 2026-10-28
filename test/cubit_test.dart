import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_greenhouse/data/local/json_store.dart';
import 'package:smart_greenhouse/data/local/local_auth_repository.dart';
import 'package:smart_greenhouse/data/local/local_device_repository.dart';
import 'package:smart_greenhouse/di/injector.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/domain/models/sensor.dart';
import 'package:smart_greenhouse/domain/repositories/device_repository.dart';
import 'package:smart_greenhouse/logic/auth/auth_cubit.dart';
import 'package:smart_greenhouse/logic/auth/auth_state.dart';
import 'package:smart_greenhouse/logic/devices/devices_cubit.dart';
import 'package:smart_greenhouse/logic/devices/devices_state.dart';
import 'package:smart_greenhouse/logic/telemetry/telemetry_cubit.dart';

import 'fakes.dart';

void main() {
  late FakeNetwork net;
  late FakeSensors sensors;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final store = await JsonStore.create();
    net = FakeNetwork();
    sensors = FakeSensors();
    await registerDependencies(
      auth: LocalAuthRepository(store),
      devices: LocalDeviceRepository(store),
      network: net,
      sensors: sensors,
    );
  });

  test('repositories and services are singletons', () {
    expect(identical(sl<IDeviceRepository>(), sl<IDeviceRepository>()), true);
    expect(identical(sl<AuthCubit>(), sl<AuthCubit>()), true);
  });

  test('AuthCubit: offline -> failure, register -> authenticated', () async {
    final cubit = sl<AuthCubit>();
    net.online = false;
    await cubit.register('Ann', 'a@b.com', 'password1');
    expect(cubit.state.status, AuthStatus.failure);
    net.online = true;
    await cubit.register('Ann', 'a@b.com', 'password1');
    expect(cubit.state.status, AuthStatus.authenticated);
    expect(cubit.state.user?.name, 'Ann');
    await cubit.logout();
    expect(cubit.state.status, AuthStatus.unauthenticated);
  });

  test('DevicesCubit: load -> add -> toggle -> delete', () async {
    final cubit = sl<DevicesCubit>();
    await cubit.load();
    expect(cubit.state.status, DevicesStatus.loaded);
    final n = cubit.state.devices.length;
    await cubit.add('Lamp', 'C', DeviceType.lamp);
    expect(cubit.state.devices.length, n + 1);
    final lamp = cubit.state.devices.last;
    await cubit.toggle(lamp, on: true);
    expect(cubit.state.devices.last.isOn, true);
    await cubit.delete(lamp.id);
    expect(cubit.state.devices.length, n);
    await cubit.close();
  });

  test('TelemetryCubit: readings to state, disconnect on close', () async {
    final cubit = sl<TelemetryCubit>()..start();
    sensors.emit(SensorKind.light, 900);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.latest[SensorKind.light]?.status, 'Мало світла');
    await cubit.close();
    expect(sensors.disconnects, 1);
  });
}
