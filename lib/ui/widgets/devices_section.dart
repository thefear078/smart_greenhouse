import 'package:flutter/material.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';
import 'package:smart_greenhouse/ui/widgets/device_tile.dart';
import 'package:smart_greenhouse/ui/widgets/responsive_grid.dart';
import 'package:smart_greenhouse/ui/widgets/section_header.dart';

/// Розділ «Пристрої»: заголовок з лічильником, індикатор, список.
class DevicesSection extends StatelessWidget {
  const DevicesSection({
    required this.devices,
    required this.loading,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    super.key,
  });

  final List<Device> devices;
  final bool loading;
  final ValueChanged<Device> onEdit;
  final ValueChanged<Device> onDelete;
  final void Function(Device device, bool on) onToggle;

  @override
  Widget build(BuildContext context) {
    final active = devices.where((d) => d.isOn).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Пристрої ($active/${devices.length} увімкнено)',
          action: loading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
        ),
        if (devices.isEmpty && !loading)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'Пристроїв ще немає. Натисніть «+», щоб додати.',
              textAlign: TextAlign.center,
            ),
          ),
        ResponsiveGrid(
          minItemWidth: 320,
          itemHeight: 76,
          children: [
            for (final d in devices)
              DeviceTile(
                device: d,
                onEdit: () => onEdit(d),
                onDelete: () => onDelete(d),
                onToggle: (on) => onToggle(d, on),
              ),
          ],
        ),
      ],
    );
  }
}
