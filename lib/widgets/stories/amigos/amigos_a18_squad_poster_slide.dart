import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/editorial_stamp.dart';
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

    return StoryCardBase(
      backgroundColor: AmigosTheme.paperBase,
      category: 'A Resenha Oficial',
      categoryIcon: Icons.celebration_rounded,
      title: 'Pôster Oficial\ndo Squad',
      subtitle: 'A resenha documentada e homologada para a história.',
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
                  child: const Text(
                    'SQUAD 2025 • TURNÊ OFICIAL',
                    style: TextStyle(
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
                const EditorialStamp.rubberStamp(
                  size: 78,
                  label: 'SQUAD ARCHIVE',
                ),

                const SizedBox(height: 12),

                // Lineup roster
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
                    '$total MENSAGENS • ${members.length} INTEGRANTES • $score% SINTONIA',
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
                const ZineBarcode(
                  code: 'FESTIVAL-SQUAD-2025',
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
              label: const Text(
                'COMPARTILHAR PÔSTER DO SQUAD',
                style: TextStyle(
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
