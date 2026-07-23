import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../core/app_theme.dart';
import '../../models/appointment_model.dart';
import '../../models/doctor_model.dart';
import '../../models/paiement_model.dart';
import '../../models/patient_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/appointment_service.dart';
import '../../services/payment_service.dart';
import '../../services/user_service.dart';
import '../notifications_screen.dart';

class ReceptionistDashboard extends StatefulWidget {
  const ReceptionistDashboard({super.key});

  @override
  State<ReceptionistDashboard> createState() => _ReceptionistDashboardState();
}

class _ReceptionistDashboardState extends State<ReceptionistDashboard> {
  final AppointmentService _appointmentService = AppointmentService();
  final UserService _userService = UserService();
  final PaymentService _paymentService = PaymentService();

  List<AppointmentModel> _appointments = [];
  List<PatientModel> _patients = [];
  List<DoctorModel> _doctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _appointmentService.getAppointments(),
        _userService.getPatients(),
        _userService.getMedecins(),
      ]);
      if (!mounted) return;
      setState(() {
        _appointments = results[0] as List<AppointmentModel>;
        _patients = results[1] as List<PatientModel>;
        _doctors = results[2] as List<DoctorModel>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showConfirmationDialog(AppointmentModel appt) async {
    DoctorModel? selectedDoctor;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Confirmer & Assigner'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Patient: ${appt.patientName}'),
              const SizedBox(height: 20),
              DropdownButtonFormField<DoctorModel>(
                decoration: const InputDecoration(labelText: 'Choisir le Médecin'),
                items: _doctors.map((d) => DropdownMenuItem(value: d, child: Text('Dr. ${d.fullName}'))).toList(),
                onChanged: (val) => setDialogState(() => selectedDoctor = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: selectedDoctor == null ? null : () async {
                try {
                  await _appointmentService.assignDoctor(appt.id!, selectedDoctor!.userId);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  _fetchData();
                } catch (e) {
                  debugPrint('Error assigning doctor / confirming appointment: $e');
                  if (!context.mounted) return;
                  String message = 'Erreur: impossible de confirmer/assigner le rendez-vous.';
                  // If DioException, try to extract server message
                  try {
                    if (e is DioException) {
                      final resp = e.response?.data;
                      if (resp is Map && resp.containsKey('detail')) {
                        message = resp['detail'].toString();
                      } else if (resp != null) {
                        message = resp.toString();
                      }
                    }
                  } catch (_) {}

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              },
              child: const Text('Confirmer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkInPatient(AppointmentModel appt) async {
    try {
      await _appointmentService.updateAppointmentStatus(appt.id!, 'ARRIVE');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${appt.patientName} est maintenant en salle d\'attente.')),
      );
      _fetchData();
    } catch (e) {
      debugPrint('Error during check-in: $e');
    }
  }

  Future<void> _deleteAppointment(AppointmentModel appt) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le rendez-vous'),
        content: Text('Voulez-vous vraiment supprimer le rendez-vous de ${appt.patientName ?? "ce patient"} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Non')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _appointmentService.deleteAppointment(appt.id!);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rendez-vous supprimé.')),
        );
        _fetchData();
      } catch (e) {
        debugPrint('Error deleting appointment: $e');
      }
    }
  }

  Future<void> _showPaymentDialog(AppointmentModel appt) async {
    final amountController = TextEditingController(text: '200');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enregistrer un paiement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Patient: ${appt.patientName ?? "N/A"}'),
            const SizedBox(height: 8),
            Text('Date RDV: ${appt.dateRdv.toString().substring(0, 10)}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Montant (MAD)',
                prefixIcon: Icon(Icons.money),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        final amount = double.tryParse(amountController.text) ?? 200;
        await _paymentService.createPayment(
          PaiementModel(rdvId: appt.id!, montant: amount),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paiement enregistré avec succès.'), backgroundColor: AppTheme.primaryTeal),
        );
      } catch (e) {
        debugPrint('Error recording payment: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'enregistrement du paiement.'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bonjour, ${authProvider.user?.username ?? 'Receptionniste'}', style: const TextStyle(fontSize: 14, color: AppTheme.mutedSlate)),
            const Text('Espace Réception', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          _buildLanguageSmallToggle(localeProvider),
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())), icon: const Icon(Icons.notifications_none_rounded)),
          IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh_rounded)),
          IconButton(
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(),
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusBanner(),
                    const SizedBox(height: 18),
                    const Text('Raccourcis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                      children: [
                        _buildMenuCard('Rendez-vous', Icons.calendar_today_rounded, Colors.blue, _appointments.length, () => _showSection('Rendez-vous', _buildAppointmentsList())),
                        _buildMenuCard('Patients', Icons.people, Colors.indigo, _patients.length, () => _showSection('Patients', _buildPatientsList())),
                        _buildMenuCard('Médecins', Icons.person_search, Colors.teal, _doctors.length, () => _showSection('Médecins', _buildDoctorsList())),
                        _buildMenuCard('Arrivées', Icons.login_rounded, Colors.orange, _appointments.where((a) => a.statut == 'CONFIRME').length, () => _showSection('En Attente', _buildAppointmentsList())),
                        _buildMenuCard('Paiements', Icons.account_balance_wallet_rounded, Colors.green, 0, () => _showSection('Paiements', _buildPaymentsList())),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Demandes récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(height: 400, child: _buildAppointmentsList()),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatusBanner() {
    if (_appointments.isEmpty) return const SizedBox.shrink();

    AppointmentModel activeAppt;
    try {
      activeAppt = _appointments.firstWhere((a) => a.statut == 'ATTENTE' || a.statut == 'CONFIRME', orElse: () => _appointments.first);
    } catch (e) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.primaryTeal, AppTheme.deepTeal]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.primaryTeal.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activeAppt.statut == 'CONFIRME' ? 'RDV Confirmé' : 'Nouvelle demande', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${activeAppt.patientName ?? 'Patient'} - ${activeAppt.dateRdv.toString().substring(0, 10)}', style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, Color color, int count, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withValues(alpha: 0.08))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 26)),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text('$count éléments', style: TextStyle(color: AppTheme.mutedSlate, fontSize: 12))])
          ],
        ),
      ),
    );
  }

  void _showSection(String title, Widget content) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(title: Text(title)), body: content)));
  }

  Widget _buildDoctorsList() {
    return ListView.builder(padding: const EdgeInsets.all(12), itemCount: _doctors.length, itemBuilder: (context, index) {final d = _doctors[index]; return Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(d.fullName), subtitle: Text(d.specialite ?? '')));});
  }

  Widget _buildLanguageSmallToggle(LocaleProvider provider) {
    return Row(
      children: [
        _langBtn('FR', const Locale('fr'), provider),
        _langBtn('AR', const Locale('ar'), provider),
      ],
    );
  }

  Widget _langBtn(String label, Locale loc, LocaleProvider provider) {
    final isSel = provider.locale.languageCode == loc.languageCode;
    return GestureDetector(
      onTap: () => provider.setLocale(loc),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSel ? AppTheme.primaryTeal.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal, color: isSel ? AppTheme.primaryTeal : AppTheme.mutedSlate)),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    if (_appointments.isEmpty) return const Center(child: Text('Aucune demande enregistrée.'));
    
    // Sort so Pending and Confirmed (not arrived) are at top
    final sortedAppts = List<AppointmentModel>.from(_appointments);
    sortedAppts.sort((a, b) {
      if (a.statut == 'ATTENTE') return -1;
      if (b.statut == 'ATTENTE') return 1;
      return 0;
    });

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sortedAppts.length,
      itemBuilder: (context, index) {
        final appt = sortedAppts[index];
        final isEm = appt.isEmergency;
        
        return Card(
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: (isEm ? Colors.red : _getStatusColor(appt.statut)).withValues(alpha: 0.1),
              child: Icon(
                isEm ? Icons.emergency : _getStatusIcon(appt.statut),
                color: isEm ? Colors.red : _getStatusColor(appt.statut),
              ),
            ),
            title: Text(appt.patientName ?? 'Patient Anonyme', style: TextStyle(fontWeight: FontWeight.bold, color: isEm ? Colors.red : null)),
            subtitle: Text('Status: ${appt.statut} - ${appt.dateRdv.toString().substring(0, 10)}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isEm) const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text('🚑 URGENCE / AMBULANCE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                    const Text('Motif:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(appt.motif ?? 'Non spécifié'),
                    const SizedBox(height: 12),
                    if (appt.medecinName != null) Text('Médecin: Dr. ${appt.medecinName}', style: const TextStyle(fontStyle: FontStyle.italic)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (appt.statut == 'ATTENTE')
                          ElevatedButton.icon(
                            onPressed: () => _showConfirmationDialog(appt),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Confirmer'),
                          ),
                        if (appt.statut == 'CONFIRME')
                          ElevatedButton.icon(
                            onPressed: () => _checkInPatient(appt),
                            icon: const Icon(Icons.login_rounded),
                            label: const Text('Enregistrer Arrivée'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          ),
                        if (appt.statut == 'ARRIVE')
                          const Chip(label: Text('En Salle d\'Attente'), backgroundColor: Colors.orangeAccent, labelStyle: TextStyle(color: Colors.white)),
                        if (appt.statut == 'TERMINE')
                          ElevatedButton.icon(
                            onPressed: () => _showPaymentDialog(appt),
                            icon: const Icon(Icons.payment),
                            label: const Text('Paiement'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          ),
                        if (appt.statut == 'ANNULE')
                          const Chip(label: Text('Annulé'), backgroundColor: Colors.redAccent, labelStyle: TextStyle(color: Colors.white)),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _deleteAppointment(appt),
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          tooltip: 'Supprimer',
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentsList() {
    final completed = _appointments.where((a) => a.statut == 'TERMINE').toList();
    if (completed.isEmpty) {
      return const Center(child: Text('Aucune consultation terminée à facturer.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: completed.length,
      itemBuilder: (context, index) {
        final appt = completed[index];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.payment, color: Colors.white)),
            title: Text(appt.patientName ?? 'Patient'),
            subtitle: Text('RDV: ${appt.dateRdv.toString().substring(0, 10)}'),
            trailing: ElevatedButton.icon(
              onPressed: () => _showPaymentDialog(appt),
              icon: const Icon(Icons.add_card),
              label: const Text('Enregistrer'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ),
        );
      },
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'ATTENTE': return Icons.hourglass_empty;
      case 'CONFIRME': return Icons.event_available;
      case 'ARRIVE': return Icons.airline_seat_recline_normal;
      case 'TERMINE': return Icons.task_alt;
      case 'ANNULE': return Icons.cancel_outlined;
      default: return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ATTENTE': return Colors.orange;
      case 'CONFIRME': return Colors.blue;
      case 'ARRIVE': return Colors.teal;
      case 'TERMINE': return Colors.green;
      case 'ANNULE': return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  Widget _buildPatientsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12), 
      itemCount: _patients.length, 
      itemBuilder: (context, index) {
        final p = _patients[index];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(p.fullName), 
            subtitle: Text('CIN: ${p.cin ?? "N/A"} | Tel: ${p.phone ?? "N/A"}'),
          )
        );
      }
    );
  }
}
