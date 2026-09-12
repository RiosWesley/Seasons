import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import '../shared/monumental_count_up.dart';
import 'grupo_background_variants.dart';
import 'grupo_theme.dart';

/// Slide g2: Total de Mensagens (Placa censitária monumental + equivalência literária em volumes de livros)
class GrupoG2LiteraryTotalSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG2LiteraryTotalSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final wordsEstimate = adapter.totalMessages * 12;
    final formattedWords = wordsEstimate
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

    return StoryCardBase(
      background: GrupoBackgroundVariants.g2LiteraryTotal(),
      category: 'Censo Demográfico',
      categoryIcon: Icons.forum_rounded,
      title: 'A Memória\nEscrita',
      subtitle: 'O volume monumental produzido pela comunidade.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Monumental Counter
          MonumentalCountUp(
            targetValue: adapter.totalMessages,
            fontSize: 58,
            color: GrupoTheme.accentPrimary,
            label: 'MENSAGENS COLETIVAS REGISTRADAS',
            subtitle: 'produzidas pelos ${adapter.memberCount} integrantes',
          ).animate().fadeIn(duration: 500.ms),

          const SizedBox(height: 28),

          // Literary Equivalence Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                18,
                side: const BorderSide(color: GrupoTheme.hairlineBorder, width: 1.2),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: GrupoTheme.cardSurface,
                        shape: SquircleBorder.radius(10),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: GrupoTheme.accentPrimary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'EQUIVALÊNCIA LITERÁRIA',
                      style: GrupoTheme.kicker.copyWith(
                        color: GrupoTheme.accentPrimary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  adapter.literaryBookDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: GrupoTheme.inkPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aproximadamente $formattedWords palavras redigidas ao longo das conversas.',
                  textAlign: TextAlign.center,
                  style: GrupoTheme.bodySerif.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: GrupoTheme.hairlineBorder,
                ),
                const SizedBox(height: 10),
                Text(
                  'Mais de ${adapter.result.generalStats.mediaCount} arquivos de mídia enriqueceram o acervo.',
                  textAlign: TextAlign.center,
                  style: GrupoTheme.captionItalic.copyWith(fontSize: 12),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 500.ms).slideY(begin: 0.06, end: 0),
        ],
      ),
    );
  }
}
