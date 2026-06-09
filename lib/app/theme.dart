import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_extension.dart';

export 'theme_extension.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF0082D3);
  static const Color primaryGold = Color(0xFFFFD700);
  static const Color accentGold = Color(0xFFFFC107);
  static const Color successGreen = Color(0xFF01A453);
  static const Color errorRed = Color(0xFFEF5350);

  static const _darkColors = AppColors(
    primaryBlue: primaryBlue,
    primaryGold: primaryGold,
    accentGold: accentGold,
    darkBg: Color(0xFF0F172A),
    surfaceDark: Color(0xFF1E293B),
    surfaceCard: Color(0xFF1E293B),
    surfaceElevated: Color(0xFF334155),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    borderColor: Color(0xFF334155),
    successGreen: successGreen,
    errorRed: errorRed,
  );

  static const _lightColors = AppColors(
    primaryBlue: primaryBlue,
    primaryGold: Color(0xFFD4AF37), // Darker gold for better contrast on light mode
    accentGold: accentGold,
    darkBg: Color(0xFFF9FAFB),
    surfaceDark: Color(0xFFF1F5F9), // e.g. Navbar background
    surfaceCard: Color(0xFFFDFDFD),
    surfaceElevated: Color(0xFFF1F5F9),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF94A3B8),
    borderColor: Color(0xFFE2E8F0),
    successGreen: successGreen,
    errorRed: errorRed,
  );

  static ThemeData get darkTheme => _buildTheme(Brightness.dark, _darkColors);
  static ThemeData get lightTheme => _buildTheme(Brightness.light, _lightColors);

  static ThemeData _buildTheme(Brightness brightness, AppColors colors) {
    return ThemeData(
      brightness: brightness,
      primaryColor: colors.primaryBlue,
      scaffoldBackgroundColor: colors.darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primaryBlue,
        brightness: brightness,
        primary: colors.primaryBlue,
        secondary: colors.primaryGold,
        surface: colors.darkBg,
        error: colors.errorRed,
      ),
      extensions: [colors],
      textTheme: GoogleFonts.outfitTextTheme(
        TextTheme(
          displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: colors.textPrimary, letterSpacing: -1.0),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: colors.textPrimary, letterSpacing: -0.5),
          headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colors.textPrimary),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colors.textPrimary),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.textPrimary),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: colors.textSecondary),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: colors.textSecondary),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: colors.textMuted),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfaceDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.textPrimary),
        iconTheme: IconThemeData(color: colors.primaryGold),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primaryGold,
          side: BorderSide(color: colors.primaryGold),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primaryGold, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: colors.textMuted),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(colors.surfaceElevated),
        dataRowColor: WidgetStateProperty.all(colors.surfaceCard),
        headingTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.primaryGold),
        dataTextStyle: TextStyle(fontSize: 14, color: colors.textSecondary),
        dividerThickness: 1,
      ),
      dividerTheme: DividerThemeData(color: colors.borderColor, thickness: 1),
      iconTheme: IconThemeData(color: colors.textSecondary, size: 22),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceElevated,
        contentTextStyle: TextStyle(color: colors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

