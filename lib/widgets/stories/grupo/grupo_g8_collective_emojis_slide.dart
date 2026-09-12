import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_theme.dart';

/// Slide g8: Evolução de Emojis (Painel de cotação da bolsa dos emojis disparados)
class GrupoG8CollectiveEmojisSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG8CollectiveEmojisSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final emojis = adapter.topEmojis.take(4).toList();

    return StoryCardBase(
      category: 'Cotação de Reações',
      categoryIcon: Icons.currency_exchange_rounded,
      title: 'A Bolsa de\nEmojis',
      subtitle: 'A moeda corrente e as reações mais negociadas em pregão.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Financial Ticker Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurface,
              shape: SquircleBorder.radius(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PREGÃO COLETIVO',
                  style: GrupoTheme.kicker.copyWith(
                    color: GrupoTheme.accentPrimary,
                    fontSize: 9,
                  ),
                ),
                Text(
                  'ÍNDICE DE LIQUIDEZ ▲',
                  style: GrupoTheme.kicker.copyWith(
                    color: const Color(0xFF16A34A),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms),

          const SizedBox(height: 18),

          // Quotation Board
          Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                18,
                side: const BorderSide(color: GrupoTheme.hairlineBorder, width: 1.2),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                if (emojis.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('Nenhuma cotação registrada.', style: GrupoTheme.captionItalic),
                  )
                else
                  ...emojis.asMap().entries.map((entry) {
                    final i = entry.key;
                    final emoji = entry.value;
                    final rank = i + 1;
                    final isTop = rank == 1;

                    return Container(
                      margin: EdgeInsets.only(bottom: i < emojis.length - 1 ? 10.0 : 0),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: ShapeDecoration(
                        color: isTop ? GrupoTheme.cardSurface : const Color(0xFFF8FAFC),
                        shape: SquircleBorder.radius(
                          12,
                          side: BorderSide(
                            color: isTop ? GrupoTheme.accentPrimary : const Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Rank
                          Text(
                            '#0$rank',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isTop ? GrupoTheme.accentPrimary : GrupoTheme.inkSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Emoji
                          Text(
                            emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 12),

                          // Code / Label
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$EMJ-0$rank',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isTop ? GrupoTheme.accentPrimary : GrupoTheme.inkPrimary,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  isTop ? 'Ativo mais negociado' : 'Alta circulação',
                                  style: GrupoTheme.captionItalic.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ),

                          // Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: ShapeDecoration(
                              color: isTop
                                  ? GrupoTheme.medalGold.withValues(alpha: 0.2)
                                  : const Color(0xFFDCFCE7),
                              shape: SquircleBorder.radius(6),
                            ),
                            child: Text(
                              isTop ? 'OURO ▲' : 'ALTA ▲',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: isTop ? const Color(0xFF854D0E) : const Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (i * 80).ms, duration: 350.ms);
                  }),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // Ticker Tape Footer Note
          Text(
            'Reações apuradas no fechamento dos anais coletivos.',
            style: GrupoTheme.captionItalic.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
