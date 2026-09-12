import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_theme.dart';

class AmigosA6TopConversationsSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA6TopConversationsSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final words = adapter.topWords.take(4).toList();

    return StoryCardBase(
      backgroundColor: AmigosTheme.paperBase,
      category: 'Assuntos em Alta',
      categoryIcon: Icons.topic_rounded,
      title: 'Top Conversas\n& Jargões',
      subtitle: 'Tópicos mais debatidos e gírias do squad.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pinboard header with pushpin icons
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: AmigosTheme.cardDecoration(
                  radius: 18,
                  color: AmigosTheme.cardSurface,
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MURAL DE CLASSIFICADOS DO SQUAD',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AmigosTheme.inkSecondary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...words.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final w = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AmigosTheme.hairlineBorder),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x10000000),
                                offset: Offset(1, 2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: idx == 0 ? AmigosTheme.stickerPop : const Color(0xFFE2E8F0),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '#${idx + 1}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          color: idx == 0 ? AmigosTheme.inkPrimary : AmigosTheme.inkSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    w.word.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AmigosTheme.inkPrimary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${w.count} citações',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AmigosTheme.accentPrimary,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    if (words.isEmpty)
                      const Text(
                        'Assuntos variados sem repetição de jargões.',
                        style: TextStyle(fontSize: 13, color: AmigosTheme.inkSecondary),
                      ),
                  ],
                ),
              ),
              // Corner pushpins
              const Positioned(
                top: -8,
                left: 12,
                child: Text('📌', style: TextStyle(fontSize: 18)),
              ),
              const Positioned(
                top: -8,
                right: 12,
                child: Text('📌', style: TextStyle(fontSize: 18)),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          const HazardTapeBanner(
            text: 'VOCABULÁRIO OFICIAL HOMOLOGADO',
            angle: 0.02,
            backgroundColor: Color(0xFFE0F2FE),
            textColor: AmigosTheme.accentPrimary,
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}
