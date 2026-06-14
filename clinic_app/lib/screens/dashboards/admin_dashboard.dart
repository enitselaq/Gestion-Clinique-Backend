import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../models/appointment_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/user_service.dart';
import '../../services/appointment_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final UserService _userService = UserService();
  final AppointmentService _appointmentService = AppointmentService();
  
  bool _isLoading = true;
  int _patientCount = 0;
  int _doctorCount = 0;
  List<AppointmentModel> _pendingRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _userService.getPatients(),
        _userService.getMedecins(),
        _appointmentService.getAppointments(),
      ]);
      
      if (!mounted) return;
      setState(() {
        _patientCount = (results[0] as List).length;
        _doctorCount = (results[1] as List).length;
        _pendingRequests = (results[2] as List<AppointmentModel>)
            .where((a) => a.statut == 'ATTENTE').toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Panneau d\'Administration'),
        actions: [
          IconButton(onPressed: _fetchStats, icon: const Icon(Icons.refresh_rounded)),
          IconButton(
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(),
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Statistiques Globales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  children: [
                    _buildStatSquare('Patients', _patientCount.toString(), Icons.people, Colors.blue),
                    _buildStatSquare('Médecins', _doctorCount.toString(), Icons.medical_services, AppTheme.primaryTeal),
                    _buildStatSquare('Demandes', _pendingRequests.length.toString(), Icons.pending_actions, Colors.orange),
                    _buildStatSquare('Urgences', _pendingRequests.where((a) => a.isEmergency).length.toString(), Icons.emergency, Colors.red),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Demandes Récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _pendingRequests.isEmpty 
                  ? const Card(child: ListTile(title: Text('Aucune demande en attente', style: TextStyle(color: Colors.grey))))
                  : Column(
                      children: _pendingRequests.take(5).map((appt) => Card(
                        child: ListTile(
                          leading: Icon(appt.isEmergency ? Icons.emergency : Icons.person, color: appt.isEmergency ? Colors.red : AppTheme.primaryTeal),
                          title: Text(appt.patientName ?? 'Patient'),
                          subtitle: Text(appt.motif ?? 'Demande de diagnostic'),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      )).toList(),
                    ),
                const SizedBox(height: 32),
                const Text('Gestion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildActionCard('Gérer le Personnel', Icons.badge_outlined),
                _buildActionCard('Paramètres de la Clinique', Icons.settings_applications_outlined),
              ],
            ),
          ),
    );
  }

  Widget _buildStatSquare(String title, String value, IconData icon, Color color) {
    return Container(
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
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(color: AppTheme.mutedSlate, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryTeal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}
