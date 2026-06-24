import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontwe/domain/datasource/auth/token_storage_datasource.dart';

class AuthStorage implements TokenStorageDatasource {
  final FlutterSecureStorage storage;

  AuthStorage(this.storage);

  @override
  Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  @override
  Future<String?> getToken() async {
    return storage.read(key: 'token');
  }

  @override
  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  @override
  Future<void> saveUserData({
    required String id,
    required String fullName,
    required String email,
    required String provider,
  }) async {
    final data = jsonEncode({
      'id': id,
      'fullName': fullName,
      'email': email,
      'provider': provider,
    });
    await storage.write(key: 'user_data', value: data);
  }

  @override
  Future<Map<String, String>?> getUserData() async {
    final data = await storage.read(key: 'user_data');
    if (data == null) return null;
    return Map<String, String>.from(jsonDecode(data));
  }

  @override
  Future<void> deleteUserData() async {
    await storage.delete(key: 'user_data');
  }
}