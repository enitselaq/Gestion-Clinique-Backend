import 'package:dio/dio.dart';
import '../models/medicament_model.dart';
import 'api_client.dart';

class MedicineService {
  final ApiClient _apiClient = ApiClient();
  Dio get _dio => _apiClient.dio;

  Future<List<MedicamentModel>> getMedicaments() async {
    try {
      final response = await _dio.get('medicaments/');
      return (response.data as List)
          .map((item) => MedicamentModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<MedicamentModel> createMedicament(MedicamentModel medicament) async {
    try {
      final response = await _dio.post('medicaments/', data: medicament.toJson());
      return MedicamentModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  // Backward-compatible method names for older UI code.
  Future<List<MedicamentModel>> getMedicines() => getMedicaments();
  Future<MedicamentModel> createMedicine(MedicamentModel medicine) => createMedicament(medicine);
}
