import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String _defaultLocalApiPath = ':8000/api/';
  static const String _androidEmulatorHost = 'http://10.0.2.2'; // For virtual phone
  static const String _localHost = 'http://127.0.0.1';

  // REAL PC IP ADDRESS:
  static const String _physicalPhoneHost = 'http://192.168.1.36'; 

  // TOGGLE SWITCH: 
  // Set to true for your real phone. Change to false for the virtual emulator
  static const bool _isUsingPhysicalPhone = true;

  static String get baseUrl {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) {
      return override.endsWith('/') ? override : '$override/';
    }
    if (kIsWeb) {
      return '$_localHost$_defaultLocalApiPath';
    }
    return switch (defaultTargetPlatform) {
      // 3.check toggle and picks the right IP automatically
      TargetPlatform.android => _isUsingPhysicalPhone 
          ? '$_physicalPhoneHost$_defaultLocalApiPath'
          : '$_androidEmulatorHost$_defaultLocalApiPath',
      _ => '$_localHost$_defaultLocalApiPath',
    };
  }
}