import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_background_variants.dart';
import 'casal_story_theme.dart';

/// Slide c10: Comparação de Hábitos (Lado a Lado / Quem é Quem no Papo)
class CasalC10HabitsComparisonSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC10HabitsComparisonSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final pStats = adapter.participantStats;
    final p1 = pStats.isNotEmpty ? pStats.first : null;
    final p2 = pStats.length > 1 ? pStats[1] : null;

    return StoryCardBase(
      category: 'Lado a Lado',
      categoryIcon: Icons.compare_arrows_rounded,
      title: 'Quem é Quem\nno Papo?',
      subtitle: 'Os estilos e hábitos individuais de cada um.',
      background: CasalBackgroundVariants.c10Habits(),
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Side-by-side card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: CasalStoryTheme.cardDecoration(
                radius: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildPartnerColumn(
                      name: adapter.partner1,
                      emoji: p1?.topEmoji ?? '❤️',
                      word: p1?.topWord ?? 'amor',
                      pct: adapter.partner1Percentage,
                      color: CasalStoryTheme.accentPrimary,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 160,
                    color: CasalStoryTheme.hairlineBorder,
                  ),
                  Expanded(
                    child: _buildPartnerColumn(
                      name: adapter.partner2,
                      emoji: p2?.topEmoji ?? '🥰',
                      word: p2?.topWord ?? 'lindo',
                      pct: adapter.partner2Percentage,
                      color: CasalStoryTheme.accentSecondary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 450.ms),

            const SizedBox(height: 18),

            // Tug of war / dynamic comparison banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: CasalStoryTheme.cardDecoration(
                backgroundColor: CasalStoryTheme.cardSurfaceBlush,
                radius: 14,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 18,
                    color: CasalStoryTheme.accentPrimary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'QUEM MAIS PUXA ASSUNTO',
                          style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9),
                        ),
                        Text(
                          '${adapter.topicStarter} lidera com maior volume de mensagens',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: CasalStoryTheme.inkPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 250.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerColumn({
    required String name,
    required String emoji,
    required String word,
    required int pct,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'serif',
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: CasalStoryTheme.inkPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 4),
        Text(
          'Top Emoji',
          style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9),
        ),
        const SizedBox(height: 10),
        Text(
          '"$word"',
          style: TextStyle(
            fontFamily: 'serif',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Top Palavra',
          style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: CasalStoryTheme.badgeHighlight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$pct% do chat',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}
