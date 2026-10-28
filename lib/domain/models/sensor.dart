/// Тип датчика теплиці; [topic] — останній сегмент MQTT-топіка.
enum SensorKind {
  temperature('temperature', 'Температура', '°C'),
  humidity('humidity', 'Вологість повітря', '%'),
  soil('soil', 'Вологість ґрунту', '%'),
  light('light', 'Освітленість', 'лк');

  const SensorKind(this.topic, this.title, this.unit);

  final String topic;
  final String title;
  final String unit;

  static SensorKind? fromTopic(String topic) {
    final last = topic.split('/').last;
    for (final k in values) {
      if (k.topic == last) return k;
    }
    return null;
  }
}

/// Одне вимірювання датчика.
class SensorReading {
  const SensorReading({
    required this.kind,
    required this.value,
    required this.time,
  });

  final SensorKind kind;
  final double value;
  final DateTime time;

  /// Бізнес-правило: оцінка показника (для статусу на картці).
  String get status => switch (kind) {
    SensorKind.temperature when value > 32 => 'Спекотно',
    SensorKind.temperature when value < 12 => 'Холодно',
    SensorKind.humidity when value < 40 => 'Сухе повітря',
    SensorKind.soil when value < 45 => 'Потрібен полив',
    SensorKind.light when value < 2000 => 'Мало світла',
    _ => 'Норма',
  };

  bool get isNormal => status == 'Норма';
}
