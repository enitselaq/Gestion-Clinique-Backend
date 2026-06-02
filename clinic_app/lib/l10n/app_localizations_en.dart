// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get createAccount => 'Create Account';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get cin => 'CIN';

  @override
  String get sexe => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get birthDate => 'Birth Date';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get loginBtn => 'LOGIN';

  @override
  String get registerBtn => 'REGISTER';

  @override
  String get newPatient => 'New patient? Sign Up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get requiredField => 'Required field';

  @override
  String get selectBirthDate => 'Please select your birth date';

  @override
  String get accountCreated => 'Account created! Please login.';

  @override
  String get authFailed => 'Authentication Failed';
}
