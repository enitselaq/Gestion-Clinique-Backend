import 'medicament_model.dart';

class PrescriptionModel {
  final int? id;
  final int consultationId;
  final DateTime? dateCreation;
  final List<MedicamentModel> medicaments;

  PrescriptionModel({
    this.id,
    required this.consultationId,
    this.dateCreation,
    required this.medicaments,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as int?,
      consultationId: json['consultation'] as int,
      dateCreation: json['date_creation'] != null ? DateTime.tryParse(json['date_creation'] as String) : null,
      medicaments: (json['medicaments'] as List?)
              ?.map((m) => MedicamentModel.fromJson(m))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consultation': consultationId,
    };
  }
}
