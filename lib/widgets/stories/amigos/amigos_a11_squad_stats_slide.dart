import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_theme.dart';

class AmigosA11SquadStatsSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA11SquadStatsSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final speed = adapter.averageResponseTimeFormatted;
    final fastest = adapter.fastestReplier;
    final fastestTime = adapter.friendStats.fastestReplyTimeFormatted;
    final days = adapter.result.generalStats.activeDaysCount > 0
        ? adapter.result.generalStats.activeDaysCount
        : 1;
    final dailyAvg = (adapter.totalMessages / days).round();

    return StoryCardBase(
      backgroundColor: AmigosTheme.paperBase,
      category: 'Destaques do Squad',
      categoryIcon: Icons.speed_rounded,
      title: 'Telemetria do\nSquad',
      subtitle: 'Velocímetro de resposta e métricas de engajamento.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Telemetry card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AmigosTheme.cardDecoration(
              radius: 18,
              color: AmigosTheme.cardSurface,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 16, color: AmigosTheme.accentPrimary),
                        SizedBox(width: 6),
                        Text(
                          'PAINEL DE TELEMETRIA',
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AmigosTheme.stickerPop,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE SENSORS',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: AmigosTheme.inkPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _statBox(
                        'TEMPO MÉDIO',
                        speed,
                        'espera típica',
                        Icons.hourglass_top_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statBox(
                        'MÉDIA DIÁRIA',
                        '$dailyAvg msgs',
                        'por dia ativo',
                        Icons.flash_on_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AmigosTheme.hairlineBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RESPOSTA MAIS RÁPIDA',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AmigosTheme.accentPrimary,
                            ),
                          ),
                          Text(
                            fastest,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AmigosTheme.inkPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          fastestTime,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AmigosTheme.accentPrimary,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          const ZineBarcode(
            code: 'TELEMETRY-SQUAD-2025',
            height: 24,
            color: AmigosTheme.inkSecondary,
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, String sub, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AmigosTheme.hairlineBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AmigosTheme.accentPrimary),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: AmigosTheme.inkSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AmigosTheme.inkPrimary,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AmigosTheme.inkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
