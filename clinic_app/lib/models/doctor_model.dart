class DoctorModel {
  final int userId; // Medecin PK == user id
  final String fullName;
  final String? specialite;

  DoctorModel({
    required this.userId,
    required this.fullName,
    this.specialite,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      userId: json['user'] as int,
      fullName: (json['full_name'] as String?) ?? '',
      specialite: json['specialite'] as String?,
    );
  }
}

