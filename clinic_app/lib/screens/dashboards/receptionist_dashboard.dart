import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/appointment_model.dart';
import '../../models/paiement_model.dart';
import '../../models/doctor_model.dart';
import '../../models/patient_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/appointment_service.dart';
import '../../services/payment_service.dart';
import '../../services/user_service.dart';
import '../../services/pdf_service.dart';
import '../../widgets/password_dialogs.dart';

class ReceptionistDashboard extends StatefulWidget {
  const ReceptionistDashboard({super.key});

  @override
  State<ReceptionistDashboard> createState() => _ReceptionistDashboardState();
}

class _ReceptionistDashboardState extends State<ReceptionistDashboard> {
  final AppointmentService _appointmentService = AppointmentService();
  final PaymentService _paymentService = PaymentService();
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();

  List<AppointmentModel> _appointments = [];
  List<PatientModel> _patients = [];
  List<DoctorModel> _doctors = [];
  List<PaiementModel> _payments = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final errors = <String>[];
    try {
      List<AppointmentModel> appointments = [];
      List<PatientModel> patients = [];
      List<DoctorModel> doctors = [];

      try {
        appointments = await _appointmentService.getAppointments();
      } catch (e) {
        errors.add('appointments');
      }

      try {
        patients = await _userService.getPatients();
      } catch (e) {
        errors.add('patients');
      }

      try {
        doctors = await _userService.getMedecins();
      } catch (e) {
        errors.add('doctors');
      }

      List<PaiementModel> payments = [];
      try {
        payments = await _paymentService.getPayments();
      } catch (e) {
        errors.add('payments');
      }

      if (!mounted) return;
      setState(() {
        _appointments = appointments;
        _patients = patients;
        _doctors = doctors;
        _payments = payments;
        _isLoading = false;
      });
      if (errors.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Some data could not be loaded: ${errors.join(', ')}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    }
  }

  List<AppointmentModel> get _filteredAppointments {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _appointments;
    return _appointments.where((appt) {
      final patientName = (appt.patientName ?? '').toLowerCase();
      final doctorName = (appt.medecinName ?? '').toLowerCase();
      final dateLabel = appt.dateRdv
          .toLocal()
          .toIso8601String()
          .split('T')[0]
          .toLowerCase();
      final status = appt.statut.toLowerCase();
      return patientName.contains(query) ||
          doctorName.contains(query) ||
          dateLabel.contains(query) ||
          status.contains(query);
    }).toList();
  }

  List<PatientModel> get _filteredPatients {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _patients;
    return _patients.where((patient) {
      final fullName = patient.fullName.toLowerCase();
      final cin = (patient.cin ?? '').toLowerCase();
      final birthDate =
          patient.dateNaissance
              ?.toIso8601String()
              .split('T')[0]
              .toLowerCase() ??
          '';
      return fullName.contains(query) ||
          cin.contains(query) ||
          birthDate.contains(query);
    }).toList();
  }

  Map<int, PaiementModel> get _paymentsByAppointmentId {
    return {
      for (final payment in _payments) payment.rdvId: payment,
    };
  }

  List<AppointmentModel> get _pendingPaymentAppointments {
    final paymentsByAppointmentId = _paymentsByAppointmentId;
    return _appointments.where((appt) {
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          (appt.patientName ?? '').toLowerCase().contains(query) ||
          (appt.medecinName ?? '').toLowerCase().contains(query) ||
          appt.dateRdv.toLocal().toIso8601String().split('T')[0].contains(query);
      return matchesSearch &&
          appt.id != null &&
          appt.statut == 'TERMINE' &&
          !paymentsByAppointmentId.containsKey(appt.id);
    }).toList();
  }

