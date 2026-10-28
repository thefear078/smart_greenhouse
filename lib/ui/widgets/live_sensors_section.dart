import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_greenhouse/domain/models/sensor.dart';
import 'package:smart_greenhouse/domain/services/sensor_service.dart';
import 'package:smart_greenhouse/ui/widgets/responsive_grid.dart';
import 'package:smart_greenhouse/ui/widgets/section_header.dart';
import 'package:smart_greenhouse/ui/widgets/sensor_card.dart';
import 'package:smart_greenhouse/ui/widgets/telemetry_chip.dart';

/// Сітка датчиків, що оновлюється потоком з [ISensorService].
/// Підписки на потоки закриваються в dispose().
class LiveSensorsSection extends StatefulWidget {
  const LiveSensorsSection({required this.service, super.key});

  final ISensorService service;

  @override
  State<LiveSensorsSection> createState() => _LiveSensorsSectionState();
}

class _LiveSensorsSectionState extends State<LiveSensorsSection> {
  final Map<SensorKind, SensorReading> _latest = {};
  TelemetryStatus _status = TelemetryStatus.connecting;
  StreamSubscription<SensorReading>? _readingsSub;
  StreamSubscription<TelemetryStatus>? _statusSub;

  @override
  void initState() {
    super.initState();
    _readingsSub = widget.service.readings.listen(
      (r) => setState(() => _latest[r.kind] = r),
    );
    _statusSub = widget.service.status.listen(
      (s) => setState(() => _status = s),
    );
    unawaited(widget.service.connect());
  }

  @override
  void dispose() {
    unawaited(_readingsSub?.cancel());
    unawaited(_statusSub?.cancel());
    unawaited(widget.service.disconnect());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Датчики',
          action: TelemetryChip(
            status: _status,
            endpoint: widget.service.endpoint,
          ),
        ),
        ResponsiveGrid(
          children: [
            for (final k in SensorKind.values)
              SensorCard(kind: k, reading: _latest[k]),
          ],
        ),
      ],
    );
  }
}
