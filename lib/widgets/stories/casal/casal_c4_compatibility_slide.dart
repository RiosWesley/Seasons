import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import '../shared/story_gauge_meter.dart';
import 'casal_story_theme.dart';

/// Slide c4: Compatibilidade (StoryGaugeMeter & Diagnóstico Lírico do Casal)
class CasalC4CompatibilitySlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC4CompatibilitySlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    return StoryCardBase(
      category: 'Índice de Sintonia',
      categoryIcon: Icons.auto_awesome_rounded,
      title: 'Compatibilidade',
      subtitle: 'Algoritmo de afinidade baseado em resposta e estilo.',
      backgroundColor: CasalStoryTheme.paperBase,
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Retro gauge meter
            StoryGaugeMeter(
              score: adapter.compatibilityScore.toDouble(),
              size: 210,
              activeColor: CasalStoryTheme.accentPrimary,
              trackColor: CasalStoryTheme.hairlineBorder,
              textColor: CasalStoryTheme.inkPrimary,
              title: 'SINTONIA DO CASAL',
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 24),

            // Lyrical relational diagnosis in parchment card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: CasalStoryTheme.cardDecoration(
                backgroundColor: CasalStoryTheme.cardSurfaceBlush,
                radius: 18,
              ),
              child: Column(
                children: [
                  const Text(
                    '✦',
                    style: TextStyle(
                      color: CasalStoryTheme.accentPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"${adapter.compatibilityDescription}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      height: 1.45,
                      color: CasalStoryTheme.inkPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'DIAGNÓSTICO RELACIONAL',
                    style: CasalStoryTheme.labelKicker.copyWith(
                      fontSize: 9,
                      color: CasalStoryTheme.inkSecondary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
