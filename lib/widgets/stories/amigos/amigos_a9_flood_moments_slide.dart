import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA9FloodMomentsSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA9FloodMomentsSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final author = adapter.biggestFloodAuthor;
    final count = adapter.biggestFloodCount;

    final isDuo = adapter.isDuo;

    return StoryCardBase(
      background: AmigosBackgroundVariants.a9FloodMoments(),
      isDarkTheme: true,
      backgroundColor: const Color(0xFF1D4ED8),
      category: 'Inundação de Mensagens',
      categoryIcon: Icons.waves_rounded,
      title: 'O Rei do\nMonólogo',
      subtitle: isDuo
          ? 'Recorde de mensagens seguidas sem resposta do amigo.'
          : 'Recorde de mensagens seguidas sem resposta.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Comic explosion callout badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AmigosTheme.dangerRed,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Text(
              '💥 ALERTA DE FLOOD RECORD',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 18),

          // Main flood card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: AmigosTheme.cardDecoration(
              radius: 20,
              color: AmigosTheme.cardSurface,
              borderColor: AmigosTheme.accentPrimary,
            ),
            child: Column(
              children: [
                Text(
                  author,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AmigosTheme.inkPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    color: AmigosTheme.accentPrimary,
                    fontFeatures: [FontFeature.tabularFigures()],
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'MENSAGENS CONSECUTIVAS',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AmigosTheme.inkSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Simulated speech bubble waterfall
                Column(
                  children: [
                    _bubble(isDuo ? 'Cadê você??' : 'Alguém online aí??', true),
                    const SizedBox(height: 6),
                    _bubble(isDuo ? 'Você não tá entendendo kkkk' : 'Gente cês não tão entendendo kkkk', true),
                    const SizedBox(height: 6),
                    _bubble(isDuo ? 'Alô??? Me responde 😭' : 'Alô??? Socorro 😭', false),
                  ],
                ),
              ],
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 16),

          const HazardTapeBanner(
            text: 'TROFÉU MONÓLOGO DE OURO',
            angle: -0.02,
          ).animate().fadeIn(delay: 350.ms),
        ],
      ),
    );
  }

  Widget _bubble(String text, bool left) {
    return Align(
      alignment: left ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AmigosTheme.hairlineBorder),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AmigosTheme.inkSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
