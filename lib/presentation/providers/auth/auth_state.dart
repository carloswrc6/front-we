import 'package:frontwe/domain/entities/auth.dart';

class AuthState {
  final AuthRegisterOutput? registerUser;
  final AuthLoginOutput? loginUser;
  final bool isLoading;
  final String? errorMessage;
  final String? errorField;

  AuthState({
    this.registerUser,
    this.loginUser,
    this.isLoading = false,
    this.errorMessage,
    this.errorField,
  });

  AuthState copyWith({
    AuthRegisterOutput? registerUser,
    AuthLoginOutput? loginUser,
    bool? isLoading,
    String? errorMessage,
    String? errorField,
  }) {
    return AuthState(
      registerUser: registerUser ?? this.registerUser,
      loginUser: loginUser ?? this.loginUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      errorField: errorField,
    );
  }
}
