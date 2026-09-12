import 'package:flutter/material.dart';

/// Swiss-minimalist luxury color architecture (Obsidian Archive).
/// Replaces the old green with an editorial palette:
/// - Cosmic Obsidian (#090A10) baseline
/// - Electric Iris (#6366F1) & Radiant Violet (#8B5CF6) gradient ramp
/// - Icy Lavender (#E0E7FF) and Slate (#94A3B8) typography
/// - Translucent glassmorphic card planes with hairline borders (#1E2238)
class SwissColors {
  SwissColors._();

  // === SWISS EDITORIAL BRAND ACCENTS (Harmonized with App Icon) ===
  static const Color brandCobalt = Color(0xFF2563EB); // Vivid Cobalt from App Icon
  static const Color brandSapphire = Color(0xFF1D4ED8); // Deep Sapphire
  static const Color brandObsidian = Color(0xFF0F172A); // Swiss Editorial Midnight Slate

  // === PRIMARY ACCENT RAMP (Electric Iris & Radiant Violet) ===
  static const Color irisPrimary = Color(0xFF6366F1);
  static const Color violetSecondary = Color(0xFF8B5CF6);
  static const Color orchidTertiary = Color(0xFFA855F7);
  static const Color accent = brandCobalt;
  static const Color accentSecondary = brandSapphire;
  static const Color accentSubduedDark = Color(0xFF1E1F3D);
  static const Color accentSubduedLight = Color(0xFFEEF2FF);
  static const Color accentBorder = Color(0xFF4F46E5);
  static const Color accentGlow = Color(0x4D6366F1);
  static const Color accentLavender = Color(0xFFE0E7FF);

  // Backward-compatibility aliases so all existing references cleanly resolve to new luxury tones
  static const Color emeraldPrimary = irisPrimary;
  static const Color emeraldSecondary = violetSecondary;

  // === DARK THEME PALETTE (Cosmic Obsidian & Deep Glass) ===
  static const Color darkBackground = Color(0xFF090A10);
  static const Color darkSurface = Color(0xFF0F111A);
  static const Color darkSurfaceCard = Color(0xFF131624);
  static const Color darkSurfaceSubdued = Color(0xFF1A1E2E);
  static const Color darkSurfaceGlass = Color(0xCC131624);
  static const Color darkBorder = Color(0xFF1E2238);
  static const Color darkBorderStrong = Color(0xFF2E3452);
  static const Color darkBorderGlow = Color(0x336366F1);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // === LIGHT THEME PALETTE (Warm Ivory/Cream & Editorial Slate) ===
  static const Color lightBackground = Color(0xFFFBF9F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubdued = Color(0xFFF6F3ED);
  static const Color lightBorder = Color(0xFFEBE6DF);
  static const Color lightBorderStrong = Color(0xFFDED8CE);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // === BENTO CARDS PASTEL ACCENTS ===
  static const Color casalBgStart = Color(0xFFFFF1F2);
  static const Color casalBgEnd = Color(0xFFFFE4E6);
  static const Color casalBorder = Color(0xFFFECDD3);
  static const Color casalAccent = Color(0xFFF43F5E);

  static const Color amigosBgStart = Color(0xFFF0F9FF);
  static const Color amigosBgEnd = Color(0xFFE0F2FE);
  static const Color amigosBorder = Color(0xFFBAE6FD);
  static const Color amigosAccent = Color(0xFF0284C7);

  // === FUNCTIONAL SEMANTIC TOKENS ===
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerSubdued = Color(0xFF3B1818);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF38BDF8);

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
