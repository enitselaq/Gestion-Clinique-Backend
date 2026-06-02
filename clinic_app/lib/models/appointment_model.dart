class AppointmentModel {
  final int? id;
  final DateTime dateRdv;
  final String statut; // ATTENTE, CONFIRME, ANNULE, TERMINE
  final int patientId; // Patient PK == user id
  final String? patientName;
  final int? medecinId; // Medecin PK == user id (nullable on backend)
  final String? medecinName;

  AppointmentModel({
    this.id,
    required this.dateRdv,
    required this.statut,
    required this.patientId,
    this.patientName,
    this.medecinId,
    this.medecinName,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as int?,
      dateRdv: DateTime.parse(json['date_rdv'] as String),
      statut: (json['statut'] as String?) ?? 'ATTENTE',
      patientId: json['patient'] as int,
      patientName: json['patient_name'] as String?,
      medecinId: json['medecin'] as int?,
      medecinName: json['medecin_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'date_rdv': dateRdv.toIso8601String(),
      'statut': statut,
      'patient': patientId,
    };
    if (medecinId != null) {
      data['medecin'] = medecinId;
    }
    return data;
  }
}
