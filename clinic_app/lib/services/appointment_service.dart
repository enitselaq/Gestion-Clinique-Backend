import 'package:dio/dio.dart';
import '../models/appointment_model.dart';
import 'api_client.dart';

class AppointmentService {
  final ApiClient _apiClient = ApiClient();
  Dio get _dio => _apiClient.dio;

  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await _dio.get('rendezvous/');
      return (response.data as List)
          .map((item) => AppointmentModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<AppointmentModel> createAppointment(
    AppointmentModel appointment,
  ) async {
    try {
      final response = await _dio.post(
        'rendezvous/',
        data: appointment.toJson(),
      );
      return AppointmentModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  Future<AppointmentModel> updateAppointment(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch('rendezvous/$id/', data: data);
      return AppointmentModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  Future<AppointmentModel> updateAppointmentStatus(
    int id,
    String status,
  ) async {
    return updateAppointment(id, {'statut': status});
  }

  Future<void> deleteAppointment(int id) async {
    try {
      await _dio.delete('rendezvous/$id/');
    } on DioException {
      rethrow;
    }
  }
}
