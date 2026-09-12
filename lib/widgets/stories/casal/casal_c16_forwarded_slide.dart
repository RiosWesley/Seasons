import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_story_theme.dart';

/// Slide c16: Encaminhamentos (Envelope Airmail "Par Avion" do Casal)
class CasalC16ForwardedSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC16ForwardedSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final fwd = adapter.forwardedMemes;

    return StoryCardBase(
      category: 'Trânsito de Notícias',
      categoryIcon: Icons.forward_rounded,
      title: 'Fofocas &\nEncaminhamentos',
      subtitle: 'Memes, vídeos e links que moldaram o humor do casal.',
      backgroundColor: CasalStoryTheme.paperBase,
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Airmail envelope card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CasalStoryTheme.cardSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: CasalStoryTheme.hairlineBorder,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CasalStoryTheme.inkPrimary.withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Airmail top stripe header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: CasalStoryTheme.badgeHighlight,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: CasalStoryTheme.accentPrimary, width: 0.8),
                        ),
                        child: Text(
                          'PAR AVION',
                          style: CasalStoryTheme.labelKicker.copyWith(
                            color: CasalStoryTheme.accentPrimary,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.send_rounded,
                        size: 16,
                        color: CasalStoryTheme.accentPrimary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Colossal metric
                  Text(
                    '~$fwd',
                    style: CasalStoryTheme.tabularMetricColossal.copyWith(
                      fontSize: 50,
                    ),
                  ),

                  Text(
                    'MENSAGENS & MEMES REPASSADOS',
                    style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9),
                  ),

                  const SizedBox(height: 18),

                  // Quote card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: CasalStoryTheme.cardSurfaceBlush,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '"Amor, olha isso aqui rápido!"',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: CasalStoryTheme.inkPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().scale(duration: 550.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 20),

            Text(
              'A central compartilhada de risadas e fofocas diárias.',
              style: CasalStoryTheme.italicSubtitle.copyWith(fontSize: 13),
            ).animate().fadeIn(delay: 350.ms),
          ],
        ),
      ),
    );
  }
}
