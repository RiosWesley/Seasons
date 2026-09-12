import 'package:flutter/material.dart';
import 'seasons_story_footer.dart';
import 'story_paper_background.dart';

/// Preset theme configuration for each story mode's physical identity.
class StoryModeTheme {
  final Color paperBaseColor;
  final Color accentColor;
  final Color hairlineBorderColor;
  final Color inkPrimary;
  final Color inkSecondary;
  final String editionTag;
  final double paperTextureOpacity;

  const StoryModeTheme({
    this.paperBaseColor = const Color(0xFFFBF9F5),
    this.accentColor = const Color(0xFFE11D48),
    this.hairlineBorderColor = const Color(0x331E1B4B),
    this.inkPrimary = const Color(0xFF1E1B4B),
    this.inkSecondary = const Color(0xFF64748B),
    this.editionTag = 'seasons archive',
    this.paperTextureOpacity = 0.40,
  });

  static const StoryModeTheme casal = StoryModeTheme(
    paperBaseColor: Color(0xFFFFF5F5),
    accentColor: Color(0xFFE11D48),
    hairlineBorderColor: Color(0xFFFECDD3),
    inkPrimary: Color(0xFF4C0519),
    inkSecondary: Color(0xFF881337),
    editionTag: "mémoire d'amour",
    paperTextureOpacity: 0.40,
  );

  static const StoryModeTheme amigos = StoryModeTheme(
    paperBaseColor: Color(0xFFF4F8FD),
    accentColor: Color(0xFF2563EB),
    hairlineBorderColor: Color(0xFFBFDBFE),
    inkPrimary: Color(0xFF0F172A),
    inkSecondary: Color(0xFF334155),
    editionTag: 'squad zine',
    paperTextureOpacity: 0.40,
  );

  static const StoryModeTheme grupo = StoryModeTheme(
    paperBaseColor: Color(0xFFFAF6FD),
    accentColor: Color(0xFF7C3AED),
    hairlineBorderColor: Color(0xFFDDD6FE),
    inkPrimary: Color(0xFF1E1B4B),
    inkSecondary: Color(0xFF475569),
    editionTag: 'gazeta da comunidade',
    paperTextureOpacity: 0.40,
  );
}

/// Multi-layer physical paper engine and layout scaffold for 9:16 story cards.
/// Integrates Warm Ivory / mode-tinted paper canvas, tactile creased texture,
/// internal hairline margin framing, safe top clearance, and Seasons footer.
class RetroPaperScaffold extends StatelessWidget {
  final StoryModeTheme theme;
  final Widget child;
  final Widget? footer;
  final double topClearance;
  final EdgeInsetsGeometry padding;

  const RetroPaperScaffold({
    super.key,
    this.theme = const StoryModeTheme(),
    required this.child,
    this.footer,
    this.topClearance = 40.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return StoryPaperBackground(
      baseColor: theme.paperBaseColor,
      accentColor: theme.accentColor,
      textureOpacity: theme.paperTextureOpacity,
      hairlineBorderColor: theme.hairlineBorderColor,
      child: SafeArea(
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: topClearance),
              Expanded(child: child),
              const SizedBox(height: 12),
              footer ??
                  SeasonsStoryFooter(
                    editionTag: theme.editionTag,
                    inkPrimary: theme.inkPrimary,
                    inkSecondary: theme.inkSecondary,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
