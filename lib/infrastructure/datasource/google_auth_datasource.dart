import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<void> init() async {
    await _googleSignIn.initialize();
  }

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      print('account: $account');

      return account;
    } catch (e) {
      print('Error in google signin');
      print(e);

      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();

      print('User signed out');
    } catch (e) {
      print('Error signing out');
      print(e);
    }
  }
}
