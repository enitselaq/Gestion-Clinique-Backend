class PaiementModel {
  final int? id;
  final int rdvId;
  final double montant;
  final DateTime? datePaiement;

  PaiementModel({
    this.id,
    required this.rdvId,
    required this.montant,
    this.datePaiement,
  });

  factory PaiementModel.fromJson(Map<String, dynamic> json) {
    return PaiementModel(
      id: json['id'] as int?,
      rdvId: json['rdv'] as int,
      montant: double.parse(json['montant'].toString()),
      datePaiement: json['date_paiement'] != null ? DateTime.tryParse(json['date_paiement'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rdv': rdvId,
      'montant': montant,
    };
  }
}
