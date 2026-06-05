import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:frontwe/infrastructure/datasource/api_client.dart';
import 'package:frontwe/infrastructure/datasource/auth_storage.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<void> init() async {
    await _googleSignIn.initialize();
  }

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      print('INICIO LOGIN GOOGLE');

      final GoogleSignInAccount account =
          await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      print('ACCOUNT: $account');

      final GoogleSignInAuthentication auth =
          account.authentication;

      print('ID TOKEN: ${auth.idToken != null}');

      final idToken = auth.idToken;

      if (idToken != null) {
        final backendResp = await sendIdTokenToBackend(idToken);

        if (backendResp != null) {

          await AuthStorage.saveToken(
            backendResp['token'],
          );

          print('Token guardado');
        }
      }

      return account;
    } catch (e) {
      print('ERROR LOGIN GOOGLE');
      print(e);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> sendIdTokenToBackend(
    String idToken,
  ) async {
    try {
      print('ENVIANDO TOKEN AL BACKEND');
      final response = await ApiClient.dio.post(
        '/auth/google',
        data: {'idToken': idToken},
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return response.data as Map<String, dynamic>;
      }
      print('Backend error: ${response.statusCode} ${response.data}');
      return null;
    } on DioException catch (e) {
      print('Error sending idToken to backend');
      print(e.message);
      print('Response data: ${e.response?.data}');
      return null;
    } catch (e) {
      print('Error sending idToken to backend');
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
