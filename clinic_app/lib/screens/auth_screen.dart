import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
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
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectBirthDate)),
        );
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
    }

    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.authFailed), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 900)
            Expanded(
              flex: 1,
              child: Container(
                color: AppTheme.primaryTeal,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Argana\nClinique',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 64,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(height: 4, width: 80, color: Colors.white24),
                        const SizedBox(height: 24),
                        Text(
                          'Solution de gestion médicale intelligente.\nAccédez à vos dossiers et rendez-vous en un clic.',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: _buildLanguageToggle(localeProvider),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          isLogin ? l10n.welcomeBack : l10n.createAccount,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isLogin ? 'Veuillez vous connecter' : 'Rejoignez notre réseau de santé',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.mutedSlate),
                        ),
                        const SizedBox(height: 30),
                        
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (!isLogin) ...[
                                _buildField(_nameController, l10n.fullName, Icons.person_outline),
                                const SizedBox(height: 16),
                                _buildField(_cinController, 'CIN', Icons.badge_outlined),
                                const SizedBox(height: 16),
                                _buildField(_phoneController, l10n.phoneNumber, Icons.phone_android_outlined),
                                const SizedBox(height: 16),
                                
                                // Gender Selector
                                Row(
                                  children: [
                                    const Text('Sexe: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Radio<String>(
                                      value: 'M',
                                      groupValue: selectedSexe,
                                      onChanged: (v) => setState(() => selectedSexe = v!),
                                    ),
                                    const Text('M'),
                                    Radio<String>(
                                      value: 'F',
                                      groupValue: selectedSexe,
                                      onChanged: (v) => setState(() => selectedSexe = v!),
                                    ),
                                    const Text('F'),
                                  ],
                                ),
                                
                                // Date of Birth Picker
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(selectedDate == null 
                                    ? 'Date de naissance' 
                                    : 'Né(e) le: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                                  trailing: const Icon(Icons.calendar_today, color: AppTheme.primaryTeal),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(2000),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (date != null) setState(() => selectedDate = date);
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                              
                              _buildField(_emailController, l10n.username, Icons.alternate_email),
                              const SizedBox(height: 16),
                              _buildField(
                                _passController, 
                                l10n.password, 
                                Icons.lock_outline,
                                isPassword: true,
                              ),
                              const SizedBox(height: 32),
                              
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  child: Text(isLogin ? l10n.loginBtn : l10n.registerBtn),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: TextButton(
                                  onPressed: () => setState(() => isLogin = !isLogin),
                                  child: Text(isLogin ? l10n.newPatient : l10n.alreadyHaveAccount),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_showLoginPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword ? IconButton(
          icon: Icon(_showLoginPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _showLoginPassword = !_showLoginPassword),
        ) : null,
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
    );
  }

  Widget _buildLanguageToggle(LocaleProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _langBtn('FR', const Locale('fr'), provider),
        const Text('|', style: TextStyle(color: Colors.grey)),
        _langBtn('AR', const Locale('ar'), provider),
        const Text('|', style: TextStyle(color: Colors.grey)),
        _langBtn('EN', const Locale('en'), provider),
      ],
    );
  }

  Widget _langBtn(String label, Locale loc, LocaleProvider provider) {
    final isSelected = provider.locale.languageCode == loc.languageCode;
    return GestureDetector(
      onTap: () => provider.setLocale(loc),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppTheme.primaryTeal : AppTheme.mutedSlate,
          ),
        ),
      ),
    );
  }
}
