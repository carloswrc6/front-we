import 'package:frontwe/domain/entities/auth.dart';

class AuthState {
  final AuthRegisterOutput? registerUser;
  final AuthLoginOutput? loginUser;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.registerUser,
    this.loginUser,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthRegisterOutput? registerUser,
    AuthLoginOutput? loginUser,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      registerUser: registerUser ?? this.registerUser,
      loginUser: loginUser ?? this.loginUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
