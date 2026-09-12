import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_story_theme.dart';

/// Slide c17: Digitou mas não enviou (Rascunhos & Hesitações do Casal)
class CasalC17TypedUnsendSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC17TypedUnsendSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final typed = adapter.unsentDrafts;

    return StoryCardBase(
      category: 'Pensamentos Secretos',
      categoryIcon: Icons.keyboard_alt_outlined,
      title: 'Digitou e\nApagou...',
      subtitle: 'Textos que foram repensados e guardados no rascunho.',
      backgroundColor: CasalStoryTheme.paperBase,
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Confidential tape badge
            Transform.rotate(
              angle: -0.06,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  color: CasalStoryTheme.badgeHighlight,
                  border: Border.all(color: CasalStoryTheme.accentPrimary, width: 1.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'CONFIDENCIAL • RASCUNHO',
                  style: CasalStoryTheme.labelKicker.copyWith(
                    color: CasalStoryTheme.accentPrimary,
                    fontSize: 9.5,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 20),

            // Card with typing dots and number
            Container(
              padding: const EdgeInsets.all(22),
              decoration: CasalStoryTheme.cardDecoration(
                radius: 20,
              ),
              child: Column(
                children: [
                  // Animated typing bubble
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dot(0),
                      const SizedBox(width: 6),
                      _dot(200),
                      const SizedBox(width: 6),
                      _dot(400),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    '~$typed',
                    style: CasalStoryTheme.tabularMetricColossal.copyWith(
                      fontSize: 52,
                    ),
                  ),

                  Text(
                    'TEXTINHOS REVISADOS',
                    style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9.5),
                  ),
                ],
              ),
            ).animate().scale(delay: 200.ms, duration: 450.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Aquelas mensagens que foram digitadas, relidas e apagadas. O autocontrole venceu.',
                textAlign: TextAlign.center,
                style: CasalStoryTheme.italicSubtitle.copyWith(fontSize: 13),
              ),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _dot(int delayMs) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: CasalStoryTheme.accentPrimary,
        shape: BoxShape.circle,
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          delay: Duration(milliseconds: delayMs),
          duration: 600.ms,
          begin: const Offset(0.7, 0.7),
          end: const Offset(1.3, 1.3),
        );
  }
}
