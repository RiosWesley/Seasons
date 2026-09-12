import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_background_variants.dart';
import 'casal_story_theme.dart';

/// Slide c15: Prints e Arquivos (Moldura Polaroid do Casal)
class CasalC15PrintsSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC15PrintsSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final estimated = adapter.estimatedPrints;

    return StoryCardBase(
      category: 'Arquivo Secreto',
      categoryIcon: Icons.screenshot_monitor_rounded,
      title: 'Prints Tirados\nda Conversa',
      subtitle: 'Estimativa dos momentos eternizados na galeria de fotos.',
      background: CasalBackgroundVariants.c15Prints(),
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
            // Polaroid frame
            Transform.rotate(
              angle: -0.025, // ~ -1.5 degrees
              child: Container(
                width: 260,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: CasalStoryTheme.inkPrimary.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Tape on top
                    Container(
                      width: 55,
                      height: 12,
                      decoration: BoxDecoration(
                        color: CasalStoryTheme.hairlineBorder.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Inner photo container
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: CasalStoryTheme.cardSurfaceBlush,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '~$estimated',
                              style: CasalStoryTheme.tabularMetricColossal.copyWith(
                                fontSize: 48,
                              ),
                            ),
                            Text(
                              'PRINTS SUSPEITOS',
                              style: CasalStoryTheme.labelKicker.copyWith(fontSize: 8.5),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Handwritten style caption
                    const Text(
                      'Arquivo confidencial do casal',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        color: CasalStoryTheme.inkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().scale(duration: 550.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Para guardar com carinho no rolo de câmera (ou puxar como prova em debates futuros 👀)',
                textAlign: TextAlign.center,
                style: CasalStoryTheme.italicSubtitle.copyWith(fontSize: 13),
              ),
            ).animate().fadeIn(delay: 350.ms),
          ],
        ),
      ),
    );
  }
}
