import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA17DraftSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA17DraftSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final drafts = adapter.unsentDrafts;

    return StoryCardBase(
      background: AmigosBackgroundVariants.a17Draft(),
      isDarkTheme: true,
      backgroundColor: const Color(0xFF111827),
      category: 'Textos Cancelados',
      categoryIcon: Icons.backspace_outlined,
      title: 'Quase Crise\nDiplomática',
      subtitle: 'Momentos de suspense que ficaram no rascunho.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Black & yellow hazard tape banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AmigosTheme.stickerPop,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('⚠️', style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text(
                  'ALERTA DE QUASE-CANCELAMENTO',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Main draft card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: AmigosTheme.cardDecoration(
              radius: 20,
              color: AmigosTheme.cardSurface,
              borderColor: const Color(0xFFF59E0B),
            ),
            child: Column(
              children: [
                // Typing dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AmigosTheme.accentPrimary,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Text(
                  '~$drafts',
                  style: const TextStyle(
                    fontSize: 58,
                    fontWeight: FontWeight.w900,
                    color: AmigosTheme.inkPrimary,
                    fontFeatures: [FontFeature.tabularFigures()],
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'MENSAGENS APAGADAS A TEMPO',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AmigosTheme.inkSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AmigosTheme.hairlineBorder),
                  ),
                  child: const Text(
                    '“Digitou... respirou fundo... apagou tudo e mandou só uma figurinha neutra.”',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AmigosTheme.inkPrimary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms).scale(curve: Curves.easeOutBack),

          const SizedBox(height: 18),

          // Red stamp
          Transform.rotate(
            angle: -0.04,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AmigosTheme.dangerRed, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'SALVO PELO BACKSPACE // CRÍTICO',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AmigosTheme.dangerRed,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 350.ms),
        ],
      ),
    );
  }
}
