import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_background_variants.dart';
import 'grupo_theme.dart';

/// Slide g13: Quem Mais Tira Print (Crachá de repórter investigativo com tira de filme)
class GrupoG13ReporterPrintsSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG13ReporterPrintsSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final reporter = adapter.reporterName;
    final printCount = adapter.reporterPrintCount;

    return StoryCardBase(
      background: GrupoBackgroundVariants.g13ReporterPrints(),
      isDarkTheme: true,
      backgroundColor: const Color(0xFF0F0A1A),
      category: 'Arquivo Secreto',
      categoryIcon: Icons.camera_alt_rounded,
      title: 'O Repórter\nOficial',
      subtitle: 'Aquele que documenta tudo para os anais históricos.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Press Credential Badge Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                20,
                side: const BorderSide(color: GrupoTheme.accentPrimary, width: 1.5),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Lanyard Clip & Badge Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: ShapeDecoration(
                        color: GrupoTheme.cardSurface,
                        shape: SquircleBorder.radius(6),
                      ),
                      child: const Text(
                        'REGISTRO #007',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: GrupoTheme.accentPrimary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.badge_rounded,
                      color: GrupoTheme.accentPrimary,
                      size: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Camera Lens Graphic
                Container(
                  width: 64,
                  height: 64,
                  decoration: ShapeDecoration(
                    color: GrupoTheme.cardSurface,
                    shape: SquircleBorder.radius(18),
                  ),
                  child: const Icon(
                    Icons.camera_rounded,
                    color: GrupoTheme.accentPrimary,
                    size: 34,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  'INFORMADOR DA COMUNIDADE',
                  style: GrupoTheme.kicker.copyWith(
                    color: GrupoTheme.accentPrimary,
                    fontSize: 9,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  reporter,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: GrupoTheme.inkPrimary,
                  ),
                ),

                const SizedBox(height: 14),

                // Film Strip Counter Strip
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.movie_filter_outlined, color: Colors.white70, size: 18),
                      Text(
                        '~$printCount PRINTS ARQUIVADOS',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const Icon(Icons.movie_filter_outlined, color: Colors.white70, size: 18),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Nada passa despercebido: toda declaração polêmica já se encontra devidamente printada.',
                  textAlign: TextAlign.center,
                  style: GrupoTheme.captionItalic.copyWith(fontSize: 12),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }
}
