import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA12InsightSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA12InsightSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final text = adapter.primaryInsight;
    final isDuo = adapter.isDuo;

    return StoryCardBase(
      background: AmigosBackgroundVariants.a12Insight(),
      isDarkTheme: true,
      backgroundColor: const Color(0xFF0F172A),
      category: 'Diagnóstico da Amizade',
      categoryIcon: Icons.lightbulb_outline_rounded,
      title: isDuo ? 'Manifesto da\nDupla' : 'Manifesto do\nSquad',
      subtitle: isDuo
          ? 'Retrato sobre a química e conexão entre vocês.'
          : 'Retrato sociológico sobre a química do grupo.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tape header
          const HazardTapeBanner(
            text: 'MANIFESTO INDIE • EDIÇÃO LIMITADA',
            angle: -0.02,
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Manifesto text card with big brutalist quote marks
          Container(
            padding: const EdgeInsets.all(22),
            decoration: AmigosTheme.cardDecoration(
              radius: 18,
              color: Colors.white,
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '“',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 48,
                      height: 0.6,
                      fontWeight: FontWeight.w900,
                      color: AmigosTheme.accentPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AmigosTheme.inkPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '”',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 48,
                      height: 0.6,
                      fontWeight: FontWeight.w900,
                      color: AmigosTheme.accentPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 450.ms),

          const SizedBox(height: 20),

          // Stamp mark
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AmigosTheme.accentPrimary, width: 1.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isDuo ? 'ARQUIVADO NO ZINE DA DUPLA' : 'ARQUIVADO NO ZINE DO SQUAD',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: AmigosTheme.accentPrimary,
                letterSpacing: 1.5,
              ),
            ),
          ).animate().fadeIn(delay: 350.ms),
        ],
      ),
    );
  }
}
