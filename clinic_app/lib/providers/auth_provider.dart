import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  bool _isInitialized = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    loadSavedSession();
  }

  Future<void> loadSavedSession() async {
    _user = await _authService.getSavedUser();
    _isInitialized = true;
    notifyListeners();
  }

  // --- 1. Login Logic ---
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.login(username, password);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --- 2. Registration Logic ---
  Future<bool> register({
    required String username,
    required String password,
    required String fullName,
    required String phone, // <--- ADDED THIS LINE
    required String cin,
    required String sexe,
    required DateTime dob,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Split fullName for Django (e.g., "John Doe" -> "John" and "Doe")
    List<String> nameParts = fullName.trim().split(' ');
    String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    String lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : ' ';

    try {
      bool success = await _authService.register(
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: '$username@clinic.com',
        phone: phone, // <--- PASS THE PHONE HERE
        cin: cin,
        sexe: sexe,
        dob: dob,
      );
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPasswordReset({
    required String username,
    required String cin,
    required DateTime dateNaissance,
    required String newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.forgotPasswordReset(
        username: username,
        cin: cin,
        dateNaissance: dateNaissance,
        newPassword: newPassword,
      );
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --- 3. Logout ---
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
