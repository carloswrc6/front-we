import 'package:frontwe/domain/entities/auth.dart';
import 'package:frontwe/infrastructure/models/auth_bd/register.dart';
import 'package:frontwe/infrastructure/models/auth_bd/login.dart';

class AuthMapper {
  static AuthRegisterOutput authDBToEntity(AuthRegisterMdl authDB) =>
      AuthRegisterOutput(
        email: authDB.email,
        fullName: authDB.fullName,
        id: authDB.id,
        token: authDB.token,
        roles: authDB.roles,
        refreshToken: authDB.refreshToken,
      );
  static AuthLoginOutput authLoginDBToEntity(AuthLoginMdl authLoginDB) =>
      AuthLoginOutput(
        id: authLoginDB.id,
        provider: authLoginDB.provider,
        email: authLoginDB.email,
        fullName: authLoginDB.fullName,
        token: authLoginDB.token,
        refreshToken: authLoginDB.refreshToken,
      );
}
