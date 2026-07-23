class PatientModel {
  final int userId; // Patient PK == user id
  final String fullName;
  final String? cin;
  final String? phone; // Added phone field
  final DateTime? dateNaissance;
  final String? sexe;
  final int? age;
  final String antecedents;
  final String allergies;

  PatientModel({
    required this.userId,
    required this.fullName,
    this.cin,
    this.phone,
    this.dateNaissance,
    this.sexe,
    this.age,
    this.antecedents = '',
    this.allergies = '',
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      userId: json['user'] as int,
      fullName: (json['full_name'] as String?) ?? '',
      cin: json['cin'] as String?,
      phone: json['phone'] as String?,
      dateNaissance: json['date_naissance'] != null
          ? DateTime.tryParse(json['date_naissance'] as String)
          : null,
      sexe: json['sexe'] as String?,
      age: json['age'] as int?,
      antecedents: (json['antecedents'] as String?) ?? '',
      allergies: (json['allergies'] as String?) ?? '',
    );
  }
}
