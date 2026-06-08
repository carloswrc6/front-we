abstract class TokenStorageDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}