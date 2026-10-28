import 'package:flutter/material.dart';
import 'package:smart_greenhouse/domain/models/sensor.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

extension SensorKindStyle on SensorKind {
  IconData get icon => switch (this) {
    SensorKind.temperature => Icons.thermostat,
    SensorKind.humidity => Icons.water_drop,
    SensorKind.soil => Icons.grass,
    SensorKind.light => Icons.wb_sunny,
  };

  Color get color => switch (this) {
    SensorKind.temperature => const Color(0xFFE65100),
    SensorKind.humidity => const Color(0xFF0277BD),
    SensorKind.soil => const Color(0xFF6D4C41),
    SensorKind.light => const Color(0xFFF9A825),
  };
}

/// Картка показника датчика; [reading] == null — даних ще немає.
class SensorCard extends StatelessWidget {
  const SensorCard({required this.kind, super.key, this.reading});

  final SensorKind kind;
  final SensorReading? reading;

  String get _value {
    final v = reading?.value;
    if (v == null) return '—';
    return kind == SensorKind.light ? v.round().toString() : v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final r = reading;
    final statusColor = r == null
        ? AppColors.textMuted
        : (r.isNormal ? AppColors.primary : AppColors.warning);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: kind.color.withValues(alpha: 0.12),
                  child: Icon(kind.icon, color: kind.color, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    kind.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  text: _value,
                  style: text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(text: ' ${kind.unit}', style: text.titleMedium),
                  ],
                ),
              ),
            ),
            Text(
              r?.status ?? 'Очікування даних',
              style: text.labelMedium?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
