import 'dart:async';

import 'package:smart_greenhouse/domain/models/sensor.dart';
import 'package:smart_greenhouse/domain/services/network_monitor.dart';
import 'package:smart_greenhouse/domain/services/sensor_service.dart';

class FakeNetwork implements INetworkMonitor {
  FakeNetwork({this.online = true});

  bool online;
  final _changes = StreamController<bool>.broadcast();

  void set(bool value) {
    online = value;
    _changes.add(value);
  }

  @override
  Future<bool> isOnline() async => online;

  @override
  Stream<bool> get onStatusChange => _changes.stream;
}

class FakeSensors implements ISensorService {
  final _readings = StreamController<SensorReading>.broadcast();
  final _status = StreamController<TelemetryStatus>.broadcast();
  int connects = 0;
  int disconnects = 0;

  void emit(SensorKind kind, double value) =>
      _readings.add(SensorReading(kind: kind, value: value, time: DateTime(0)));

  @override
  Stream<SensorReading> get readings => _readings.stream;

  @override
  Stream<TelemetryStatus> get status => _status.stream;

  @override
  String get endpoint => 'fake';

  @override
  Future<void> connect() async {
    connects++;
    _status.add(TelemetryStatus.connected);
  }

  @override
  Future<void> disconnect() async => disconnects++;
}
