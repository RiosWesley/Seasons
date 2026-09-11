import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/models/grupo_stats.dart';
import '../../theme/squircle_border.dart';
import '../../theme/swiss_colors.dart';
import '../../theme/swiss_typography.dart';
import '../../widgets/count_up_text.dart';
import 'story_card_base.dart';

/// Builder that generates all 16 bespoke slides for Grupo Mode.
class GrupoStoryCards {
  GrupoStoryCards._();

  static Widget buildSlide({
    required String slideId,
    required GrupoAnalysisResult analysis,
    VoidCallback? onShare,
  }) {
    switch (slideId) {
      case 'g1':
        return _buildG1Header(analysis);
      case 'g2':
        return _buildG2Total(analysis);
      case 'g3':
        return _buildG3Ranking(analysis);
      case 'g4':
        return _buildG4Dynamics(analysis);
      case 'g5':
        return _buildG5Timeline(analysis);
      case 'g6':
        return _buildG6Topics(analysis);
      case 'g7':
        return _buildG7Heatmap(analysis);
      case 'g8':
        return _buildG8EmojiEvolution(analysis);
      case 'g9':
        return _buildG9Floods(analysis);
      case 'g10':
        return _buildG10Network(analysis);
      case 'g11':
        return _buildG11Insight(analysis);
      case 'g12':
        return _buildG12Ignoring(analysis);
      case 'g13':
        return _buildG13FakeScreenshots(analysis);
      case 'g14':
        return _buildG14FakeForwarded(analysis);
      case 'g15':
        return _buildG15FakeDeleted(analysis);
      case 'g16':
        return _buildG16Final(analysis, onShare);
      default:
        return _buildG1Header(analysis);
    }
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  // 1. Capa do Grupo
  static Widget _buildG1Header(GrupoAnalysisResult analysis) {
    final gen = analysis.generalStats;

    return StoryCardBase(
      category: 'Modo Grupo',
      categoryIcon: Icons.groups_rounded,
      title: 'O Ano do Grupo',
      subtitle: '${gen.participants.length} participantes • ${_formatDate(gen.startDate)} até ${_formatDate(gen.endDate)}',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: ShapeDecoration(
              color: SwissColors.emeraldPrimary.withValues(alpha: 0.15),
              shape: SquircleBorder.radius(24),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: SwissColors.emeraldPrimary,
              size: 46,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 28),
          Text(
            '${gen.participants.length} Membros Conectados',
            style: SwissTypography.displayMedium.copyWith(
              color: SwissColors.darkTextPrimary,
              fontSize: 22,
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  // 2. Volume Coletivo
  static Widget _buildG2Total(GrupoAnalysisResult analysis) {
    final gen = analysis.generalStats;

    return StoryCardBase(
      category: 'Volume do Grupo',
      categoryIcon: Icons.forum_rounded,
      title: 'Um Ano Inteiro de\nMovimentação',
      subtitle: 'Toda mensagem contada com precisão.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CountUpText(
            targetValue: gen.totalMessages,
            style: SwissTypography.metricLarge.copyWith(
              fontSize: 54,
              color: SwissColors.emeraldPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'MENSAGENS COLETIVAS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'E mais de ${gen.mediaCount} fotos, áudios e figurinhas enviadas.',
            textAlign: TextAlign.center,
            style: SwissTypography.bodyMedium.copyWith(
              color: SwissColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // 3. Leaderboard / Top 3 Membros
  static Widget _buildG3Ranking(GrupoAnalysisResult analysis) {
    final rankings = analysis.memberRanking.take(3).toList();

    return StoryCardBase(
      category: 'Pódio de Atividade',
      categoryIcon: Icons.leaderboard_rounded,
      title: 'Top 3 Mais Ativos',
      subtitle: 'Quem mais contribuiu para as conversas.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rankings.map((m) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: ShapeDecoration(
                color: SwissColors.darkSurfaceCard,
                shape: SquircleBorder.radius(14, side: const BorderSide(color: SwissColors.darkBorder)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(m.medal ?? '🏅', style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          m.name,
                          style: SwissTypography.titleMedium.copyWith(
                            color: SwissColors.darkTextPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        '${m.percentage}%',
                        style: SwissTypography.metricSmall.copyWith(
                          color: SwissColors.emeraldPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: m.percentage / 100.0,
                      minHeight: 4,
                      backgroundColor: SwissColors.darkSurfaceSubdued,
                      valueColor: const AlwaysStoppedAnimation<Color>(SwissColors.emeraldPrimary),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ).animate().fadeIn(duration: 450.ms),
    );
  }

  // 4. Dinâmicas do Grupo
  static Widget _buildG4Dynamics(GrupoAnalysisResult analysis) {
    final d = analysis.groupDynamics;

    return StoryCardBase(
      category: 'Papéis Coletivos',
      categoryIcon: Icons.stars_rounded,
      title: 'Personalidades do\nGrupo',
      subtitle: 'O perfil comportamental dos participantes.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _roleRow('O Mais Ativo', d.mostActive, Icons.record_voice_over_rounded),
          const SizedBox(height: 10),
          _roleRow('O Silencioso (Lurker)', d.silent, Icons.visibility_outlined),
          const SizedBox(height: 10),
          _roleRow('O Mais Consistente', d.mostConsistent, Icons.calendar_month_rounded),
          const SizedBox(height: 10),
          _roleRow('Coruja da Madrugada', d.nightOwl, Icons.bedtime_outlined),
        ],
      ).animate().fadeIn(duration: 450.ms),
    );
  }

  // 5. Linha do Tempo
  static Widget _buildG5Timeline(GrupoAnalysisResult analysis) {
    final timeline = analysis.generalStats.timeline;

    return StoryCardBase(
      category: 'Cronologia',
      categoryIcon: Icons.timeline_rounded,
      title: 'Atividade no Tempo',
      subtitle: 'Como o grupo se comportou ao longo dos meses.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(16, side: const BorderSide(color: SwissColors.darkBorder)),
            ),
            child: Column(
              children: timeline.take(4).map((t) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.month, style: SwissTypography.titleMedium.copyWith(color: SwissColors.darkTextPrimary, fontSize: 14)),
                      Text('${t.count} msgs', style: SwissTypography.labelSmall.copyWith(color: SwissColors.emeraldPrimary)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ).animate().fadeIn(duration: 400.ms),
        ],
      ),
    );
  }

  // 6. Tópicos Mais Debatidos
  static Widget _buildG6Topics(GrupoAnalysisResult analysis) {
    final topics = analysis.topics;

    return StoryCardBase(
      category: 'Assuntos Principais',
      categoryIcon: Icons.tag_rounded,
      title: 'Pautas do Grupo',
      subtitle: 'Os temas mais recorrentes nos chats.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: topics.take(4).map((t) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: ShapeDecoration(
                color: SwissColors.darkSurfaceCard,
                shape: SquircleBorder.radius(12, side: const BorderSide(color: SwissColors.darkBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t.topic, style: SwissTypography.titleMedium.copyWith(color: SwissColors.darkTextPrimary, fontSize: 15)),
                  Text('${t.mentions} menções', style: SwissTypography.labelSmall.copyWith(color: SwissColors.emeraldPrimary)),
                ],
              ),
            ),
          );
        }).toList(),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 7. Heatmap de Atividade
  static Widget _buildG7Heatmap(GrupoAnalysisResult analysis) {
    final activeHours = analysis.activeHours;
    final topHour = activeHours.isNotEmpty ? activeHours.first : '21h';

    return StoryCardBase(
      category: 'Horários de Pico',
      categoryIcon: Icons.access_time_filled_rounded,
      title: 'Horário de Pico do\nGrupo',
      subtitle: 'Quando as notificações não pararam de apitar.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(20, side: const BorderSide(color: SwissColors.emeraldPrimary, width: 2)),
            ),
            child: Text(
              topHour,
              style: SwissTypography.displayMedium.copyWith(
                color: SwissColors.emeraldPrimary,
                fontSize: 44,
              ),
            ),
          ).animate().scale(duration: 500.ms),
          const SizedBox(height: 20),
          Text(
            'Dia da semana favorito: ${analysis.generalStats.mostActiveDayOfWeek}',
            style: SwissTypography.bodyMedium.copyWith(
              color: SwissColors.darkTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // 8. Evolução de Emojis
  static Widget _buildG8EmojiEvolution(GrupoAnalysisResult analysis) {
    final emojis = analysis.topEmojis.take(4).toList();

    return StoryCardBase(
      category: 'Reações do Grupo',
      categoryIcon: Icons.emoji_emotions_outlined,
      title: 'Figurinhas & Emojis',
      subtitle: 'As reações mais enviadas no grupo.',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: emojis.map((e) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(16, side: const BorderSide(color: SwissColors.darkBorder)),
            ),
            child: Text(e, style: const TextStyle(fontSize: 36)),
          );
        }).toList(),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 9. Flood Moments
  static Widget _buildG9Floods(GrupoAnalysisResult analysis) {
    final mostActive = analysis.groupDynamics.mostActive;

    return StoryCardBase(
      category: 'Inundação no Chat',
      categoryIcon: Icons.water_drop_rounded,
      title: 'Flood Champion',
      subtitle: 'Quem mais enfileirou mensagens no chat coletivo.',
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: ShapeDecoration(
          color: SwissColors.darkSurfaceCard,
          shape: SquircleBorder.radius(18, side: const BorderSide(color: SwissColors.darkBorder)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_rounded, size: 36, color: SwissColors.emeraldPrimary),
            const SizedBox(height: 12),
            Text(
              mostActive,
              style: SwissTypography.titleLarge.copyWith(
                color: SwissColors.darkTextPrimary,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'O motor das discussões coletivas!',
              style: SwissTypography.labelSmall.copyWith(
                color: SwissColors.darkTextSecondary,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 10. Matriz de Interação / Rede
  static Widget _buildG10Network(GrupoAnalysisResult analysis) {
    final inter = analysis.memberInteraction;

    return StoryCardBase(
      category: 'Matriz de Interação',
      categoryIcon: Icons.hub_outlined,
      title: 'Conexões no Grupo',
      subtitle: 'Quem mais interage e reage no chat.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _interactionRow('Campeão de Reações', inter.reactionChampionName, '${inter.reactionCount} reações', Icons.thumb_up_alt_outlined),
          const SizedBox(height: 12),
          _interactionRow('Campeão de Respostas', inter.replyChampionName, '${inter.replyCount} respostas', Icons.reply_rounded),
          const SizedBox(height: 12),
          _interactionRow('Iniciador de Assuntos', inter.topicsStartedChampionName, '${inter.topicsStartedCount} tópicos', Icons.campaign_rounded),
        ],
      ).animate().fadeIn(duration: 450.ms),
    );
  }

  // 11. Insight
  static Widget _buildG11Insight(GrupoAnalysisResult analysis) {
    final main = analysis.insights.isNotEmpty
        ? analysis.insights.first
        : 'Grupo com excelente engajamento coletivo e distribuição contínua de atividade.';

    return StoryCardBase(
      category: 'Diagnóstico Coletivo',
      categoryIcon: Icons.lightbulb_outline_rounded,
      title: 'Diagnóstico do Grupo',
      subtitle: 'A leitura final da atmosfera de vocês.',
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: ShapeDecoration(
          color: SwissColors.darkSurfaceCard,
          shape: SquircleBorder.radius(18, side: const BorderSide(color: SwissColors.darkBorder)),
        ),
        child: Text(
          main,
          textAlign: TextAlign.center,
          style: SwissTypography.bodyLarge.copyWith(
            color: SwissColors.darkTextPrimary,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 12. Quem Mais Ignora
  static Widget _buildG12Ignoring(GrupoAnalysisResult analysis) {
    final ig = analysis.groupIgnoringStats;

    return StoryCardBase(
      category: 'Vácuo Coletivo',
      categoryIcon: Icons.timer_off_outlined,
      title: 'Quem Mais Ignora',
      subtitle: 'Líderes de demora na resposta (>2h).',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(18, side: const BorderSide(color: SwissColors.darkBorder)),
            ),
            child: Column(
              children: [
                Text(
                  ig.mostIgnoringName,
                  style: SwissTypography.titleLarge.copyWith(
                    color: SwissColors.emeraldPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${ig.mostIgnoringCount} vácuos aplicados',
                  style: SwissTypography.labelSmall.copyWith(
                    color: SwissColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 13. Quem Mais Tira Print (Playful)
  static Widget _buildG13FakeScreenshots(GrupoAnalysisResult analysis) {
    final msgs = analysis.generalStats.totalMessages;
    final pr = (msgs * 0.05).round().clamp(10, 999);

    return StoryCardBase(
      category: 'Galeria Secreta',
      categoryIcon: Icons.camera_alt_outlined,
      title: 'Prints do Grupo',
      subtitle: 'Momentos inesquecíveis capturados para a posteridade.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '~$pr',
            style: SwissTypography.metricLarge.copyWith(
              fontSize: 54,
              color: SwissColors.emeraldPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'PRINTS ESTIMADOS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 14. Quem Mais Encaminha (Playful)
  static Widget _buildG14FakeForwarded(GrupoAnalysisResult analysis) {
    final msgs = analysis.generalStats.totalMessages;
    final f = (msgs * 0.04).round().clamp(6, 600);

    return StoryCardBase(
      category: 'Central de Repasses',
      categoryIcon: Icons.forward_rounded,
      title: 'Encaminhamentos',
      subtitle: 'Links, notícias e memes compartilhados.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '~$f',
            style: SwissTypography.metricLarge.copyWith(
              fontSize: 54,
              color: SwissColors.emeraldPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'MENSAGENS ENCAMINHADAS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 15. Quem Mais Apaga (Playful)
  static Widget _buildG15FakeDeleted(GrupoAnalysisResult analysis) {
    final msgs = analysis.generalStats.totalMessages;
    final del = (msgs * 0.02).round().clamp(2, 300);

    return StoryCardBase(
      category: 'Arrependimentos',
      categoryIcon: Icons.delete_outline_rounded,
      title: 'Mensagens Apagadas',
      subtitle: 'Textos que desapareceram misteriosamente.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '~$del',
            style: SwissTypography.metricLarge.copyWith(
              fontSize: 54,
              color: SwissColors.emeraldPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'MENSAGENS DELETADAS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 16. Conclusão do Grupo
  static Widget _buildG16Final(GrupoAnalysisResult analysis, VoidCallback? onShare) {
    final gen = analysis.generalStats;

    return StoryCardBase(
      category: 'Retrospectiva Concluída',
      categoryIcon: Icons.celebration_rounded,
      title: 'Group Wrapped',
      subtitle: 'Um ciclo inteiro resumido em dados.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(20, side: const BorderSide(color: SwissColors.emeraldPrimary, width: 1.5)),
            ),
            child: Column(
              children: [
                Text(
                  '${gen.participants.length} Integrantes',
                  style: SwissTypography.titleLarge.copyWith(
                    color: SwissColors.darkTextPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${gen.totalMessages} mensagens analisadas',
                  style: SwissTypography.metricSmall.copyWith(
                    color: SwissColors.emeraldPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: SwissColors.emeraldPrimary,
              foregroundColor: Colors.black,
              shape: SquircleBorder.button(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            onPressed: onShare,
            icon: const Icon(Icons.share_rounded, size: 18),
            label: Text(
              'Compartilhar no Grupo',
              style: SwissTypography.labelLarge.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  static Widget _roleRow(String role, String name, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: SwissColors.darkSurfaceCard,
        shape: SquircleBorder.radius(12, side: const BorderSide(color: SwissColors.darkBorder)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: SwissColors.emeraldPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              role,
              style: SwissTypography.labelSmall.copyWith(
                color: SwissColors.darkTextSecondary,
              ),
            ),
          ),
          Text(
            name,
            style: SwissTypography.titleMedium.copyWith(
              color: SwissColors.darkTextPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _interactionRow(String role, String name, String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: SwissColors.darkSurfaceCard,
        shape: SquircleBorder.radius(14, side: const BorderSide(color: SwissColors.darkBorder)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: SwissColors.emeraldPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: SwissTypography.labelSmall.copyWith(color: SwissColors.darkTextSecondary, fontSize: 11)),
                Text(name, style: SwissTypography.titleMedium.copyWith(color: SwissColors.darkTextPrimary, fontSize: 14)),
              ],
            ),
          ),
          Text(count, style: SwissTypography.labelSmall.copyWith(color: SwissColors.emeraldPrimary)),
        ],
      ),
    );
  }
}
