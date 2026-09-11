import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/models/amigos_stats.dart';
import '../../theme/squircle_border.dart';
import '../../theme/swiss_colors.dart';
import '../../theme/swiss_typography.dart';
import '../../widgets/count_up_text.dart';
import 'story_card_base.dart';

/// Builder that generates all 18 bespoke slides for Amigos Mode.
class AmigosStoryCards {
  AmigosStoryCards._();

  static Widget buildSlide({
    required String slideId,
    required AmigosAnalysisResult analysis,
    VoidCallback? onShare,
  }) {
    switch (slideId) {
      case 'a1':
        return _buildA1Header(analysis);
      case 'a2':
        return _buildA2Total(analysis);
      case 'a3':
        return _buildA3Styles(analysis);
      case 'a4':
        return _buildA4Compatibility(analysis);
      case 'a5':
        return _buildA5Timeline(analysis);
      case 'a6':
        return _buildA6Topics(analysis);
      case 'a7':
        return _buildA7Heatmap(analysis);
      case 'a8':
        return _buildA8EmojiCulture(analysis);
      case 'a9':
        return _buildA9Floods(analysis);
      case 'a10':
        return _buildA10Personalities(analysis);
      case 'a11':
        return _buildA11Stats(analysis);
      case 'a12':
        return _buildA12Insight(analysis);
      case 'a13':
        return _buildA13Ignoring(analysis);
      case 'a14':
        return _buildA14AudioIgnoring(analysis);
      case 'a15':
        return _buildA15FakeScreenshots(analysis);
      case 'a16':
        return _buildA16FakeForwarded(analysis);
      case 'a17':
        return _buildA17FakeTyped(analysis);
      case 'a18':
        return _buildA18Final(analysis, onShare);
      default:
        return _buildA1Header(analysis);
    }
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  // 1. Capa do Squad
  static Widget _buildA1Header(AmigosAnalysisResult analysis) {
    final gen = analysis.generalStats;
    final count = gen.participants.length;

    return StoryCardBase(
      category: 'Modo Amigos',
      categoryIcon: Icons.people_alt_rounded,
      title: 'Retrospectiva\ndo Squad',
      subtitle: '$count amigos • ${_formatDate(gen.startDate)} até ${_formatDate(gen.endDate)}',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: ShapeDecoration(
              color: SwissColors.emeraldPrimary.withValues(alpha: 0.15),
              shape: SquircleBorder.radius(24),
            ),
            child: const Icon(
              Icons.group_rounded,
              color: SwissColors.emeraldPrimary,
              size: 42,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 28),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: gen.participants.map((p) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: ShapeDecoration(
                  color: SwissColors.darkSurfaceCard,
                  shape: SquircleBorder.radius(10, side: const BorderSide(color: SwissColors.darkBorder)),
                ),
                child: Text(
                  p,
                  style: SwissTypography.labelSmall.copyWith(
                    color: SwissColors.darkTextPrimary,
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  // 2. Volume Total
  static Widget _buildA2Total(AmigosAnalysisResult analysis) {
    final gen = analysis.generalStats;
    final days = gen.activeDaysCount > 0 ? gen.activeDaysCount : 1;

    return StoryCardBase(
      category: 'Movimentação do Squad',
      categoryIcon: Icons.chat_bubble_outline_rounded,
      title: 'O Grupo Não\nParou Um Segundo',
      subtitle: 'Total acumulado de fofocas e planos.',
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
            'MENSAGENS DO SQUAD',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Distribuídas ao longo de $days dias de pura resenha',
            textAlign: TextAlign.center,
            style: SwissTypography.bodyMedium.copyWith(
              color: SwissColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // 3. Estilos de Comunicação
  static Widget _buildA3Styles(AmigosAnalysisResult analysis) {
    final styles = analysis.communicationStyles;

    return StoryCardBase(
      category: 'Arquétipos do Squad',
      categoryIcon: Icons.badge_outlined,
      title: 'Estilos de\nComunicação',
      subtitle: 'O papel natural de cada amigo na conversa.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: styles.take(5).map((st) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: ShapeDecoration(
                color: SwissColors.darkSurfaceCard,
                shape: SquircleBorder.radius(12, side: const BorderSide(color: SwissColors.darkBorder)),
              ),
              child: Row(
                children: [
                  Text(st.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          st.name,
                          style: SwissTypography.titleMedium.copyWith(
                            color: SwissColors.darkTextPrimary,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          st.style.toUpperCase(),
                          style: SwissTypography.labelSmall.copyWith(
                            color: SwissColors.emeraldPrimary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 4. Compatibilidade / Harmonia
  static Widget _buildA4Compatibility(AmigosAnalysisResult analysis) {
    final comp = analysis.compatibility;

    return StoryCardBase(
      category: 'Harmonia do Grupo',
      categoryIcon: Icons.diversity_3_rounded,
      title: 'Sintonia da Vibe',
      subtitle: 'Diversidade e complementaridade de estilos.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(36, side: const BorderSide(color: SwissColors.emeraldPrimary, width: 2)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountUpText(
                    targetValue: comp.score,
                    suffix: '%',
                    style: SwissTypography.metricLarge.copyWith(
                      color: SwissColors.emeraldPrimary,
                      fontSize: 38,
                    ),
                  ),
                  Text(
                    'HARMONIA',
                    style: SwissTypography.labelSmall.copyWith(
                      color: SwissColors.darkTextSecondary,
                      fontSize: 9,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            comp.description,
            textAlign: TextAlign.center,
            style: SwissTypography.titleMedium.copyWith(
              color: SwissColors.darkTextPrimary,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  // 5. Linha do Tempo
  static Widget _buildA5Timeline(AmigosAnalysisResult analysis) {
    final timeline = analysis.generalStats.timeline;

    return StoryCardBase(
      category: 'Histórico Mensal',
      categoryIcon: Icons.show_chart_rounded,
      title: 'Onda de Mensagens',
      subtitle: 'Meses em que o squad mais se reuniu online.',
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
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          t.month,
                          style: SwissTypography.titleMedium.copyWith(
                            color: SwissColors.darkTextPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: (t.count / (analysis.generalStats.totalMessages > 0 ? analysis.generalStats.totalMessages : 1)).clamp(0.05, 1.0),
                            minHeight: 8,
                            backgroundColor: SwissColors.darkSurfaceSubdued,
                            valueColor: const AlwaysStoppedAnimation<Color>(SwissColors.emeraldPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${t.count}',
                        style: SwissTypography.labelSmall.copyWith(
                          color: SwissColors.darkTextSecondary,
                          fontFeatures: SwissTypography.tabularFigures,
                        ),
                      ),
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

  // 6. Top Conversas / Tópicos
  static Widget _buildA6Topics(AmigosAnalysisResult analysis) {
    final words = analysis.generalStats.topWords.take(4).toList();

    return StoryCardBase(
      category: 'Assuntos em Alta',
      categoryIcon: Icons.topic_rounded,
      title: 'Tópicos Mais\nDiscutidos',
      subtitle: 'O que dominou as conversas do grupo.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: words.map((w) {
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
                  Text(
                    w.word.toUpperCase(),
                    style: SwissTypography.titleMedium.copyWith(
                      color: SwissColors.darkTextPrimary,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${w.count} menções',
                    style: SwissTypography.labelSmall.copyWith(
                      color: SwissColors.emeraldPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 7. Heatmap de Atividade
  static Widget _buildA7Heatmap(AmigosAnalysisResult analysis) {
    final fStat = analysis.friendStats;

    return StoryCardBase(
      category: 'Picos de Atividade',
      categoryIcon: Icons.access_time_rounded,
      title: 'Horário Nobre do\nSquad',
      subtitle: 'Quando a resenha pega fogo.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(20, side: const BorderSide(color: SwissColors.emeraldPrimary, width: 1.5)),
            ),
            child: Text(
              fStat.activeHourFormatted,
              style: SwissTypography.displayMedium.copyWith(
                color: SwissColors.emeraldPrimary,
                fontSize: 44,
              ),
            ),
          ).animate().scale(duration: 500.ms),
          const SizedBox(height: 20),
          Text(
            'Dia mais agitado: ${analysis.generalStats.mostActiveDayOfWeek}',
            style: SwissTypography.titleMedium.copyWith(
              color: SwissColors.darkTextPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // 8. Emoji Culture
  static Widget _buildA8EmojiCulture(AmigosAnalysisResult analysis) {
    final emojis = analysis.generalStats.topEmojis.take(5).toList();

    return StoryCardBase(
      category: 'Cultura do Squad',
      categoryIcon: Icons.mood_rounded,
      title: 'Emoji Culture',
      subtitle: 'Os símbolos oficiais da resenha.',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: emojis.map((e) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(14, side: const BorderSide(color: SwissColors.darkBorder)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Text(
                  '${e.count}',
                  style: SwissTypography.labelSmall.copyWith(
                    color: SwissColors.emeraldPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 9. Flood Moments
  static Widget _buildA9Floods(AmigosAnalysisResult analysis) {
    final fStat = analysis.friendStats;

    return StoryCardBase(
      category: 'Inundação de Mensagens',
      categoryIcon: Icons.waves_rounded,
      title: 'O Rei do Monólogo',
      subtitle: 'Quem mandou mais mensagens seguidas sem parar.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(20, side: const BorderSide(color: SwissColors.darkBorder)),
            ),
            child: Column(
              children: [
                Text(
                  fStat.biggestFloodName,
                  style: SwissTypography.titleLarge.copyWith(
                    color: SwissColors.emeraldPrimary,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${fStat.biggestFloodCount}',
                  style: SwissTypography.metricLarge.copyWith(
                    fontSize: 48,
                    color: SwissColors.darkTextPrimary,
                  ),
                ),
                Text(
                  'mensagens consecutivas',
                  style: SwissTypography.labelSmall.copyWith(
                    color: SwissColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 450.ms),
        ],
      ),
    );
  }

  // 10. Personalidades
  static Widget _buildA10Personalities(AmigosAnalysisResult analysis) {
    final styles = analysis.communicationStyles;

    return StoryCardBase(
      category: 'Personalidades',
      categoryIcon: Icons.psychology_rounded,
      title: 'O DNA do Squad',
      subtitle: 'Cada um com seu jeito inconfundível.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: styles.map((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(s.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s.name,
                    style: SwissTypography.titleMedium.copyWith(
                      color: SwissColors.darkTextPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  s.style,
                  style: SwissTypography.labelSmall.copyWith(
                    color: SwissColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 11. Estatísticas do Squad
  static Widget _buildA11Stats(AmigosAnalysisResult analysis) {
    final f = analysis.friendStats;
    final dyn = analysis.groupDynamics;

    return StoryCardBase(
      category: 'Destaques do Squad',
      categoryIcon: Icons.military_tech_rounded,
      title: 'Quem é Quem?',
      subtitle: 'Os recordistas do grupo de amigos.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _badgeRow('Mais Falante', f.mostMessagesName, '${f.mostMessagesCount} msgs', Icons.record_voice_over_rounded),
          const SizedBox(height: 12),
          _badgeRow('Mais Rápido', f.fastestReplyName, f.fastestReplyTimeFormatted, Icons.flash_on_rounded),
          const SizedBox(height: 12),
          _badgeRow('Inicia Conversas', dyn.conversationStarter, 'Líder dos tópicos', Icons.chat_rounded),
        ],
      ).animate().fadeIn(duration: 450.ms),
    );
  }

  // 12. Insight
  static Widget _buildA12Insight(AmigosAnalysisResult analysis) {
    final main = analysis.insights.isNotEmpty
        ? analysis.insights.first
        : 'Grupo extremamente ativo com dinamismo exemplar e laços de amizade consolidados.';

    return StoryCardBase(
      category: 'Diagnóstico da Amizade',
      categoryIcon: Icons.lightbulb_outline_rounded,
      title: 'Insight do Squad',
      subtitle: 'O resumo da convivência de vocês.',
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

  // 13. Interações Ocultas (Ghosting)
  static Widget _buildA13Ignoring(AmigosAnalysisResult analysis) {
    final ig = analysis.ignoringStats;

    return StoryCardBase(
      category: 'Interações Ocultas',
      categoryIcon: Icons.timer_off_outlined,
      title: 'Vácuo Amigável',
      subtitle: 'Quando a resposta demorou para sair.',
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
                  '${ig.ignoredCount}',
                  style: SwissTypography.metricLarge.copyWith(
                    color: SwissColors.emeraldPrimary,
                    fontSize: 44,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Vácuos Registrados (>2h)',
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

  // 14. Áudios no Vácuo
  static Widget _buildA14AudioIgnoring(AmigosAnalysisResult analysis) {
    final a = analysis.audioIgnoringStats;

    return StoryCardBase(
      category: 'Podcast do WhatsApp',
      categoryIcon: Icons.mic_rounded,
      title: 'Áudios Longos',
      subtitle: 'Quem manda podcast de 5 minutos.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${a.totalAudios}',
            style: SwissTypography.metricLarge.copyWith(
              fontSize: 52,
              color: SwissColors.emeraldPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ÁUDIOS OU MÍDIAS ENVIADAS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 15. Prints Tirados
  static Widget _buildA15FakeScreenshots(AmigosAnalysisResult analysis) {
    final msgs = analysis.generalStats.totalMessages;
    final pr = (msgs * 0.045).round().clamp(6, 850);

    return StoryCardBase(
      category: 'Registro Histórico',
      categoryIcon: Icons.camera_alt_outlined,
      title: 'Prints do Squad',
      subtitle: 'Momentos que foram parar na galeria.',
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
            'PRINTS COLETADOS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 16. Encaminhamentos
  static Widget _buildA16FakeForwarded(AmigosAnalysisResult analysis) {
    final msgs = analysis.generalStats.totalMessages;
    final f = (msgs * 0.035).round().clamp(4, 500);

    return StoryCardBase(
      category: 'Circulação de Links',
      categoryIcon: Icons.forward_rounded,
      title: 'Fofoca Repassada',
      subtitle: 'Memes e notícias que caíram no grupo.',
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
            'REPASSES REGISTRADOS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 17. Digitou mas não enviou
  static Widget _buildA17FakeTyped(AmigosAnalysisResult analysis) {
    final msgs = analysis.generalStats.totalMessages;
    final t = (msgs * 0.06).round().clamp(8, 700);

    return StoryCardBase(
      category: 'Textos Cancelados',
      categoryIcon: Icons.backspace_outlined,
      title: 'Digitou e\nApagou...',
      subtitle: 'Quando alguém pensou duas vezes.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '~$t',
            style: SwissTypography.metricLarge.copyWith(
              fontSize: 54,
              color: SwissColors.emeraldPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'MENSAGENS NÃO ENVIADAS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 18. Conclusão & Compartilhamento
  static Widget _buildA18Final(AmigosAnalysisResult analysis, VoidCallback? onShare) {
    final gen = analysis.generalStats;

    return StoryCardBase(
      category: 'Retrospectiva do Squad',
      categoryIcon: Icons.celebration_rounded,
      title: 'Squad Wrapped',
      subtitle: 'A união do grupo em números.',
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
                  '${gen.participants.length} Amigos',
                  style: SwissTypography.titleLarge.copyWith(
                    color: SwissColors.darkTextPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${gen.totalMessages} mensagens trocadas',
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
              'Compartilhar no Status',
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

  static Widget _badgeRow(String role, String name, String detail, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: SwissColors.darkSurfaceCard,
        shape: SquircleBorder.radius(14, side: const BorderSide(color: SwissColors.darkBorder)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: SwissColors.emeraldPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: SwissTypography.labelSmall.copyWith(color: SwissColors.darkTextSecondary, fontSize: 11)),
                Text(name, style: SwissTypography.titleMedium.copyWith(color: SwissColors.darkTextPrimary, fontSize: 15)),
              ],
            ),
          ),
          Text(detail, style: SwissTypography.labelSmall.copyWith(color: SwissColors.emeraldPrimary)),
        ],
      ),
    );
  }
}
