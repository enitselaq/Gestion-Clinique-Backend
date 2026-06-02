import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String _defaultLocalApiPath = ':8000/api/';
  static const String _androidEmulatorHost = 'http://10.0.2.2';
  static const String _localHost = 'http://127.0.0.1';

  static String get baseUrl {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) {
      return override.endsWith('/') ? override : '$override/';
    }
    if (kIsWeb) {
      return '$_localHost$_defaultLocalApiPath';
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => '$_androidEmulatorHost$_defaultLocalApiPath',
      _ => '$_localHost$_defaultLocalApiPath',
    };
  }
}
