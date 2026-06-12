import 'package:dio/dio.dart';
import 'package:frontwe/domain/datasource/auth/auth_datasource.dart';
import 'package:frontwe/domain/entities/auth.dart';
import 'package:frontwe/infrastructure/datasource/api_client.dart';
import 'package:frontwe/infrastructure/mappers/auth_mappers.dart';
import 'package:frontwe/infrastructure/models/auth_bd/register.dart';
import 'package:frontwe/infrastructure/models/auth_bd/login.dart';

class AuthDbDatasource extends AuthDatasource {
  final dio = ApiClient.dio;

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
      final response = await dio.post(
        '/auth/register',
        data: {
          "email": user.email,
          "password": user.password,
          "fullName": user.fullName,
        },
      );

      final authDBResponse = AuthRegisterMdl.fromJson(response.data);
      final newUser = AuthMapper.authDBToEntity(authDBResponse);
      return newUser;
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await ApiClient.dio.post('/auth/forgot-password', data: {'email': email});
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    await ApiClient.dio.post(
      '/auth/reset-password',
      data: {'email': email, 'code': code, 'password': password},
    );
  }
}
