import 'package:frontwe/domain/datasource/auth/auth_datasource.dart';
import 'package:frontwe/domain/datasource/auth/social_auth_datasource.dart';
import 'package:frontwe/domain/datasource/auth/token_storage_datasource.dart';

import 'package:frontwe/domain/entities/auth.dart';
import 'package:frontwe/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;
  final SocialAuthDatasource socialDatasource;
  final TokenStorageDatasource storageDatasource;

  AuthRepositoryImpl(
    this.authDatasource,
    this.socialDatasource,
    this.storageDatasource,
  );

  @override
  Future<AuthLoginOutput> loginUser(AuthLoginInput user) async {
    final auth = await authDatasource.loginUser(user);

    await storageDatasource.saveToken(auth.token);

    return auth;
  }

  @override
  Future<AuthRegisterOutput> userRegister(AuthRegisterInput user) {
    return authDatasource.userRegister(user);
  }

  @override
  Future<AuthLoginOutput> loginWithGoogle() async {
    final auth = await socialDatasource.loginWithGoogle();

    await storageDatasource.saveToken(auth.token);

    return auth;
  }

  @override
  Future<String> loginWithApple() async {
    final token = await socialDatasource.loginWithApple();

    await storageDatasource.saveToken(token);

    return token;
  }

  @override
  Future<void> logout() async {
    await socialDatasource.signOut();

    await storageDatasource.deleteToken();
  }

  @override
  Future<String?> getSavedToken() {
    return storageDatasource.getToken();
  }

  @override
  Future<void> forgotPassword(String email) {
    return authDatasource.forgotPassword(email);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) {
    return authDatasource.resetPassword(
      email: email,
      code: code,
      password: password,
    );
  }
}
