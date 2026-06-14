// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcomeBack => 'Connexion';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get fullName => 'Nom complet';

  @override
  String get phoneNumber => 'N° de téléphone';

  @override
  String get cin => 'CIN';

  @override
  String get sexe => 'Sexe';

  @override
  String get male => 'Masculin';

  @override
  String get female => 'Féminin';

  @override
  String get birthDate => 'Date de naissance';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get loginBtn => 'CONNEXION';

  @override
  String get registerBtn => 'S\'INSCRIRE';

  @override
  String get newPatient => 'Nouveau patient ? S\'inscrire';

  @override
  String get alreadyHaveAccount => 'Déjà inscrit ? Connexion';

  @override
  String get requiredField => 'Champ obligatoire';

  @override
  String get selectBirthDate => 'Veuillez choisir votre date de naissance';

  @override
  String get accountCreated => 'Compte créé ! Connectez-vous.';

  @override
  String get authFailed => 'Échec de l\'authentification';
}
