import 'package:frontwe/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<AuthRegisterOutput> userRegister(AuthRegisterInput user);
  Future<AuthLoginOutput> loginUser(AuthLoginInput user);

  Future<AuthLoginOutput> loginWithGoogle();
  Future<String> loginWithApple();
  Future<void> logout();

  Future<String?> getSavedToken();

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
