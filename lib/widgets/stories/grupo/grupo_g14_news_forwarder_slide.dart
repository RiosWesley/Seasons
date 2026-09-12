import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_theme.dart';

/// Slide g14: Quem Mais Encaminha (Estação central de notícias e memes via adapter)
class GrupoG14NewsForwarderSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG14NewsForwarderSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final forwarder = adapter.forwarderName;
    final forwardCount = adapter.forwardedCount;

    return StoryCardBase(
      category: 'Central de Notícias',
      categoryIcon: Icons.forward_to_inbox_rounded,
      title: 'A Central de\nDespachos',
      subtitle: 'A agência teletipo que abastece o chat com links e memes.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Telegraph Agency Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                20,
                side: const BorderSide(color: GrupoTheme.hairlineBorder, width: 1.2),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Morse Code Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: ShapeDecoration(
                    color: GrupoTheme.cardSurface,
                    shape: SquircleBorder.radius(6),
                  ),
                  child: const Text(
                    '• • •   — — —   • • •',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: GrupoTheme.accentPrimary,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Antenna / Transmitter Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: ShapeDecoration(
                    color: GrupoTheme.cardSurface,
                    shape: SquircleBorder.radius(18),
                  ),
                  child: const Icon(
                    Icons.cell_tower_rounded,
                    color: GrupoTheme.accentPrimary,
                    size: 34,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  'CORRESPONDENTE INTERNACIONAL',
                  style: GrupoTheme.kicker.copyWith(
                    color: GrupoTheme.accentPrimary,
                    fontSize: 9,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  forwarder,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: GrupoTheme.inkPrimary,
                  ),
                ),

                const SizedBox(height: 14),

                // Teletype Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF8FAFC),
                    shape: SquircleBorder.radius(
                      12,
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '~$forwardCount',
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: GrupoTheme.accentPrimary,
                          height: 1.0,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'MEMES E DESPACHOS ENCAMINHADOS',
                        style: GrupoTheme.kicker.copyWith(fontSize: 9),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Atua como a Reuters oficial do grupo: nenhuma novidade da internet chega sem antes passar por aqui.',
                  textAlign: TextAlign.center,
                  style: GrupoTheme.captionItalic.copyWith(fontSize: 12),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }
}
