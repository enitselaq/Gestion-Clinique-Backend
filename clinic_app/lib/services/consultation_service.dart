import 'package:dio/dio.dart';
import '../models/consultation_model.dart';
import 'api_client.dart';

class ConsultationService {
  final ApiClient _apiClient = ApiClient();
  Dio get _dio => _apiClient.dio;

  Future<List<ConsultationModel>> getConsultations() async {
    try {
      final response = await _dio.get('consultations/');
      return (response.data as List)
          .map((item) => ConsultationModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<ConsultationModel> createConsultation(ConsultationModel consultation) async {
    try {
      final response = await _dio.post('consultations/', data: consultation.toJson());
      return ConsultationModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  Future<ConsultationModel> updateConsultation(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch('consultations/$id/', data: data);
      return ConsultationModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}
