import 'package:smart_greenhouse/domain/models/device.dart';

/// Контракт локального кешу списку пристроїв (Offline-First).
abstract interface class IDeviceCache {
  Future<List<Device>> readCache();

  Future<void> saveCache(List<Device> devices);
}
