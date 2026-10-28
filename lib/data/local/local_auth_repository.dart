import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:smart_greenhouse/data/local/json_store.dart';
import 'package:smart_greenhouse/domain/models/user.dart';
import 'package:smart_greenhouse/domain/repositories/auth_repository.dart';

/// Реалізація [IAuthRepository] у локальному сховищі.
class LocalAuthRepository implements IAuthRepository {
  LocalAuthRepository(this._store);

  static const String _usersKey = 'users';
  static const String _sessionKey = 'session_email';

  final JsonStore _store;

  static String hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  List<User> _users() =>
      (_store.readList(_usersKey) ?? const []).map(User.fromJson).toList();

  Future<void> _save(List<User> users) =>
      _store.writeList(_usersKey, users.map((u) => u.toJson()).toList());

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    final users = _users();
    if (users.any((u) => u.email == normalized)) {
      throw const AuthException('Користувач з таким email уже існує');
    }
    final user = User(
      name: name.trim(),
      email: normalized,
      passwordHash: hash(password),
    );
    await _save([...users, user]);
    await _store.writeString(_sessionKey, normalized);
    return user;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final normalized = email.trim().toLowerCase();
    final match = _users().where((u) => u.email == normalized);
    if (match.isEmpty || match.first.passwordHash != hash(password)) {
      throw const AuthException('Невірний email або пароль');
    }
    await _store.writeString(_sessionKey, normalized);
    return match.first;
  }

  @override
  Future<User?> currentUser() async {
    final email = _store.readString(_sessionKey);
    if (email == null) return null;
    final match = _users().where((u) => u.email == email);
    return match.isEmpty ? null : match.first;
  }

  @override
  Future<User> updateName(String name) async {
    final current = await currentUser();
    if (current == null) throw const AuthException('Сесія завершилась');
    final updated = current.copyWith(name: name.trim());
    await _save([
      for (final u in _users()) u.email == current.email ? updated : u,
    ]);
    return updated;
  }

  @override
  Future<void> logout() => _store.remove(_sessionKey);
}
