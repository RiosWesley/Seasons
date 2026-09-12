import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/monumental_count_up.dart';
import 'amigos_theme.dart';

class AmigosA2TotalImpactSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA2TotalImpactSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final total = adapter.totalMessages > 0 ? adapter.totalMessages : 1;
    final days = adapter.result.generalStats.activeDaysCount > 0
        ? adapter.result.generalStats.activeDaysCount
        : 1;
    final sortedMembers = adapter.sortedMemberVolumes;

    return StoryCardBase(
      backgroundColor: AmigosTheme.paperBase,
      category: 'Movimentação do Squad',
      categoryIcon: Icons.chat_bubble_outline_rounded,
      title: 'O Grupo Não\nParou Um Segundo',
      subtitle: 'Volume anual e impacto da resenha.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Monumental counter
          MonumentalCountUp(
            targetValue: adapter.totalMessages,
            fontSize: 56,
            color: AmigosTheme.accentPrimary,
            label: 'MENSAGENS DO SQUAD',
          ),

          const SizedBox(height: 20),

          // Member distribution card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AmigosTheme.cardDecoration(
              radius: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'DISTRIBUIÇÃO DE VOZ',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AmigosTheme.inkSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      '$days dias ativos',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AmigosTheme.accentPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...sortedMembers.take(4).map((entry) {
                  final pct = (entry.value / total).clamp(0.0, 1.0);
                  final pctFormatted = (pct * 100).round();

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AmigosTheme.inkPrimary,
                              ),
                            ),
                            Text(
                              '${entry.value} ($pctFormatted%)',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AmigosTheme.inkSecondary,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFDBEAFE),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AmigosTheme.accentPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // Receipt footer note
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Média de ${(adapter.totalMessages / days).round()} msgs por dia ativo',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AmigosTheme.inkSecondary,
              ),
            ),
          ).animate().fadeIn(delay: 350.ms),
        ],
      ),
    );
  }
}
