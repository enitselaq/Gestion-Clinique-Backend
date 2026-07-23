import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryTeal = Color(0xFF0F766E);
  static const Color deepTeal = Color(0xFF115E59);
  static const Color clinicalBlue = Color(0xFF2563EB);
  static const Color mint = Color(0xFFDDF7F0);
  static const Color softMint = Color(0xFFF0FDFA);
  static const Color warmSurface = Color(0xFFFAFCFB);
  static const Color slate = Color(0xFF1E293B);
  static const Color mutedSlate = Color(0xFF64748B);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: primaryTeal,
      brightness: Brightness.light,
      primary: primaryTeal,
      secondary: clinicalBlue,
      surface: warmSurface,
    );

    final borderRadius = BorderRadius.circular(16);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: slate, fontWeight: FontWeight.w900, letterSpacing: -0.5),
        headlineMedium: TextStyle(color: slate, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        titleLarge: TextStyle(color: slate, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: slate, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: slate, height: 1.5, fontSize: 16),
        bodyMedium: TextStyle(color: slate, height: 1.5, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: slate,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: slate,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        prefixIconColor: primaryTeal,
        labelStyle: const TextStyle(color: mutedSlate, fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: primaryTeal, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryTeal,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: primaryTeal, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
