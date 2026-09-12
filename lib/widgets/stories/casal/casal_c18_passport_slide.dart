import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/casal_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/editorial_stamp.dart';
import '../shared/seasons_story_footer.dart';
import '../shared/story_share_action.dart';
import 'casal_story_theme.dart';

/// Slide c18: Conclusão & Passaporte ("Passaporte do Casal")
class CasalC18PassportSlide extends StatelessWidget {
  final CasalStoryAdapter adapter;
  final VoidCallback? onShare;

  const CasalC18PassportSlide({
    super.key,
    required this.adapter,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return StoryCardBase(
      category: 'Passaporte Oficial',
      categoryIcon: Icons.card_membership_rounded,
      title: 'Passaporte do Casal',
      subtitle: 'O registro oficial e permanente da sintonia a dois.',
      backgroundColor: CasalStoryTheme.paperBase,
      footer: const SeasonsStoryFooter(editionTag: "mémoire d'amour"),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Diplomatic Passport Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: CasalStoryTheme.cardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: CasalStoryTheme.hairlineBorder,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CasalStoryTheme.inkPrimary.withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Text(
                    'REPÚBLICA DO AMOR • PASSAPORTE OFICIAL',
                    style: CasalStoryTheme.labelKicker.copyWith(
                      letterSpacing: 1.5,
                      fontSize: 8.5,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Couple names and seal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          adapter.partner1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: CasalStoryTheme.inkPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                        child: EditorialStamp.waxSeal(
                          size: 54,
                          label: 'AMOR',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          adapter.partner2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: CasalStoryTheme.inkPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 24, color: CasalStoryTheme.hairlineBorder),

                  // 3 Visas / Stamps row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildVisaBadge(
                        label: 'SINTONIA',
                        value: '${adapter.compatibilityScore}%',
                      ),
                      _buildVisaBadge(
                        label: 'VOLUME',
                        value: '${adapter.totalMessages}',
                      ),
                      _buildVisaBadge(
                        label: 'LINGUAGEM',
                        value: adapter.dominantLoveLanguageName.split(' ').first,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Validity
                  Text(
                    'VALIDADE: ETERNO • EXPEDIDO EM 2025',
                    style: CasalStoryTheme.labelKicker.copyWith(
                      color: CasalStoryTheme.accentPrimary,
                      fontSize: 8.5,
                    ),
                  ),
                ],
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 24),

            // Share Action button (contains Icons.share_rounded and executes onShare)
            StoryShareAction(
              onShare: onShare ?? () {},
              label: 'COMPARTILHAR PASSAPORTE',
              backgroundColor: CasalStoryTheme.accentPrimary,
              foregroundColor: Colors.white,
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildVisaBadge({required String label, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'serif',
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: CasalStoryTheme.inkPrimary,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: CasalStoryTheme.labelKicker.copyWith(fontSize: 8),
        ),
      ],
    );
  }
}
