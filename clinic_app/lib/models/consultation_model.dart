class ConsultationModel {
  final int? id;
  final String diagnostic;
  final String notes;
  final DateTime? dateConsult;
  final int rdvId;
  final int medecinId; // Medecin PK == user id
  final String? patientName;
  final String? medecinName;

  ConsultationModel({
    this.id,
    required this.diagnostic,
    required this.notes,
    this.dateConsult,
    required this.rdvId,
    required this.medecinId,
    this.patientName,
    this.medecinName,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      id: json['id'] as int?,
      diagnostic: json['diagnostic'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      dateConsult: json['date_consult'] != null ? DateTime.tryParse(json['date_consult'] as String) : null,
      rdvId: json['rdv'] as int,
      medecinId: json['medecin'] as int,
      patientName: json['patient_name'] as String?,
      medecinName: json['medecin_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diagnostic': diagnostic,
      'notes': notes,
      'rdv': rdvId,
      'medecin': medecinId,
    };
  }
}
