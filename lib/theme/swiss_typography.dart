import 'package:flutter/material.dart';
import 'swiss_colors.dart';

/// Typographic hierarchy adhering to Swiss International Typographic Style.
/// Mandates FontFeature.tabularFigures() for all numeric counters, timers,
/// metrics, and percentages to eliminate horizontal text jitter.
class SwissTypography {
  SwissTypography._();

  /// Tabular figures (tnum) feature ensuring uniform digit width.
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  // Base text styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2,
    height: 1.1,
    fontFeatures: tabularFigures,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.15,
    fontFeatures: tabularFigures,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 1.25,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.45,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    fontFeatures: tabularFigures,
  );

  // Dedicated metric styles (all with tabular figures)
  static const TextStyle metricLarge = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    height: 1.1,
    fontFeatures: tabularFigures,
  );

  static const TextStyle metricMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    fontFeatures: tabularFigures,
  );

  static const TextStyle metricSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    fontFeatures: tabularFigures,
  );

  /// Generates a complete Material TextTheme for dark or light modes.
  static TextTheme createTextTheme({required bool isDark}) {
    final primary = isDark ? SwissColors.darkTextPrimary : SwissColors.lightTextPrimary;
    final secondary = isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary;

    return TextTheme(
      displayLarge: displayLarge.copyWith(color: primary),
      displayMedium: displayMedium.copyWith(color: primary),
      displaySmall: displayMedium.copyWith(fontSize: 28, color: primary),
      headlineLarge: titleLarge.copyWith(fontSize: 26, color: primary),
      headlineMedium: titleLarge.copyWith(color: primary),
      headlineSmall: titleMedium.copyWith(color: primary),
      titleLarge: titleLarge.copyWith(color: primary),
      titleMedium: titleMedium.copyWith(color: primary),
      titleSmall: titleMedium.copyWith(fontSize: 15, color: secondary),
      bodyLarge: bodyLarge.copyWith(color: primary),
      bodyMedium: bodyMedium.copyWith(color: secondary),
      bodySmall: bodyMedium.copyWith(fontSize: 12, color: secondary),
      labelLarge: labelLarge.copyWith(color: primary),
      labelMedium: labelLarge.copyWith(fontSize: 12, color: secondary),
      labelSmall: labelSmall.copyWith(color: secondary),
    );
  }
}
