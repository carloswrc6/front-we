import 'package:frontwe/domain/entities/auth.dart';

class AuthState {

  final AuthRegisterOutput? registerUser;
  final AuthLoginOutput? loginUser;

  final bool isAuthenticated;
  final String? token;

  final bool isLoading;
  final String? errorMessage;
  final String? errorField;

  AuthState({
    this.registerUser,
    this.loginUser,
    this.isAuthenticated = false,
    this.token,
    this.isLoading = false,
    this.errorMessage,
    this.errorField,
  });

  AuthState copyWith({
    AuthRegisterOutput? registerUser,
    AuthLoginOutput? loginUser,
    bool? isAuthenticated,
    String? token,
    bool? isLoading,
    String? errorMessage,
    String? errorField,
  }) {
    return AuthState(
      registerUser: registerUser ?? this.registerUser,
      loginUser: loginUser ?? this.loginUser,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      errorField: errorField,
    );
  }
}