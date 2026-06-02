// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcomeBack => 'مرحباً بك مجدداً';

  @override
  String get createAccount => 'إنشاء حساب جديد';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get cin => 'بطاقة التعريف الوطنية';

  @override
  String get sexe => 'الجنس';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get birthDate => 'تاريخ الازدياد';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get loginBtn => 'تسجيل الدخول';

  @override
  String get registerBtn => 'تسجيل';

  @override
  String get newPatient => 'مريض جديد؟ إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ دخول';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get selectBirthDate => 'يرجى اختيار تاريخ ميلادك';

  @override
  String get accountCreated => 'تم إنشاء الحساب بنجاح! يرجى تسجيل الدخول';

  @override
  String get authFailed => 'فشل في عملية تسجيل الدخول';
}
