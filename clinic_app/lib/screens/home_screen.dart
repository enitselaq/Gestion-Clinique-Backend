import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinic Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await authProvider.logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.name.isNotEmpty == true ? user!.name : 'Authenticated user',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text('Role: ${user?.role ?? 'Unknown'}'),
            const SizedBox(height: 8),
            Text('Email: ${user?.email.isNotEmpty == true ? user!.email : 'Not provided'}'),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Login now routes into the app correctly. Build the next patient, appointment, and consultation screens from here.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
