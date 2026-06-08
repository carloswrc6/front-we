import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontwe/domain/datasource/auth/token_storage_datasource.dart';

class AuthStorage implements TokenStorageDatasource {
  final FlutterSecureStorage storage;

  AuthStorage(this.storage);

  @override
  Future<void> saveToken(String token) async {
    await storage.write(
      key: 'token',
      value: token,
    );
  }

  @override
  Future<String?> getToken() async {
    return storage.read(key: 'token');
  }

  @override
  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }
}