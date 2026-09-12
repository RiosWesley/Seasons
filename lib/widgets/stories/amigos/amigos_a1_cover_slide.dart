import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../shared/editorial_stamp.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA1CoverSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA1CoverSlide({super.key, required this.adapter});

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return StoryCardBase(
      background: AmigosBackgroundVariants.a1Cover(),
      backgroundColor: AmigosTheme.paperBase,
      category: 'Modo Amigos',
      categoryIcon: Icons.group_rounded,
      title: 'Zine do\nSquad',
      subtitle: '${adapter.memberCount} integrantes • ${_formatDate(adapter.startDate)} a ${_formatDate(adapter.endDate)}',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Issue tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AmigosTheme.stickerPop,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x20000000),
                  offset: Offset(1, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            child: const Text(
              'VOL. 2025 // ISSUE 01',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AmigosTheme.inkPrimary,
                letterSpacing: 1.5,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).scale(curve: Curves.easeOutBack),

          const SizedBox(height: 20),

          // Rubber stamp
          const Center(
            child: EditorialStamp.rubberStamp(
              size: 100,
              label: 'SQUAD ARCHIVE',
            ),
          ).animate().scale(duration: 650.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 24),

          // Member Badges (tilted sticker aesthetic)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 10,
            children: adapter.participants.asMap().entries.map((entry) {
              final idx = entry.key;
              final p = entry.value;
              final tilt = (idx % 2 == 0 ? -0.04 : 0.04) * (1.0 + (idx % 3) * 0.2);

              return Transform.rotate(
                angle: tilt,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: AmigosTheme.cardDecoration(
                    color: idx == 0 ? const Color(0xFFE0F2FE) : AmigosTheme.cardSurface,
                    borderColor: idx == 0 ? AmigosTheme.accentPrimary : AmigosTheme.hairlineBorder,
                    radius: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: idx == 0 ? AmigosTheme.accentPrimary : AmigosTheme.accentSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        p,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AmigosTheme.inkPrimary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 250.ms, duration: 500.ms),

          const SizedBox(height: 28),

          // Barcode footer mark
          const ZineBarcode(
            code: 'SQUAD-ARCHIVE-916',
            height: 28,
            color: AmigosTheme.inkSecondary,
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}
