import 'package:flutter/material.dart';

/// Design tokens and visual constants for Grupo Mode stories.
/// Adheres to the Periodical Magazine / Community Broadsheet aesthetic:
/// Alabaster paper, Midnight Plum Obsidian ink, Imperial Violet accents,
/// and Medal Gold highlights.
class GrupoTheme {
  GrupoTheme._();

  // --- Color Palette ---
  static const Color paperBase = Color(0xFFFAF6FD);
  static const Color inkPrimary = Color(0xFF1E1B4B);
  static const Color inkSecondary = Color(0xFF475569);
  static const Color accentPrimary = Color(0xFF7C3AED);
  static const Color accentSecondary = Color(0xFFA855F7);
  static const Color cardSurface = Color(0xFFF3E8FF);
  static const Color cardSurfaceWhite = Color(0xF5FFFFFF);
  static const Color hairlineBorder = Color(0xFFDDD6FE);

  // --- Medal Colors ---
  static const Color medalGold = Color(0xFFEAB308);
  static const Color medalSilver = Color(0xFF94A3B8);
  static const Color medalBronze = Color(0xFFB45309);

  // --- Typography Helpers ---
  static const TextStyle broadsheetHeader = TextStyle(
    fontFamily: 'serif',
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: inkPrimary,
    letterSpacing: -0.5,
    height: 1.15,
  );

  static const TextStyle kicker = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: inkSecondary,
  );

  static const TextStyle bodySerif = TextStyle(
    fontFamily: 'serif',
    fontSize: 14,
    color: inkSecondary,
    height: 1.45,
  );

  static const TextStyle captionItalic = TextStyle(
    fontFamily: 'serif',
    fontSize: 13,
    fontStyle: FontStyle.italic,
    color: inkSecondary,
    height: 1.35,
  );
}
