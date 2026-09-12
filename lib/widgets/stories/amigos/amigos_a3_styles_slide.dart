import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/models/amigos_stats.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA3StylesSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA3StylesSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final isDuo = adapter.isDuo;

    if (isDuo) {
      return _buildDuoShowdown();
    }

    return _buildSquadList();
  }

  Widget _buildDuoShowdown() {
    final styleA = adapter.friendAStyle;
    final styleB = adapter.friendBStyle;

    return StoryCardBase(
      background: AmigosBackgroundVariants.a3Styles(),
      backgroundColor: AmigosTheme.paperBase,
      category: 'Duelo de Estilos',
      categoryIcon: Icons.compare_arrows_rounded,
      title: 'Os Dois Lados\nda Amizade',
      subtitle: 'O contraste de estilos que faz a parceria funcionar.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Friend A Card
          _buildDuoCard(
            label: 'LADO A',
            friendName: adapter.friendA,
            style: styleA,
            messages: adapter.friendAMessages,
            percentage: adapter.friendAPercentage,
            accentColor: AmigosTheme.accentPrimary,
            tagColor: const Color(0xFFE0F2FE),
            delayMs: 150,
          ),

          // Showdown VS Badge
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 1.5,
                  color: AmigosTheme.hairlineBorder,
                ),
                const SizedBox(width: 8),
                Transform.rotate(
                  angle: -0.05,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AmigosTheme.stickerPop,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x20000000),
                          offset: Offset(1, 2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: const Text(
                      'VS',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AmigosTheme.inkPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 38,
                  height: 1.5,
                  color: AmigosTheme.hairlineBorder,
                ),
              ],
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

          // Friend B Card
          _buildDuoCard(
            label: 'LADO B',
            friendName: adapter.friendB,
            style: styleB,
            messages: adapter.friendBMessages,
            percentage: adapter.friendBPercentage,
            accentColor: AmigosTheme.accentSecondary,
            tagColor: AmigosTheme.cardSurface,
            delayMs: 300,
          ),

          const SizedBox(height: 16),

          // Bottom synergy banner
          const HazardTapeBanner(
            text: '⚡ COMPLEMENTO PERFEITO // RESENHA EQUILIBRADA',
            angle: -0.01,
          ).animate().fadeIn(delay: 450.ms),
        ],
      ),
    );
  }

  Widget _buildDuoCard({
    required String label,
    required String friendName,
    required CommunicationStyle style,
    required int messages,
    required int percentage,
    required Color accentColor,
    required Color tagColor,
    required int delayMs,
  }) {
    final signature = adapter.styleSignature(style);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AmigosTheme.cardDecoration(
        radius: 16,
        color: AmigosTheme.cardSurface,
        borderColor: accentColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Tag & Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: accentColor,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Text(
                '$messages msgs ($percentage%)',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AmigosTheme.inkSecondary,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Center: Avatar + Info
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AmigosTheme.hairlineBorder, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x15000000),
                      offset: Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    style.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friendName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AmigosTheme.inkPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'O ${style.style.toUpperCase()}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: accentColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Signature dynamic line
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AmigosTheme.hairlineBorder.withValues(alpha: 0.8)),
            ),
            child: Text(
              signature,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AmigosTheme.inkSecondary,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delayMs.ms, duration: 400.ms).slideY(begin: 0.08, end: 0.0);
  }

  Widget _buildSquadList() {
    final styles = adapter.communicationStyles;

    return StoryCardBase(
      background: AmigosBackgroundVariants.a3Styles(),
      backgroundColor: AmigosTheme.paperBase,
      category: 'Arquétipos do Squad',
      categoryIcon: Icons.badge_outlined,
      title: 'Estilos de\nComunicação',
      subtitle: 'O papel natural de cada amigo na conversa.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...styles.take(4).toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final s = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: AmigosTheme.cardDecoration(
                  radius: 14,
                  color: AmigosTheme.cardSurface,
                  borderColor: idx == 0 ? AmigosTheme.accentPrimary : AmigosTheme.hairlineBorder,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AmigosTheme.hairlineBorder),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x12000000),
                            offset: Offset(1, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          s.emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  s.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AmigosTheme.inkPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AmigosTheme.stickerPop.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'CARD OFICIAL',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    color: AmigosTheme.inkSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            s.style.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AmigosTheme.accentPrimary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (100 * idx).ms, duration: 400.ms).slideY(begin: 0.1, end: 0.0);
          }),
          if (styles.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Squad equilibrado com sintonia natural em todos os assuntos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AmigosTheme.inkSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
