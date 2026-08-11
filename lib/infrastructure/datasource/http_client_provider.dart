import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/config/constants/enviroment.dart';
import 'package:frontwe/config/router/router_keys.dart';
import 'package:frontwe/infrastructure/datasource/auth_storage.dart';
import 'package:frontwe/providers/lang/locale_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final httpClientProvider = Provider<Dio>((ref) {
  final locale = ref.watch(localeProvider);
  final storage = AuthStorage(const FlutterSecureStorage());

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.API_URL_BACK,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': locale.languageCode,
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Accept-Language'] = locale.languageCode;

          final token = await storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await storage.deleteToken();
            await storage.deleteUserData();
            await goToLogin();
          }
          return handler.next(error);
        },
      ),
    );

  return dio;
});

extension HttpClientExt on WidgetRef {
  Dio get httpClient => watch(httpClientProvider);
}
