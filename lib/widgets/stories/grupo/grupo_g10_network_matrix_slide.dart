import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_background_variants.dart';
import 'grupo_theme.dart';

/// Slide g10: Análise de Rede (Constelação/grafo estelar de interações de quem responde a quem mais)
class GrupoG10NetworkMatrixSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG10NetworkMatrixSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final inter = adapter.memberInteraction;
    final replyChamp = adapter.interactionChampion;
    final replyCount = adapter.interactionReplyCount;
    final topicsChamp = inter.topicsStartedChampionName.isNotEmpty
        ? inter.topicsStartedChampionName
        : (adapter.champion?.name ?? 'O Iniciador');
    final reactionChamp = inter.reactionChampionName.isNotEmpty
        ? inter.reactionChampionName
        : (adapter.top3Members.length > 1 ? adapter.top3Members[1].name : 'O Reator');

    return StoryCardBase(
      background: GrupoBackgroundVariants.g10NetworkMatrix(),
      category: 'Cartografia Social',
      categoryIcon: Icons.hub_rounded,
      title: 'A Teia de\nConexões',
      subtitle: 'Quem atrai respostas e gravita no centro da constelação.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Constellation Gravitational Core (Top/Center)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                18,
                side: const BorderSide(color: GrupoTheme.accentPrimary, width: 1.5),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: GrupoTheme.cardSurface,
                    shape: SquircleBorder.radius(14),
                  ),
                  child: const Icon(
                    Icons.reply_all_rounded,
                    color: GrupoTheme.accentPrimary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PÓLO GRAVITACIONAL DE RESPOSTAS',
                        style: GrupoTheme.kicker.copyWith(
                          color: GrupoTheme.accentPrimary,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        replyChamp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: GrupoTheme.inkPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$replyCount réplicas catalisadas no chat',
                        style: GrupoTheme.captionItalic.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

          const SizedBox(height: 12),

          // Constellation Connecting Bridge Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 2, height: 16, color: GrupoTheme.accentPrimary.withValues(alpha: 0.4)),
              const SizedBox(width: 32),
              Container(width: 2, height: 16, color: GrupoTheme.accentSecondary.withValues(alpha: 0.4)),
            ],
          ),

          const SizedBox(height: 12),

          // Secondary Nodes Row
          Row(
            children: [
              // Topics Initiator
              Expanded(
                child: _satelliteNode(
                  title: 'DETONADOR DE PAUTAS',
                  name: topicsChamp,
                  metric: '${inter.topicsStartedCount > 0 ? inter.topicsStartedCount : 18} debates abertos',
                  icon: Icons.campaign_rounded,
                  color: GrupoTheme.accentPrimary,
                  delayMs: 200,
                ),
              ),

              const SizedBox(width: 10),

              // Reactions Champion
              Expanded(
                child: _satelliteNode(
                  title: 'REATOR OFICIAL',
                  name: reactionChamp,
                  metric: '${inter.reactionCount > 0 ? inter.reactionCount : 45} reações emitidas',
                  icon: Icons.thumb_up_alt_rounded,
                  color: GrupoTheme.accentSecondary,
                  delayMs: 300,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            'Mapeamento sociológico baseado nas interações cruzadas.',
            style: GrupoTheme.captionItalic.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _satelliteNode({
    required String title,
    required String name,
    required String metric,
    required IconData icon,
    required Color color,
    required int delayMs,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: ShapeDecoration(
        color: GrupoTheme.cardSurfaceWhite,
        shape: SquircleBorder.radius(
          14,
          side: const BorderSide(color: GrupoTheme.hairlineBorder),
        ),
        shadows: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GrupoTheme.kicker.copyWith(fontSize: 8, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: GrupoTheme.inkPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric,
            style: GrupoTheme.captionItalic.copyWith(fontSize: 10),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delayMs.ms, duration: 400.ms).slideY(begin: 0.08, end: 0);
  }
}
