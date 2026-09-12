import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/story_gauge_meter.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA4CompatibilitySlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA4CompatibilitySlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final score = adapter.compatibilityScore.toDouble().clamp(0.0, 100.0);

    return StoryCardBase(
      background: AmigosBackgroundVariants.a4Compatibility(),
      backgroundColor: AmigosTheme.paperBase,
      category: 'Harmonia do Grupo',
      categoryIcon: Icons.diversity_3_rounded,
      title: 'Sintonia do\nSquad',
      subtitle: 'Índice de sintonia cruzada e dinâmica interna.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gauge meter
          StoryGaugeMeter(
            score: score,
            size: 210,
            activeColor: AmigosTheme.accentPrimary,
            trackColor: const Color(0x202563EB),
            textColor: AmigosTheme.inkPrimary,
            title: 'SINTONIA DO SQUAD',
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 14),

          // Hazard tape pop
          const HazardTapeBanner(
            text: '⚡ ALTO TEOR DE ZOEIRA & SINTONIA',
            angle: -0.03,
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 20),

          // Diagnostic description card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: AmigosTheme.cardDecoration(
              radius: 14,
            ),
            child: Column(
              children: [
                Text(
                  adapter.compatibilityDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AmigosTheme.inkPrimary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _subMetric('Sintonia', '${score.round()}%'),
                    Container(width: 1, height: 24, color: AmigosTheme.hairlineBorder),
                    _subMetric('Caos', '${(100 - score * 0.3).round()}%'),
                    Container(width: 1, height: 24, color: AmigosTheme.hairlineBorder),
                    _subMetric('Lealdade', '100%'),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 350.ms, duration: 450.ms),
        ],
      ),
    );
  }

  Widget _subMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AmigosTheme.accentPrimary,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AmigosTheme.inkSecondary,
          ),
        ),
      ],
    );
  }
}
