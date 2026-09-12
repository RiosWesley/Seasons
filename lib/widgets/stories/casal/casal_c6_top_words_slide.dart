import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_background_variants.dart';
import 'casal_story_theme.dart';

/// Slide c6: Top Palavras (Letterpress & Vocabulário Afetivo do Casal)
class CasalC6TopWordsSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC6TopWordsSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final words = adapter.topWords.take(5).toList();

    return StoryCardBase(
      category: 'Vocabulário',
      categoryIcon: Icons.font_download_rounded,
      title: 'Palavras Mais\nFaladas',
      subtitle: 'O dialeto único e os apelidos da relação.',
      background: CasalBackgroundVariants.c6TopWords(),
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (words.isEmpty)
              const Center(
                child: Text(
                  'Sem palavras registradas',
                  style: TextStyle(fontFamily: 'serif', color: CasalStoryTheme.inkSecondary),
                ),
              )
            else
              ...words.asMap().entries.map((entry) {
                final idx = entry.key;
                final w = entry.value;
                final isTop = idx == 0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: CasalStoryTheme.cardDecoration(
                      backgroundColor: isTop
                          ? CasalStoryTheme.cardSurfaceBlush
                          : CasalStoryTheme.cardSurface,
                      borderColor: isTop
                          ? CasalStoryTheme.accentSecondary
                          : CasalStoryTheme.hairlineBorder,
                      radius: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isTop
                                    ? CasalStoryTheme.accentPrimary
                                    : CasalStoryTheme.badgeHighlight,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${idx + 1}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: isTop ? Colors.white : CasalStoryTheme.inkPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '"${w.word}"',
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontSize: isTop ? 18 : 16,
                                fontWeight: isTop ? FontWeight.w800 : FontWeight.w600,
                                color: CasalStoryTheme.inkPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: CasalStoryTheme.badgeHighlight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${w.count}x',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: CasalStoryTheme.accentPrimary,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 100 * idx), duration: 350.ms);
              }),
          ],
        ),
      ),
    );
  }
}
