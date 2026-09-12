import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_theme.dart';

class AmigosA10PersonalitiesSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA10PersonalitiesSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final titles = [
      (
        'Mais Rápido no Gatilho',
        adapter.fastestReplier,
        '⚡',
        'Respostas em tempo recorde',
      ),
      (
        'O Podcaster de Áudios',
        adapter.podcasterAuthor,
        '🎙️',
        'Áudios com duração de podcast',
      ),
      (
        'Líder de Pautas',
        adapter.memeSupplier,
        '🔥',
        'Iniciador oficial das conversas',
      ),
    ];

    return StoryCardBase(
      backgroundColor: AmigosTheme.paperBase,
      category: 'Personalidades',
      categoryIcon: Icons.psychology_rounded,
      title: 'Títulos\nHonorários',
      subtitle: 'Condecorações oficiais outorgadas pelo squad.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...titles.asMap().entries.map((entry) {
            final idx = entry.key;
            final t = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: AmigosTheme.cardDecoration(
                  radius: 16,
                  color: AmigosTheme.cardSurface,
                  borderColor: idx == 0 ? AmigosTheme.accentPrimary : AmigosTheme.hairlineBorder,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AmigosTheme.hairlineBorder),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x10000000),
                            offset: Offset(1, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(t.$3, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.$1.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: AmigosTheme.accentPrimary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t.$2,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AmigosTheme.inkPrimary,
                            ),
                          ),
                          Text(
                            t.$4,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AmigosTheme.inkSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (120 * idx).ms, duration: 400.ms).slideY(begin: 0.1, end: 0.0);
          }),

          const SizedBox(height: 12),

          const HazardTapeBanner(
            text: '🏅 CONDECORAÇÕES OFICIAIS DO ANO',
            angle: -0.02,
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}
