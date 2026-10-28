import 'package:get_it/get_it.dart';
import 'package:smart_greenhouse/data/cached/cached_device_repository.dart';
import 'package:smart_greenhouse/data/local/json_store.dart';
import 'package:smart_greenhouse/data/local/local_auth_repository.dart';
import 'package:smart_greenhouse/data/local/local_device_repository.dart';
import 'package:smart_greenhouse/data/remote/api_client.dart';
import 'package:smart_greenhouse/data/remote/remote_device_repository.dart';
import 'package:smart_greenhouse/data/services/connectivity_network_monitor.dart';
import 'package:smart_greenhouse/data/services/mqtt_sensor_service.dart';
import 'package:smart_greenhouse/data/services/plugin_flashlight.dart';
import 'package:smart_greenhouse/domain/repositories/auth_repository.dart';
import 'package:smart_greenhouse/domain/repositories/device_repository.dart';
import 'package:smart_greenhouse/domain/services/flashlight_service.dart';
import 'package:smart_greenhouse/domain/services/network_monitor.dart';
import 'package:smart_greenhouse/domain/services/sensor_service.dart';
import 'package:smart_greenhouse/logic/auth/auth_cubit.dart';
import 'package:smart_greenhouse/logic/devices/devices_cubit.dart';
import 'package:smart_greenhouse/logic/flashlight/flashlight_cubit.dart';
import 'package:smart_greenhouse/logic/network/network_cubit.dart';
import 'package:smart_greenhouse/logic/telemetry/telemetry_cubit.dart';

/// Єдиний DI-контейнер застосунку.
final GetIt sl = GetIt.instance;

/// Реєструє сервіси як singleton (створюються один раз) і Cubit-и.
/// Тести передають власні (фейкові) реалізації абстракцій.
Future<void> registerDependencies({
  required IAuthRepository auth,
  required IDeviceRepository devices,
  required INetworkMonitor network,
  required ISensorService sensors,
  IFlashlight? flashlight,
}) async {
  await sl.reset();
  final user = await auth.currentUser();
  _hasSession = user != null;
  sl
    ..registerSingleton<IAuthRepository>(auth)
    ..registerSingleton<IDeviceRepository>(devices)
    ..registerSingleton<INetworkMonitor>(network)
    ..registerSingleton<ISensorService>(sensors)
    ..registerSingleton<IFlashlight>(flashlight ?? PluginFlashlight())
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(sl(), sl(), initialUser: user),
    )
    ..registerLazySingleton<NetworkCubit>(() => NetworkCubit(sl()))
    ..registerFactory<DevicesCubit>(() => DevicesCubit(sl()))
    ..registerFactory<TelemetryCubit>(() => TelemetryCubit(sl()))
    ..registerFactory<FlashlightCubit>(() => FlashlightCubit(sl()));
}

/// Продакшн-конфігурація: локальне сховище, REST API з кешем, MQTT.
Future<void> configureDependencies() async {
  final store = await JsonStore.create();
  final auth = LocalAuthRepository(store);
  final network = ConnectivityNetworkMonitor();
  final api = ApiClient(
    baseUrl: ApiClient.defaultBaseUrl,
    tokenProvider: auth.token,
  );
  await registerDependencies(
    auth: auth,
    devices: CachedDeviceRepository(
      remote: RemoteDeviceRepository(api),
      cache: LocalDeviceRepository(store, withSeed: false),
      network: network,
    ),
    network: network,
    sensors: MqttSensorService(),
  );
}

/// Автологін на рівні точки входу: чи була збережена сесія.
bool get hasSession => _hasSession;
bool _hasSession = false;
