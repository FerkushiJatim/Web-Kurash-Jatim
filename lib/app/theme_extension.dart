import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primaryBlue;
  final Color primaryGold;
  final Color accentGold;
  final Color darkBg;
  final Color surfaceDark;
  final Color surfaceCard;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color borderColor;
  final Color successGreen;
  final Color errorRed;

  const AppColors({
    required this.primaryBlue,
    required this.primaryGold,
    required this.accentGold,
    required this.darkBg,
    required this.surfaceDark,
    required this.surfaceCard,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.borderColor,
    required this.successGreen,
    required this.errorRed,
  });

  @override
  AppColors copyWith({
    Color? primaryBlue,
    Color? primaryGold,
    Color? accentGold,
    Color? darkBg,
    Color? surfaceDark,
    Color? surfaceCard,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? borderColor,
    Color? successGreen,
    Color? errorRed,
  }) {
    return AppColors(
      primaryBlue: primaryBlue ?? this.primaryBlue,
      primaryGold: primaryGold ?? this.primaryGold,
      accentGold: accentGold ?? this.accentGold,
      darkBg: darkBg ?? this.darkBg,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      borderColor: borderColor ?? this.borderColor,
      successGreen: successGreen ?? this.successGreen,
      errorRed: errorRed ?? this.errorRed,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t)!,
      primaryGold: Color.lerp(primaryGold, other.primaryGold, t)!,
      accentGold: Color.lerp(accentGold, other.accentGold, t)!,
      darkBg: Color.lerp(darkBg, other.darkBg, t)!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      errorRed: Color.lerp(errorRed, other.errorRed, t)!,
    );
  }
}

extension BuildContextThemeExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

