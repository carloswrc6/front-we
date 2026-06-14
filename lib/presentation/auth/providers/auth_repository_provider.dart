import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontwe/domain/repository/auth_repository.dart';

import 'package:frontwe/infrastructure/datasource/auth_db_datasource.dart';
import 'package:frontwe/infrastructure/datasource/auth_storage.dart';
import 'package:frontwe/infrastructure/datasource/google_auth_datasource.dart';
import 'package:frontwe/infrastructure/datasource/http_client_provider.dart';
import 'package:frontwe/infrastructure/repositories/auth_repository_impl.dart';

import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(httpClientProvider);
  
  return AuthRepositoryImpl(
    AuthDbDatasource(dio: dio),

    GoogleSignInService(GoogleSignIn.instance),

    AuthStorage(const FlutterSecureStorage()),
  );
});
