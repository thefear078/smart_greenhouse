import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/domain/repositories/device_cache.dart';
import 'package:smart_greenhouse/domain/repositories/device_repository.dart';
import 'package:smart_greenhouse/domain/repositories/repository_exception.dart';
import 'package:smart_greenhouse/domain/services/network_monitor.dart';

/// Offline-First репозиторій: мережа -> збереження в кеш -> UI;
/// без мережі або при помилці сервера — останні збережені дані.
/// Зміни даних без мережі заборонені (кеш лише для читання).
class CachedDeviceRepository implements IDeviceRepository {
  CachedDeviceRepository({
    required IDeviceRepository remote,
    required IDeviceCache cache,
    required INetworkMonitor network,
  }) : _remote = remote,
       _cache = cache,
       _network = network;

  final IDeviceRepository _remote;
  final IDeviceCache _cache;
  final INetworkMonitor _network;

  /// `true`, якщо останній getAll() повернув дані з кешу.
  bool servedFromCache = false;

  @override
  Future<List<Device>> getAll() async {
    if (await _network.isOnline()) {
      try {
        final fresh = await _remote.getAll();
        await _cache.saveCache(fresh);
        servedFromCache = false;
        return fresh;
      } on RepositoryException {
        final cached = await _cache.readCache();
        if (cached.isEmpty) rethrow;
        servedFromCache = true;
        return cached;
      }
    }
    servedFromCache = true;
    return _cache.readCache();
  }

  Future<void> _requireOnline() async {
    if (!await _network.isOnline()) {
      throw const RepositoryException(
        'Немає мережі — зміни недоступні в офлайн-режимі',
      );
    }
  }

  Future<void> _sync(List<Device> Function(List<Device>) change) async =>
      _cache.saveCache(change(await _cache.readCache()));

  @override
  Future<Device> add({
    required String name,
    required String zone,
    required DeviceType type,
  }) async {
    await _requireOnline();
    final d = await _remote.add(name: name, zone: zone, type: type);
    await _sync((list) => [...list, d]);
    return d;
  }

  @override
  Future<Device> update(Device device) async {
    await _requireOnline();
    final d = await _remote.update(device);
    await _sync((list) => [for (final x in list) x.id == d.id ? d : x]);
    return d;
  }

  @override
  Future<void> delete(String id) async {
    await _requireOnline();
    await _remote.delete(id);
    await _sync((list) => list.where((x) => x.id != id).toList());
  }
}
