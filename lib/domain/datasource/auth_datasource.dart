import 'package:frontwe/domain/entities/auth.dart';

abstract class AuthDatasource {
  Future<AuthRegisterOutput> userRegister(AuthRegisterInput user);
  Future<AuthLoginOutput> loginUser(AuthLoginInput user);
}
