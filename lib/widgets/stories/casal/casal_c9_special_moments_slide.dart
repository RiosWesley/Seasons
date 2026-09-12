import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_story_theme.dart';

/// Slide c9: Momentos Especiais (Álbum de Memórias & Dias Marcantes)
class CasalC9SpecialMomentsSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC9SpecialMomentsSlide({super.key, required this.adapter});

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final gen = adapter.result.generalStats;

    return StoryCardBase(
      category: 'Marcos Importantes',
      categoryIcon: Icons.star_border_rounded,
      title: 'Dias Memoráveis',
      subtitle: 'Momentos que ficaram eternizados no arquivo do casal.',
      backgroundColor: CasalStoryTheme.paperBase,
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Memory Scrapbook Card 1: Start date
            _buildScrapbookCard(
              title: 'O Início Registrado',
              date: _formatDate(gen.startDate),
              description: 'O primeiro dia em que este arquivo começou a guardar palavras.',
              icon: Icons.bookmark_added_rounded,
              rotation: -0.015, // ~ -1 degree
              delayMs: 100,
            ),

            const SizedBox(height: 14),

            // Memory Scrapbook Card 2: Peak activity
            _buildScrapbookCard(
              title: 'O Dia de Maior Conexão',
              date: adapter.peakDayName,
              description: 'O dia da semana com maior intensidade de conversas ininterruptas.',
              icon: Icons.local_fire_department_rounded,
              rotation: 0.015, // ~ +1 degree
              delayMs: 250,
            ),

            const SizedBox(height: 14),

            // Memory Scrapbook Card 3: Media library
            _buildScrapbookCard(
              title: 'Galeria Compartilhada',
              date: '${gen.mediaCount} mídias',
              description: 'Fotos, vídeos e áudios que compuseram o álbum secreto de vocês.',
              icon: Icons.photo_library_rounded,
              rotation: -0.01,
              delayMs: 400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrapbookCard({
    required String title,
    required String date,
    required String description,
    required IconData icon,
    required double rotation,
    required int delayMs,
  }) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: CasalStoryTheme.cardDecoration(
          radius: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: CasalStoryTheme.accentPrimary),
                    const SizedBox(width: 8),
                    Text(
                      title.toUpperCase(),
                      style: CasalStoryTheme.labelKicker.copyWith(fontSize: 9.5),
                    ),
                  ],
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: CasalStoryTheme.inkPrimary,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: CasalStoryTheme.italicSubtitle.copyWith(
                fontSize: 12,
                color: CasalStoryTheme.inkSecondary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delayMs), duration: 350.ms);
  }
}
