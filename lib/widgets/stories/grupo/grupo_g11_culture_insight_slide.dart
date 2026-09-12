import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_theme.dart';

/// Slide g11: Insight Coletivo (Ensaio sociológico com drop-cap iluminada)
class GrupoG11CultureInsightSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG11CultureInsightSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final text = adapter.primaryInsight.trim();
    final firstChar = text.isNotEmpty ? text.substring(0, 1) : 'U';
    final remainingText = text.length > 1 ? text.substring(1) : '';

    return StoryCardBase(
      category: 'Ensaio de Domingo',
      categoryIcon: Icons.auto_stories_rounded,
      title: 'Retrato\nSociológico',
      subtitle: 'Uma leitura analítica sobre a cultura desta comunidade.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illuminated Essay Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                20,
                side: const BorderSide(color: GrupoTheme.hairlineBorder, width: 1.2),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Editorial Chapter Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CAPÍTULO ÚNICO • ANÁLISE QUALITATIVA',
                      style: GrupoTheme.kicker.copyWith(
                        color: GrupoTheme.accentPrimary,
                        fontSize: 8,
                      ),
                    ),
                    const Icon(
                      Icons.format_quote_rounded,
                      size: 18,
                      color: GrupoTheme.accentPrimary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Illuminated Drop-Cap and Body
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drop-Cap
                    Container(
                      margin: const EdgeInsets.only(right: 12, top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: ShapeDecoration(
                        color: GrupoTheme.cardSurface,
                        shape: SquircleBorder.radius(
                          10,
                          side: const BorderSide(color: GrupoTheme.accentPrimary, width: 1.5),
                        ),
                      ),
                      child: Text(
                        firstChar,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: GrupoTheme.accentPrimary,
                          height: 1.0,
                        ),
                      ),
                    ),

                    // Remainder of text
                    Expanded(
                      child: Text(
                        remainingText,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: GrupoTheme.inkPrimary,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Classical Fleur-de-lis / Asterism divider
                const Center(
                  child: Text(
                    '✦   ✦   ✦',
                    style: TextStyle(
                      color: GrupoTheme.medalGold,
                      fontSize: 12,
                      letterSpacing: 4,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: Text(
                    'Chancela do Observatório Seasons de Comunidades',
                    style: GrupoTheme.captionItalic.copyWith(fontSize: 11),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.06, end: 0),
        ],
      ),
    );
  }
}
