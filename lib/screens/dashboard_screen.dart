import 'package:flutter/material.dart';
import 'package:smart_greenhouse/data/mock_data.dart';
import 'package:smart_greenhouse/routes.dart';
import 'package:smart_greenhouse/widgets/device_tile.dart';
import 'package:smart_greenhouse/widgets/greenhouse_header.dart';
import 'package:smart_greenhouse/widgets/page_container.dart';
import 'package:smart_greenhouse/widgets/responsive_grid.dart';
import 'package:smart_greenhouse/widgets/section_header.dart';
import 'package:smart_greenhouse/widgets/sensor_card.dart';

/// Головний екран: показники датчиків і виконавчі пристрої теплиці.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Greenhouse'),
        actions: [
          IconButton(
            tooltip: 'Профіль',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: PageContainer(
        children: [
          const GreenhouseHeader(
            name: MockData.greenhouseName,
            subtitle: 'Усі системи працюють · оновлено щойно',
          ),
          const SectionHeader(title: 'Датчики'),
          ResponsiveGrid(
            children: [
              for (final s in MockData.sensors) SensorCard(reading: s),
            ],
          ),
          SectionHeader(
            title: 'Пристрої',
            action: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Додати'),
            ),
          ),
          ResponsiveGrid(
            minItemWidth: 320,
            itemHeight: 76,
            children: [for (final d in MockData.devices) DeviceTile(device: d)],
          ),
        ],
      ),
    );
  }
}
