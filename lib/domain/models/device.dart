/// Тип виконавчого пристрою теплиці.
enum DeviceType {
  fan('Вентилятор'),
  pump('Насос поливу'),
  lamp('Фітолампа'),
  heater('Обігрівач'),
  sensor('Датчик');

  const DeviceType(this.label);

  final String label;
}

/// Пристрій теплиці (сутність CRUD).
class Device {
  const Device({
    required this.id,
    required this.name,
    required this.zone,
    required this.type,
    this.isOn = false,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json['id'] as String,
    name: json['name'] as String,
    zone: json['zone'] as String,
    type: DeviceType.values.byName(json['type'] as String),
    isOn: json['isOn'] as bool? ?? false,
  );

  final String id;
  final String name;
  final String zone;
  final DeviceType type;
  final bool isOn;

  Device copyWith({String? name, String? zone, DeviceType? type, bool? isOn}) =>
      Device(
        id: id,
        name: name ?? this.name,
        zone: zone ?? this.zone,
        type: type ?? this.type,
        isOn: isOn ?? this.isOn,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'zone': zone,
    'type': type.name,
    'isOn': isOn,
  };
}
