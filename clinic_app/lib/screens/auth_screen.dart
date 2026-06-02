import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import 'package:clinic_app/l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool _showLoginPassword = false;
  bool _showForgotPassword = false;
  bool _showForgotConfirmPassword = false;
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  String selectedSexe = 'M';

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  final _cinController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _nameController.dispose();
    _cinController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  String? _validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _validateUsername(String? value, String message) {
    final base = _validateRequired(value, message);
    if (base != null) return base;
    if (!RegExp(r'^[a-zA-Z0-9._-]{3,}$').hasMatch(value!.trim())) {
      return 'Use at least 3 characters without spaces';
    }
    return null;
  }

  String? _validatePassword(String? value, String message) {
    final base = _validateRequired(value, message);
    if (base != null) return base;
    if (value!.trim().length < 6) {
      return 'Password must contain at least 6 characters';
    }
    return null;
  }

  String? _validatePhone(String? value, String message) {
    final base = _validateRequired(value, message);
    if (base != null) return base;
    final normalized = value!.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^[0-9+\-]{8,15}$').hasMatch(normalized)) {
      return 'Invalid phone number';
    }
    return null;
  }

  String? _validateCin(String? value, String message) {
    final base = _validateRequired(value, message);
    if (base != null) return base;
    if (!RegExp(r'^[A-Za-z0-9]{4,20}$').hasMatch(value!.trim())) {
      return 'Invalid CIN format';
    }
    return null;
  }

  void _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success;

    if (isLogin) {
      success = await authProvider.login(
        _emailController.text.trim(),
        _passController.text,
      );
    } else {
      if (!mounted) return;
      if (selectedDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.selectBirthDate)));
        return;
      }

      success = await authProvider.register(
        username: _emailController.text.trim(),
        password: _passController.text,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        cin: _cinController.text.trim().toUpperCase(),
        sexe: selectedSexe,
        dob: selectedDate!,
      );

      if (!mounted) return;
      if (success) {
        setState(() => isLogin = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.accountCreated),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }
    }

    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.authFailed), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController(
      text: _emailController.text.trim(),
    );
    final cinController = TextEditingController();
    final newPasswordController = TextEditingController();
    DateTime? birthDate;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Forgot password'),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    usernameController,
                    'Username',
                    Icons.alternate_email,
                    validator: (value) =>
                        _validateUsername(value, 'Required'),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    cinController,
                    'CIN',
                    Icons.badge,
                    validator: (value) => _validateCin(value, 'Required'),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: birthDate ?? DateTime(2000),
                          firstDate: DateTime(1920),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() => birthDate = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        birthDate == null
                            ? 'Birth date'
                            : '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: !_showForgotPassword,
                    decoration: InputDecoration(
                      labelText: 'New password',
                      prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                      suffixIcon: IconButton(
                        onPressed: () => setDialogState(
                          () => _showForgotPassword = !_showForgotPassword,
                        ),
                        icon: Icon(
                          _showForgotPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) =>
                        _validatePassword(value, 'Required'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    obscureText: !_showForgotConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm new password',
                      prefixIcon: Icon(Icons.lock_reset, color: Colors.blue[800]),
                      suffixIcon: IconButton(
                        onPressed: () => setDialogState(
                          () => _showForgotConfirmPassword =
                              !_showForgotConfirmPassword,
                        ),
                        icon: Icon(
                          _showForgotConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if ((value ?? '').isEmpty) return 'Required';
                      if (value != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
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
                if (!formKey.currentState!.validate()) return;
                if (birthDate == null) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Birth date is required')),
                  );
                  return;
                }
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final success = await authProvider.forgotPasswordReset(
                  username: usernameController.text.trim(),
                  cin: cinController.text.trim().toUpperCase(),
                  dateNaissance: birthDate!,
                  newPassword: newPasswordController.text,
                );
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Password reset successfully. You can log in now.'
                          : 'Password reset failed',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue[800]!.withValues(alpha: 0.3),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Locale>(
                value: localeProvider.locale,
                icon: Icon(Icons.language, color: Colors.blue[800], size: 20),
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) localeProvider.setLocale(newLocale);
                },
                items: const [
                  DropdownMenuItem(value: Locale('fr'), child: Text(' FR')),
                  DropdownMenuItem(value: Locale('ar'), child: Text(' AR')),
                  DropdownMenuItem(value: Locale('en'), child: Text(' EN')),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Icon(Icons.local_hospital, size: 80, color: Colors.blue[800]),
              const SizedBox(height: 10),
              Text(
                isLogin ? l10n.welcomeBack : l10n.createAccount,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 30),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!isLogin) ...[
                          _buildTextField(
                            _nameController,
                            l10n.fullName,
                            Icons.person,
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            _phoneController,
                            l10n.phoneNumber,
                            Icons.phone,
                            inputType: TextInputType.phone,
                            validator: (value) =>
                                _validatePhone(value, l10n.requiredField),
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            _cinController,
                            l10n.cin,
                            Icons.badge,
                            validator: (value) =>
                                _validateCin(value, l10n.requiredField),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: selectedSexe,
                                  decoration: InputDecoration(
                                    labelText: l10n.sexe,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: 'M',
                                      child: Text(l10n.male),
                                    ),
                                    DropdownMenuItem(
                                      value: 'F',
                                      child: Text(l10n.female),
                                    ),
                                  ],
                                  onChanged: (val) =>
                                      setState(() => selectedSexe = val!),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => _selectDate(context),
                                  child: Text(
                                    selectedDate == null
                                        ? l10n.birthDate
                                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                        _buildTextField(
                          _emailController,
                          l10n.username,
                          Icons.alternate_email,
                          validator: (value) =>
                              _validateUsername(value, l10n.requiredField),
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          _passController,
                          l10n.password,
                          Icons.lock,
                          isPassword: true,
                          isPasswordVisible: _showLoginPassword,
                          onTogglePasswordVisibility: () {
                            setState(
                              () => _showLoginPassword = !_showLoginPassword,
                            );
                          },
                          validator: (value) =>
                              _validatePassword(value, l10n.requiredField),
                        ),
                        if (isLogin)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _showForgotPasswordDialog,
                              child: const Text('Forgot password?'),
                            ),
                          ),
                        const SizedBox(height: 30),
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) => auth.isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[800],
                                    minimumSize: const Size(
                                      double.infinity,
                                      50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _submit,
                                  child: Text(
                                    isLogin ? l10n.loginBtn : l10n.registerBtn,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                              selectedDate = null;
                            });
                          },
                          child: Text(
                            isLogin ? l10n.newPatient : l10n.alreadyHaveAccount,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePasswordVisibility,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[800]),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onTogglePasswordVisibility,
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator:
          validator ?? (value) => _validateRequired(value, l10n.requiredField),
    );
  }
}
