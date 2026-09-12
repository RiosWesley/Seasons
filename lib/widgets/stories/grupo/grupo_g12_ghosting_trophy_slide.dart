import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_background_variants.dart';
import 'grupo_theme.dart';

/// Slide g12: Quem Mais Ignora ("Troféu Vácuo de Ouro" em pedestal de pedra)
class GrupoG12GhostingTrophySlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG12GhostingTrophySlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final champ = adapter.vacuumChampion;
    final count = adapter.vacuumCount;

    return StoryCardBase(
      background: GrupoBackgroundVariants.g12GhostingTrophy(),
      isDarkTheme: true,
      backgroundColor: const Color(0xFF1B0B33),
      category: 'Gabinete do Silêncio',
      categoryIcon: Icons.hourglass_empty_rounded,
      title: 'O Troféu Vácuo\nde Ouro',
      subtitle: 'Homenagem ao mestre supremo da diplomacia silenciosa.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Golden Trophy Monument
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                20,
                side: const BorderSide(color: GrupoTheme.hairlineBorder, width: 1.2),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.medalGold.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Trophy Icon in Golden Halo
                Container(
                  width: 72,
                  height: 72,
                  decoration: ShapeDecoration(
                    color: GrupoTheme.medalGold.withValues(alpha: 0.15),
                    shape: SquircleBorder.radius(20),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: GrupoTheme.medalGold,
                    size: 42,
                  ),
                ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

                const SizedBox(height: 18),

                Text(
                  'ORDEM DO SILÊNCIO REFLEXIVO',
                  style: GrupoTheme.kicker.copyWith(
                    color: const Color(0xFF854D0E),
                    fontSize: 9,
                  ),
                ),

                const SizedBox(height: 6),

                // Winner Name
                Text(
                  champ,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: GrupoTheme.inkPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                // Stone Pedestal / Metric Plaque
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF1F5F9), // Slate stone
                    shape: SquircleBorder.radius(
                      10,
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timer_off_outlined,
                        size: 16,
                        color: GrupoTheme.inkSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$count ocasiões de reflexão prolongada',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: GrupoTheme.inkPrimary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  '“Não foi esquecimento, foi prudência meditativa antes de emitir parecer no coletivo.”',
                  textAlign: TextAlign.center,
                  style: GrupoTheme.captionItalic.copyWith(fontSize: 12),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }
}
