import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_background_variants.dart';
import 'grupo_theme.dart';

/// Slide g3: Top 3 do Grupo (Pódio 3D monumental com medalhas ouro/prata/bronze e percentuais)
class GrupoG3Top3PodiumSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG3Top3PodiumSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final top3 = adapter.top3Members;
    final m1 = top3.isNotEmpty ? top3[0] : null;
    final m2 = top3.length > 1 ? top3[1] : null;
    final m3 = top3.length > 2 ? top3[2] : null;

    final combinedShare =
        (m1?.percentage ?? 0) + (m2?.percentage ?? 0) + (m3?.percentage ?? 0);

    return StoryCardBase(
      background: GrupoBackgroundVariants.g3Podium(),
      isDarkTheme: true,
      backgroundColor: const Color(0xFF1E0A3C),
      category: 'Tribuna de Honra',
      categoryIcon: Icons.military_tech_rounded,
      title: 'O Pódio da\nAssembleia',
      subtitle: 'Os três oradores que mais ocuparam a palavra.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The 3D Podium Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 2nd Place (Left)
              Expanded(
                child: _buildPodiumColumn(
                  rank: '2º',
                  name: m2?.name ?? '2º Lugar',
                  percentage: m2?.percentage ?? 0,
                  columnHeight: 110,
                  medalEmoji: '🥈',
                  accentColor: GrupoTheme.medalSilver,
                  delayMs: 150,
                ),
              ),

              const SizedBox(width: 8),

              // 1st Place (Center - Tallest)
              Expanded(
                child: _buildPodiumColumn(
                  rank: '1º',
                  name: m1?.name ?? '1º Lugar',
                  percentage: m1?.percentage ?? 0,
                  columnHeight: 155,
                  medalEmoji: '🥇',
                  accentColor: GrupoTheme.medalGold,
                  isChampion: true,
                  delayMs: 0,
                ),
              ),

              const SizedBox(width: 8),

              // 3rd Place (Right)
              Expanded(
                child: _buildPodiumColumn(
                  rank: '3º',
                  name: m3?.name ?? '3º Lugar',
                  percentage: m3?.percentage ?? 0,
                  columnHeight: 85,
                  medalEmoji: '🥉',
                  accentColor: GrupoTheme.medalBronze,
                  delayMs: 300,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Footnote Summary Plaque
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                14,
                side: const BorderSide(color: GrupoTheme.hairlineBorder),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    color: GrupoTheme.cardSurface,
                    shape: SquircleBorder.radius(8),
                  ),
                  child: const Icon(
                    Icons.equalizer_rounded,
                    size: 18,
                    color: GrupoTheme.accentPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CONCENTRAÇÃO DA ASSEMBLEIA',
                        style: GrupoTheme.kicker.copyWith(fontSize: 9),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'O Top 3 responde por $combinedShare% de todas as mensagens do grupo.',
                        style: GrupoTheme.bodySerif.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn({
    required String rank,
    required String name,
    required int percentage,
    required double columnHeight,
    required String medalEmoji,
    required Color accentColor,
    bool isChampion = false,
    required int delayMs,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Member info above column
        if (isChampion) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: ShapeDecoration(
              color: GrupoTheme.medalGold.withValues(alpha: 0.2),
              shape: SquircleBorder.radius(6),
            ),
            child: const Text(
              'ORADOR DO ANO',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: Color(0xFF854D0E),
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],

        Text(
          medalEmoji,
          style: TextStyle(fontSize: isChampion ? 26 : 20),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: isChampion ? 14 : 12,
            fontWeight: FontWeight.w800,
            color: GrupoTheme.inkPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$percentage%',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: isChampion ? 18 : 15,
            fontWeight: FontWeight.w900,
            color: isChampion ? GrupoTheme.accentPrimary : GrupoTheme.inkSecondary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 8),

        // 3D Podium Block
        Container(
          height: columnHeight,
          width: double.infinity,
          decoration: ShapeDecoration(
            color: isChampion ? GrupoTheme.cardSurface : GrupoTheme.cardSurfaceWhite,
            shape: SquircleBorder.radius(
              14,
              side: BorderSide(
                color: isChampion ? GrupoTheme.accentPrimary : GrupoTheme.hairlineBorder,
                width: isChampion ? 1.5 : 1.0,
              ),
            ),
            shadows: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.18),
                blurRadius: isChampion ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                rank,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: isChampion ? 28 : 22,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                width: 24,
                height: 2,
                color: accentColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: delayMs.ms, duration: 450.ms).slideY(begin: 0.15, end: 0);
  }
}
