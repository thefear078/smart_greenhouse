import 'package:flutter/material.dart';
import 'package:smart_greenhouse/domain/services/sensor_service.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

/// Індикатор стану MQTT-підключення; підказка показує брокер і топік.
class TelemetryChip extends StatelessWidget {
  const TelemetryChip({
    required this.status,
    required this.endpoint,
    super.key,
  });

  final TelemetryStatus status;
  final String endpoint;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      TelemetryStatus.connected => ('MQTT онлайн', AppColors.primary),
      TelemetryStatus.connecting => ('Підключення…', AppColors.warning),
      TelemetryStatus.disconnected => ('MQTT офлайн', AppColors.textMuted),
      TelemetryStatus.error => ('Помилка MQTT', AppColors.danger),
    };
    return Tooltip(
      message: endpoint,
      child: Chip(
        visualDensity: VisualDensity.compact,
        avatar: Icon(Icons.circle, size: 10, color: color),
        label: Text(label),
      ),
    );
  }
}
