import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_theme.dart';

class AmigosA3StylesSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA3StylesSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final styles = adapter.communicationStyles;

    return StoryCardBase(
      backgroundColor: AmigosTheme.paperBase,
      category: 'Arquétipos do Squad',
      categoryIcon: Icons.badge_outlined,
      title: 'Estilos de\nComunicação',
      subtitle: 'O papel natural de cada amigo na conversa.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...styles.take(4).toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final s = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: AmigosTheme.cardDecoration(
                  radius: 14,
                  color: AmigosTheme.cardSurface,
                  borderColor: idx == 0 ? AmigosTheme.accentPrimary : AmigosTheme.hairlineBorder,
                ),
                child: Row(
                  children: [
                    // Avatar / Emoji badge
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AmigosTheme.hairlineBorder),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x12000000),
                            offset: Offset(1, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          s.emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  s.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AmigosTheme.inkPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AmigosTheme.stickerPop.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'CARD OFICIAL',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    color: AmigosTheme.inkSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            s.style.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AmigosTheme.accentPrimary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (100 * idx).ms, duration: 400.ms).slideY(begin: 0.1, end: 0.0);
          }),
          if (styles.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Squad equilibrado com sintonia natural em todos os assuntos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AmigosTheme.inkSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
