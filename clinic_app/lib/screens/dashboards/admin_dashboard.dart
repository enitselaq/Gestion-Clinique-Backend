import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/user_service.dart';
import '../../widgets/password_dialogs.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _users = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await _userService.getAllUsers();
      if (!mounted) return;
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching users: $e')));
    }
  }

  List<dynamic> get _filteredUsers {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _users;
    return _users.where((user) {
      final fullName = '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'
          .toLowerCase();
      final username = (user['username'] ?? '').toString().toLowerCase();
      final role = (user['role'] ?? '').toString().toLowerCase();
      final email = (user['email'] ?? '').toString().toLowerCase();
      final cin = (user['cin'] ?? '').toString().toLowerCase();
      return fullName.contains(query) ||
          username.contains(query) ||
          role.contains(query) ||
          email.contains(query) ||
          cin.contains(query);
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

  Future<void> _showDeleteUserDialog(Map<String, dynamic> user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete user'),
        content: Text('Delete ${user['username']} permanently?'),
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

    final success = await _userService.deleteUser(user['id'] as int);
    if (!mounted) return;
    if (success) {
      _fetchUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete user')));
    }
  }

  void _showUserDialog({Map<String, dynamic>? user}) {
    final isEditing = user != null;
    final formKey = GlobalKey<FormState>();

    String username = user?['username'] ?? '';
    String password = '';
    String firstName = user?['first_name'] ?? '';
    String lastName = user?['last_name'] ?? '';
    String email = user?['email'] ?? '';
    String role = user?['role'] ?? 'MEDECIN';
    String telephone = user?['telephone'] ?? '';
    String specialite = user?['specialite'] ?? '';
    String cin = user?['cin'] ?? '';
    DateTime? dateNaissance = user?['date_naissance'] != null
        ? DateTime.tryParse(user!['date_naissance'] as String)
        : null;
    String sexe = user?['sexe'] ?? 'M';
    String antecedents = user?['antecedents'] ?? '';
    String allergies = user?['allergies'] ?? '';
    bool showPassword = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit User' : 'Create User'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: username,
                      enabled: !isEditing,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        final normalized = value?.trim() ?? '';
                        if (normalized.isEmpty) return 'Required';
                        if (!RegExp(
                          r'^[a-zA-Z0-9._-]{3,}$',
                        ).hasMatch(normalized)) {
                          return 'Invalid username';
                        }
                        return null;
                      },
                      onChanged: (value) => username = value,
                    ),
                    if (!isEditing)
                      TextFormField(
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () => setDialogState(
                              () => showPassword = !showPassword,
                            ),
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().length < 6) {
                            return 'Minimum 6 characters';
                          }
                          return null;
                        },
                        onChanged: (value) => password = value,
                      ),
                    TextFormField(
                      initialValue: firstName,
                      decoration: const InputDecoration(
                        labelText: 'First name',
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                      onChanged: (value) => firstName = value,
                    ),
                    TextFormField(
                      initialValue: lastName,
                      decoration: const InputDecoration(labelText: 'Last name'),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                      onChanged: (value) => lastName = value,
                    ),
                    TextFormField(
                      initialValue: email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                      onChanged: (value) => email = value,
                    ),
                    TextFormField(
                      initialValue: telephone,
                      decoration: const InputDecoration(labelText: 'Telephone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        final normalized =
                            value?.replaceAll(RegExp(r'\s+'), '') ?? '';
                        if (normalized.isEmpty) return 'Required';
                        if (!RegExp(r'^[0-9+\-]{8,15}$').hasMatch(normalized)) {
                          return 'Invalid phone number';
                        }
                        return null;
                      },
                      onChanged: (value) => telephone = value,
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: role,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: const [
                        DropdownMenuItem(
                          value: 'MEDECIN',
                          child: Text('Doctor'),
                        ),
                        DropdownMenuItem(
                          value: 'REC',
                          child: Text('Receptionist'),
                        ),
                        DropdownMenuItem(value: 'ADMIN', child: Text('Admin')),
                        DropdownMenuItem(
                          value: 'PATIENT',
                          child: Text('Patient'),
                        ),
                      ],
                      onChanged: (value) =>
                          setDialogState(() => role = value ?? role),
                    ),
                    if (role == 'MEDECIN')
                      TextFormField(
                        initialValue: specialite,
                        decoration: const InputDecoration(
                          labelText: 'Speciality',
                        ),
                        validator: (value) {
                          if (role == 'MEDECIN' &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Speciality is required';
                          }
                          return null;
                        },
                        onChanged: (value) => specialite = value,
                      ),
                    if (role == 'PATIENT') ...[
                      TextFormField(
                        initialValue: cin,
                        decoration: const InputDecoration(labelText: 'CIN'),
                        validator: (value) {
                          final normalized = value?.trim() ?? '';
                          if (normalized.isEmpty) return 'CIN is required';
                          if (!RegExp(
                            r'^[A-Za-z0-9]{4,20}$',
                          ).hasMatch(normalized)) {
                            return 'Invalid CIN format';
                          }
                          return null;
                        },
                        onChanged: (value) => cin = value,
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: sexe,
                        decoration: const InputDecoration(labelText: 'Sex'),
                        items: const [
                          DropdownMenuItem(value: 'M', child: Text('Male')),
                          DropdownMenuItem(value: 'F', child: Text('Female')),
                        ],
                        onChanged: (value) =>
                            setDialogState(() => sexe = value ?? sexe),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          dateNaissance == null
                              ? 'Birth date'
                              : 'Birth date: ${dateNaissance!.toIso8601String().split('T')[0]}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dateNaissance ?? DateTime(2000),
                            firstDate: DateTime(1920),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setDialogState(() => dateNaissance = picked);
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: antecedents,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Medical history',
                        ),
                        onChanged: (value) => antecedents = value,
                      ),
                      TextFormField(
                        initialValue: allergies,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Allergies',
                        ),
                        onChanged: (value) => allergies = value,
                      ),
                    ],
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
                if (role == 'PATIENT' && dateNaissance == null) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Birth date is required for patients'),
                    ),
                  );
                  return;
                }

                final payload = <String, dynamic>{
                  'first_name': firstName.trim(),
                  'last_name': lastName.trim(),
                  'email': email.trim(),
                  'role': role,
                  'telephone': telephone.trim(),
                };

                if (role == 'PATIENT') {
                  payload['patient_cin'] = cin.trim().toUpperCase();
                  payload['patient_date_naissance'] = dateNaissance!
                      .toIso8601String()
                      .split('T')[0];
                  payload['patient_sexe'] = sexe;
                  payload['patient_antecedents'] = antecedents.trim();
                  payload['patient_allergies'] = allergies.trim();
                }
                if (role == 'MEDECIN') {
                  payload['medecin_specialite'] = specialite.trim();
                }

                bool success;
                if (isEditing) {
                  success = await _userService.updateUser(
                    user['id'] as int,
                    payload,
                  );
                } else {
                  final createdId = await _userService.createUser(
                    username: username.trim(),
                    password: password,
                    firstName: firstName.trim(),
                    lastName: lastName.trim(),
                    email: email.trim(),
                    role: role,
                    telephone: telephone.trim(),
                    patientCin: role == 'PATIENT'
                        ? cin.trim().toUpperCase()
                        : null,
                    patientBirthDate: role == 'PATIENT' ? dateNaissance : null,
                    patientSexe: role == 'PATIENT' ? sexe : null,
                    patientAntecedents: role == 'PATIENT'
                        ? antecedents.trim()
                        : null,
                    patientAllergies: role == 'PATIENT'
                        ? allergies.trim()
                        : null,
                    medecinSpecialite: role == 'MEDECIN'
                        ? specialite.trim()
                        : null,
                  );
                  success = createdId != null;
                }

                if (!dialogContext.mounted) return;
                if (success) {
                  Navigator.pop(dialogContext);
                  _fetchUsers();
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEditing
                            ? 'Failed to update user'
                            : 'Failed to create user',
                      ),
                    ),
                  );
                }
              },
              child: Text(isEditing ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  String _profileSubtitle(Map<String, dynamic> user) {
    final role = (user['role'] ?? '').toString();
    if (role == 'MEDECIN' && (user['specialite'] ?? '').toString().isNotEmpty) {
      return 'Speciality: ${user['specialite']}';
    }
    if (role == 'PATIENT') {
      final cin = (user['cin'] ?? '').toString();
      return cin.isEmpty ? 'Patient profile' : 'CIN: $cin';
    }
    return (user['email'] ?? '').toString();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _filteredUsers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(onPressed: _fetchUsers, icon: const Icon(Icons.refresh)),
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
                hintText: 'Search by name, role, username, email or CIN',
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
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index] as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            '${user['first_name']} ${user['last_name']}',
                          ),
                          subtitle: Text(
                            '${user['role']} - ${_profileSubtitle(user)}',
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (action) {
                              if (action == 'edit') {
                                _showUserDialog(user: user);
                              } else if (action == 'delete') {
                                _showDeleteUserDialog(user);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
      ),
    );
  }
}
