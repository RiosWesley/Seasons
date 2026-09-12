import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA7HeatmapSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA7HeatmapSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final peakHour = adapter.peakHourFormatted;
    final dayOfWeek = adapter.result.generalStats.mostActiveDayOfWeek.isNotEmpty
        ? adapter.result.generalStats.mostActiveDayOfWeek
        : 'Finais de Semana';
    final activeHours = adapter.activeHours;

    int maxHourActivity = 1;
    for (final h in activeHours) {
      if (h.count > maxHourActivity) maxHourActivity = h.count;
    }

    final isDuo = adapter.isDuo;

    return StoryCardBase(
      background: AmigosBackgroundVariants.a7Heatmap(),
      isDarkTheme: true,
      backgroundColor: const Color(0xFF0B0F19),
      category: 'Picos de Atividade',
      categoryIcon: Icons.access_time_rounded,
      title: isDuo ? 'O Horário da\nDupla' : 'O Horário do\nSquad',
      subtitle: isDuo
          ? 'Quando a resenha entre vocês pega fogo.'
          : 'Quando a resenha pega fogo e o chat explode.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Subway digital clock card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: AmigosTheme.cardDecoration(
              radius: 20,
              color: AmigosTheme.inkPrimary,
              borderColor: AmigosTheme.accentPrimary,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AmigosTheme.accentSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'PICO DE RESENHA',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AmigosTheme.accentSecondary,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  peakHour,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 14),

          // Sticker
          const HazardTapeBanner(
            text: '🚨 HORÁRIO DE PICO DO CAOS',
            angle: -0.02,
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 20),

          // 24-hour block schedule mini grid
          Container(
            padding: const EdgeInsets.all(14),
            decoration: AmigosTheme.cardDecoration(
              radius: 14,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'MAPA 24 HORAS',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AmigosTheme.inkSecondary,
                      ),
                    ),
                    Text(
                      'Dia mais quente: $dayOfWeek',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AmigosTheme.accentPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: List.generate(24, (hour) {
                    final isPeak = hour == adapter.peakHour;
                    final matching = activeHours.where((h) => h.hour == hour);
                    final count = matching.isNotEmpty ? matching.first.count : 0;
                    final intensity = (count / maxHourActivity).clamp(0.1, 1.0);

                    return Container(
                      width: 32,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isPeak
                            ? AmigosTheme.accentPrimary
                            : AmigosTheme.accentPrimary.withValues(alpha: 0.15 + 0.65 * intensity),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '$hour',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: isPeak ? FontWeight.w900 : FontWeight.w600,
                            color: isPeak ? Colors.white : AmigosTheme.inkPrimary,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
