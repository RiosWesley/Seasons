import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA5TimelineSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA5TimelineSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final timeline = adapter.timeline;
    final peak = adapter.peakTimelineMonth;
    final maxCount = peak != null && peak.count > 0 ? peak.count : 1;

    return StoryCardBase(
      background: AmigosBackgroundVariants.a5Timeline(),
      isDarkTheme: true,
      backgroundColor: const Color(0xFF0A1128),
      category: 'Histórico Mensal',
      categoryIcon: Icons.show_chart_rounded,
      title: 'Sismógrafo de\nResenhas',
      subtitle: 'Picos de tretas, saídas e comemorações.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: AmigosTheme.cardDecoration(
              radius: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.waves_rounded, size: 16, color: AmigosTheme.accentPrimary),
                        SizedBox(width: 6),
                        Text(
                          'ATIVIDADE TEMPORAL',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AmigosTheme.inkSecondary,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    if (peak != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AmigosTheme.stickerPop,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'PICO: ${peak.month.toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: AmigosTheme.inkPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ...timeline.take(5).map((t) {
                  final isPeak = peak != null && t.month == peak.month;
                  final ratio = (t.count / maxCount).clamp(0.08, 1.0);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 64,
                          child: Text(
                            t.month,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isPeak ? FontWeight.w900 : FontWeight.w700,
                              color: isPeak ? AmigosTheme.accentPrimary : AmigosTheme.inkPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: isPeak ? 12 : 8,
                              backgroundColor: const Color(0xFFDBEAFE),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isPeak ? AmigosTheme.accentPrimary : AmigosTheme.accentSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${t.count}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isPeak ? AmigosTheme.accentPrimary : AmigosTheme.inkSecondary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // Seismograph note
          if (peak != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                border: Border.all(color: AmigosTheme.hairlineBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.flash_on_rounded, size: 16, color: AmigosTheme.accentPrimary),
                  const SizedBox(width: 6),
                  Text(
                    '${peak.month} registrou a maior concentração de tretas do ano',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AmigosTheme.inkPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}
