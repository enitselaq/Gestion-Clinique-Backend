import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/role_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, AuthProvider>(
      builder: (context, localeProvider, authProvider, child) {
        return MaterialApp(
          title: 'Clinic Management',
          debugShowCheckedModeBanner: false,
          
          locale: localeProvider.locale,
          
          // Use the auto-generated list of locales from your ARB files
          supportedLocales: AppLocalizations.supportedLocales,

          // This connects your translations to the actual App UI
          localizationsDelegates: const [
            AppLocalizations.delegate, 
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: !authProvider.isInitialized
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              : authProvider.user == null
                  ? const AuthScreen()
                  : const RoleRouter(),
        );
      },
    );
  }
}
