import 'package:flutter/material.dart';

/// Design tokens and typography for Casal Mode Stories ("Mémoire d'Amour").
class CasalStoryTheme {
  CasalStoryTheme._();

  // Romantic Editorial Palette
  static const Color paperBase = Color(0xFFFFF5F5); // Warm Blush Ivory
  static const Color inkPrimary = Color(0xFF4C0519); // Velvet deep bordeaux
  static const Color inkSecondary = Color(0xFF881337); // Soft rose bordeaux
  static const Color inkMuted = Color(0xFF9F1239); // Muted rose ink
  static const Color accentPrimary = Color(0xFFE11D48); // Vivid rose crimson
  static const Color accentSecondary = Color(0xFFFB7185); // Peony coral
  static const Color cardSurface = Colors.white; // Pure white on blush paper
  static const Color cardSurfaceBlush = Color(0xFFFFF1F2); // Parchment blush
  static const Color hairlineBorder = Color(0xFFFECDD3); // Soft rose stitch border
  static const Color badgeHighlight = Color(0xFFFFE4E6); // Delicate petal tint
  static const Color goldAccent = Color(0xFFD97706); // Warm gold seal highlight

  // Typography Tokens
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'serif',
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: inkPrimary,
    height: 1.15,
    letterSpacing: -0.8,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'serif',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: inkPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle italicSubtitle = TextStyle(
    fontFamily: 'serif',
    fontStyle: FontStyle.italic,
    fontSize: 14,
    height: 1.35,
    color: inkSecondary,
  );

  static const TextStyle tabularMetricColossal = TextStyle(
    fontFamily: 'serif',
    fontSize: 54,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.5,
    height: 1.05,
    color: accentPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle labelKicker = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.3,
    color: inkSecondary,
  );

  static ShapeDecoration cardDecoration({
    Color backgroundColor = cardSurface,
    Color borderColor = hairlineBorder,
    double radius = 16.0,
    double borderWidth = 1.0,
  }) {
    return ShapeDecoration(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: borderColor, width: borderWidth),
      ),
      shadows: [
        BoxShadow(
          color: inkPrimary.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
