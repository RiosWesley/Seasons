import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/editorial_stamp.dart';
import '../shared/seasons_story_footer.dart';
import 'casal_background_variants.dart';
import 'casal_story_theme.dart';

/// Slide c1: Capa (Pôster de Livro Clássico / Cinema do Casal)
class CasalC1CoverSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;

  const CasalC1CoverSlide({super.key, required this.adapter});

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return StoryCardBase(
      category: 'Modo Casal',
      categoryIcon: Icons.favorite_rounded,
      title: 'A História de\nVocês Dois',
      subtitle: '${_formatDate(adapter.startDate)} até ${_formatDate(adapter.endDate)}',
      background: CasalBackgroundVariants.c1Cover(),
      isDarkTheme: true,
      footer: const SeasonsStoryFooter(
        editionTag: "mémoire d'amour",
        inkPrimary: Colors.white,
        inkSecondary: Color(0xFFFB7185),
      ),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: CasalStoryTheme.cardDecoration(
            backgroundColor: const Color(0xFFFFF9F5).withValues(alpha: 0.95),
            borderColor: const Color(0xFFFECDD3),
            radius: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Wax seal hero
              const EditorialStamp.waxSeal(
                size: 84,
                label: 'AMOR',
              ).animate().scale(duration: 650.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 18),

              // Filigree stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 1,
                    color: CasalStoryTheme.accentSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '✦',
                    style: TextStyle(
                      color: CasalStoryTheme.accentPrimary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 1,
                    color: CasalStoryTheme.accentSecondary.withValues(alpha: 0.5),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Couple names
              Text(
                adapter.partner1,
                textAlign: TextAlign.center,
                style: CasalStoryTheme.headlineLarge.copyWith(
                  fontSize: 26,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).animate().fadeIn(delay: 150.ms, duration: 450.ms),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '&',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: CasalStoryTheme.accentPrimary,
                  ),
                ),
              ),

              Text(
                adapter.partner2,
                textAlign: TextAlign.center,
                style: CasalStoryTheme.headlineLarge.copyWith(
                  fontSize: 26,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).animate().fadeIn(delay: 250.ms, duration: 450.ms),

              const SizedBox(height: 16),

              // Days together badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: CasalStoryTheme.badgeHighlight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: CasalStoryTheme.hairlineBorder,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  '${adapter.daysTogether} DIAS DE HISTÓRIA',
                  style: CasalStoryTheme.labelKicker.copyWith(
                    color: CasalStoryTheme.inkPrimary,
                    fontSize: 9.5,
                  ),
                ),
              ).animate().fadeIn(delay: 350.ms),

              const SizedBox(height: 16),

              // Invitation prompt
              Text(
                'Toque para reviver cada capítulo',
                style: CasalStoryTheme.italicSubtitle.copyWith(
                  fontSize: 12.5,
                  color: CasalStoryTheme.inkSecondary.withValues(alpha: 0.8),
                ),
              ).animate().fadeIn(delay: 450.ms),
            ],
          ),
        ),
      ),
    );
  }
}
