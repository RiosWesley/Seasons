import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import '../shared/editorial_stamp.dart';
import 'grupo_theme.dart';

/// Slide g1: Capa da Gazeta (Cartaz de comunidade broadsheet com selo editorial e contagem de membros)
class GrupoG1CoverSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG1CoverSlide({super.key, required this.adapter});

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return StoryCardBase(
      category: 'A Gazeta da Comunidade',
      categoryIcon: Icons.newspaper_rounded,
      title: 'Gazeta Oficial\ndos Membros',
      subtitle:
          '${adapter.memberCount} participantes • ${_formatDate(adapter.startDate)} a ${_formatDate(adapter.endDate)}',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dateline banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: GrupoTheme.inkPrimary.withValues(alpha: 0.2), width: 1.0),
                bottom: BorderSide(color: GrupoTheme.inkPrimary.withValues(alpha: 0.2), width: 1.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ANO DO COLETIVO',
                  style: GrupoTheme.kicker.copyWith(fontSize: 9),
                ),
                Text(
                  'EDIÇÃO EXTRAORDINÁRIA',
                  style: GrupoTheme.kicker.copyWith(
                    fontSize: 9,
                    color: GrupoTheme.accentPrimary,
                  ),
                ),
                Text(
                  'CENSO GERAL',
                  style: GrupoTheme.kicker.copyWith(fontSize: 9),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 28),

          // Central Periodical Medal Seal
          const EditorialStamp.periodicalMedal(
            size: 96,
            label: 'OFICIAL',
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 28),

          // Member Census Plaque
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                18,
                side: const BorderSide(color: GrupoTheme.hairlineBorder, width: 1.2),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'POPULAÇÃO DO CHAT',
                  style: GrupoTheme.kicker.copyWith(
                    color: GrupoTheme.accentPrimary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${adapter.memberCount}',
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    color: GrupoTheme.inkPrimary,
                    height: 1.0,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Membros Conectados e Ativos',
                  style: GrupoTheme.bodySerif,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: GrupoTheme.hairlineBorder,
                ),
                const SizedBox(height: 10),
                Text(
                  '${adapter.totalMessages} mensagens catalogadas em ata pública',
                  style: GrupoTheme.captionItalic,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }
}
