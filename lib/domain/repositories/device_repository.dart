import 'package:smart_greenhouse/domain/models/device.dart';

/// Контракт CRUD-операцій над пристроями теплиці.
abstract interface class IDeviceRepository {
  Future<List<Device>> getAll();

  Future<Device> add({
    required String name,
    required String zone,
    required DeviceType type,
  });

  Future<Device> update(Device device);

  Future<void> delete(String id);
}
