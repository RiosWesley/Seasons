import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_background_variants.dart';
import 'grupo_theme.dart';

/// Slide g5: Timeline Coletiva (Calendário anual de 12 meses / ondas sazonais)
class GrupoG5TimelineSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG5TimelineSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final timeline = adapter.timeline;
    final maxCount = timeline.isNotEmpty
        ? timeline.map((t) => t.count).reduce(math.max)
        : 1;

    // Find peak month
    final peak = timeline.isNotEmpty
        ? timeline.reduce((a, b) => a.count > b.count ? a : b)
        : null;

    final displayItems = timeline.take(6).toList();

    return StoryCardBase(
      background: GrupoBackgroundVariants.g5Timeline(),
      isDarkTheme: true,
      backgroundColor: const Color(0xFF15082E),
      category: 'Cronologia Comunitária',
      categoryIcon: Icons.calendar_month_rounded,
      title: 'As Ondas do Ano',
      subtitle: 'O fluxo das marés de conversas ao longo dos meses.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Monthly Columns Chart
          Container(
            padding: const EdgeInsets.all(18),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                18,
                side: const BorderSide(color: GrupoTheme.hairlineBorder, width: 1.2),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FLUXO MENSAL DE ATIVIDADE',
                      style: GrupoTheme.kicker.copyWith(
                        color: GrupoTheme.accentPrimary,
                        fontSize: 9,
                      ),
                    ),
                    const Icon(
                      Icons.auto_graph_rounded,
                      size: 16,
                      color: GrupoTheme.accentPrimary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bars
                if (displayItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('Dados sazonais em consolidação.', style: GrupoTheme.captionItalic),
                  )
                else
                  SizedBox(
                    height: 140,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: displayItems.asMap().entries.map((entry) {
                        final i = entry.key;
                        final item = entry.value;
                        final isPeak = item.count == maxCount;
                        final heightFactor = maxCount > 0
                            ? (item.count / maxCount).clamp(0.15, 1.0)
                            : 0.2;

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isPeak)
                                  const Text(
                                    '✦',
                                    style: TextStyle(
                                      color: GrupoTheme.medalGold,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                else
                                  const SizedBox(height: 14),

                                const SizedBox(height: 2),

                                // Bar
                                Flexible(
                                  child: FractionallySizedBox(
                                    heightFactor: heightFactor,
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        color: isPeak
                                            ? GrupoTheme.accentPrimary
                                            : GrupoTheme.hairlineBorder,
                                        shape: SquircleBorder.radius(6),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  item.month.length > 3
                                      ? item.month.substring(0, 3).toUpperCase()
                                      : item.month.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'serif',
                                    fontSize: 10,
                                    fontWeight: isPeak ? FontWeight.w800 : FontWeight.w600,
                                    color: isPeak
                                        ? GrupoTheme.accentPrimary
                                        : GrupoTheme.inkSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: (i * 45).ms, duration: 350.ms)
                            .slideY(begin: 0.15, end: 0);
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 20),

          // Seasonal Peak Callout
          if (peak != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: ShapeDecoration(
                color: GrupoTheme.cardSurface,
                shape: SquircleBorder.radius(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: GrupoTheme.medalGold,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CLÍMAX HISTÓRICO DO GRUPO',
                          style: GrupoTheme.kicker.copyWith(
                            color: GrupoTheme.accentPrimary,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${peak.month}: recorde de ${peak.count} mensagens registradas.',
                          style: GrupoTheme.bodySerif.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: GrupoTheme.inkPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
