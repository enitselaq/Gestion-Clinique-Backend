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
  List<dynamic> _allUsers = [];
  String _searchQuery = '';

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
        _userService.getAllUsers(),
      ]);
      
      if (!mounted) return;
      setState(() {
        _patientCount = results[0].length;
        _doctorCount = results[1].length;
        _pendingRequests = (results[2] as List<AppointmentModel>)
            .where((a) => a.statut == 'ATTENTE').toList();
        _allUsers = results[3];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchUsers(String query) async {
    setState(() {
      _searchQuery = query;
      _isLoading = true;
    });
    try {
      if (query.isEmpty) {
        final users = await _userService.getAllUsers();
        if (!mounted) return;
        setState(() { _allUsers = users; _isLoading = false; });
      } else {
        final response = await _userService.searchUsers(query);
        if (!mounted) return;
        setState(() { _allUsers = response; _isLoading = false; });
      }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gestion des Utilisateurs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${_allUsers.length} comptes', style: TextStyle(color: AppTheme.mutedSlate, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: _searchUsers,
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom, rôle, email ou CIN...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                _buildUsersList(),
              ],
            ),
          ),
    );
  }

  Widget _buildUsersList() {
    final filtered = _searchQuery.isEmpty
        ? _allUsers
        : _allUsers.where((u) {
            final name = '${u['first_name'] ?? ''} ${u['last_name'] ?? ''}'.toLowerCase();
            final role = (u['role'] ?? '').toString().toLowerCase();
            final email = (u['email'] ?? '').toString().toLowerCase();
            final q = _searchQuery.toLowerCase();
            return name.contains(q) || role.contains(q) || email.contains(q);
          }).toList();

    if (filtered.isEmpty) {
      return const Card(child: ListTile(title: Text('Aucun utilisateur trouvé', style: TextStyle(color: Colors.grey))));
    }

    return Column(
      children: filtered.take(20).map((u) {
        final role = u['role'] ?? '';
        final roleColor = role == 'ADMIN' ? Colors.red
            : role == 'MEDECIN' ? AppTheme.primaryTeal
            : role == 'REC' ? Colors.indigo
            : Colors.blue;
        final roleLabel = role == 'ADMIN' ? 'Administrateur'
            : role == 'MEDECIN' ? 'Médecin'
            : role == 'REC' ? 'Réceptionniste'
            : 'Patient';
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: roleColor.withValues(alpha: 0.1),
              child: Icon(Icons.person, color: roleColor),
            ),
            title: Text('${u['first_name'] ?? ''} ${u['last_name'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('$roleLabel • ${u['email'] ?? ''}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(roleLabel, style: TextStyle(fontSize: 11, color: roleColor, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      }).toList(),
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
}
