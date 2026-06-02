class MedicamentModel {
  final int? id;
  final int ordonnanceId;
  final String nomGenerique;
  final String dosage;
  final String instructions;

  MedicamentModel({
    this.id,
    required this.ordonnanceId,
    required this.nomGenerique,
    required this.dosage,
    required this.instructions,
  });

  factory MedicamentModel.fromJson(Map<String, dynamic> json) {
    return MedicamentModel(
      id: json['id'] as int?,
      ordonnanceId: json['ordonnance'] as int,
      nomGenerique: json['nom_generique'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ordonnance': ordonnanceId,
      'nom_generique': nomGenerique,
      'dosage': dosage,
      'instructions': instructions,
    };
  }
}
