import 'package:frontwe/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<AuthRegisterOutput> userRegister(AuthRegisterInput user);
  Future<AuthLoginOutput> loginUser(AuthLoginInput user);
  // Future<Auth> loginGoogleApple(LoginGoogleApple user);
}
