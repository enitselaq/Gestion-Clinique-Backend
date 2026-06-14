import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest', // Helps Django recognize it's an API call, not a browser
    },
  ));
  final _storage = const FlutterSecureStorage();

  ApiClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Token $token';
          }
          // Log request for debugging
          debugPrint('--> ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 403) {
            debugPrint('DEBUG: 403 Forbidden Error at ${e.requestOptions.path}');
            debugPrint('DEBUG: Response Data: ${e.response?.data}');
            debugPrint('DEBUG: Request Headers: ${e.requestOptions.headers}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
