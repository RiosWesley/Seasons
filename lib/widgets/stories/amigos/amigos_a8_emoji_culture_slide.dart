import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA8EmojiCultureSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA8EmojiCultureSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final emojis = adapter.topEmojis.take(5).toList();

    return StoryCardBase(
      background: AmigosBackgroundVariants.a8EmojiCulture(),
      backgroundColor: AmigosTheme.paperBase,
      category: 'Cultura do Squad',
      categoryIcon: Icons.mood_rounded,
      title: 'Emoji Culture',
      subtitle: 'Álbum de figurinhas recortadas da resenha.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AmigosTheme.hairlineBorder),
            ),
            child: const Text(
              'STICKERS OFICIAIS COLECIONÁVEIS',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AmigosTheme.accentPrimary,
                letterSpacing: 1.2,
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 24),

          // Stickers with die-cut white borders
          Wrap(
            spacing: 16,
            runSpacing: 18,
            alignment: WrapAlignment.center,
            children: emojis.asMap().entries.map((entry) {
              final idx = entry.key;
              final e = entry.value;
              final angles = [-0.07, 0.05, -0.04, 0.08, -0.03];
              final angle = angles[idx % angles.length];

              return Transform.rotate(
                angle: angle,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: idx == 0 ? AmigosTheme.accentPrimary : const Color(0xFFCBD5E1),
                      width: 2.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x280F172A),
                        offset: Offset(2, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(e.emoji, style: const TextStyle(fontSize: 36)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: idx == 0 ? AmigosTheme.stickerPop : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${e.count}x',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: idx == 0 ? AmigosTheme.inkPrimary : AmigosTheme.inkSecondary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 200.ms, duration: 450.ms),

          const SizedBox(height: 24),

          const HazardTapeBanner(
            text: 'HOMOLOGADO NO ÁLBUM DO SQUAD',
            angle: 0.02,
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}
