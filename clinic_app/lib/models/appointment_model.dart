class AppointmentModel {
  final int? id;
  final DateTime dateRdv;
  final String statut; // ATTENTE, CONFIRME, ARRIVE, TERMINE, ANNULE
  final int patientId; 
  final String? patientName;
  final int? medecinId; 
  final String? medecinName;
  final String? motif;
  final bool isEmergency;

  AppointmentModel({
    this.id,
    required this.dateRdv,
    required this.statut,
    required this.patientId,
    this.patientName,
    this.medecinId,
    this.medecinName,
    this.motif,
    this.isEmergency = false,
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
      motif: json['motif'] as String?,
      isEmergency: json['is_emergency'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    // We send a clean date format and the motif.
    // We REMOVE 'patient' and 'statut' fields.
    // Modern backends detect the patient from the Token automatically.
    return {
      'date_rdv': "${dateRdv.year}-${dateRdv.month.toString().padLeft(2, '0')}-${dateRdv.day.toString().padLeft(2, '0')} ${dateRdv.hour.toString().padLeft(2, '0')}:${dateRdv.minute.toString().padLeft(2, '0')}:00",
      'motif': motif,
      'is_emergency': isEmergency,
    };
  }
}
