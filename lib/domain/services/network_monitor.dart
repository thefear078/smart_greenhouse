/// Контракт моніторингу стану мережі.
abstract interface class INetworkMonitor {
  /// Чи є з'єднання прямо зараз.
  Future<bool> isOnline();

  /// Потік змін стану (`true` — онлайн).
  Stream<bool> get onStatusChange;
}
