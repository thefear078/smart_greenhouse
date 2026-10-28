import 'package:smart_greenhouse/domain/models/user.dart';

/// Помилка авторизації з повідомленням для користувача.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Контракт авторизації. UI залежить лише від цієї абстракції,
/// тож локальне сховище можна замінити на REST API без змін в UI.
abstract interface class IAuthRepository {
  /// Реєструє користувача; кидає [AuthException], якщо email зайнятий.
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  /// Перевіряє облікові дані; кидає [AuthException] при помилці.
  Future<User> login({required String email, required String password});

  /// Поточний авторизований користувач або `null`.
  Future<User?> currentUser();

  Future<User> updateName(String name);

  /// Токен сесії для заголовка Authorization (Bearer).
  Future<String?> token();

  Future<void> logout();
}
