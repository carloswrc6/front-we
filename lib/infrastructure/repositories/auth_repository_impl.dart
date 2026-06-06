import 'package:frontwe/domain/datasource/auth_datasource.dart';
import 'package:frontwe/domain/entities/auth.dart';
import 'package:frontwe/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;
  AuthRepositoryImpl(this.datasource);

  @override
  Future<AuthLoginOutput> loginUser(AuthLoginInput user) {
    return datasource.loginUser(user);
  }

  @override
  Future<AuthRegisterOutput> userRegister(AuthRegisterInput user) {
    return datasource.userRegister(user);
  }
}
