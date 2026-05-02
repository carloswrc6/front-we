import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/auth.dart';
import 'package:frontwe/domain/repository/auth_repository.dart';
import 'auth_state.dart';

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

  Future<void> register(AuthRegisterInput user) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final auth = await authRepository.userRegister(user);

      state = state.copyWith(
        registerUser: auth,
        loginUser: null,
        isLoading: false,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      setError('Error inesperado');
    }
  }

  Future<void> login(AuthLoginInput user) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final auth = await authRepository.loginUser(user);

      state = state.copyWith(
        loginUser: auth,
        registerUser: null,
        isLoading: false,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      setError('Error inesperado');
    }
  }

  void _handleDioError(DioException e) {
    String message = 'Error inesperado';

    if (e.response != null) {
      final data = e.response?.data;

      if (data['message'] is List) {
        message = (data['message'] as List).join(', ');
      } else if (data['message'] is String) {
        message = data['message'];
      } else {
        message = data.toString();
      }
    } else {
      message = e.message ?? 'Error de conexión';
    }

    setError(message);
  }
}
