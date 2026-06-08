abstract class SocialAuthDatasource {
  Future<String> loginWithGoogle();
  Future<String> loginWithApple();
  Future<void> signOut();
}