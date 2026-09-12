import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_background_variants.dart';
import 'grupo_theme.dart';

/// Slide g4: Dinâmicas do Grupo (Diagrama de Pareto 80/20: falantes ativos vs ouvintes silenciosos)
class GrupoG4DynamicsSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG4DynamicsSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final topShare = adapter.paretoTopSharePercentage;
    final silentShare = 100 - topShare;
    final mostActive = adapter.groupDynamics.mostActive;
    final silent = adapter.groupDynamics.silent;

    return StoryCardBase(
      background: GrupoBackgroundVariants.g4Dynamics(),
      category: 'Sociologia Coletiva',
      categoryIcon: Icons.pie_chart_outline_rounded,
      title: 'A Lei de Pareto\n(80/20)',
      subtitle: 'A proporção entre a voz ativa e o silêncio atento.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mathematical Sigma Formula Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurface,
              shape: SquircleBorder.radius(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Σ',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: GrupoTheme.accentPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'DISTRIBUIÇÃO DEMOGRÁFICA DO CHAT',
                  style: GrupoTheme.kicker.copyWith(
                    color: GrupoTheme.accentPrimary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 20),

          // Proportional Split Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: topShare.clamp(1, 99),
                    child: Container(
                      color: GrupoTheme.accentPrimary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: silentShare.clamp(1, 99),
                    child: Container(
                      color: GrupoTheme.hairlineBorder,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

          const SizedBox(height: 20),

          // Two Bento Cards: Active Talkers vs Silent Listeners
          Row(
            children: [
              // Talkers
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: GrupoTheme.cardSurfaceWhite,
                    shape: SquircleBorder.radius(
                      16,
                      side: const BorderSide(color: GrupoTheme.accentPrimary, width: 1.2),
                    ),
                    shadows: [
                      BoxShadow(
                        color: GrupoTheme.accentPrimary.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORADORES ATIVOS',
                        style: GrupoTheme.kicker.copyWith(
                          color: GrupoTheme.accentPrimary,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$topShare%',
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: GrupoTheme.accentPrimary,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'das mensagens partem de 20% da tribuna.',
                        style: GrupoTheme.bodySerif.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 10),
                      Container(height: 1, color: GrupoTheme.hairlineBorder),
                      const SizedBox(height: 8),
                      Text(
                        'Voz Principal:',
                        style: GrupoTheme.kicker.copyWith(fontSize: 8),
                      ),
                      Text(
                        mostActive,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: GrupoTheme.inkPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Listeners
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: GrupoTheme.cardSurfaceWhite,
                    shape: SquircleBorder.radius(
                      16,
                      side: const BorderSide(color: GrupoTheme.hairlineBorder, width: 1.0),
                    ),
                    shadows: [
                      BoxShadow(
                        color: GrupoTheme.inkSecondary.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OBSERVADORES',
                        style: GrupoTheme.kicker.copyWith(fontSize: 9),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$silentShare%',
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: GrupoTheme.inkSecondary,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'preferem a leitura silenciosa e vigilante.',
                        style: GrupoTheme.bodySerif.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 10),
                      Container(height: 1, color: GrupoTheme.hairlineBorder),
                      const SizedBox(height: 8),
                      Text(
                        'Observador Oficial:',
                        style: GrupoTheme.kicker.copyWith(fontSize: 8),
                      ),
                      Text(
                        silent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: GrupoTheme.inkPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 250.ms, duration: 450.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }
}
