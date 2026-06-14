import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../core/app_theme.dart';
import '../../models/appointment_model.dart';
import '../../models/consultation_model.dart';
import '../../models/paiement_model.dart';
import '../../models/prescription_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/appointment_service.dart';
import '../../services/consultation_service.dart';
import '../../services/payment_service.dart';
import '../../services/prescription_service.dart';
import '../../services/pdf_service.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final AppointmentService _appointmentService = AppointmentService();
  final ConsultationService _consultationService = ConsultationService();
  final PrescriptionService _prescriptionService = PrescriptionService();
  final PaymentService _paymentService = PaymentService();

  List<AppointmentModel> _appointments = [];
  List<ConsultationModel> _consultations = [];
  List<PrescriptionModel> _prescriptions = [];
  List<PaiementModel> _payments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final patientId = authProvider.user?.profileId;
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _appointmentService.getAppointments(),
        _consultationService.getConsultations(),
        _prescriptionService.getPrescriptions(),
        _paymentService.getPayments(),
      ]);
      if (!mounted) return;
      setState(() {
        final appts = results[0] as List<AppointmentModel>;
        _appointments = patientId != null ? appts.where((a) => a.patientId == patientId).toList() : appts;
        _consultations = (results[1] as List<ConsultationModel>).where((c) => _appointments.any((a) => a.id == c.rdvId)).toList();
        _prescriptions = (results[2] as List<PrescriptionModel>).where((o) => _consultations.any((c) => c.id == o.consultationId)).toList();
        _payments = (results[3] as List<PaiementModel>).where((p) => _appointments.any((a) => a.id == p.rdvId)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showDiagnosticRequestDialog() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final motifController = TextEditingController();
    bool needsAmbulance = false;
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Nouveau Diagnostic'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Veuillez décrire brièvement vos symptômes.', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 16),
                TextField(
                  controller: motifController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Symptômes', hintText: 'Ex: Fièvre, douleur abdominale...'),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Date souhaitée: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  trailing: const Icon(Icons.calendar_month, color: AppTheme.primaryTeal),
                  onTap: () async {
                    final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
                    if (date != null) setDialogState(() => selectedDate = date);
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Besoin d\'ambulance ?'),
                  subtitle: const Text('Urgences uniquement', style: TextStyle(fontSize: 11)),
                  value: needsAmbulance,
                  activeThumbColor: Colors.redAccent,
                  onChanged: (val) => setDialogState(() => needsAmbulance = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (motifController.text.isEmpty) return;
                try {
                  await _appointmentService.createAppointment(AppointmentModel(
                    dateRdv: selectedDate,
                    statut: 'ATTENTE',
                    patientId: authProvider.user!.profileId!,
                    motif: motifController.text,
                    isEmergency: needsAmbulance,
                  ));
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  _fetchData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Demande de diagnostic envoyée avec succès !'),
                      backgroundColor: AppTheme.primaryTeal,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } on DioException catch (e) {
                  if (!context.mounted) return;
                  final errorMsg = e.response?.data is Map ? e.response?.data['detail'] ?? e.message : e.message;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur Serveur (403): $errorMsg'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: $e'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Envoyer la demande'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bonjour, ${authProvider.user?.username ?? 'Patient'}', style: const TextStyle(fontSize: 14, color: AppTheme.mutedSlate)),
            const Text('Votre Espace Santé', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(onPressed: _fetchData, icon: const Icon(Icons.notifications_none_rounded)),
          IconButton(
            onPressed: () => authProvider.logout(),
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
                    const SizedBox(height: 24),
                    const Text('Raccourcis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildMenuCard('Rendez-vous', Icons.calendar_today_rounded, Colors.blue, _appointments.length, () => _showSection('Mes Rendez-vous', _buildAppointmentsList())),
                        _buildMenuCard('Diagnostics', Icons.description_rounded, Colors.teal, _consultations.length, () => _showSection('Mes Diagnostics', _buildConsultationsList())),
                        _buildMenuCard('Ordonnances', Icons.medication_rounded, Colors.orange, _prescriptions.length, () => _showSection('Mes Ordonnances', _buildPrescriptionsList())),
                        _buildMenuCard('Paiements', Icons.account_balance_wallet_rounded, Colors.red, _appointments.where((a) => a.statut == 'TERMINE').length, () => _showSection('Facturation', _buildPaymentsList())),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text('Dernière Activité', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildRecentActivity(),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showDiagnosticRequestDialog,
        icon: const Icon(Icons.add),
        label: const Text('Demander un Diagnostic'),
        backgroundColor: AppTheme.primaryTeal,
      ),
    );
  }

  Widget _buildStatusBanner() {
    if (_appointments.isEmpty) return const SizedBox.shrink();
    
    AppointmentModel activeAppt;
    try {
      activeAppt = _appointments.lastWhere(
        (a) => a.statut == 'CONFIRME' || a.statut == 'ATTENTE', 
        orElse: () => _appointments.first
      );
    } catch (e) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.primaryTeal, AppTheme.deepTeal]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.primaryTeal.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeAppt.statut == 'CONFIRME' ? 'RDV Confirmé' : 'Demande en cours',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Le ${activeAppt.dateRdv.toString().substring(0, 10)} ${activeAppt.medecinName != null ? "avec Dr. ${activeAppt.medecinName}" : ""}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                ),
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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('$count éléments', style: TextStyle(color: AppTheme.mutedSlate, fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showSection(String title, Widget content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: content,
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    if (_appointments.isEmpty) return const Center(child: Text('Aucun rendez-vous'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _appointments.length,
      itemBuilder: (context, index) {
        final a = _appointments[index];
        return Card(
          child: ListTile(
            leading: Icon(a.isEmergency ? Icons.emergency : Icons.event, color: a.isEmergency ? Colors.red : AppTheme.primaryTeal),
            title: Text(a.motif ?? 'Diagnostic'),
            subtitle: Text('Statut: ${a.statut}\nDate: ${a.dateRdv.toString().substring(0, 10)}'),
          ),
        );
      },
    );
  }

  Widget _buildConsultationsList() {
    if (_consultations.isEmpty) return const Center(child: Text('Aucun diagnostic disponible'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _consultations.length,
      itemBuilder: (context, index) {
        final c = _consultations[index];
        return Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.medical_information, color: Colors.teal),
                title: Text(c.diagnostic),
                subtitle: Text('Dr. ${c.medecinName ?? "Inconnu"} - ${c.dateConsult?.toString().substring(0, 10)}'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _downloadReport(c),
                      icon: const Icon(Icons.download),
                      label: const Text('Télécharger PDF'),
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

  Future<void> _downloadReport(ConsultationModel c) async {
    final pres = _prescriptions.where((p) => p.consultationId == c.id).firstOrNull;
    final path = await PdfService.exportFullDiagnostic(
      consultation: c,
      prescription: pres,
      patientName: c.patientName ?? "Patient",
      doctorName: c.medecinName ?? "Médecin",
    );
    if (path != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rapport téléchargé : $path')));
    }
  }

  Widget _buildPrescriptionsList() {
    if (_prescriptions.isEmpty) return const Center(child: Text('Aucune ordonnance'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _prescriptions.length,
      itemBuilder: (context, index) {
        final p = _prescriptions[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.medication, color: Colors.orange),
            title: Text('Ordonnance #${p.id}'),
            subtitle: Text('Médicaments: ${p.medicaments.length}'),
          ),
        );
      },
    );
  }

  Widget _buildPaymentsList() {
    final pending = _appointments.where((a) => a.statut == 'TERMINE' && !_payments.any((p) => p.rdvId == a.id)).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pending.isNotEmpty) ...[
          const Text('À régler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ...pending.map((a) => Card(
            color: Colors.red[50],
            child: ListTile(
              title: const Text('Consultation à payer'),
              subtitle: Text('Dr. ${a.medecinName} - 200 MAD'),
              trailing: ElevatedButton(onPressed: () {}, child: const Text('Payer')),
            ),
          )),
          const SizedBox(height: 20),
        ],
        const Text('Historique', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ..._payments.map((p) => Card(
          child: ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text('${p.montant} MAD'),
            subtitle: Text('Payé le ${p.datePaiement?.toString().substring(0, 10)}'),
          ),
        )),
      ],
    );
  }

  Widget _buildRecentActivity() {
    if (_appointments.isEmpty) return const Text('Aucune activité récente');
    final latest = _appointments.last;
    return Card(
      child: ListTile(
        leading: Icon(latest.statut == 'CONFIRME' ? Icons.check_circle : Icons.pending, color: latest.statut == 'CONFIRME' ? Colors.green : Colors.orange),
        title: Text(latest.motif ?? 'Demande de diagnostic'),
        subtitle: Text('Status: ${latest.statut}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
