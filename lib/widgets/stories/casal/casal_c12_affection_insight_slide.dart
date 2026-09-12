import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_background_variants.dart';
import 'casal_story_theme.dart';

/// Slide c12: Insight de Afeto (Crônica & Diagnóstico Profundo do Casal)
class CasalC12AffectionInsightSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC12AffectionInsightSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    return StoryCardBase(
      category: 'Diagnóstico do Casal',
      categoryIcon: Icons.psychology_alt_rounded,
      title: 'Insight da Sintonia',
      subtitle: 'A essência poética do ritmo e da conversa a dois.',
      background: CasalBackgroundVariants.c12Insight(),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: CasalStoryTheme.cardDecoration(
                backgroundColor: CasalStoryTheme.cardSurface.withValues(alpha: 0.95),
                radius: 24,
              ),
              child: Column(
                children: [
                  // Illuminated opening quote mark
                  const Text(
                    '“',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: CasalStoryTheme.accentPrimary,
                      height: 0.8,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Insight body
                  Text(
                    adapter.primaryInsight,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontStyle: FontStyle.italic,
                      fontSize: 17,
                      height: 1.55,
                      color: CasalStoryTheme.inkPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Star ornament
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 1,
                        color: CasalStoryTheme.hairlineBorder,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '✦',
                          style: TextStyle(
                            color: CasalStoryTheme.accentSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 1,
                        color: CasalStoryTheme.hairlineBorder,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'CRÔNICA RELACIONAL • SEASONS',
                    style: CasalStoryTheme.labelKicker.copyWith(
                      fontSize: 9,
                      color: CasalStoryTheme.inkSecondary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
