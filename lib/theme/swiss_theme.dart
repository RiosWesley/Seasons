import 'package:flutter/material.dart';
import 'squircle_border.dart';
import 'swiss_colors.dart';
import 'swiss_typography.dart';

/// Cohesive Swiss-Minimalist ThemeData builder.
/// Configures zero-elevation surfaces, continuous squircle geometry,
/// disciplined emerald accents, and tabular numeral typography.
class SwissTheme {
  SwissTheme._();

  /// Dark theme adhering to cool graphite palette.
  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark().copyWith(
      primary: SwissColors.emeraldPrimary,
      secondary: SwissColors.emeraldSecondary,
      surface: SwissColors.darkSurface,
      error: SwissColors.danger,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: SwissColors.darkTextPrimary,
      onError: Colors.white,
      outline: SwissColors.darkBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SwissColors.darkBackground,
      canvasColor: SwissColors.darkBackground,
      cardColor: SwissColors.darkSurfaceCard,
      dividerColor: SwissColors.darkBorder,
      textTheme: SwissTypography.createTextTheme(isDark: true),
      appBarTheme: const AppBarTheme(
        backgroundColor: SwissColors.darkBackground,
        foregroundColor: SwissColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: SwissColors.darkSurfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: SquircleBorder.card(
          side: const BorderSide(color: SwissColors.darkBorder, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: SwissColors.emeraldPrimary,
          foregroundColor: Colors.black,
          textStyle: SwissTypography.labelLarge,
          shape: SquircleBorder.button(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: SwissColors.darkTextPrimary,
          side: const BorderSide(color: SwissColors.darkBorder, width: 1.0),
          shape: SquircleBorder.button(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  /// Light theme adhering to crisp off-white palette.
  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light().copyWith(
      primary: SwissColors.emeraldPrimary,
      secondary: SwissColors.emeraldSecondary,
      surface: SwissColors.lightSurface,
      error: SwissColors.danger,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: SwissColors.lightTextPrimary,
      onError: Colors.white,
      outline: SwissColors.lightBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SwissColors.lightBackground,
      canvasColor: SwissColors.lightBackground,
      cardColor: SwissColors.lightSurfaceCard,
      dividerColor: SwissColors.lightBorder,
      textTheme: SwissTypography.createTextTheme(isDark: false),
      appBarTheme: const AppBarTheme(
        backgroundColor: SwissColors.lightBackground,
        foregroundColor: SwissColors.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: SwissColors.lightSurfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: SquircleBorder.card(
          side: const BorderSide(color: SwissColors.lightBorder, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: SwissColors.emeraldPrimary,
          foregroundColor: Colors.black,
          textStyle: SwissTypography.labelLarge,
          shape: SquircleBorder.button(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: SwissColors.lightTextPrimary,
          side: const BorderSide(color: SwissColors.lightBorder, width: 1.0),
          shape: SquircleBorder.button(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}
