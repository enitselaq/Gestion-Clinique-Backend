import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final _storage = const FlutterSecureStorage();

  Dio get _dio => _apiClient.dio;

  // --- 1. Login Method ---
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'login/',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        UserModel user = UserModel.fromJson(response.data);

        // Save session data locally
        await _storage.write(key: 'token', value: user.token);
        await _storage.write(key: 'role', value: user.role);
        await _storage.write(key: 'user_id', value: user.userId.toString());
        await _storage.write(key: 'name', value: user.name);
        await _storage.write(key: 'email', value: user.email);
        if (user.profileId != null) {
          await _storage.write(
            key: 'profile_id',
            value: user.profileId.toString(),
          );
        }

        return user;
      }
    } on DioException catch (e) {
      debugPrint("Login error: ${e.response?.data ?? e.message}");
      rethrow;
    }
    return null;
  }

  // --- 2. Register Method (Matches your Django Serializer) ---
  Future<bool> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String cin,
    required String sexe,
    required DateTime dob,
  }) async {
    try {
      final response = await _dio.post(
        'signup/',
        data: {
          'username': username,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'telephone': phone,
          'role': 'PATIENT',
          'cin': cin,
          'sexe': sexe,
          'date_naissance': dob.toIso8601String().split(
            'T',
          )[0], // Formats to YYYY-MM-DD
        },
      );

      return response.statusCode == 201;
    } on DioException catch (e) {
      debugPrint("Registration error: ${e.response?.data}");
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        'change-password/',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'] as String?;
        if (token != null) {
          await _storage.write(key: 'token', value: token);
        }
        return true;
      }
      return false;
    } on DioException catch (e) {
      debugPrint("Change password error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  Future<bool> forgotPasswordReset({
    required String username,
    required String cin,
    required DateTime dateNaissance,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        'forgot-password/',
        data: {
          'username': username,
          'cin': cin,
          'date_naissance': dateNaissance.toIso8601String().split('T')[0],
          'new_password': newPassword,
        },
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("Forgot password error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  // --- 3. Session Helpers ---
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<UserModel?> getSavedUser() async {
    final token = await _storage.read(key: 'token');
    final role = await _storage.read(key: 'role');
    final userId = await _storage.read(key: 'user_id');

    if (token == null || role == null || userId == null) {
      return null;
    }

    final profileId = await _storage.read(key: 'profile_id');
    final name = await _storage.read(key: 'name') ?? '';
    final email = await _storage.read(key: 'email') ?? '';

    return UserModel(
      token: token,
      userId: int.parse(userId),
      profileId: profileId != null ? int.tryParse(profileId) : null,
      role: role,
      name: name,
      email: email,
    );
  }
}
