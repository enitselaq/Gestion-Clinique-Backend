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
          debugPrint('DEBUG: HTTP Error at ${e.requestOptions.path} - ${e.response?.statusCode}');
          debugPrint('DEBUG: Response Data: ${e.response?.data}');
          debugPrint('DEBUG: Request Headers: ${e.requestOptions.headers}');
          debugPrint('DEBUG: Request Body: ${e.requestOptions.data}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
