import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_background_variants.dart';
import 'casal_story_theme.dart';

/// Slide c7: Heatmap ("A Nossa Hora" - Grade 24h & Horário Sagrado)
class CasalC7HeatmapSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC7HeatmapSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final peakHour = adapter.peakIntimacyFormatted;
    final activeHours = adapter.activeHours;
    final maxHourCount = activeHours.fold<int>(0, (m, h) => h.count > m ? h.count : m);
    final safeMax = maxHourCount > 0 ? maxHourCount : 1;

    return StoryCardBase(
      category: 'Horários & Rotina',
      categoryIcon: Icons.access_time_rounded,
      title: 'A Nossa Hora',
      subtitle: 'O momento em que o dia desacelera e a conversa flui.',
      background: CasalBackgroundVariants.c7Heatmap(),
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
            // Celestial clock dial
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CasalStoryTheme.cardSurfaceBlush,
                border: Border.all(
                  color: CasalStoryTheme.accentSecondary,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CasalStoryTheme.accentPrimary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned(
                    top: 14,
                    child: Icon(
                      Icons.nightlight_round,
                      size: 16,
                      color: CasalStoryTheme.accentPrimary,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        peakHour,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: CasalStoryTheme.inkPrimary,
                          letterSpacing: -1.0,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        'PICO DE AFETO',
                        style: CasalStoryTheme.labelKicker.copyWith(fontSize: 8.5),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 24),

            // 24h mini heatmap grid
            Container(
              padding: const EdgeInsets.all(14),
              decoration: CasalStoryTheme.cardDecoration(
                radius: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DISTRIBUIÇÃO PELAS 24 HORAS',
                        style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9),
                      ),
                      const Text(
                        '0h — 23h',
                        style: TextStyle(
                          fontSize: 10,
                          color: CasalStoryTheme.inkSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 12,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: 24,
                    itemBuilder: (context, index) {
                      final hourData = activeHours.where((h) => h.hour == index).firstOrNull;
                      final count = hourData?.count ?? 0;
                      final intensity = (count / safeMax).clamp(0.08, 1.0);

                      return Container(
                        decoration: BoxDecoration(
                          color: CasalStoryTheme.accentPrimary.withValues(alpha: intensity * 0.85),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 14),

            // Peak day banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: CasalStoryTheme.cardDecoration(
                backgroundColor: CasalStoryTheme.cardSurfaceBlush,
                radius: 12,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: CasalStoryTheme.accentPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dia mais movimentado: ${adapter.peakDayName}',
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: CasalStoryTheme.inkPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 350.ms),
          ],
        ),
      ),
    );
  }
}
