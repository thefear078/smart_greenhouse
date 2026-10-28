import 'package:flutter/material.dart';

/// Статичні дані-заглушки для UI (бізнес-логіка з'явиться в лаб. №3).
class SensorReading {
  const SensorReading({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    this.status = 'Норма',
  });

  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String status;
}

class DeviceInfo {
  const DeviceInfo({
    required this.name,
    required this.zone,
    required this.icon,
    required this.isOn,
  });

  final String name;
  final String zone;
  final IconData icon;
  final bool isOn;
}

abstract final class MockData {
  static const String userName = 'Костянтин Ягусевич';
  static const String userEmail = 'kostiantyn@greenhouse.ua';
  static const String greenhouseName = 'Теплиця «Львів-1»';

  static const List<SensorReading> sensors = [
    SensorReading(
      title: 'Температура',
      value: '24.5',
      unit: '°C',
      icon: Icons.thermostat,
      color: Color(0xFFE65100),
    ),
    SensorReading(
      title: 'Вологість повітря',
      value: '68',
      unit: '%',
      icon: Icons.water_drop,
      color: Color(0xFF0277BD),
    ),
    SensorReading(
      title: 'Вологість ґрунту',
      value: '41',
      unit: '%',
      icon: Icons.grass,
      color: Color(0xFF6D4C41),
      status: 'Потрібен полив',
    ),
    SensorReading(
      title: 'Освітленість',
      value: '12 400',
      unit: 'лк',
      icon: Icons.wb_sunny,
      color: Color(0xFFF9A825),
    ),
  ];

  static const List<DeviceInfo> devices = [
    DeviceInfo(name: 'Вентилятор', zone: 'Зона A', icon: Icons.air, isOn: true),
    DeviceInfo(
      name: 'Насос поливу',
      zone: 'Зона B',
      icon: Icons.water,
      isOn: false,
    ),
    DeviceInfo(
      name: 'Фітолампа',
      zone: 'Зона A',
      icon: Icons.light,
      isOn: true,
    ),
    DeviceInfo(
      name: 'Обігрівач',
      zone: 'Зона C',
      icon: Icons.local_fire_department,
      isOn: false,
    ),
  ];
}
