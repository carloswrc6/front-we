import 'package:dio/dio.dart';
import 'package:frontwe/config/constants/enviroment.dart';
import 'package:frontwe/domain/datasource/auth_datasource.dart';
import 'package:frontwe/domain/entities/auth.dart';
import 'package:frontwe/infrastructure/mappers/auth_mappers.dart';
import 'package:frontwe/infrastructure/models/auth_bd/register.dart';
import 'package:frontwe/infrastructure/models/auth_bd/login.dart';

class AuthDbDatasource extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.API_URL_BACK));

  @override
  Future<LoginGoogleApple> loginGoogleApple(LoginGoogleApple user) {
    // TODO: implement loginGoogleApple
    throw UnimplementedError();
  }

  @override
  Future<AuthLoginOutput> loginUser(AuthLoginInput user) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {"email": user.email, "password": user.password},
      );

      final authLoginDBResponse = AuthLoginMdl.fromJson(response.data);

      return AuthMapper.authLoginDBToEntity(authLoginDBResponse);
    } on DioException catch (e) {
      String message = 'Error inesperado';

      if (e.response != null) {
        final data = e.response?.data;

        if (data['message'] is List) {
          message = (data['message'] as List).join(', ');
        } else if (data['message'] is String) {
          message = data['message'];
        } else {
          message = data.toString();
        }
      } else {
        message = e.message ?? 'Error de conexión';
      }

      throw Exception(message);
    }
  }

  @override
  Future<AuthRegisterOutput> userRegister(AuthRegisterInput user) async {
    try {
      print('➡️ Calling API...');
      print('Base URL: ${dio.options.baseUrl}');

      final response = await dio.post(
        '/auth/register',
        data: {
          "email": user.email,
          "password": user.password,
          "fullName": user.fullName,
        },
      );

      print('✅ Status code: ${response.statusCode}');
      print('📦 Response data: ${response.data}');

      final authDBResponse = AuthRegisterMdl.fromJson(response.data);

      final newUser = AuthMapper.authDBToEntity(authDBResponse);

      print('🎯 User created: ${newUser.email}');

      return newUser;
    } on DioException catch (e) {
      print('❌ Dio error: ${e.message}');
      print('❌ Status code: ${e.response?.statusCode}');
      print('❌ Data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('❌ Unknown error: $e');
      rethrow;
    }
  }
}
