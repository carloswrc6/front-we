import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/repository/auth_repository.dart';
import 'package:frontwe/infrastructure/datasource/auth_db_datasource.dart';
import 'package:frontwe/infrastructure/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(AuthDbDatasource());
});
