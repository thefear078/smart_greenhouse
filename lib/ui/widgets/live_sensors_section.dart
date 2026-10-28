import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/domain/models/sensor.dart';
import 'package:smart_greenhouse/logic/telemetry/telemetry_cubit.dart';
import 'package:smart_greenhouse/ui/widgets/responsive_grid.dart';
import 'package:smart_greenhouse/ui/widgets/section_header.dart';
import 'package:smart_greenhouse/ui/widgets/sensor_card.dart';
import 'package:smart_greenhouse/ui/widgets/telemetry_chip.dart';

/// Сітка датчиків, що перемальовується за станом [TelemetryCubit].
class LiveSensorsSection extends StatelessWidget {
  const LiveSensorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TelemetryCubit, TelemetryState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: 'Датчики',
            action: TelemetryChip(
              status: state.status,
              endpoint: context.read<TelemetryCubit>().endpoint,
            ),
          ),
          ResponsiveGrid(
            children: [
              for (final k in SensorKind.values)
                SensorCard(kind: k, reading: state.latest[k]),
            ],
          ),
        ],
      ),
    );
  }
}
