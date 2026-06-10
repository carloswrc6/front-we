import 'package:frontwe/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<AuthRegisterOutput> userRegister(AuthRegisterInput user);
  Future<AuthLoginOutput> loginUser(AuthLoginInput user);

  Future<AuthLoginOutput> loginWithGoogle();
  Future<String> loginWithApple();
  Future<void> logout();

  Future<String?> getSavedToken();
}
