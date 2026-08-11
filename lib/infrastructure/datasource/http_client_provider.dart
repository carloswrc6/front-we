import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/config/constants/enviroment.dart';
import 'package:frontwe/config/router/router_keys.dart';
import 'package:frontwe/infrastructure/datasource/auth_storage.dart';
import 'package:frontwe/providers/lang/locale_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _noRefreshPaths = {
  '/auth/login',
  '/auth/register',
  '/auth/refresh',
  '/auth/forgot-password',
  '/auth/verify-reset-code',
  '/auth/reset-password',
  '/auth/google',
  '/auth/apple',
};

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
  );

  bool isRefreshing = false;

  Future<String?> tryRefresh() async {
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null) return null;

    final response = await dio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    final data = response.data as Map<String, dynamic>;
    final token = data['token'] as String?;
    final newRefresh = data['refreshToken'] as String?;
    if (token == null) return null;

    await storage.saveToken(token);
    if (newRefresh != null) {
      await storage.saveRefreshToken(newRefresh);
    }
    return token;
  }

  dio.interceptors.add(
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
        final status = error.response?.statusCode;
        final path = error.requestOptions.path;

        if (status == 401 && !_noRefreshPaths.contains(path)) {
          if (!isRefreshing) {
            isRefreshing = true;
            try {
              final newToken = await tryRefresh();
              if (newToken != null) {
                final opts = error.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newToken';
                final response = await dio.fetch<dynamic>(opts);
                return handler.resolve(response);
              }
            } catch (_) {
              // refresh failed, fall through to logout
            } finally {
              isRefreshing = false;
            }

            await storage.deleteToken();
            await storage.deleteRefreshToken();
            await storage.deleteUserData();
            await goToLogin();
          }
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
