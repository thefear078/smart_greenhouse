import 'package:equatable/equatable.dart';
import 'package:smart_greenhouse/domain/models/user.dart';

enum AuthStatus { unauthenticated, loading, authenticated, failure }

/// Імутабельний стан авторизації.
class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.message,
  });

  final AuthStatus status;
  final User? user;

  /// Повідомлення для користувача (помилка або успіх).
  final String? message;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({AuthStatus? status, User? user, String? message}) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        message: message,
      );

  @override
  List<Object?> get props => [status, user?.email, user?.name, message];
}
