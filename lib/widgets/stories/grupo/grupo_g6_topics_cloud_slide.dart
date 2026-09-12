import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_theme.dart';

/// Slide g6: Top Conversas (Pauta da assembleia com temas e nuvem léxica)
class GrupoG6TopicsCloudSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG6TopicsCloudSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final topics = adapter.topics.take(3).toList();
    final topWords = adapter.result.generalStats.topWords.take(6).toList();

    return StoryCardBase(
      category: 'Ordem do Dia',
      categoryIcon: Icons.gavel_rounded,
      title: 'A Pauta da\nAssembleia',
      subtitle: 'Os temas que mobilizaram os debates mais intensos.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Legislative Agenda List
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
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PAUTAS DE MAIOR COMOÇÃO',
                  style: GrupoTheme.kicker.copyWith(
                    color: GrupoTheme.accentPrimary,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 12),

                if (topics.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Debates gerais e conversas espontâneas.', style: GrupoTheme.captionItalic),
                  )
                else
                  ...topics.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final t = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '#0$index',
                                style: TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: index == 1
                                      ? GrupoTheme.accentPrimary
                                      : GrupoTheme.inkSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  t.topic,
                                  style: TextStyle(
                                    fontFamily: 'serif',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: GrupoTheme.inkPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                '${t.mentions} menções',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: GrupoTheme.accentPrimary,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: (t.mentions / (topics.first.mentions > 0 ? topics.first.mentions : 1))
                                  .clamp(0.1, 1.0),
                              minHeight: 3,
                              backgroundColor: GrupoTheme.cardSurface,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                index == 1 ? GrupoTheme.accentPrimary : GrupoTheme.hairlineBorder,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 18),

          // Lexical Cloud
          if (topWords.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: ShapeDecoration(
                color: GrupoTheme.cardSurface,
                shape: SquircleBorder.radius(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VOCABULÁRIO RECORRENTE EM ATA',
                    style: GrupoTheme.kicker.copyWith(
                      color: GrupoTheme.inkSecondary,
                      fontSize: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: topWords.asMap().entries.map((entry) {
                      final i = entry.key;
                      final w = entry.value;
                      final isTop = i == 0;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: ShapeDecoration(
                          color: isTop
                              ? GrupoTheme.accentPrimary.withValues(alpha: 0.15)
                              : Colors.white,
                          shape: SquircleBorder.radius(8),
                        ),
                        child: Text(
                          w.word,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: isTop ? 14 : 12,
                            fontWeight: isTop ? FontWeight.w800 : FontWeight.w600,
                            color: isTop ? GrupoTheme.accentPrimary : GrupoTheme.inkPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
