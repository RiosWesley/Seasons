import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA16ForwardedSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA16ForwardedSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final supplier = adapter.memeSupplier;
    final forwarded = adapter.forwardedMemes;

    return StoryCardBase(
      background: AmigosBackgroundVariants.a16Forwarded(),
      backgroundColor: AmigosTheme.paperBase,
      category: 'Circulação de Links',
      categoryIcon: Icons.forward_rounded,
      title: 'Central de\nTransmissão',
      subtitle: adapter.isDuo
          ? 'Quem abastece a conversa com memes e links externos.'
          : 'Quem abastece o grupo com memes e links externos.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Radio tower / Teletype card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: AmigosTheme.cardDecoration(
              radius: 20,
              color: AmigosTheme.cardSurface,
              borderColor: AmigosTheme.accentPrimary,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cell_tower_rounded, size: 18, color: AmigosTheme.accentPrimary),
                        SizedBox(width: 6),
                        Text(
                          'NEWS WIRE 24/7',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AmigosTheme.accentPrimary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AmigosTheme.stickerPop,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'ON AIR',
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
                Text(
                  '~$forwarded',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: AmigosTheme.accentPrimary,
                    fontFeatures: [FontFeature.tabularFigures()],
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'LINKS & MEMES REPASSADOS',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AmigosTheme.inkSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AmigosTheme.hairlineBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.share_location_rounded, size: 18, color: AmigosTheme.accentPrimary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CORRESPONDENTE INTERNACIONAL',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AmigosTheme.inkSecondary,
                              ),
                            ),
                            Text(
                              supplier,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AmigosTheme.inkPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // Ticker line
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AmigosTheme.hairlineBorder),
            ),
            child: const Text(
              'TIKTOK • FOFOCAS • VÍDEOS • MEMES EXTERNOS',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: AmigosTheme.accentPrimary,
                letterSpacing: 1.0,
              ),
            ),
          ).animate().fadeIn(delay: 250.ms),
        ],
      ),
    );
  }
}