  List<PaiementModel> get _filteredPayments {
    final appointmentsById = {
      for (final appt in _appointments)
        if (appt.id != null) appt.id!: appt,
    };
    final query = _searchQuery.trim().toLowerCase();
    final filtered = _payments.where((payment) {
      if (query.isEmpty) return true;
      final appt = appointmentsById[payment.rdvId];
      return (appt?.patientName ?? '').toLowerCase().contains(query) ||
          (appt?.medecinName ?? '').toLowerCase().contains(query) ||
          payment.montant.toString().toLowerCase().contains(query);
    }).toList();
    filtered.sort((a, b) {
      final aDate = a.datePaiement ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.datePaiement ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return filtered;
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

  void _showPatientDetailsDialog(PatientModel patient) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(
            patient.fullName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(dialogContext, 'CIN', patient.cin ?? 'N/A'),
                        _infoRow(
                          dialogContext,
                          'Birth date',
                          patient.dateNaissance
                                  ?.toIso8601String()
                                  .split('T')[0] ??
                              'N/A',
                        ),
                        _infoRow(dialogContext, 'Sex', patient.sexe ?? 'N/A'),
                        _infoRow(
                          dialogContext,
                          'Age',
                          patient.age?.toString() ?? 'N/A',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    dialogContext,
                    title: 'Medical history',
                    value: patient.antecedents.trim().isEmpty
                        ? 'No history recorded'
                        : patient.antecedents,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoSection(
                    dialogContext,
                    title: 'Allergies',
                    value: patient.allergies.trim().isEmpty
                        ? 'No allergies recorded'
                        : patient.allergies,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextSpan(
              text: value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteAppointmentDialog(AppointmentModel appt) async {
    if (appt.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete appointment'),
        content: Text(
          'Delete the appointment of ${appt.patientName ?? 'this patient'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _appointmentService.deleteAppointment(appt.id!);
      if (!mounted) return;
      _fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment deleted successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete appointment: $e')),
      );
    }
  }

  void _showCreateOrEditAppointmentDialog({AppointmentModel? appointment}) {
    final isEditing = appointment != null;
    final formKey = GlobalKey<FormState>();
    int? patientId = appointment?.patientId;
    int? doctorId = appointment?.medecinId;
    DateTime selectedDate = (appointment?.dateRdv ?? DateTime.now()).toLocal();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(
      (appointment?.dateRdv ?? DateTime.now()).toLocal(),
    );
    String statut = appointment?.statut ?? 'ATTENTE';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Appointment' : 'New Appointment'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Patient'),
                      initialValue: patientId,
                      items: _patients
                          .map(
                            (p) => DropdownMenuItem<int>(
                              value: p.userId,
                              child: Text(p.fullName),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => patientId = v,
                      validator: (v) => v == null ? 'Required' : null,
                    ),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Doctor'),
                      initialValue: doctorId,
                      items: _doctors
                          .map(
                            (d) => DropdownMenuItem<int>(
                              value: d.userId,
                              child: Text(d.fullName),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => doctorId = v,
                      validator: (v) => v == null ? 'Required' : null,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Status'),
                      initialValue: statut,
                      items: const [
                        DropdownMenuItem(
                          value: 'ATTENTE',
                          child: Text('Waiting'),
                        ),
                        DropdownMenuItem(
                          value: 'CONFIRME',
                          child: Text('Confirmed'),
                        ),
                        DropdownMenuItem(
                          value: 'ANNULE',
                          child: Text('Cancelled'),
                        ),
                        DropdownMenuItem(
                          value: 'TERMINE',
                          child: Text('Completed'),
                        ),
                      ],
                      onChanged: (v) =>
                          setDialogState(() => statut = v ?? statut),
                    ),
                    ListTile(
                      title: Text(
                        'Date: ${selectedDate.toIso8601String().split('T')[0]}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) {
                          setDialogState(() => selectedDate = picked);
                        }
                      },
                    ),
                    ListTile(
                      title: Text('Time: ${selectedTime.format(context)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setDialogState(() => selectedTime = picked);
                        }
                      },
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
                if (formKey.currentState!.validate()) {
                  final dateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  try {
                    if (isEditing && appointment.id != null) {
                      await _appointmentService
                          .updateAppointment(appointment.id!, {
                            'patient': patientId!,
                            'medecin': doctorId,
                            'date_rdv': dateTime.toIso8601String(),
                            'statut': statut,
                          });
                    } else {
                      await _appointmentService.createAppointment(
                        AppointmentModel(
                          patientId: patientId!,
                          medecinId: doctorId,
                          dateRdv: dateTime,
                          statut: statut,
                        ),
                      );
                    }
                    if (!dialogContext.mounted) return;
                    Navigator.pop(dialogContext);
                    _fetchData();
                  } catch (e) {
                    if (!dialogContext.mounted) return;
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Failed to save appointment: $e')),
                    );
                  }
                }
              },
              child: Text(isEditing ? 'Save' : 'Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(AppointmentModel appt) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    final defaultAmount = 200.0;
    controller.text = defaultAmount.toStringAsFixed(2);
    double montant = defaultAmount;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Register Payment for ${appt.patientName}'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(dialogContext, 'Patient', appt.patientName ?? 'N/A'),
                _infoRow(
                  dialogContext,
                  'Doctor',
                  appt.medecinName != null ? 'Dr. ${appt.medecinName}' : 'N/A',
                ),
                _infoRow(
                  dialogContext,
                  'Appointment',
                  appt.dateRdv
                      .toLocal()
                      .toIso8601String()
                      .replaceFirst('T', ' ')
                      .substring(0, 16),
                ),
                _infoRow(dialogContext, 'Status', appt.statut),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: 'MAD ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (v) => montant = double.tryParse(v) ?? 0,
                  validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0
                      ? 'Invalid amount'
                      : null,
                ),
                const SizedBox(height: 8),
                const Text(
                  'This payment is recorded after the doctor completes the consultation.',
                ),
              ],
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
              if (!formKey.currentState!.validate() || appt.id == null) return;
              final payment = await _paymentService.createPayment(
                PaiementModel(rdvId: appt.id!, montant: montant),
              );
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);

              await PdfService.exportReceipt(
                payment: payment,
                patientName: appt.patientName ?? '',
              );
              _fetchData();
            },
            child: const Text('Pay & Complete'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    final appointments = _filteredAppointments;
    final paymentsByAppointmentId = _paymentsByAppointmentId;
    if (appointments.isEmpty) {
      return const Center(child: Text('No appointments found'));
    }

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appt = appointments[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              '${appt.patientName ?? 'Patient #${appt.patientId}'} - ${appt.medecinName != null ? 'Dr. ${appt.medecinName}' : 'No doctor'}',
            ),
            subtitle: Text(
              '${appt.dateRdv.toLocal().toIso8601String().replaceFirst('T', ' ').substring(0, 16)}\n'
              'Status: ${appt.statut} | Payment: ${appt.id != null && paymentsByAppointmentId.containsKey(appt.id) ? 'Paid' : 'Not paid'}',
            ),
            trailing: PopupMenuButton<_RdvAction>(
              onSelected: (action) async {
                if (appt.id == null) return;
                switch (action) {
                  case _RdvAction.edit:
                    _showCreateOrEditAppointmentDialog(appointment: appt);
                    return;
                  case _RdvAction.confirm:
                    await _appointmentService.updateAppointmentStatus(
                      appt.id!,
                      'CONFIRME',
                    );
                    _fetchData();
                    return;
                  case _RdvAction.cancel:
                    await _appointmentService.updateAppointmentStatus(
                      appt.id!,
                      'ANNULE',
                    );
                    _fetchData();
                    return;
                  case _RdvAction.delete:
                    _showDeleteAppointmentDialog(appt);
                    return;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: _RdvAction.edit,
                  child: Text('Edit'),
                ),
                if (appt.statut == 'ATTENTE')
                  const PopupMenuItem(
                    value: _RdvAction.confirm,
                    child: Text('Confirm'),
                  ),
                if (appt.statut != 'ANNULE' && appt.statut != 'TERMINE')
                  const PopupMenuItem(
                    value: _RdvAction.cancel,
                    child: Text('Cancel'),
                  ),
                const PopupMenuItem(
                  value: _RdvAction.delete,
                  child: Text('Delete'),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildPatientsTab() {
    final patients = _filteredPatients;
    if (patients.isEmpty) {
      return const Center(child: Text('No patients found'));
    }

    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text(patient.fullName),
            subtitle: Text(
              'CIN: ${patient.cin ?? 'N/A'}\n'
              'Birth date: ${patient.dateNaissance != null ? patient.dateNaissance!.toIso8601String().split('T')[0] : 'N/A'} - '
              'Sex: ${patient.sexe ?? 'N/A'} - Age: ${patient.age ?? 'N/A'}',
            ),
            onTap: () => _showPatientDetailsDialog(patient),
            trailing: const Icon(Icons.chevron_right),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildPaymentsTab() {
    final pendingAppointments = _pendingPaymentAppointments;
    final payments = _filteredPayments;
    final appointmentsById = {
      for (final appt in _appointments)
        if (appt.id != null) appt.id!: appt,
    };

    if (pendingAppointments.isEmpty && payments.isEmpty) {
      return const Center(child: Text('No payment data found'));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'Pending payments',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        if (pendingAppointments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('No completed appointments waiting for payment'),
          ),
        ...pendingAppointments.map((appt) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.payments_outlined)),
              title: Text(appt.patientName ?? 'Patient #${appt.patientId}'),
              subtitle: Text(
                '${appt.medecinName != null ? 'Dr. ${appt.medecinName}' : 'No doctor'}\n'
                '${appt.dateRdv.toLocal().toIso8601String().replaceFirst('T', ' ').substring(0, 16)}',
              ),
              trailing: ElevatedButton(
                onPressed: () => _showPaymentDialog(appt),
                child: const Text('Pay'),
              ),
              isThreeLine: true,
            ),
          );
        }),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            'Payment history',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        if (payments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('No payments recorded yet'),
          ),
        ...payments.map((payment) {
          final appt = appointmentsById[payment.rdvId];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
              title: Text(appt?.patientName ?? 'Appointment #${payment.rdvId}'),
              subtitle: Text(
                'Amount: MAD ${payment.montant.toStringAsFixed(2)}\n'
                'Paid on: ${payment.datePaiement?.toLocal().toIso8601String().replaceFirst('T', ' ').substring(0, 16) ?? 'N/A'}',
              ),
              isThreeLine: true,
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Receptionist Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Appointments'),
              Tab(text: 'Patients'),
              Tab(text: 'Payments'),
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search patients, appointments or dates',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      children: [
                        _buildAppointmentsTab(),
                        _buildPatientsTab(),
                        _buildPaymentsTab(),
                      ],
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCreateOrEditAppointmentDialog(),
          icon: const Icon(Icons.add),
          label: const Text('New Appointment'),
        ),
      ),
    );
  }
}

enum _RdvAction { edit, confirm, cancel, delete }
