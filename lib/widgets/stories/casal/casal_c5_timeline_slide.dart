import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_story_theme.dart';

/// Slide c5: Timeline (Atividade no Tempo / Ritmo dos Meses)
class CasalC5TimelineSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC5TimelineSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final timeline = adapter.timeline;
    final maxCount = timeline.fold<int>(0, (m, e) => e.count > m ? e.count : m);
    final safeMax = maxCount > 0 ? maxCount : 1;
    final peak = adapter.peakTimelineMonth;

    return StoryCardBase(
      category: 'Linha do Tempo',
      categoryIcon: Icons.show_chart_rounded,
      title: 'Ritmo dos Meses',
      subtitle: 'Como o papo fluiu ao longo do tempo.',
      backgroundColor: CasalStoryTheme.paperBase,
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chart card
            Container(
              height: 220,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: CasalStoryTheme.cardDecoration(
                radius: 18,
              ),
              child: timeline.isEmpty
                  ? const Center(
                      child: Text(
                        'Sem histórico temporal registrado',
                        style: TextStyle(fontFamily: 'serif', color: CasalStoryTheme.inkSecondary),
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: timeline.take(6).map((item) {
                        final ratio = item.count / safeMax;
                        final isPeak = item.count == maxCount;

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isPeak)
                                  const Icon(
                                    Icons.push_pin_rounded,
                                    size: 13,
                                    color: CasalStoryTheme.accentPrimary,
                                  ),
                                Text(
                                  '${item.count}',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: isPeak ? FontWeight.w800 : FontWeight.w600,
                                    color: isPeak
                                        ? CasalStoryTheme.accentPrimary
                                        : CasalStoryTheme.inkSecondary,
                                    fontFeatures: const [FontFeature.tabularFigures()],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: (125 * ratio).clamp(10.0, 125.0),
                                  decoration: BoxDecoration(
                                    color: isPeak
                                        ? CasalStoryTheme.accentPrimary
                                        : CasalStoryTheme.badgeHighlight,
                                    borderRadius: BorderRadius.circular(6),
                                    border: isPeak
                                        ? null
                                        : Border.all(
                                            color: CasalStoryTheme.hairlineBorder,
                                            width: 0.8,
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.month,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: isPeak ? FontWeight.w700 : FontWeight.w500,
                                    color: CasalStoryTheme.inkPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            // Peak banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: CasalStoryTheme.cardDecoration(
                backgroundColor: CasalStoryTheme.cardSurfaceBlush,
                radius: 14,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: CasalStoryTheme.accentPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MÊS DE MAIOR INTENSIDADE',
                          style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9),
                        ),
                        Text(
                          '${peak?.month ?? "Constante"} • ${peak?.count ?? adapter.totalMessages} mensagens',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                            color: CasalStoryTheme.inkPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
