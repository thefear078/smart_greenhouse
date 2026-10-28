import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/data/mock_data.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/logic/devices/devices_cubit.dart';
import 'package:smart_greenhouse/logic/devices/devices_state.dart';
import 'package:smart_greenhouse/logic/flashlight/flashlight_cubit.dart';
import 'package:smart_greenhouse/ui/routes.dart';
import 'package:smart_greenhouse/ui/widgets/confirm_dialog.dart';
import 'package:smart_greenhouse/ui/widgets/device_form_dialog.dart';
import 'package:smart_greenhouse/ui/widgets/devices_section.dart';
import 'package:smart_greenhouse/ui/widgets/error_retry.dart';
import 'package:smart_greenhouse/ui/widgets/greenhouse_header.dart';
import 'package:smart_greenhouse/ui/widgets/live_sensors_section.dart';
import 'package:smart_greenhouse/ui/widgets/network_banner.dart';
import 'package:smart_greenhouse/ui/widgets/page_container.dart';
import 'package:smart_greenhouse/ui/widgets/snack.dart';

/// Головний екран. Не знає про репозиторії: лише надсилає наміри
/// в [DevicesCubit] і перемальовується за його станом.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<DevicesCubit>();
    final r = await DeviceFormDialog.show(context);
    if (r != null) await cubit.add(r.name, r.zone, r.type);
  }

  Future<void> _edit(BuildContext context, Device d) async {
    final cubit = context.read<DevicesCubit>();
    final r = await DeviceFormDialog.show(context, initial: d);
    if (r != null) {
      await cubit.edit(d.copyWith(name: r.name, zone: r.zone, type: r.type));
    }
  }

  Future<void> _delete(BuildContext context, Device d) async {
    final cubit = context.read<DevicesCubit>();
    final ok = await confirmDialog(
      context,
      title: 'Видалити пристрій?',
      message: '«${d.name}» буде видалено.',
      confirmLabel: 'Видалити',
    );
    if (ok) await cubit.delete(d.id);
  }

  Widget _devices(BuildContext context, DevicesState state) {
    final cubit = context.read<DevicesCubit>();
    if (state.status == DevicesStatus.error) {
      return ErrorRetry(message: state.error ?? '', onRetry: cubit.load);
    }
    return DevicesSection(
      devices: state.devices,
      loading:
          state.status == DevicesStatus.loading ||
          state.status == DevicesStatus.initial,
      onEdit: (d) => _edit(context, d),
      onDelete: (d) => _delete(context, d),
      onToggle: (d, on) => cubit.toggle(d, on: on),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Greenhouse'),
        actions: [
          IconButton(
            tooltip: 'Оновити',
            icon: const Icon(Icons.refresh),
            onPressed: context.read<DevicesCubit>().load,
          ),
          IconButton(
            tooltip: 'Профіль',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Додати пристрій',
        onPressed: () => _add(context),
        child: const Icon(Icons.add),
      ),
      body: NetworkBanner(
        child: PageContainer(
          children: [
            BlocListener<FlashlightCubit, FlashlightState>(
              listener: (context, s) => Snack.success(context, s.message ?? ''),
              child: GreenhouseHeader(
                name: MockData.greenhouseName,
                subtitle: 'Телеметрія в реальному часі через MQTT',
                onSecretLongPress: context.read<FlashlightCubit>().toggle,
              ),
            ),
            const LiveSensorsSection(),
            BlocConsumer<DevicesCubit, DevicesState>(
              listenWhen: (a, b) => a.noticeId != b.noticeId,
              listener: (context, s) => Snack.error(context, s.notice ?? ''),
              builder: _devices,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
