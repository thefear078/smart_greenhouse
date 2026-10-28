import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/domain/models/device.dart';
import 'package:smart_greenhouse/domain/repositories/device_repository.dart';
import 'package:smart_greenhouse/domain/repositories/repository_exception.dart';
import 'package:smart_greenhouse/logic/devices/devices_state.dart';

/// CRUD пристроїв: UI надсилає намір -> Cubit викликає репозиторій ->
/// емітить новий стан -> UI перемальовується.
class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit(this._repo) : super(const DevicesState());

  final IDeviceRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(status: DevicesStatus.loading));
    try {
      final list = await _repo.getAll();
      emit(state.copyWith(status: DevicesStatus.loaded, devices: list));
    } on RepositoryException catch (e) {
      emit(state.copyWith(status: DevicesStatus.error, error: e.message));
    }
  }

  Future<void> _mutate(Future<void> Function() action) async {
    emit(state.copyWith(status: DevicesStatus.loading));
    try {
      await action();
      final list = await _repo.getAll();
      emit(state.copyWith(status: DevicesStatus.loaded, devices: list));
    } on RepositoryException catch (e) {
      emit(state.copyWith(status: DevicesStatus.loaded, notice: e.message));
    }
  }

  Future<void> add(String name, String zone, DeviceType type) =>
      _mutate(() => _repo.add(name: name, zone: zone, type: type));

  Future<void> edit(Device device) => _mutate(() => _repo.update(device));

  Future<void> toggle(Device device, {required bool on}) =>
      _mutate(() => _repo.update(device.copyWith(isOn: on)));

  Future<void> delete(String id) => _mutate(() => _repo.delete(id));
}
