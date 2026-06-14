import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../models/appointment_model.dart';
import '../../models/consultation_model.dart';
import '../../models/medicament_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/appointment_service.dart';
import '../../services/consultation_service.dart';
import '../../services/prescription_service.dart';
import '../../services/medicine_service.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final AppointmentService _appointmentService = AppointmentService();

  List<AppointmentModel> _waitingPatients = [];
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
      final appts = await _appointmentService.getAppointments();
      if (!mounted) return;
      setState(() {
        _waitingPatients = appts.where((a) => a.medecinId == doctorId && a.statut == 'ARRIVE').toList();
        _isLoading = false;
      });
    } catch (e) {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Espace Consultation'),
        actions: [
          IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh_rounded)),
          IconButton(
            onPressed: () => authProvider.logout(),
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(authProvider.user?.name ?? ""),
            const SizedBox(height: 24),
            Text('Salle d\'attente (${_waitingPatients.length})', 
                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _waitingPatients.isEmpty 
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _waitingPatients.length,
                      itemBuilder: (context, index) => _buildPatientCard(_waitingPatients[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String doctorName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryTeal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(Icons.medical_services, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ravi de vous revoir !', style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text('Dr. $doctorName', 
                     style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(AppointmentModel appt) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryTeal.withValues(alpha: 0.1),
          child: Text(appt.patientName?[0] ?? "P", style: const TextStyle(color: AppTheme.primaryTeal, fontWeight: FontWeight.bold)),
        ),
        title: Text(appt.patientName ?? "Patient", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Motif: ${appt.motif ?? "Diagnostic"}'),
            const SizedBox(height: 4),
            if (appt.isEmergency)
              const Text('🚑 URGENCE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _startConsultation(appt),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text('Consulter'),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Aucun patient en attente.', style: TextStyle(color: Colors.grey)),
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

  void _addMedication() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final instrController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un médicament'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom du médicament')),
            TextField(controller: dosageController, decoration: const InputDecoration(labelText: 'Dosage (ex: 1 tab 3x/j)')),
            TextField(controller: instrController, decoration: const InputDecoration(labelText: 'Instructions')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _meds.add({
                    'name': nameController.text,
                    'dosage': dosageController.text,
                    'instructions': instrController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitConsultation() async {
    if (_diagController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Le diagnostic est requis.')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      final doctorId = Provider.of<AuthProvider>(context, listen: false).user?.profileId;
      
      final consultation = await _consultationService.createConsultation(ConsultationModel(
        diagnostic: _diagController.text,
        notes: _notesController.text,
        rdvId: widget.appointment.id!,
        medecinId: doctorId!,
      ));

      if (_meds.isNotEmpty) {
        final prescription = await _prescriptionService.createOrdonnance(consultationId: consultation.id!);
        for (var med in _meds) {
          await _medicineService.createMedicament(MedicamentModel(
            ordonnanceId: prescription.id!,
            nomGenerique: med['name']!,
            dosage: med['dosage']!,
            instructions: med['instructions']!,
          ));
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Consultation: ${widget.appointment.patientName}', 
                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Diagnostic', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(controller: _diagController, maxLines: 2, decoration: const InputDecoration(hintText: 'Conclusion médicale...')),
                  const SizedBox(height: 20),
                  const Text('Observations / Notes', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(controller: _notesController, maxLines: 3, decoration: const InputDecoration(hintText: 'Notes complémentaires...')),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Prescription (Médicaments)', style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(onPressed: _addMedication, icon: const Icon(Icons.add_circle, color: AppTheme.primaryTeal)),
                    ],
                  ),
                  ..._meds.map((m) => Card(
                    child: ListTile(
                      title: Text(m['name']!),
                      subtitle: Text('${m['dosage']} - ${m['instructions']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => setState(() => _meds.remove(m)),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSaving ? null : _submitConsultation,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: _isSaving 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Finaliser la Consultation'),
          ),
        ],
      ),
    );
  }
}
