import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smart_greenhouse/domain/services/network_monitor.dart';

/// [INetworkMonitor] на основі пакета connectivity_plus.
class ConnectivityNetworkMonitor implements INetworkMonitor {
  ConnectivityNetworkMonitor([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _hasNetwork(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  @override
  Future<bool> isOnline() async =>
      _hasNetwork(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_hasNetwork).distinct();
}
