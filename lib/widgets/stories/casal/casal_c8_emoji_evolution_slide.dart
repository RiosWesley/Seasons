import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_background_variants.dart';
import 'casal_story_theme.dart';

/// Slide c8: Evolução de Emojis (Altar & Pódio dos Emojis do Casal)
class CasalC8EmojiEvolutionSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC8EmojiEvolutionSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final emojis = adapter.topEmojis.take(3).toList();
    final first = emojis.isNotEmpty ? emojis[0] : null;
    final second = emojis.length > 1 ? emojis[1] : null;
    final third = emojis.length > 2 ? emojis[2] : null;

    return StoryCardBase(
      category: 'Expressão Visual',
      categoryIcon: Icons.sentiment_satisfied_alt_rounded,
      title: 'Top Emojis do\nCasal',
      subtitle: 'As reações que dispensaram palavras e marcaram o ano.',
      background: CasalBackgroundVariants.c8EmojiEvolution(),
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Triple altar / podium
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: CasalStoryTheme.cardDecoration(
                radius: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // #2 Left
                  if (second != null)
                    Expanded(
                      child: _buildPodiumStep(
                        emoji: second.emoji,
                        count: second.count,
                        rank: '2º',
                        height: 90,
                        isLeader: false,
                      ),
                    )
                  else
                    const Spacer(),

                  const SizedBox(width: 10),

                  // #1 Center (Highest)
                  if (first != null)
                    Expanded(
                      child: _buildPodiumStep(
                        emoji: first.emoji,
                        count: first.count,
                        rank: '1º',
                        height: 125,
                        isLeader: true,
                      ),
                    )
                  else
                    const Spacer(),

                  const SizedBox(width: 10),

                  // #3 Right
                  if (third != null)
                    Expanded(
                      child: _buildPodiumStep(
                        emoji: third.emoji,
                        count: third.count,
                        rank: '3º',
                        height: 75,
                        isLeader: false,
                      ),
                    )
                  else
                    const Spacer(),
                ],
              ),
            ).animate().fadeIn(duration: 450.ms),

            const SizedBox(height: 20),

            // Lyrical caption card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: CasalStoryTheme.cardDecoration(
                backgroundColor: CasalStoryTheme.cardSurfaceBlush,
                radius: 14,
              ),
              child: Row(
                children: [
                  const Text('❤️', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'O emoji campeão foi disparado ${first?.count ?? 0} vezes como batimento contínuo da conversa.',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontStyle: FontStyle.italic,
                        fontSize: 12.5,
                        color: CasalStoryTheme.inkPrimary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumStep({
    required String emoji,
    required int count,
    required String rank,
    required double height,
    required bool isLeader,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Pulsing emoji if leader
        Text(
          emoji,
          style: TextStyle(fontSize: isLeader ? 38 : 30),
        ).animate(
          onPlay: (controller) => isLeader ? controller.repeat(reverse: true) : null,
        ).scale(
          begin: const Offset(1, 1),
          end: isLeader ? const Offset(1.15, 1.15) : const Offset(1, 1),
          duration: 900.ms,
          curve: Curves.easeInOut,
        ),

        const SizedBox(height: 6),

        Text(
          '$count',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isLeader ? CasalStoryTheme.accentPrimary : CasalStoryTheme.inkSecondary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),

        const SizedBox(height: 6),

        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isLeader ? CasalStoryTheme.accentPrimary : CasalStoryTheme.badgeHighlight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            border: isLeader
                ? null
                : Border.all(color: CasalStoryTheme.hairlineBorder, width: 0.8),
          ),
          child: Center(
            child: Text(
              rank,
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: isLeader ? Colors.white : CasalStoryTheme.inkPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
