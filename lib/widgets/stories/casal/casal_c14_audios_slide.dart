import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_background_variants.dart';
import 'casal_story_theme.dart';

/// Slide c14: Áudios no Vácuo (Encarte de Vinil / Fita Cassete do Casal)
class CasalC14AudiosSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC14AudiosSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final totalAudios = adapter.totalAudios;
    final mins = adapter.estimatedAudioMinutesFormatted;
    final albumEq = (adapter.estimatedAudioMinutes / 45).toStringAsFixed(1);

    return StoryCardBase(
      category: 'Áudios & Mídias',
      categoryIcon: Icons.mic_none_rounded,
      title: 'Áudios no Vácuo',
      subtitle: 'Minutos de voz, risadas e conversas que poderiam ser podcasts.',
      background: CasalBackgroundVariants.c14Audios(),
      isDarkTheme: true,
      footer: const SeasonsStoryFooter(
        editionTag: "mémoire d'amour",
        inkPrimary: Colors.white,
        inkSecondary: Color(0xFFFB7185),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Vinyl sleeve record representation
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CasalStoryTheme.inkPrimary,
                boxShadow: [
                  BoxShadow(
                    color: CasalStoryTheme.inkPrimary.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer groove ring
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1.0,
                      ),
                    ),
                  ),
                  // Middle groove ring
                  Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1.0,
                      ),
                    ),
                  ),
                  // Vinyl center label
                  Container(
                    width: 65,
                    height: 65,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: CasalStoryTheme.accentPrimary,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.graphic_eq_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().scale(duration: 650.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 24),

            // Colossal audio minutes
            Text(
              '$mins min',
              style: CasalStoryTheme.tabularMetricColossal.copyWith(
                fontSize: 42,
              ),
            ).animate().fadeIn(delay: 200.ms),

            Text(
              'DE ÁUDIOS TROCADOS • ~$albumEq ÁLBUNS OUVIDOS',
              style: CasalStoryTheme.labelKicker.copyWith(
                fontSize: 9.5,
              ),
            ),

            const SizedBox(height: 18),

            // Hero badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: CasalStoryTheme.cardDecoration(
                backgroundColor: CasalStoryTheme.cardSurfaceBlush,
                radius: 14,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.headphones_rounded,
                    size: 16,
                    color: CasalStoryTheme.accentPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${adapter.audioListeningHero} ouviu com mais rapidez ($totalAudios áudios totais)',
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                      color: CasalStoryTheme.inkPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 350.ms),
          ],
        ),
      ),
    );
  }
}
