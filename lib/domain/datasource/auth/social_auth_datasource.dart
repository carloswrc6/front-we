import 'package:frontwe/domain/entities/auth.dart';

abstract class SocialAuthDatasource {
  Future<AuthLoginOutput> loginWithGoogle();
  Future<String> loginWithApple();
  Future<void> signOut();
}