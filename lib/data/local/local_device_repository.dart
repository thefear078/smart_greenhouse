import 'package:smart_greenhouse/data/local/json_store.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/domain/repositories/device_cache.dart';
import 'package:smart_greenhouse/domain/repositories/device_repository.dart';

/// Реалізація [IDeviceRepository] у локальному сховищі.
/// Також слугує кешем ([IDeviceCache]) для мережевого репозиторію;
/// у цьому режимі ([withSeed] = false) стартовий набір не додається.
class LocalDeviceRepository implements IDeviceRepository, IDeviceCache {
  LocalDeviceRepository(this._store, {this.withSeed = true});

  final bool withSeed;

  static const String _key = 'devices';

  /// Стартовий набір пристроїв при першому запуску.
  static const List<Device> seed = [
    Device(
      id: 'd1',
      name: 'Вентилятор',
      zone: 'Зона A',
      type: DeviceType.fan,
      isOn: true,
    ),
    Device(
      id: 'd2',
      name: 'Насос поливу',
      zone: 'Зона B',
      type: DeviceType.pump,
    ),
    Device(
      id: 'd3',
      name: 'Фітолампа',
      zone: 'Зона A',
      type: DeviceType.lamp,
      isOn: true,
    ),
  ];

  final JsonStore _store;

  List<Device> _read() {
    final raw = _store.readList(_key);
    if (raw == null) return withSeed ? [...seed] : [];
    return raw.map(Device.fromJson).toList();
  }

  Future<void> _write(List<Device> devices) =>
      _store.writeList(_key, devices.map((d) => d.toJson()).toList());

  @override
  Future<List<Device>> getAll() async => List.unmodifiable(_read());

  @override
  Future<List<Device>> readCache() => getAll();

  @override
  Future<void> saveCache(List<Device> devices) => _write(devices);

  @override
  Future<Device> add({
    required String name,
    required String zone,
    required DeviceType type,
  }) async {
    final device = Device(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      zone: zone.trim(),
      type: type,
    );
    await _write([..._read(), device]);
    return device;
  }

  @override
  Future<Device> update(Device device) async {
    await _write([for (final d in _read()) d.id == device.id ? device : d]);
    return device;
  }

  @override
  Future<void> delete(String id) async =>
      _write(_read().where((d) => d.id != id).toList());
}
