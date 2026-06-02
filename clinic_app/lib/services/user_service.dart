import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/doctor_model.dart';
import '../models/patient_model.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();
  Dio get _dio => _apiClient.dio;

  // Generic method to create user (Doctor or Receptionist)
  Future<int?> createUser({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    required String telephone,
    String? patientCin,
    DateTime? patientBirthDate,
    String? patientSexe,
    String? patientAntecedents,
    String? patientAllergies,
    String? medecinSpecialite,
  }) async {
    try {
      final payload = <String, dynamic>{
        'username': username,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'role': role,
        'telephone': telephone,
      };
      if (patientCin != null && patientCin.isNotEmpty) {
        payload['patient_cin'] = patientCin;
      }
      if (patientBirthDate != null) {
        payload['patient_date_naissance'] = patientBirthDate
            .toIso8601String()
            .split('T')[0];
      }
      if (patientSexe != null && patientSexe.isNotEmpty) {
        payload['patient_sexe'] = patientSexe;
      }
      if (patientAntecedents != null) {
        payload['patient_antecedents'] = patientAntecedents;
      }
      if (patientAllergies != null) {
        payload['patient_allergies'] = patientAllergies;
      }
      if (medecinSpecialite != null && medecinSpecialite.isNotEmpty) {
        payload['medecin_specialite'] = medecinSpecialite;
      }
      final response = await _dio.post('users/', data: payload);
      if (response.statusCode == 201) {
        return response.data['id'] as int?;
      }
      return null;
    } on DioException {
      return null;
    }
  }

  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('users/$id/', data: data);
      return response.statusCode == 200;
    } on DioException {
      return false;
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    final response = await _dio.get('users/');
    return response.data;
  }

  Future<bool> deleteUser(int id) async {
    try {
      final response = await _dio.delete('users/$id/');
      return response.statusCode == 204;
    } on DioException {
      return false;
    }
  }

  Future<List<DoctorModel>> getMedecins() async {
    final response = await _dio.get('medecins/');
    return (response.data as List).map((e) => DoctorModel.fromJson(e)).toList();
  }

  Future<List<PatientModel>> getPatients() async {
    final response = await _dio.get('patients/');
    return (response.data as List)
        .map((e) => PatientModel.fromJson(e))
        .toList();
  }

  Future<DoctorModel> getMedecin(int userId) async {
    final response = await _dio.get('medecins/$userId/');
    return DoctorModel.fromJson(response.data);
  }

  Future<bool> upsertMedecinSpecialite({
    required int userId,
    required String specialite,
  }) async {
    try {
      // Most installs create the Medecin profile automatically via signal.
      final response = await _dio.patch(
        'medecins/$userId/',
        data: {'specialite': specialite},
      );
      return response.statusCode == 200;
    } on DioException {
      try {
        final response = await _dio.post(
          'medecins/',
          data: {'user': userId, 'specialite': specialite},
        );
        return response.statusCode == 201;
      } on DioException {
        return false;
      }
    }
  }
}
