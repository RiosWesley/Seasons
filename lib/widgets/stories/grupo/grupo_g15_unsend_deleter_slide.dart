import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_theme.dart';

/// Slide g15: Quem Mais Apaga (Fantasma do chat invisível com fumaça evanescente via adapter)
class GrupoG15UnsendDeleterSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG15UnsendDeleterSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final ghost = adapter.unsendGhostName;
    final delCount = adapter.unsendCount;

    return StoryCardBase(
      category: 'Arquivo Invisível',
      categoryIcon: Icons.auto_delete_rounded,
      title: 'O Fantasma\ndo Chat',
      subtitle: 'O líder das mensagens apagadas antes que alguém pudesse ler.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ghost Mystery Box
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
                // Evanescent Ghost Icon
                Container(
                  width: 68,
                  height: 68,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF1F5F9),
                    shape: SquircleBorder.radius(20),
                  ),
                  child: const Icon(
                    Icons.blur_on_rounded,
                    color: GrupoTheme.inkSecondary,
                    size: 38,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'ESPECIALISTA EM APAGAMENTO',
                  style: GrupoTheme.kicker.copyWith(
                    color: GrupoTheme.inkSecondary,
                    fontSize: 9,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  ghost,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: GrupoTheme.inkPrimary,
                  ),
                ),

                const SizedBox(height: 14),

                // Simulated "Mensagem Apagada" Bubble
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.block_rounded, size: 14, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 8),
                      Text(
                        'Esta mensagem foi apagada',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  '~$delCount',
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: GrupoTheme.inkPrimary,
                    height: 1.0,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'MENSAGENS EVAPORADAS NO AR',
                  style: GrupoTheme.kicker.copyWith(fontSize: 9),
                ),

                const SizedBox(height: 12),

                Text(
                  'O que foi dito ninguém sabe. Mas a pergunta permanece: o print foi tirado a tempo?',
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
