import 'package:flutter/material.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

extension DeviceTypeIcon on DeviceType {
  IconData get icon => switch (this) {
    DeviceType.fan => Icons.air,
    DeviceType.pump => Icons.water,
    DeviceType.lamp => Icons.light,
    DeviceType.heater => Icons.local_fire_department,
    DeviceType.sensor => Icons.sensors,
  };
}

/// Рядок пристрою: перемикач, редагування (тап) і видалення.
class DeviceTile extends StatelessWidget {
  const DeviceTile({
    required this.device,
    super.key,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  final Device device;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final color = device.isOn ? AppColors.primary : AppColors.textMuted;
    return Card(
      child: ListTile(
        onTap: onEdit,
        contentPadding: const EdgeInsets.only(left: AppSpacing.md),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(device.type.icon, color: color),
        ),
        title: Text(device.name, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${device.zone} · ${device.isOn ? 'Увімкнено' : 'Вимкнено'}',
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(value: device.isOn, onChanged: onToggle),
            IconButton(
              tooltip: 'Видалити',
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
