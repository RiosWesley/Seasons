import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_story_theme.dart';

/// Slide c11: Estatísticas do Cotidiano (Constância & Tempo de Resposta)
class CasalC11DailyStatsSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC11DailyStatsSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    return StoryCardBase(
      category: 'Velocidade de Resposta',
      categoryIcon: Icons.bolt_rounded,
      title: 'Ritmo do Cotidiano',
      subtitle: 'A rapidez e a constância da presença um do outro.',
      backgroundColor: CasalStoryTheme.paperBase,
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row 1: Average response time
            _buildStatRow(
              title: 'Tempo Médio de Resposta',
              value: adapter.averageResponseTimeFormatted,
              subtitle: 'Rapidez na troca de mensagens no dia a dia',
              icon: Icons.timer_outlined,
              delayMs: 100,
            ),

            const SizedBox(height: 12),

            // Row 2: Daily pace
            _buildStatRow(
              title: 'Média Diária',
              value: '${adapter.dailyMessagePaceFormatted} msgs',
              subtitle: 'Ritmo contínuo em dias normais e fins de semana',
              icon: Icons.speed_rounded,
              delayMs: 200,
            ),

            const SizedBox(height: 12),

            // Row 3: Days together
            _buildStatRow(
              title: 'Dias Conectados',
              value: '${adapter.daysTogether} dias',
              subtitle: 'De conexão ativa ininterrupta registrada',
              icon: Icons.calendar_month_rounded,
              delayMs: 300,
            ),

            const SizedBox(height: 20),

            // Oval certificate stamp
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: CasalStoryTheme.badgeHighlight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: CasalStoryTheme.hairlineBorder,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    size: 14,
                    color: CasalStoryTheme.accentPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'CERTIFICADO DE CONSTÂNCIA DO CASAL',
                    style: CasalStoryTheme.labelKicker.copyWith(
                      color: CasalStoryTheme.inkPrimary,
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 450.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required int delayMs,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: CasalStoryTheme.cardDecoration(
        radius: 16,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CasalStoryTheme.badgeHighlight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: CasalStoryTheme.accentPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: CasalStoryTheme.inkPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: CasalStoryTheme.italicSubtitle.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'serif',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: CasalStoryTheme.accentPrimary,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delayMs), duration: 350.ms);
  }
}
