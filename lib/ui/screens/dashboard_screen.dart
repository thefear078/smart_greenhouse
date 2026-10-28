import 'package:flutter/material.dart';
import 'package:smart_greenhouse/data/mock_data.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/domain/repositories/repository_exception.dart';
import 'package:smart_greenhouse/ui/app_scope.dart';
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

/// Головний екран: датчики (MQTT) і пристрої (REST API + кеш).
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<List<Device>>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= AppScope.of(context).devices.getAll();
  }

  void _reload() {
    final future = AppScope.of(context).devices.getAll();
    setState(() {
      _future = future;
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } on RepositoryException catch (e) {
      if (mounted) Snack.error(context, e.message);
    }
    if (mounted) _reload();
  }

  Future<void> _add() async {
    final r = await DeviceFormDialog.show(context);
    if (r == null || !mounted) return;
    final repo = AppScope.of(context).devices;
    await _run(() => repo.add(name: r.name, zone: r.zone, type: r.type));
  }

  Future<void> _edit(Device d) async {
    final r = await DeviceFormDialog.show(context, initial: d);
    if (r == null || !mounted) return;
    final repo = AppScope.of(context).devices;
    await _run(
      () => repo.update(d.copyWith(name: r.name, zone: r.zone, type: r.type)),
    );
  }

  Future<void> _delete(Device d) async {
    final ok = await confirmDialog(
      context,
      title: 'Видалити пристрій?',
      message: '«${d.name}» буде видалено.',
      confirmLabel: 'Видалити',
    );
    if (!ok || !mounted) return;
    final repo = AppScope.of(context).devices;
    await _run(() => repo.delete(d.id));
  }

  Future<void> _toggle(Device d, bool on) async {
    final repo = AppScope.of(context).devices;
    await _run(() => repo.update(d.copyWith(isOn: on)));
  }

  Widget _devices(BuildContext context, AsyncSnapshot<List<Device>> snap) {
    if (snap.hasError) {
      return ErrorRetry(message: snap.error.toString(), onRetry: _reload);
    }
    return DevicesSection(
      devices: snap.data ?? const [],
      loading: snap.connectionState != ConnectionState.done,
      onEdit: _edit,
      onDelete: _delete,
      onToggle: _toggle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Greenhouse'),
        actions: [
          IconButton(
            tooltip: 'Оновити',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
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
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: NetworkBanner(
        monitor: scope.network,
        child: PageContainer(
          children: [
            const GreenhouseHeader(
              name: MockData.greenhouseName,
              subtitle: 'Телеметрія в реальному часі через MQTT',
            ),
            LiveSensorsSection(service: scope.sensors),
            FutureBuilder<List<Device>>(future: _future, builder: _devices),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
