import 'package:smart_greenhouse/domain/models/device.dart';

/// DTO пристрою у форматі REST API (поля як на сервері).
class DeviceDto {
  const DeviceDto({
    required this.id,
    required this.name,
    required this.zone,
    required this.type,
    required this.isOn,
  });

  factory DeviceDto.fromJson(Map<String, dynamic> json) => DeviceDto(
    id: json['id'].toString(),
    name: json['name'] as String? ?? '',
    zone: json['zone'] as String? ?? '',
    type: json['type'] as String? ?? DeviceType.sensor.name,
    isOn: json['isOn'] as bool? ?? false,
  );

  final String id;
  final String name;
  final String zone;
  final String type;
  final bool isOn;

  Map<String, dynamic> toJson() => {
    'name': name,
    'zone': zone,
    'type': type,
    'isOn': isOn,
  };
}

/// Мапер DTO <-> доменна модель.
extension DeviceDtoMapper on DeviceDto {
  Device toDomain() => Device(
    id: id,
    name: name,
    zone: zone,
    type: DeviceType.values.asNameMap()[type] ?? DeviceType.sensor,
    isOn: isOn,
  );
}

extension DeviceToDto on Device {
  DeviceDto toDto() =>
      DeviceDto(id: id, name: name, zone: zone, type: type.name, isOn: isOn);
}
