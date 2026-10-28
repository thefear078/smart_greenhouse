import 'package:flutter/material.dart';
import 'package:smart_greenhouse/data/mock_data.dart';
import 'package:smart_greenhouse/theme/app_theme.dart';

/// Рядок виконавчого пристрою з перемикачем стану.
class DeviceTile extends StatelessWidget {
  const DeviceTile({required this.device, super.key, this.onChanged});

  final DeviceInfo device;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final color = device.isOn ? AppColors.primary : AppColors.textMuted;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(device.icon, color: color),
        ),
        title: Text(device.name, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${device.zone} · ${device.isOn ? 'Увімкнено' : 'Вимкнено'}',
        ),
        trailing: Switch(value: device.isOn, onChanged: onChanged ?? (_) {}),
      ),
    );
  }
}
