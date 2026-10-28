import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/domain/models/sensor.dart';
import 'package:smart_greenhouse/domain/services/sensor_service.dart';

class TelemetryState extends Equatable {
  const TelemetryState({
    this.status = TelemetryStatus.connecting,
    this.latest = const {},
  });

  final TelemetryStatus status;
  final Map<SensorKind, SensorReading> latest;

  @override
  List<Object?> get props => [
    status,
    for (final r in latest.values) '${r.kind}:${r.value}',
  ];
}

/// Слухає потоки MQTT-сервісу; підписки закриваються в close().
class TelemetryCubit extends Cubit<TelemetryState> {
  TelemetryCubit(this._service) : super(const TelemetryState());

  final ISensorService _service;
  StreamSubscription<SensorReading>? _readings;
  StreamSubscription<TelemetryStatus>? _status;

  String get endpoint => _service.endpoint;

  void start() {
    _readings = _service.readings.listen(
      (r) => emit(
        TelemetryState(
          status: state.status,
          latest: {...state.latest, r.kind: r},
        ),
      ),
    );
    _status = _service.status.listen(
      (s) => emit(TelemetryState(status: s, latest: state.latest)),
    );
    unawaited(_service.connect());
  }

  @override
  Future<void> close() async {
    final disconnect = _service.disconnect();
    await _readings?.cancel();
    await _status?.cancel();
    await disconnect;
    return super.close();
  }
}
