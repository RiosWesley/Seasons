import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_story_theme.dart';

/// Slide c13: Interações Ocultas (O Famoso Vácuo & Carimbo Desculpa a Demora)
class CasalC13HiddenInteractionsSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC13HiddenInteractionsSlide({super.key, required this.adapter});

  static String _formatWait(int ms) {
    if (ms <= 0) return '0 min';
    final hours = ms / 3600000;
    if (hours < 1.0) {
      final mins = (ms / 60000).round();
      return '$mins min';
    }
    return '${hours.toStringAsFixed(1)} horas';
  }

  @override
  Widget build(BuildContext context) {
    final ig = adapter.ignoringStats;

    return StoryCardBase(
      category: 'Interações Ocultas',
      categoryIcon: Icons.timer_off_outlined,
      title: 'O Famoso Vácuo',
      subtitle: 'Quando a vida real chamou e a resposta demorou um pouco mais.',
      backgroundColor: CasalStoryTheme.paperBase,
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Distressed stamp "DESCULPA A DEMORA"
            Transform.rotate(
              angle: -0.09, // ~ -5 degrees
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CasalStoryTheme.accentPrimary,
                    width: 2.2,
                  ),
                ),
                child: Text(
                  'DESCULPA A DEMORA!',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 2.0,
                    color: CasalStoryTheme.accentPrimary.withValues(alpha: 0.88),
                  ),
                ),
              ),
            ).animate().scale(delay: 200.ms, duration: 450.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 24),

            // 2 Stat boxes side by side
            Row(
              children: [
                Expanded(
                  child: _statBox(
                    label: 'Vácuos Dados',
                    value: '${ig.ignoredCount}',
                    icon: Icons.snooze_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statBox(
                    label: 'Vácuos Recebidos',
                    value: '${ig.wasIgnoredCount}',
                    icon: Icons.hourglass_bottom_rounded,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms, duration: 350.ms),

            const SizedBox(height: 14),

            // Longest wait card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: CasalStoryTheme.cardDecoration(
                backgroundColor: CasalStoryTheme.cardSurfaceBlush,
                radius: 14,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.history_toggle_off_rounded,
                    size: 18,
                    color: CasalStoryTheme.accentPrimary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MAIOR ESPERA REGISTRADA',
                          style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9),
                        ),
                        Text(
                          _formatWait(ig.longestIgnoredTimeMs),
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: CasalStoryTheme.inkPrimary,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${adapter.mostPatientPartner} foi paciente',
                    style: CasalStoryTheme.italicSubtitle.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 450.ms, duration: 350.ms),
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
                  style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9.5),
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
              fontSize: 18,
              color: CasalStoryTheme.inkPrimary,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
