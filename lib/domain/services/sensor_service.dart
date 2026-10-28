import 'package:smart_greenhouse/domain/models/sensor.dart';

/// Стан підключення до джерела телеметрії.
enum TelemetryStatus { disconnected, connecting, connected, error }

/// Контракт потокових даних від IoT-датчиків (MQTT або інше джерело).
abstract interface class ISensorService {
  Stream<SensorReading> get readings;

  Stream<TelemetryStatus> get status;

  /// Опис підключення для UI (брокер і топік).
  String get endpoint;

  Future<void> connect();

  Future<void> disconnect();
}
