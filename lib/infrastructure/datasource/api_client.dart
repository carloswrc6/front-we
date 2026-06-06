import 'package:dio/dio.dart';
import 'package:frontwe/config/constants/enviroment.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Environment.API_URL_BACK,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth headers here if needed, for example:
          // final token = await SecureStorageService.getToken();
          // if (token != null) options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
    );
}
