import 'dart:async';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_greenhouse/domain/models/sensor.dart';
import 'package:smart_greenhouse/domain/services/sensor_service.dart';

/// [ISensorService] через MQTT-брокер (за замовчуванням — HiveMQ).
///
/// Підписка на `<baseTopic>/#`; payload — число (`24.5`) або JSON
/// (`{"value": 24.5}`). Останній сегмент топіка визначає тип датчика.
class MqttSensorService implements ISensorService {
  MqttSensorService({
    this.host = 'broker.hivemq.com',
    this.port = 1883,
    this.baseTopic = 'lpnu/kb408/yahusevych/greenhouse',
  });

  final String host;
  final int port;
  final String baseTopic;

  final _readings = StreamController<SensorReading>.broadcast();
  final _status = StreamController<TelemetryStatus>.broadcast();
  MqttServerClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _sub;

  @override
  Stream<SensorReading> get readings => _readings.stream;

  @override
  Stream<TelemetryStatus> get status => _status.stream;

  @override
  String get endpoint => '$host:$port · $baseTopic/#';

  @override
  Future<void> connect() async {
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      return;
    }
    final id = 'sg_${DateTime.now().millisecondsSinceEpoch}';
    final client = MqttServerClient.withPort(host, id, port)
      ..logging(on: false)
      ..keepAlivePeriod = 20
      ..autoReconnect = true
      ..onDisconnected = (() => _status.add(TelemetryStatus.disconnected))
      ..onConnected = (() => _status.add(TelemetryStatus.connected))
      ..connectionMessage = MqttConnectMessage()
          .withClientIdentifier(id)
          .startClean()
          .withWillQos(MqttQos.atMostOnce);
    _client = client;
    _status.add(TelemetryStatus.connecting);
    try {
      await client.connect();
    } on Exception {
      client.disconnect();
      _status.add(TelemetryStatus.error);
      return;
    }
    client.subscribe('$baseTopic/#', MqttQos.atMostOnce);
    await _sub?.cancel();
    _sub = client.updates?.listen(_onMessages);
  }

  void _onMessages(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (final m in messages) {
      final kind = SensorKind.fromTopic(m.topic);
      final publish = m.payload;
      if (kind == null || publish is! MqttPublishMessage) continue;
      final text = MqttPublishPayload.bytesToStringAsString(
        publish.payload.message,
      );
      final value = parsePayload(text);
      if (value != null) {
        _readings.add(
          SensorReading(kind: kind, value: value, time: DateTime.now()),
        );
      }
    }
  }

  /// Розбирає payload: `24.5` або `{"value": 24.5}`.
  static double? parsePayload(String text) {
    final plain = double.tryParse(text.trim());
    if (plain != null) return plain;
    try {
      final json = jsonDecode(text);
      if (json is Map && json['value'] is num) {
        return (json['value'] as num).toDouble();
      }
    } on FormatException {
      return null;
    }
    return null;
  }

  @override
  Future<void> disconnect() async {
    await _sub?.cancel();
    _sub = null;
    _client?.disconnect();
    _client = null;
  }
}
