import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_story_theme.dart';

/// Slide c3: Love Language (As 4 Linguagens do Amor do Casal)
class CasalC3LoveLanguageSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC3LoveLanguageSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final ll = adapter.loveLanguage;
    final total = ll.hearts + ll.romanticWords + ll.memes + ll.directTexts;
    final safeTotal = total > 0 ? total : 1;

    final dominant = adapter.dominantLoveLanguageName;

    return StoryCardBase(
      category: 'Love Language',
      categoryIcon: Icons.favorite_border_rounded,
      title: 'A Linguagem do\nAmor de Vocês',
      subtitle: 'Como o afeto se traduziu em palavras e sinais.',
      backgroundColor: CasalStoryTheme.paperBase,
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dominant language highlight banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: CasalStoryTheme.cardDecoration(
                backgroundColor: CasalStoryTheme.cardSurfaceBlush,
                borderColor: CasalStoryTheme.accentSecondary,
                radius: 14,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: CasalStoryTheme.accentPrimary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LINGUAGEM DOMINANTE',
                          style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9),
                        ),
                        Text(
                          dominant,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: CasalStoryTheme.inkPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 16),

            // 4 Language cards
            _buildLanguageCard(
              title: 'Corações & Afeto',
              count: ll.hearts,
              pct: (ll.hearts / safeTotal * 100).round(),
              icon: Icons.favorite_rounded,
              color: CasalStoryTheme.accentPrimary,
              delayMs: 100,
            ),
            const SizedBox(height: 10),

            _buildLanguageCard(
              title: 'Palavras de Amor',
              count: ll.romanticWords,
              pct: (ll.romanticWords / safeTotal * 100).round(),
              icon: Icons.chat_bubble_rounded,
              color: CasalStoryTheme.accentSecondary,
              delayMs: 200,
            ),
            const SizedBox(height: 10),

            _buildLanguageCard(
              title: 'Memes & Risadas',
              count: ll.memes,
              pct: (ll.memes / safeTotal * 100).round(),
              icon: Icons.sentiment_very_satisfied_rounded,
              color: const Color(0xFFF59E0B),
              delayMs: 300,
            ),
            const SizedBox(height: 10),

            _buildLanguageCard(
              title: 'Conversas Diretas',
              count: ll.directTexts,
              pct: (ll.directTexts / safeTotal * 100).round(),
              icon: Icons.send_rounded,
              color: const Color(0xFF0284C7),
              delayMs: 400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String title,
    required int count,
    required int pct,
    required IconData icon,
    required Color color,
    required int delayMs,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: CasalStoryTheme.cardDecoration(
        radius: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: CasalStoryTheme.inkPrimary,
                  ),
                ),
              ),
              Text(
                '$count ($pct%)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: CasalStoryTheme.inkSecondary,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (pct / 100.0).clamp(0.02, 1.0),
              minHeight: 5,
              backgroundColor: CasalStoryTheme.badgeHighlight,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delayMs), duration: 350.ms);
  }
}
