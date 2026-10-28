import 'package:equatable/equatable.dart';
import 'package:smart_greenhouse/domain/models/device.dart';

enum DevicesStatus { initial, loading, loaded, error }

/// Імутабельний стан списку пристроїв.
class DevicesState extends Equatable {
  const DevicesState({
    this.status = DevicesStatus.initial,
    this.devices = const [],
    this.error,
    this.notice,
    this.noticeId = 0,
  });

  final DevicesStatus status;
  final List<Device> devices;

  /// Помилка завантаження (екран показує «Повторити»).
  final String? error;

  /// Разове повідомлення (наприклад, «зміни недоступні офлайн»).
  final String? notice;

  /// Лічильник, щоб однакові повідомлення показувались повторно.
  final int noticeId;

  int get activeCount => devices.where((d) => d.isOn).length;

  DevicesState copyWith({
    DevicesStatus? status,
    List<Device>? devices,
    String? error,
    String? notice,
  }) => DevicesState(
    status: status ?? this.status,
    devices: devices ?? this.devices,
    error: error,
    notice: notice,
    noticeId: notice == null ? noticeId : noticeId + 1,
  );

  @override
  List<Object?> get props => [
    status,
    error,
    noticeId,
    for (final d in devices) d.toJson().toString(),
  ];
}
