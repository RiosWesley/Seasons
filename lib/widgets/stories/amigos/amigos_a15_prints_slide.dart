import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_theme.dart';

class AmigosA15PrintsSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA15PrintsSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final prints = adapter.estimatedPrints;
    final investigator = adapter.printInvestigator;

    return StoryCardBase(
      backgroundColor: AmigosTheme.paperBase,
      category: 'Registro Histórico',
      categoryIcon: Icons.camera_alt_outlined,
      title: 'Dossiê de\nFofoca',
      subtitle: 'Prints e arquivos confidenciais da galeria.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Folder container
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE68A), // Manila folder
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD97706), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x25000000),
                  offset: Offset(3, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB45309),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'ARQUIVO CONFIDENCIAL',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const Text('📎', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  '~$prints',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF78350F),
                    fontFeatures: [FontFeature.tabularFigures()],
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'PRINTS & PROVAS CATALOGADAS',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF92400E),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFD97706)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 16, color: Color(0xFFB45309)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Detetive oficial do squad: $investigator',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF78350F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.08, end: 0.0),

          const SizedBox(height: 18),

          // Red stamp
          Transform.rotate(
            angle: -0.05,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AmigosTheme.dangerRed, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'PROVAS ARQUIVADAS / NÃO VAZAR',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AmigosTheme.dangerRed,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}
