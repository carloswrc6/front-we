import 'package:frontwe/domain/entities/auth.dart';

abstract class AuthDatasource {
  Future<AuthRegisterOutput> userRegister(AuthRegisterInput user);
  Future<AuthLoginOutput> loginUser(AuthLoginInput user);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
