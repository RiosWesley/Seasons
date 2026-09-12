import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/monumental_count_up.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_background_variants.dart';
import 'casal_story_theme.dart';

/// Slide c2: Total de Mensagens (Monumental Count Up & Balanço do Casal)
class CasalC2TotalSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC2TotalSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    return StoryCardBase(
      category: 'Volume de Conversa',
      categoryIcon: Icons.forum_rounded,
      title: 'Vocês Falaram\nBastante!',
      subtitle: 'Cada mensagem foi um pedacinho da história.',
      background: CasalBackgroundVariants.c2Total(),
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Daily pace postal seal badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: CasalStoryTheme.badgeHighlight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: CasalStoryTheme.hairlineBorder,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_post_office_outlined,
                    size: 13,
                    color: CasalStoryTheme.accentPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${adapter.dailyMessagePaceFormatted} MSGS / DIA',
                    style: CasalStoryTheme.labelKicker.copyWith(
                      color: CasalStoryTheme.inkPrimary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 20),

            // Monumental count up
            MonumentalCountUp(
              targetValue: adapter.totalMessages,
              label: 'MENSAGENS TROCADAS',
              color: CasalStoryTheme.inkPrimary,
              fontSize: 52,
            ).animate().fadeIn(delay: 150.ms, duration: 450.ms),

            const SizedBox(height: 24),

            // Partner balance card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: CasalStoryTheme.cardDecoration(
                radius: 18,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adapter.partner1,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: CasalStoryTheme.inkPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${adapter.partner1Messages} msgs (${adapter.partner1Percentage}%)',
                              style: const TextStyle(
                                fontSize: 11,
                                color: CasalStoryTheme.inkSecondary,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              adapter.partner2,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: CasalStoryTheme.inkPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${adapter.partner2Messages} msgs (${adapter.partner2Percentage}%)',
                              style: const TextStyle(
                                fontSize: 11,
                                color: CasalStoryTheme.inkSecondary,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress split bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      height: 8,
                      child: Row(
                        children: [
                          Expanded(
                            flex: adapter.partner1Percentage.clamp(1, 99),
                            child: Container(color: CasalStoryTheme.accentPrimary),
                          ),
                          Expanded(
                            flex: adapter.partner2Percentage.clamp(1, 99),
                            child: Container(color: CasalStoryTheme.accentSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Two stats boxes
            Row(
              children: [
                Expanded(
                  child: _statBox(
                    label: 'Média por Dia',
                    value: '${adapter.dailyMessagePaceFormatted} msgs',
                    icon: Icons.speed_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statBox(
                    label: 'Dias Conectados',
                    value: '${adapter.daysTogether} dias',
                    icon: Icons.calendar_month_rounded,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _statBox({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: CasalStoryTheme.cardDecoration(
        backgroundColor: CasalStoryTheme.cardSurfaceBlush,
        radius: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: CasalStoryTheme.accentPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: CasalStoryTheme.labelKicker.copyWith(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'serif',
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: CasalStoryTheme.inkPrimary,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
