import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/domain/services/network_monitor.dart';

class NetworkState extends Equatable {
  const NetworkState({this.online = true, this.checked = false});

  final bool online;

  /// `true` після першої перевірки (для попередження при старті офлайн).
  final bool checked;

  @override
  List<Object?> get props => [online, checked];
}

/// Глобальний стан мережі; підписка закривається в close().
class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit(this._monitor) : super(const NetworkState());

  final INetworkMonitor _monitor;
  StreamSubscription<bool>? _sub;

  Future<void> start() async {
    _sub = _monitor.onStatusChange.listen(
      (online) => emit(NetworkState(online: online, checked: true)),
    );
    final online = await _monitor.isOnline();
    if (!isClosed) emit(NetworkState(online: online, checked: true));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
