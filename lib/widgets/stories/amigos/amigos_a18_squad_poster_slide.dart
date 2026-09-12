import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/editorial_stamp.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA18SquadPosterSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;
  final VoidCallback? onShare;

  const AmigosA18SquadPosterSlide({
    super.key,
    required this.adapter,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final members = adapter.participants;
    final total = adapter.totalMessages;
    final score = adapter.compatibilityScore;

    final isDuo = adapter.isDuo;

    return StoryCardBase(
      background: AmigosBackgroundVariants.a18SquadPoster(),
      backgroundColor: AmigosTheme.paperBase,
      category: isDuo ? 'A Dupla do Ano' : 'A Resenha Oficial',
      categoryIcon: Icons.celebration_rounded,
      title: isDuo ? 'Pôster Oficial\nda Dupla' : 'Pôster Oficial\ndo Squad',
      subtitle: isDuo
          ? 'A amizade documentada e homologada para a história.'
          : 'A resenha documentada e homologada para a história.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Festival poster container
          Container(
            padding: const EdgeInsets.all(18),
            decoration: AmigosTheme.cardDecoration(
              radius: 18,
              color: Colors.white,
              borderColor: AmigosTheme.accentPrimary,
            ),
            child: Column(
              children: [
                // Tour banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AmigosTheme.stickerPop,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isDuo ? 'A DUPLA DO ANO • TURNÊ OFICIAL' : 'SQUAD 2025 • TURNÊ OFICIAL',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AmigosTheme.inkPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Rubber stamp
                EditorialStamp.rubberStamp(
                  size: 78,
                  label: isDuo ? 'PARCERIA OFICIAL' : 'SQUAD ARCHIVE',
                ),

                const SizedBox(height: 12),

                // Lineup roster (hero duo headline or wrap for multi)
                if (isDuo)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          adapter.friendA.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AmigosTheme.inkPrimary,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AmigosTheme.stickerPop,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '⚡',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          adapter.friendB.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AmigosTheme.inkPrimary,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  )
                else
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: members.map((m) {
                      return Text(
                        m.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AmigosTheme.inkPrimary,
                          letterSpacing: 0.5,
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AmigosTheme.hairlineBorder),
                  ),
                  child: Text(
                    isDuo
                        ? '$total MENSAGENS • DUPLA OFICIAL • $score% SINTONIA'
                        : '$total MENSAGENS • ${members.length} INTEGRANTES • $score% SINTONIA',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AmigosTheme.accentPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Barcode
                ZineBarcode(
                  code: isDuo ? 'DUPLA-OFICIAL-2025' : 'FESTIVAL-SQUAD-2025',
                  height: 24,
                  color: AmigosTheme.inkPrimary,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).scale(curve: Curves.easeOutBack),

          const SizedBox(height: 18),

          // Share Action Button with Icons.share_rounded
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AmigosTheme.accentPrimary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AmigosTheme.accentPrimary.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onShare,
              icon: const Icon(Icons.share_rounded, size: 20, color: Colors.white),
              label: Text(
                isDuo ? 'COMPARTILHAR PÔSTER DA DUPLA' : 'COMPARTILHAR PÔSTER DO SQUAD',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0.0),
        ],
      ),
    );
  }
}
