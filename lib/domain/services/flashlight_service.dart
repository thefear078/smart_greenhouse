/// Помилка керування ліхтариком (непідтримувана платформа, немає спалаху).
class FlashlightFailure implements Exception {
  const FlashlightFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Контракт апаратного ліхтарика.
abstract interface class IFlashlight {
  /// Перемикає ліхтарик і повертає новий стан; кидає [FlashlightFailure].
  Future<bool> toggle();
}
