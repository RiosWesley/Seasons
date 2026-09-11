import 'package:flutter/material.dart';

/// Swiss-minimalist color architecture conforming to Swiss International Typographic Style.
/// Features disciplined neutral monotone palettes (adaptive Light & Dark) and
/// Swiss Precision Emerald (#00DC82 / #10B981) as the sole accent token.
class SwissColors {
  SwissColors._();

  // === SINGLE DISCIPLINED ACCENT (Swiss Precision Emerald) ===
  static const Color emeraldPrimary = Color(0xFF00DC82);
  static const Color emeraldSecondary = Color(0xFF10B981);
  static const Color accent = emeraldPrimary;
  static const Color accentSubduedDark = Color(0xFF0E3A2F);
  static const Color accentSubduedLight = Color(0xFFE8FAF3);
  static const Color accentBorder = Color(0xFF059669);

  // === DARK THEME PALETTE (Cool Graphite) ===
  static const Color darkBackground = Color(0xFF0B0C0E);
  static const Color darkSurface = Color(0xFF14171A);
  static const Color darkSurfaceCard = Color(0xFF181D27);
  static const Color darkSurfaceSubdued = Color(0xFF1E2432);
  static const Color darkBorder = Color(0xFF24292E);
  static const Color darkBorderStrong = Color(0xFF384259);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // === LIGHT THEME PALETTE (Crisp Off-White) ===
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubdued = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightBorderStrong = Color(0xFFCBD5E1);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // === FUNCTIONAL SEMANTIC TOKENS ===
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerSubdued = Color(0xFF3B1818);
  static const Color success = emeraldSecondary;

  // === ADAPTIVE RESOLVERS ===
  static Color background(bool isDark) =>
      isDark ? darkBackground : lightBackground;

  static Color surface(bool isDark) =>
      isDark ? darkSurface : lightSurface;

  static Color cardSurface(bool isDark) =>
      isDark ? darkSurfaceCard : lightSurfaceCard;

  static Color border(bool isDark) =>
      isDark ? darkBorder : lightBorder;

  static Color borderStrong(bool isDark) =>
      isDark ? darkBorderStrong : lightBorderStrong;

  static Color textPrimary(bool isDark) =>
      isDark ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;

  static Color textMuted(bool isDark) =>
      isDark ? darkTextMuted : lightTextMuted;

  static Color accentSubdued(bool isDark) =>
      isDark ? accentSubduedDark : accentSubduedLight;
}
