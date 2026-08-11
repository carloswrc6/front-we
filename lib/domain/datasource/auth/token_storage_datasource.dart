abstract class TokenStorageDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> deleteRefreshToken();

  Future<void> saveUserData({
    required String id,
    required String fullName,
    required String email,
    required String provider,
  });
  Future<Map<String, String>?> getUserData();
  Future<void> deleteUserData();
}