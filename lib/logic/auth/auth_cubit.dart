import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/domain/models/user.dart';
import 'package:smart_greenhouse/domain/repositories/auth_repository.dart';
import 'package:smart_greenhouse/domain/services/network_monitor.dart';
import 'package:smart_greenhouse/logic/auth/auth_state.dart';

/// Керує сесією: вхід, реєстрація, профіль, вихід.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._auth, this._network, {User? initialUser})
    : super(
        initialUser == null
            ? const AuthState()
            : AuthState(status: AuthStatus.authenticated, user: initialUser),
      );

  final IAuthRepository _auth;
  final INetworkMonitor _network;

  Future<void> _guarded(
    String offlineMessage,
    Future<User> Function() action, {
    String? successMessage,
  }) async {
    if (!await _network.isOnline()) {
      emit(state.copyWith(status: AuthStatus.failure, message: offlineMessage));
      return;
    }
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await action();
      emit(
        AuthState(
          status: AuthStatus.authenticated,
          user: user,
          message: successMessage,
        ),
      );
    } on AuthException catch (e) {
      emit(AuthState(status: AuthStatus.failure, message: e.message));
    }
  }

  Future<void> login(String email, String password) => _guarded(
    'Немає інтернету — вхід неможливий',
    () => _auth.login(email: email, password: password),
  );

  Future<void> register(String name, String email, String password) => _guarded(
    'Немає інтернету — реєстрація неможлива',
    () => _auth.register(name: name, email: email, password: password),
    successMessage: 'Акаунт створено',
  );

  Future<void> updateName(String name) async {
    final user = await _auth.updateName(name);
    emit(
      AuthState(
        status: AuthStatus.authenticated,
        user: user,
        message: 'Профіль оновлено',
      ),
    );
  }

  Future<void> logout() async {
    await _auth.logout();
    emit(const AuthState());
  }
}
