import 'package:dio/dio.dart';
import 'package:frontwe/domain/datasource/auth/social_auth_datasource.dart';
import 'package:frontwe/domain/entities/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:frontwe/infrastructure/datasource/api_client.dart';

class GoogleSignInService implements SocialAuthDatasource {
  final GoogleSignIn googleSignIn;

  GoogleSignInService(this.googleSignIn);

  Future<void> init() async {
    await googleSignIn.initialize();
  }

  @override
  Future<AuthLoginOutput> loginWithGoogle() async {
    final account = await googleSignIn.authenticate(scopeHint: ['email']);

    final auth = account.authentication;

    final idToken = auth.idToken;

    if (idToken == null) {
      throw Exception('Google no devolvió idToken');
    }

    final backendResp = await sendIdTokenToBackend(idToken);

    if (backendResp == null) {
      throw Exception('Error autenticando con backend');
    }

    // return backendResp['token'];
    return AuthLoginOutput(
      id: backendResp['id'],
      provider: backendResp['provider'],
      email: backendResp['email'],
      fullName: backendResp['fullName'],
      token: backendResp['token'],
    );
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
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

  @override
  Future<String> loginWithApple() {
    // TODO: implement loginWithApple
    throw UnimplementedError();
  }
}
