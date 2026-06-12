import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/auth.dart';
import 'package:frontwe/domain/repository/auth_repository.dart';
import 'package:frontwe/presentation/auth/state/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthState());

  void setError(String message) {
    state = state.copyWith(
      errorMessage: message,
      isLoading: false,
      loginUser: null,
      registerUser: null,
    );
  }

  Future register(AuthRegisterInput user) async {
    try {
      print('➡️ register start');

      state = state.copyWith(isLoading: true, errorMessage: null);

      final auth = await authRepository.userRegister(user);

      print('✅ register success: $auth');

      state = state.copyWith(
        registerUser: auth,
        loginUser: AuthLoginOutput(
          id: auth.id,
          provider: 'local',
          email: auth.email,
          fullName: auth.fullName,
          token: auth.token,
        ),
        isAuthenticated: true,
        token: auth.token,
        isLoading: false,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      setError(message);
    }
  }

  Future<void> login(AuthLoginInput user) async {
    try {
      print('➡️ login start');

      state = state.copyWith(
        isLoading: true,
        errorMessage: null, // ✅ consistente con register
      );

      final auth = await authRepository.loginUser(user);

      print('✅ login success: $auth');

      state = state.copyWith(
        loginUser: auth,
        isAuthenticated: true,
        token: auth.token,
        registerUser: null,
        isLoading: false,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      setError(message);
    }
  }

  // Future<void> loginApple()
  Future<void> loginGoogle() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final auth = await authRepository.loginWithGoogle();

      state = state.copyWith(
        isAuthenticated: true,
        token: auth.token,
        loginUser: auth,
        registerUser: null,
        isLoading: false,
      );
    } catch (e) {
      setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _handleDioError(DioException e) {
    String message = 'Error inesperado';

    if (e.response != null) {
      final data = e.response?.data;

      // 🔥 NUEVO: manejar { field, message }
      if (data is Map && data['message'] is Map) {
        final field = data['message']['field'];
        final msg = data['message']['message'];

        message = msg ?? 'Error';

        // 👉 Aquí podrías luego enviar el field a UI (opcional)
        print('Field error: $field');
      } else if (data is Map && data['message'] is List) {
        message = (data['message'] as List).join(', ');
      } else if (data is Map && data['message'] is String) {
        message = data['message'];
      } else {
        message = data.toString();
      }
    } else {
      message = e.message ?? 'Error de conexión';
    }

    setError(message);
  }

  Future<void> logout() async {
    await authRepository.logout();

    state = AuthState();
  }

  Future<void> forgotPassword(String email) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        forgotPasswordSuccess: false,
      );

      await authRepository.forgotPassword(email);

      state = state.copyWith(isLoading: false, forgotPasswordSuccess: true);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        resetPasswordSuccess: false,
      );

      await authRepository.resetPassword(
        email: email,
        code: code,
        password: password,
      );

      state = state.copyWith(isLoading: false, resetPasswordSuccess: true);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
