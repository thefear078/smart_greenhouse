import 'package:smart_greenhouse/data/remote/api_client.dart';
import 'package:smart_greenhouse/data/remote/device_dto.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/domain/repositories/device_repository.dart';

/// [IDeviceRepository] поверх REST API (`/devices`).
/// Помилки мережі кидаються як [ApiException].
class RemoteDeviceRepository implements IDeviceRepository {
  RemoteDeviceRepository(this._api);

  static const String _path = '/devices';
  final ApiClient _api;

  Device _parse(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const ApiException('Некоректна відповідь сервера');
    }
    return DeviceDto.fromJson(json).toDomain();
  }

  @override
  Future<List<Device>> getAll() async {
    final json = await _api.get(_path);
    if (json is! List) throw const ApiException('Очікувався список');
    return List.unmodifiable(json.map(_parse));
  }

  @override
  Future<Device> add({
    required String name,
    required String zone,
    required DeviceType type,
  }) async {
    final dto = DeviceDto(
      id: '',
      name: name,
      zone: zone,
      type: type.name,
      isOn: false,
    );
    return _parse(await _api.post(_path, dto.toJson()));
  }

  @override
  Future<Device> update(Device device) async =>
      _parse(await _api.put('$_path/${device.id}', device.toDto().toJson()));

  @override
  Future<void> delete(String id) => _api.delete('$_path/$id');
}
