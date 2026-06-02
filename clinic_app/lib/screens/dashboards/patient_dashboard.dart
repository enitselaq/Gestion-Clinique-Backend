import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
import '../../widgets/password_dialogs.dart';

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

  static const double _defaultConsultationFee = 200.0;

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
        final consults = results[1] as List<ConsultationModel>;
        final ords = results[2] as List<PrescriptionModel>;
        final pays = results[3] as List<PaiementModel>;

        _appointments = patientId != null
            ? appts.where((a) => a.patientId == patientId).toList()
            : appts;
        _consultations = consults
            .where((c) => _appointments.any((a) => a.id == c.rdvId))
            .toList();
        _prescriptions = ords
            .where((o) => _consultations.any((c) => c.id == o.consultationId))
            .toList();
        _payments = pays
            .where((p) => _appointments.any((a) => a.id == p.rdvId))
            .toList();
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

  Map<int, PaiementModel> get _paymentsByAppointmentId {
    return {
      for (final payment in _payments) payment.rdvId: payment,
    };
  }

  List<AppointmentModel> get _pendingOnlinePayments {
    final paymentsByAppointmentId = _paymentsByAppointmentId;
    return _appointments.where((appointment) {
      return appointment.id != null &&
          appointment.statut == 'TERMINE' &&
          !paymentsByAppointmentId.containsKey(appointment.id);
    }).toList();
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

  Future<void> _showOnlinePaymentDialog(AppointmentModel appointment) async {
    if (appointment.id == null) return;
    final formKey = GlobalKey<FormState>();
    final cardHolderController = TextEditingController();
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final amountController = TextEditingController(
      text: _defaultConsultationFee.toStringAsFixed(2),
    );
    bool showCardNumber = false;
    bool showCvv = false;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Online Payment${appointment.medecinName != null ? ' - Dr. ${appointment.medecinName}' : ''}',
          ),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Simulated card payment for the patient portal.',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: cardHolderController,
                      decoration: const InputDecoration(
                        labelText: 'Cardholder name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: cardNumberController,
                      obscureText: !showCardNumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Card number',
                        prefixIcon: const Icon(Icons.credit_card),
                        suffixIcon: IconButton(
                          onPressed: () => setDialogState(
                            () => showCardNumber = !showCardNumber,
                          ),
                          icon: Icon(
                            showCardNumber
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      validator: (value) {
                        final normalized =
                            (value ?? '').replaceAll(RegExp(r'\s+'), '');
                        if (normalized.length < 12 || normalized.length > 19) {
                          return 'Invalid card number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: expiryController,
                            decoration: const InputDecoration(
                              labelText: 'Expiry (MM/YY)',
                              prefixIcon: Icon(Icons.date_range_outlined),
                            ),
                            validator: (value) {
                              if (!RegExp(
                                r'^\d{2}/\d{2}$',
                              ).hasMatch(value ?? '')) {
                                return 'Invalid expiry';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: cvvController,
                            obscureText: !showCvv,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setDialogState(() => showCvv = !showCvv),
                                icon: Icon(
                                  showCvv
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (!RegExp(r'^\d{3,4}$').hasMatch(value ?? '')) {
                                return 'Invalid CVV';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: 'MAD ',
                      ),
                      validator: (value) =>
                          (double.tryParse(value ?? '') ?? 0) <= 0
                          ? 'Invalid amount'
                          : null,
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
                  final payment = await _paymentService.createPayment(
                    PaiementModel(
                      rdvId: appointment.id!,
                      montant: double.parse(amountController.text),
                    ),
                  );
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  if (!mounted) return;
                  final authProvider = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  final messenger = ScaffoldMessenger.of(context);
                  final savedPath = await PdfService.exportReceipt(
                    payment: payment,
                    patientName: authProvider.user?.name ?? '',
                  );
                  await _fetchData();
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        savedPath == null
                            ? 'Payment completed successfully'
                            : 'Payment completed. Receipt downloaded.',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Payment failed: $e')),
                  );
                }
              },
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportPrescriptionPdf(
    PrescriptionModel ordonnance,
    String patientName,
    String doctorName,
  ) async {
    final savedPath = await PdfService.exportPrescription(
      ordonnance: ordonnance,
      patientName: patientName,
      doctorName: doctorName,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          savedPath == null
              ? 'Prescription PDF generated'
              : 'Prescription PDF downloaded',
        ),
      ),
    );
  }

  Future<void> _exportReceiptPdf(
    PaiementModel payment,
    String patientName,
  ) async {
    final savedPath = await PdfService.exportReceipt(
      payment: payment,
      patientName: patientName,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          savedPath == null ? 'Receipt PDF generated' : 'Receipt PDF downloaded',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final patientName = authProvider.user?.name ?? '';

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Health Portal'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Appointments'),
              Tab(text: 'Consultations'),
              Tab(text: 'Prescriptions'),
              Tab(text: 'Pay Online'),
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildList(
                    _appointments,
                    (appt) => ListTile(
                      title: Text(
                        appt.medecinName != null
                            ? 'Dr. ${appt.medecinName}'
                            : 'Appointment',
                      ),
                      subtitle: Text(
                        '${appt.dateRdv.toIso8601String().replaceFirst('T', ' ').substring(0, 16)}\nStatus: ${appt.statut}',
                      ),
                    ),
                  ),
                  _buildList(
                    _consultations,
                    (c) => ListTile(
                      title: Text('Diagnostic: ${c.diagnostic}'),
                      subtitle: Text(
                        'Date: ${c.dateConsult != null ? c.dateConsult!.toIso8601String().split('T')[0] : 'N/A'}\nNotes: ${c.notes}',
                      ),
                    ),
                  ),
                  _buildList(_prescriptions, (o) {
                    final consult = _consultations
                        .where((c) => c.id == o.consultationId)
                        .firstOrNull;
                    final doctorName = consult?.medecinName ?? '';
                    return ListTile(
                      title: Text('Ordonnance #${o.id ?? ''}'),
                      subtitle: Text(
                        'Date: ${o.dateCreation != null ? o.dateCreation!.toIso8601String().split('T')[0] : 'N/A'}\nMedicines: ${o.medicaments.length}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.picture_as_pdf),
                        onPressed: () => _exportPrescriptionPdf(
                          o,
                          patientName,
                          doctorName,
                        ),
                      ),
                    );
                  }),
                  _buildPendingPaymentsTab(),
                  _buildList(
                    _payments,
                    (pay) => ListTile(
                      title: Text('Amount: ${pay.montant} MAD'),
                      subtitle: Text(
                        'Date: ${pay.datePaiement != null ? pay.datePaiement!.toIso8601String().split('T')[0] : 'N/A'}\nRDV: #${pay.rdvId}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.receipt_long),
                        onPressed: () => _exportReceiptPdf(pay, patientName),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildList(List<dynamic> items, Widget Function(dynamic) itemBuilder) {
    if (items.isEmpty) return const Center(child: Text('No records found'));
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.all(8),
        child: itemBuilder(items[index]),
      ),
    );
  }

  Widget _buildPendingPaymentsTab() {
    final pendingPayments = _pendingOnlinePayments;
    if (pendingPayments.isEmpty) {
      return const Center(
        child: Text('No completed appointments waiting for online payment'),
      );
    }

    return ListView.builder(
      itemCount: pendingPayments.length,
      itemBuilder: (context, index) {
        final appointment = pendingPayments[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.account_balance_wallet_outlined),
            ),
            title: Text(
              appointment.medecinName != null
                  ? 'Consultation with Dr. ${appointment.medecinName}'
                  : 'Completed consultation',
            ),
            subtitle: Text(
              '${appointment.dateRdv.toIso8601String().replaceFirst('T', ' ').substring(0, 16)}\nAmount due: ${_defaultConsultationFee.toStringAsFixed(2)} MAD',
            ),
            trailing: ElevatedButton(
              onPressed: () => _showOnlinePaymentDialog(appointment),
              child: const Text('Pay'),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

extension _FirstOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
