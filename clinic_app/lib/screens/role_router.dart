import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboards/admin_dashboard.dart';
import 'dashboards/doctor_dashboard.dart';
import 'dashboards/receptionist_dashboard.dart';
import 'dashboards/patient_dashboard.dart';

class RoleRouter extends StatelessWidget {
  const RoleRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user logged in')),
      );
    }

    // Normalize role string to handle case sensitivity issues
    final role = user.role.toUpperCase().trim();

    switch (role) {
      case 'ADMIN':
        return const AdminDashboard();
      case 'MEDECIN':
        return const DoctorDashboard();
      case 'REC':
        return const ReceptionistDashboard();
      case 'PATIENT':
        return const PatientDashboard();
      default:
        return Scaffold(
          appBar: AppBar(
            title: const Text('Access Error'),
            actions: [
              IconButton(
                onPressed: () => authProvider.logout(),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Unknown role detected: "$role"', 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Please contact the system administrator.'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => authProvider.logout(),
                  child: const Text('Return to Login'),
                ),
              ],
            ),
          ),
        );
    }
  }
}
