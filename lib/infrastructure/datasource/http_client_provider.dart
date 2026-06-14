import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/config/constants/enviroment.dart';
import 'package:frontwe/providers/lang/locale_provider.dart';

/// Riverpod provider para el cliente HTTP con soporte de Accept-Language
final httpClientProvider = Provider<Dio>((ref) {
  final locale = ref.watch(localeProvider);
  
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.API_URL_BACK,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': locale.languageCode, // es, en
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Actualizar Accept-Language en cada request
          options.headers['Accept-Language'] = locale.languageCode;
          
          // Add auth headers here if needed, for example:
          // final token = await SecureStorageService.getToken();
          // if (token != null) options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
    );

  return dio;
});

/// Extension para facilitar acceso al cliente HTTP desde providers
extension HttpClientExt on WidgetRef {
  Dio get httpClient => watch(httpClientProvider);
}
