import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../models/appointment_model.dart';
import '../../models/consultation_model.dart';
import '../../models/medicament_model.dart';
import '../../models/patient_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/appointment_service.dart';
import '../../services/consultation_service.dart';
import '../../services/medicine_service.dart';
import '../../services/prescription_service.dart';
import '../../services/user_service.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final AppointmentService _appointmentService = AppointmentService();
  final ConsultationService _consultationService = ConsultationService();
  final UserService _userService = UserService();

  List<AppointmentModel> _assignedAppointments = [];
  List<AppointmentModel> _patientQueue = [];
  List<ConsultationModel> _consultations = [];
  List<PatientModel> _patients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final doctorId = Provider.of<AuthProvider>(context, listen: false).user?.profileId;
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _appointmentService.getAppointments(),
        _consultationService.getConsultations(),
        _userService.getPatients(),
      ]);
      if (!mounted) return;
      final appts = results[0] as List<AppointmentModel>;
      final consultations = results[1] as List<ConsultationModel>;
      final patients = results[2] as List<PatientModel>;
      setState(() {
        _assignedAppointments = appts
            .where((a) => a.medecinId == doctorId && (a.statut == 'CONFIRME' || a.statut == 'ARRIVE'))
            .toList();
        _consultations = consultations.where((c) => c.medecinId == doctorId).toList();
        _patients = patients.where((p) => _assignedAppointments.any((a) => a.patientId == p.userId)).toList();
        final grouped = <int, AppointmentModel>{};
        for (final appt in _assignedAppointments) {
          final current = grouped[appt.patientId];
          if (current == null || appt.dateRdv.isAfter(current.dateRdv)) {
            grouped[appt.patientId] = appt;
          }
        }
        _patientQueue = grouped.values.toList()
          ..sort((a, b) => b.dateRdv.compareTo(a.dateRdv));
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading doctor dashboard: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _startConsultation(AppointmentModel appt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ConsultationForm(
        appointment: appt,
        onComplete: () {
          _fetchData();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final waitingCount = _assignedAppointments.where((a) => a.statut == 'ARRIVE').length;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Espace Medecin'),
              Text(
                authProvider.user?.name ?? 'Service de consultation',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Patients'),
              Tab(text: 'Diagnostics'),
            ],
          ),
          actions: [
            IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh_rounded)),
            IconButton(
              onPressed: () => authProvider.logout(),
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    _buildHeroCard(authProvider.user?.name ?? ''),
                    const SizedBox(height: 16),
                    _buildMetrics(waitingCount),
                    const SizedBox(height: 18),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildAppointmentsTab(),
                          _buildConsultationsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeroCard(String doctorName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primaryTeal,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Icon(Icons.medical_services_outlined, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bienvenue au service de consultation', style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text(
                  doctorName.isEmpty ? 'Medecin' : doctorName,
                  style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_patientQueue.length} patients assignes, ${_consultations.length} diagnostics disponibles',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics(int waitingCount) {
    return Row(
      children: [
        Expanded(child: _metricCard('Patients', _patientQueue.length, Icons.assignment_ind, AppTheme.primaryTeal)),
        const SizedBox(width: 12),
        Expanded(child: _metricCard('En attente', waitingCount, Icons.hourglass_bottom, Colors.orange)),
        const SizedBox(width: 12),
        Expanded(child: _metricCard('Termines', _consultations.length, Icons.task_alt, Colors.green)),
      ],
    );
  }

  Widget _metricCard(String label, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.mutedSlate)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    if (_patientQueue.isEmpty) {
      return _buildEmptyState('Aucun patient assigne pour le moment.');
    }
    return ListView.builder(
      itemCount: _patientQueue.length,
      itemBuilder: (context, index) => _buildAppointmentCard(_patientQueue[index]),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appt) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => _showPatientDetails(appt),
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: appt.isEmergency ? Colors.red.withValues(alpha: 0.1) : AppTheme.primaryTeal.withValues(alpha: 0.1),
          child: Icon(appt.isEmergency ? Icons.emergency : Icons.person, color: appt.isEmergency ? Colors.red : AppTheme.primaryTeal),
        ),
        title: Text(appt.patientName ?? 'Patient', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statut: ${appt.statut}'),
              Text('Date: ${appt.dateRdv.toString().substring(0, 10)}'),
              Text('Motif: ${appt.motif ?? "Diagnostic"}'),
              if (appt.isEmergency) const Text('URGENCE / AMBULANCE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  void _showPatientDetails(AppointmentModel appt) {
    final patientMatches = _patients.where((p) => p.userId == appt.patientId).toList();
    final patient = patientMatches.isNotEmpty ? patientMatches.first : null;
    final patientAppointments = _assignedAppointments.where((a) => a.patientId == appt.patientId).toList();
    final patientConsultations = _consultations.where((c) => patientAppointments.any((a) => a.id == c.rdvId)).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appt.patientName ?? 'Patient',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Motif: ${appt.motif ?? "Diagnostic"}', style: const TextStyle(color: AppTheme.mutedSlate)),
            const SizedBox(height: 18),
            _detailLine('CIN', patient?.cin ?? 'N/A'),
            _detailLine('Telephone', patient?.phone ?? 'N/A'),
            _detailLine('Sexe', patient?.sexe ?? 'N/A'),
            _detailLine('Age', patient?.age?.toString() ?? 'N/A'),
            _detailLine('Statut', appt.statut),
            _detailLine('Date demandee', appt.dateRdv.toString().substring(0, 10)),
            _detailLine('Demandes', patientAppointments.length.toString()),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (appt.statut == 'CONFIRME' || appt.statut == 'ARRIVE') ? () => _startConsultation(appt) : null,
                    icon: const Icon(Icons.medical_information_outlined),
                    label: const Text('Creer consultation'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text('Consultations recentes', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: patientConsultations.isEmpty
                  ? const Center(child: Text('Aucune consultation pour ce rendez-vous.'))
                  : ListView.builder(
                      itemCount: patientConsultations.length,
                      itemBuilder: (context, index) {
                        final c = patientConsultations[index];
                        return Card(
                          child: ListTile(
                            title: Text(c.diagnostic),
                            subtitle: Text(c.dateConsult?.toString().substring(0, 10) ?? ''),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildConsultationsTab() {
    if (_consultations.isEmpty) {
      return _buildEmptyState('Aucun diagnostic cree.');
    }
    return ListView.builder(
      itemCount: _consultations.length,
      itemBuilder: (context, index) {
        final c = _consultations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.description_outlined)),
            title: Text(c.patientName ?? 'Patient'),
            subtitle: Text('${c.diagnostic}\n${c.dateConsult?.toString().substring(0, 10) ?? ''}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ConsultationForm extends StatefulWidget {
  final AppointmentModel appointment;
  final VoidCallback onComplete;

  const _ConsultationForm({required this.appointment, required this.onComplete});

  @override
  State<_ConsultationForm> createState() => _ConsultationFormState();
}

class _ConsultationFormState extends State<_ConsultationForm> {
  final _diagController = TextEditingController();
  final _notesController = TextEditingController();
  final List<Map<String, String>> _meds = [];
  bool _isSaving = false;

  final ConsultationService _consultationService = ConsultationService();
  final PrescriptionService _prescriptionService = PrescriptionService();
  final MedicineService _medicineService = MedicineService();
  final AppointmentService _appointmentService = AppointmentService();

  @override
  void dispose() {
    _diagController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addMedication() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final instrController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un medicament'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom du medicament')),
            TextField(controller: dosageController, decoration: const InputDecoration(labelText: 'Dosage')),
            TextField(controller: instrController, decoration: const InputDecoration(labelText: 'Instructions')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              setState(() {
                _meds.add({
                  'name': nameController.text.trim(),
                  'dosage': dosageController.text.trim(),
                  'instructions': instrController.text.trim(),
                });
              });
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitConsultation() async {
    if (_diagController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Le diagnostic est requis.')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      final doctorId = Provider.of<AuthProvider>(context, listen: false).user?.profileId;
      final consultation = await _consultationService.createConsultation(
        ConsultationModel(
          diagnostic: _diagController.text.trim(),
          notes: _notesController.text.trim(),
          rdvId: widget.appointment.id!,
          medecinId: doctorId!,
        ),
      );

      if (_meds.isNotEmpty) {
        final prescription = await _prescriptionService.createOrdonnance(consultationId: consultation.id!);
        for (final med in _meds) {
          await _medicineService.createMedicament(
            MedicamentModel(
              ordonnanceId: prescription.id!,
              nomGenerique: med['name']!,
              dosage: med['dosage']!,
              instructions: med['instructions']!,
            ),
          );
        }
      }

      await _appointmentService.updateAppointmentStatus(widget.appointment.id!, 'TERMINE');
      widget.onComplete();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Consultation - ${widget.appointment.patientName ?? "Patient"}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          Text('Motif: ${widget.appointment.motif ?? "Diagnostic"}', style: const TextStyle(color: AppTheme.mutedSlate)),
          const Divider(height: 28),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Diagnostic', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(controller: _diagController, maxLines: 3, decoration: const InputDecoration(hintText: 'Conclusion medicale')),
                  const SizedBox(height: 18),
                  const Text('Observations / notes', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(controller: _notesController, maxLines: 4, decoration: const InputDecoration(hintText: 'Notes complementaires')),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ordonnance', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextButton.icon(onPressed: _addMedication, icon: const Icon(Icons.add), label: const Text('Medicament')),
                    ],
                  ),
                  ..._meds.map(
                    (m) => Card(
                      child: ListTile(
                        title: Text(m['name']!),
                        subtitle: Text('${m['dosage']} - ${m['instructions']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => setState(() => _meds.remove(m)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _submitConsultation,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isSaving
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Finaliser la consultation'),
            ),
          ),
        ],
      ),
    );
  }
}
