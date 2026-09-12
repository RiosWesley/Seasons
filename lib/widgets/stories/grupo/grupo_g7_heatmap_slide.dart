import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_theme.dart';

/// Slide g7: Heatmap de Atividade (Matriz de temperatura 24h com rosa dos ventos)
class GrupoG7HeatmapSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG7HeatmapSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final topHour = adapter.activeHours.isNotEmpty ? adapter.activeHours.first : '21h';
    final topDay = adapter.result.generalStats.mostActiveDayOfWeek;

    return StoryCardBase(
      category: 'Termômetro Coletivo',
      categoryIcon: Icons.access_time_filled_rounded,
      title: 'A Hora de Maior\nEbulição',
      subtitle: 'O instante em que a comunidade atinge temperatura máxima.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Peak Hour Monumental Block
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                22,
                side: const BorderSide(color: GrupoTheme.accentPrimary, width: 2.0),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'HORÁRIO NOBRE DA ASSEMBLEIA',
                  style: GrupoTheme.kicker.copyWith(
                    color: GrupoTheme.accentPrimary,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  topHour,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: GrupoTheme.accentPrimary,
                    height: 1.05,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pico de notificações simultâneas',
                  style: GrupoTheme.captionItalic,
                ),
              ],
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 22),

          // 4-Quadrant Thermal Matrix
          Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                16,
                side: const BorderSide(color: GrupoTheme.hairlineBorder),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.inkSecondary.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CICLO DE TEMPERATURA (24H)',
                  style: GrupoTheme.kicker.copyWith(fontSize: 8),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _periodTile('Madrugada', '00h - 06h', 'Calmaria', const Color(0xFF94A3B8)),
                    const SizedBox(width: 8),
                    _periodTile('Manhã', '06h - 12h', 'Despertar', const Color(0xFFA855F7)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _periodTile('Tarde', '12h - 18h', 'Movimento', const Color(0xFF7C3AED)),
                    const SizedBox(width: 8),
                    _periodTile('Noite', '18h - 24h', 'Pico Coletivo', const Color(0xFFEAB308), isHighlight: true),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

          const SizedBox(height: 18),

          // Compass Rose Footnote
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurface,
              shape: SquircleBorder.radius(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.explore_outlined,
                  size: 16,
                  color: GrupoTheme.accentPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Dia mais agitado: $topDay • Matriz 24h',
                  style: GrupoTheme.captionItalic.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 350.ms, duration: 350.ms),
        ],
      ),
    );
  }

  Widget _periodTile(String name, String hours, String status, Color color, {bool isHighlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: ShapeDecoration(
          color: isHighlight ? GrupoTheme.cardSurface : const Color(0xFFF8FAFC),
          shape: SquircleBorder.radius(
            10,
            side: BorderSide(
              color: isHighlight ? GrupoTheme.accentPrimary : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isHighlight ? GrupoTheme.accentPrimary : GrupoTheme.inkPrimary,
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              hours,
              style: TextStyle(
                fontSize: 9,
                color: GrupoTheme.inkSecondary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              status,
              style: TextStyle(
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
                fontSize: 10,
                color: isHighlight ? GrupoTheme.accentPrimary : GrupoTheme.inkSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
