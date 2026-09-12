import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_theme.dart';

class AmigosA14AudiosSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA14AudiosSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final author = adapter.podcasterAuthor;
    final count = adapter.totalAudios;
    final mins = adapter.estimatedAudioMinutes;

    return StoryCardBase(
      backgroundColor: AmigosTheme.paperBase,
      category: 'Podcast do WhatsApp',
      categoryIcon: Icons.mic_rounded,
      title: 'O Podcaster do\nSquad',
      subtitle: 'Quem grava episódios inteiros de áudio na conversa.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Podcast album card
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
                        Icon(Icons.graphic_eq_rounded, size: 18, color: AmigosTheme.accentPrimary),
                        SizedBox(width: 6),
                        Text(
                          'SQUADCAST • EP. 01',
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
                        '1.5x VELOCIDADE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: AmigosTheme.inkPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  author,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AmigosTheme.inkPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Apresentador oficial dos monólogos de voz',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AmigosTheme.inkSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // Equalizer wave bars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [14, 28, 44, 20, 52, 36, 16, 48, 60, 32, 22, 54, 40, 18].map((h) {
                    return Container(
                      width: 5,
                      height: h.toDouble(),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: AmigosTheme.accentPrimary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _metric('$count', 'áudios gravados'),
                    Container(width: 1, height: 24, color: AmigosTheme.hairlineBorder),
                    _metric('~$mins min', 'duração estimada'),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).scale(curve: Curves.easeOutBack),

          const SizedBox(height: 16),

          const HazardTapeBanner(
            text: 'OUVINTE OFICIAL REQUER FONES DE OUVIDO',
            angle: 0.02,
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _metric(String val, String desc) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AmigosTheme.inkPrimary,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          desc,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AmigosTheme.inkSecondary,
          ),
        ),
      ],
    );
  }
}
