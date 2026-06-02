import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/appointment_model.dart';
import '../../models/consultation_model.dart';
import '../../models/medicament_model.dart';
import '../../models/patient_model.dart';
import '../../models/prescription_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/appointment_service.dart';
import '../../services/consultation_service.dart';
import '../../services/user_service.dart';
import '../../services/prescription_service.dart';
import '../../services/medicine_service.dart';
import '../../services/pdf_service.dart';
import '../../widgets/password_dialogs.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final AppointmentService _appointmentService = AppointmentService();
  final ConsultationService _consultationService = ConsultationService();
  final PrescriptionService _prescriptionService = PrescriptionService();
  final MedicineService _medicineService = MedicineService();
  final UserService _userService = UserService();

  List<AppointmentModel> _myAppointments = [];
  List<ConsultationModel> _consultations = [];
  List<PrescriptionModel> _prescriptions = [];
  Map<int, PatientModel> _patientsById = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final doctorId = authProvider.user?.profileId;

    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _appointmentService.getAppointments(),
        _consultationService.getConsultations(),
        _prescriptionService.getPrescriptions(),
        _userService.getPatients(),
      ]);

      if (!mounted) return;

      final appointments = results[0] as List<AppointmentModel>;
      final consultations = results[1] as List<ConsultationModel>;
      final prescriptions = results[2] as List<PrescriptionModel>;
      final patients = results[3] as List<PatientModel>;
      final visibleAppointments = doctorId != null
          ? appointments.where((a) => a.medecinId == doctorId).toList()
          : appointments;
      final consultationIds = consultations
          .map((c) => c.id)
          .whereType<int>()
          .toSet();

      setState(() {
        _myAppointments = visibleAppointments;
        _consultations = consultations;
        _prescriptions = prescriptions
            .where((p) => consultationIds.contains(p.consultationId))
            .toList();
        _patientsById = {
          for (final patient in patients) patient.userId: patient,
        };
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showConsultationDialog(AppointmentModel appt) {
    final formKey = GlobalKey<FormState>();
    String diagnostic = '';
    String notes = '';
    final drafts = <_MedicineDraft>[_MedicineDraft()];
    final patient = _patientsById[appt.patientId];

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Consultation: ${appt.patientName}'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (patient != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Age: ${patient.age ?? 'N/A'} | Sex: ${patient.sexe ?? 'N/A'} | CIN: ${patient.cin ?? 'N/A'}',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'History: ${patient.antecedents.trim().isEmpty ? 'None recorded' : patient.antecedents}',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Allergies: ${patient.allergies.trim().isEmpty ? 'None recorded' : patient.allergies}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Diagnostic',
                      ),
                      maxLines: 3,
                      onChanged: (v) => diagnostic = v,
                      validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Notes'),
                      maxLines: 3,
                      onChanged: (v) => notes = v,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Expanded(child: Text('Prescription (Medicines)')),
                        TextButton.icon(
                          onPressed: () => setDialogState(
                            () => drafts.add(_MedicineDraft()),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                    ...drafts.asMap().entries.map((entry) {
                      final index = entry.key;
                      final draft = entry.value;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Medicine ${index + 1}'),
                                  const Spacer(),
                                  if (drafts.length > 1)
                                    IconButton(
                                      onPressed: () => setDialogState(
                                        () => drafts.removeAt(index),
                                      ),
                                      icon: const Icon(Icons.close),
                                      tooltip: 'Remove',
                                    ),
                                ],
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Generic name',
                                ),
                                onChanged: (v) => draft.nomGenerique = v,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Dosage',
                                ),
                                onChanged: (v) => draft.dosage = v,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Instructions',
                                ),
                                onChanged: (v) => draft.instructions = v,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  final authProvider = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  final doctorPk =
                      authProvider.user?.profileId ?? appt.medecinId;
                  if (doctorPk == null || appt.id == null) {
                    throw Exception(
                      'Missing doctor or appointment identifier.',
                    );
                  }

                  final consult = ConsultationModel(
                    diagnostic: diagnostic.trim(),
                    notes: notes.trim(),
                    rdvId: appt.id!,
                    medecinId: doctorPk,
                  );
                  final savedConsult = await _consultationService
                      .createConsultation(consult);

                  final medDrafts = drafts
                      .where(
                        (d) =>
                            d.nomGenerique.trim().isNotEmpty ||
                            d.dosage.trim().isNotEmpty ||
                            d.instructions.trim().isNotEmpty,
                      )
                      .toList();
                  if (medDrafts.isNotEmpty) {
                    final ordonnance = await _prescriptionService
                        .createOrdonnance(consultationId: savedConsult.id!);
                    final ordonnanceId = ordonnance.id;
                    if (ordonnanceId == null) {
                      throw Exception(
                        'Ordonnance id missing from server response.',
                      );
                    }
                    for (final d in medDrafts) {
                      await _medicineService.createMedicament(
                        MedicamentModel(
                          ordonnanceId: ordonnanceId,
                          nomGenerique: d.nomGenerique.trim(),
                          dosage: d.dosage.trim(),
                          instructions: d.instructions.trim(),
                        ),
                      );
                    }
                  }

                  await _appointmentService.updateAppointmentStatus(
                    appt.id!,
                    'TERMINE',
                  );

                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  _fetchData();
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Error saving consultation: $e')),
                  );
                }
              },
              child: const Text('Save & Complete'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditConsultationDialog(ConsultationModel consultation) {
    if (consultation.id == null) return;
    final formKey = GlobalKey<FormState>();
    String diagnostic = consultation.diagnostic;
    String notes = consultation.notes;
    final relatedAppointment = _myAppointments
        .where((appt) => appt.id == consultation.rdvId)
        .firstOrNull;
    final patient = relatedAppointment != null
        ? _patientsById[relatedAppointment.patientId]
        : null;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit Consultation: ${consultation.patientName ?? 'Patient'}'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (patient != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Age: ${patient.age ?? 'N/A'} | Sex: ${patient.sexe ?? 'N/A'} | CIN: ${patient.cin ?? 'N/A'}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      initialValue: diagnostic,
                      decoration: const InputDecoration(
                        labelText: 'Diagnostic',
                      ),
                      maxLines: 3,
                      onChanged: (v) => diagnostic = v,
                      validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: notes,
                      decoration: const InputDecoration(labelText: 'Notes'),
                      maxLines: 4,
                      onChanged: (v) => notes = v,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  await _consultationService.updateConsultation(
                    consultation.id!,
                    {
                      'diagnostic': diagnostic.trim(),
                      'notes': notes.trim(),
                    },
                  );
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  _fetchData();
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Error updating consultation: $e')),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    if (_myAppointments.isEmpty) {
      return const Center(child: Text('No appointments assigned'));
    }

    return ListView.builder(
      itemCount: _myAppointments.length,
      itemBuilder: (context, index) {
        final appt = _myAppointments[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(appt.patientName ?? 'Patient #${appt.patientId}'),
            subtitle: Text(
              '${appt.dateRdv.toLocal().toIso8601String().replaceFirst('T', ' ').substring(0, 16)}\nStatus: ${appt.statut}',
            ),
            trailing: appt.statut != 'TERMINE' && appt.statut != 'ANNULE'
                ? (appt.statut == 'CONFIRME'
                    ? ElevatedButton(
                        onPressed: () => _showConsultationDialog(appt),
                        child: const Text('Consult'),
                      )
                    : const Tooltip(
                        message: 'Appointment must be confirmed first',
                        child: Icon(Icons.hourglass_top, color: Colors.orange),
                      ))
                : const Icon(Icons.done_all, color: Colors.blue),
          ),
        );
      },
    );
  }

  Widget _buildConsultationsTab() {
    if (_consultations.isEmpty) {
      return const Center(child: Text('No consultation history yet'));
    }

    return ListView.builder(
      itemCount: _consultations.length,
      itemBuilder: (context, index) {
        final consult = _consultations[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.medical_information_outlined),
            ),
            title: Text(consult.patientName ?? 'Patient'),
            subtitle: Text(
              'Diagnostic: ${consult.diagnostic}\n'
              'Date: ${consult.dateConsult != null ? consult.dateConsult!.toIso8601String().split('T')[0] : 'N/A'}\n'
              'Notes: ${consult.notes.isEmpty ? 'No notes' : consult.notes}',
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit consultation',
              onPressed: () => _showEditConsultationDialog(consult),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrescriptionsTab() {
    if (_prescriptions.isEmpty) {
      return const Center(child: Text('No ordonnance history yet'));
    }

    return ListView.builder(
      itemCount: _prescriptions.length,
      itemBuilder: (context, index) {
        final ordonnance = _prescriptions[index];
        final consultation = _consultations
            .where((c) => c.id == ordonnance.consultationId)
            .firstOrNull;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
            title: Text('Ordonnance #${ordonnance.id ?? ''}'),
            subtitle: Text(
              'Patient: ${consultation?.patientName ?? 'N/A'}\n'
              'Date: ${ordonnance.dateCreation != null ? ordonnance.dateCreation!.toIso8601String().split('T')[0] : 'N/A'}\n'
              'Medicines: ${ordonnance.medicaments.length}',
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () => PdfService.exportPrescription(
                ordonnance: ordonnance,
                patientName: consultation?.patientName ?? '',
                doctorName: consultation?.medecinName ?? '',
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Doctor Dashboard'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Appointments'),
              Tab(text: 'Consultations'),
              Tab(text: 'Ordonnances'),
            ],
          ),
          actions: [
            IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh)),
            IconButton(
              onPressed: () => showChangePasswordDialog(context),
              icon: const Icon(Icons.lock_reset),
              tooltip: 'Change password',
            ),
            IconButton(
              onPressed: () => _showLogoutConfirmation(context),
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildAppointmentsTab(),
                  _buildConsultationsTab(),
                  _buildPrescriptionsTab(),
                ],
              ),
      ),
    );
  }
}

class _MedicineDraft {
  String nomGenerique = '';
  String dosage = '';
  String instructions = '';
}

extension _FirstOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
