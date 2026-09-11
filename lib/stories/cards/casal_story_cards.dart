import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/models/casal_stats.dart';
import '../../theme/squircle_border.dart';
import '../../theme/swiss_colors.dart';
import '../../theme/swiss_typography.dart';
import '../../widgets/count_up_text.dart';
import 'story_card_base.dart';

/// Builder that generates all 18 bespoke slides for Casal Mode.
class CasalStoryCards {
  CasalStoryCards._();

  static Widget buildSlide({
    required String slideId,
    required CasalAnalysisResult analysis,
    VoidCallback? onShare,
  }) {
    switch (slideId) {
      case 'c1':
        return _buildC1Header(analysis);
      case 'c2':
        return _buildC2Total(analysis);
      case 'c3':
        return _buildC3LoveLanguage(analysis);
      case 'c4':
        return _buildC4Compatibility(analysis);
      case 'c5':
        return _buildC5Timeline(analysis);
      case 'c6':
        return _buildC6TopWords(analysis);
      case 'c7':
        return _buildC7Heatmap(analysis);
      case 'c8':
        return _buildC8EmojiEvolution(analysis);
      case 'c9':
        return _buildC9SpecialMoments(analysis);
      case 'c10':
        return _buildC10Comparison(analysis);
      case 'c11':
        return _buildC11Stats(analysis);
      case 'c12':
        return _buildC12Insight(analysis);
      case 'c13':
        return _buildC13Ignoring(analysis);
      case 'c14':
        return _buildC14AudioIgnoring(analysis);
      case 'c15':
        return _buildC15FakeScreenshots(analysis);
      case 'c16':
        return _buildC16FakeForwarded(analysis);
      case 'c17':
        return _buildC17FakeTyped(analysis);
      case 'c18':
        return _buildC18Final(analysis, onShare);
      default:
        return _buildC1Header(analysis);
    }
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  static String _formatDuration(double ms) {
    if (ms <= 0) return 'Instantâneo';
    final sec = (ms / 1000).round();
    if (sec < 60) return '$sec seg';
    final min = (sec / 60).round();
    if (min < 60) return '$min min';
    final h = (min / 60).round();
    return '$h h';
  }

  // 1. Capa
  static Widget _buildC1Header(CasalAnalysisResult analysis) {
    final gen = analysis.generalStats;
    final p1 = gen.participants.isNotEmpty ? gen.participants.first : 'Você';
    final p2 = gen.participants.length > 1 ? gen.participants[1] : 'Parceiro';

    return StoryCardBase(
      category: 'Modo Casal',
      categoryIcon: Icons.favorite_rounded,
      title: 'A História de\nVocês Dois',
      subtitle: '${_formatDate(gen.startDate)} até ${_formatDate(gen.endDate)}',
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
              Icons.favorite_rounded,
              color: SwissColors.emeraldPrimary,
              size: 44,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 32),
          Text(
            '$p1\n&\n$p2',
            textAlign: TextAlign.center,
            style: SwissTypography.displayMedium.copyWith(
              color: SwissColors.darkTextPrimary,
              fontSize: 32,
              height: 1.25,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(12, side: const BorderSide(color: SwissColors.darkBorder)),
            ),
            child: Text(
              'Toque para descobrir a sintonia do casal',
              style: SwissTypography.labelSmall.copyWith(
                color: SwissColors.darkTextSecondary,
              ),
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  // 2. Total de Mensagens
  static Widget _buildC2Total(CasalAnalysisResult analysis) {
    final gen = analysis.generalStats;
    final days = gen.activeDaysCount > 0 ? gen.activeDaysCount : 1;
    final avgDaily = (gen.totalMessages / days).round();

    return StoryCardBase(
      category: 'Volume de Conversa',
      categoryIcon: Icons.forum_rounded,
      title: 'Vocês Falaram\nBastante!',
      subtitle: 'Cada mensagem foi um pedacinho da história.',
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
            'MENSAGENS TROCADAS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          Row(
            children: [
              Expanded(
                child: _miniStatBox(
                  label: 'Média por Dia',
                  value: '$avgDaily msgs',
                  icon: Icons.speed_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniStatBox(
                  label: 'Dias Conectados',
                  value: '$days dias',
                  icon: Icons.calendar_today_rounded,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
        ],
      ),
    );
  }

  // 3. Love Language
  static Widget _buildC3LoveLanguage(CasalAnalysisResult analysis) {
    final ll = analysis.loveLanguage;
    final total = ll.hearts + ll.romanticWords + ll.memes + ll.directTexts;
    final safeTotal = total > 0 ? total : 1;

    return StoryCardBase(
      category: 'Love Language',
      categoryIcon: Icons.favorite_border_rounded,
      title: 'A Linguagem do\nAmor de Vocês',
      subtitle: 'Como o afeto se traduz no dia a dia.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _loveLanguageRow(
            label: 'Corações & Afeto',
            count: ll.hearts,
            pct: (ll.hearts / safeTotal * 100).round(),
            icon: Icons.favorite_rounded,
            color: const Color(0xFFEF4444),
          ),
          const SizedBox(height: 14),
          _loveLanguageRow(
            label: 'Palavras de Amor',
            count: ll.romanticWords,
            pct: (ll.romanticWords / safeTotal * 100).round(),
            icon: Icons.chat_bubble_rounded,
            color: SwissColors.emeraldPrimary,
          ),
          const SizedBox(height: 14),
          _loveLanguageRow(
            label: 'Memes & Risadas',
            count: ll.memes,
            pct: (ll.memes / safeTotal * 100).round(),
            icon: Icons.sentiment_very_satisfied_rounded,
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 14),
          _loveLanguageRow(
            label: 'Conversas Diretas',
            count: ll.directTexts,
            pct: (ll.directTexts / safeTotal * 100).round(),
            icon: Icons.send_rounded,
            color: const Color(0xFF3B82F6),
          ),
        ],
      ).animate().fadeIn(duration: 450.ms),
    );
  }

  // 4. Compatibilidade
  static Widget _buildC4Compatibility(CasalAnalysisResult analysis) {
    final comp = analysis.compatibility;

    return StoryCardBase(
      category: 'Índice de Sintonia',
      categoryIcon: Icons.auto_awesome_rounded,
      title: 'Compatibilidade',
      subtitle: 'Algoritmo de afinidade baseado em resposta e estilo.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 170,
                height: 170,
                child: CircularProgressIndicator(
                  value: comp.score / 100.0,
                  strokeWidth: 12,
                  backgroundColor: SwissColors.darkSurfaceSubdued,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    SwissColors.emeraldPrimary,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountUpText(
                    targetValue: comp.score,
                    suffix: '%',
                    style: SwissTypography.metricLarge.copyWith(
                      fontSize: 44,
                      color: SwissColors.darkTextPrimary,
                    ),
                  ),
                  Text(
                    'SINTONIA',
                    style: SwissTypography.labelSmall.copyWith(
                      color: SwissColors.emeraldPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(16, side: const BorderSide(color: SwissColors.darkBorder)),
            ),
            child: Text(
              comp.description,
              textAlign: TextAlign.center,
              style: SwissTypography.titleMedium.copyWith(
                color: SwissColors.darkTextPrimary,
                fontSize: 16,
              ),
            ),
          ).animate().fadeIn(delay: 350.ms),
        ],
      ),
    );
  }

  // 5. Atividade no Tempo (Linha do Tempo)
  static Widget _buildC5Timeline(CasalAnalysisResult analysis) {
    final timeline = analysis.generalStats.timeline;
    final maxCount = timeline.fold<int>(0, (m, e) => e.count > m ? e.count : m);
    final safeMax = maxCount > 0 ? maxCount : 1;

    return StoryCardBase(
      category: 'Linha do Tempo',
      categoryIcon: Icons.show_chart_rounded,
      title: 'Ritmo dos Meses',
      subtitle: 'Como o papo fluiu ao longo do ano.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(16, side: const BorderSide(color: SwissColors.darkBorder)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: timeline.take(6).map((item) {
                final ratio = item.count / safeMax;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${item.count}',
                          style: SwissTypography.labelSmall.copyWith(
                            fontSize: 9,
                            color: SwissColors.darkTextSecondary,
                            fontFeatures: SwissTypography.tabularFigures,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 140 * ratio.clamp(0.08, 1.0),
                          decoration: ShapeDecoration(
                            color: item.count == maxCount
                                ? SwissColors.emeraldPrimary
                                : SwissColors.darkSurfaceSubdued,
                            shape: SquircleBorder.radius(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.month,
                          style: SwissTypography.labelSmall.copyWith(
                            fontSize: 11,
                            color: SwissColors.darkTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 20),
          Text(
            'Mês de maior intensidade: ${timeline.isNotEmpty ? timeline.first.month : "N/A"}',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.emeraldPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // 6. Top Palavras
  static Widget _buildC6TopWords(CasalAnalysisResult analysis) {
    final words = analysis.generalStats.topWords.take(5).toList();

    return StoryCardBase(
      category: 'Vocabulário',
      categoryIcon: Icons.abc_rounded,
      title: 'Palavras Mais\nFaladas',
      subtitle: 'O dialeto único da relação.',
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
                    '"${w.word}"',
                    style: SwissTypography.titleMedium.copyWith(
                      color: SwissColors.darkTextPrimary,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    '${w.count}x',
                    style: SwissTypography.metricSmall.copyWith(
                      color: SwissColors.emeraldPrimary,
                      fontSize: 15,
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
  static Widget _buildC7Heatmap(CasalAnalysisResult analysis) {
    final hours = analysis.generalStats.activeHours;
    final topHour = hours.isNotEmpty ? hours.first.hour : 20;

    return StoryCardBase(
      category: 'Horários & Rotina',
      categoryIcon: Icons.access_time_rounded,
      title: 'A Hora Favorita\nde Vocês',
      subtitle: 'Quando a conversa esquenta.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(32, side: const BorderSide(color: SwissColors.emeraldPrimary, width: 2)),
            ),
            child: Center(
              child: Text(
                '${topHour.toString().padLeft(2, "0")}h',
                style: SwissTypography.displayLarge.copyWith(
                  color: SwissColors.emeraldPrimary,
                  fontSize: 38,
                ),
              ),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            'Pico de Mensagens',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Dia mais movimentado: ${analysis.generalStats.mostActiveDayOfWeek}',
            style: SwissTypography.titleMedium.copyWith(
              color: SwissColors.darkTextPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // 8. Evolução de Emojis
  static Widget _buildC8EmojiEvolution(CasalAnalysisResult analysis) {
    final emojis = analysis.generalStats.topEmojis.take(4).toList();

    return StoryCardBase(
      category: 'Expressão Visual',
      categoryIcon: Icons.sentiment_satisfied_alt_rounded,
      title: 'Top Emojis do\nCasal',
      subtitle: 'Reações que dispensaram palavras.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: emojis.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: ShapeDecoration(
                color: SwissColors.darkSurfaceCard,
                shape: SquircleBorder.radius(14, side: const BorderSide(color: SwissColors.darkBorder)),
              ),
              child: Row(
                children: [
                  Text(e.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Enviado ${e.count} vezes',
                      style: SwissTypography.bodyMedium.copyWith(
                        color: SwissColors.darkTextSecondary,
                      ),
                    ),
                  ),
                  Text(
                    '${e.count}',
                    style: SwissTypography.metricSmall.copyWith(
                      color: SwissColors.emeraldPrimary,
                      fontSize: 18,
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

  // 9. Momentos Especiais
  static Widget _buildC9SpecialMoments(CasalAnalysisResult analysis) {
    final gen = analysis.generalStats;

    return StoryCardBase(
      category: 'Marcos Importantes',
      categoryIcon: Icons.star_border_rounded,
      title: 'Dias Memoráveis',
      subtitle: 'Quando vocês mais conversaram sem parar.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: ShapeDecoration(
              color: SwissColors.darkSurfaceCard,
              shape: SquircleBorder.radius(20, side: const BorderSide(color: SwissColors.darkBorder)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.celebration_rounded,
                  color: SwissColors.emeraldPrimary,
                  size: 36,
                ),
                const SizedBox(height: 14),
                Text(
                  _formatDate(gen.startDate),
                  style: SwissTypography.titleLarge.copyWith(
                    color: SwissColors.darkTextPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Início da Retrospectiva Registrada',
                  style: SwissTypography.labelSmall.copyWith(
                    color: SwissColors.darkTextSecondary,
                  ),
                ),
                const Divider(height: 28, color: SwissColors.darkBorder),
                Text(
                  'Total de ${gen.mediaCount} mídias compartilhadas',
                  style: SwissTypography.bodyMedium.copyWith(
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

  // 10. Comparação
  static Widget _buildC10Comparison(CasalAnalysisResult analysis) {
    final pStats = analysis.participantStats;
    final p1 = pStats.isNotEmpty ? pStats.first : null;
    final p2 = pStats.length > 1 ? pStats[1] : null;

    return StoryCardBase(
      category: 'Lado a Lado',
      categoryIcon: Icons.compare_arrows_rounded,
      title: 'Quem é Quem\nno Papo?',
      subtitle: 'Estilos individuais de cada um.',
      child: Row(
        children: [
          Expanded(child: _participantColumn(p1?.name ?? 'P1', p1?.topEmoji ?? '❤️', p1?.topWord ?? 'amor')),
          Container(width: 1, height: 180, color: SwissColors.darkBorder),
          Expanded(child: _participantColumn(p2?.name ?? 'P2', p2?.topEmoji ?? '🥰', p2?.topWord ?? 'lindo')),
        ],
      ).animate().fadeIn(duration: 450.ms),
    );
  }

  static Widget _participantColumn(String name, String emoji, String word) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: SwissTypography.titleMedium.copyWith(
            color: SwissColors.darkTextPrimary,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        Text(emoji, style: const TextStyle(fontSize: 36)),
        const SizedBox(height: 6),
        Text('Emoji Favorito', style: SwissTypography.labelSmall.copyWith(color: SwissColors.darkTextSecondary, fontSize: 10)),
        const SizedBox(height: 16),
        Text('"$word"', style: SwissTypography.titleMedium.copyWith(color: SwissColors.emeraldPrimary, fontSize: 16)),
        const SizedBox(height: 4),
        Text('Top Palavra', style: SwissTypography.labelSmall.copyWith(color: SwissColors.darkTextSecondary, fontSize: 10)),
      ],
    );
  }

  // 11. Estatísticas de Tempo
  static Widget _buildC11Stats(CasalAnalysisResult analysis) {
    final resp = analysis.responseTimeStats;

    return StoryCardBase(
      category: 'Velocidade de Resposta',
      categoryIcon: Icons.bolt_rounded,
      title: 'Ritmo da Conexão',
      subtitle: 'Quanto tempo cada um espera para responder.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _miniStatBox(
            label: 'Tempo Médio de Resposta',
            value: _formatDuration(resp.averageResponseTimeMs),
            icon: Icons.timer_outlined,
          ),
          const SizedBox(height: 12),
          _miniStatBox(
            label: 'Resposta Mais Rápida',
            value: _formatDuration(resp.fastestResponseMs.toDouble()),
            icon: Icons.flash_on_rounded,
          ),
          const SizedBox(height: 12),
          _miniStatBox(
            label: 'Total de Trocas de Turno',
            value: '${resp.responseCount} turnos',
            icon: Icons.sync_alt_rounded,
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 12. Insight
  static Widget _buildC12Insight(CasalAnalysisResult analysis) {
    final insights = analysis.insights;
    final mainInsight = insights.isNotEmpty
        ? insights.first
        : 'Vocês mantêm uma sintonia equilibrada com conversas frequentes e grande conexão emocional.';

    return StoryCardBase(
      category: 'Diagnóstico do Casal',
      categoryIcon: Icons.psychology_alt_rounded,
      title: 'Insight da Sintonia',
      subtitle: 'A essência da comunicação de vocês.',
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: SwissColors.darkSurfaceCard,
          shape: SquircleBorder.radius(20, side: const BorderSide(color: SwissColors.darkBorder)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              color: SwissColors.emeraldPrimary,
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              mainInsight,
              textAlign: TextAlign.center,
              style: SwissTypography.bodyLarge.copyWith(
                color: SwissColors.darkTextPrimary,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 450.ms),
    );
  }

  // 13. Interações Ocultas (Vácuos >2h)
  static Widget _buildC13Ignoring(CasalAnalysisResult analysis) {
    final ig = analysis.ignoringStats;

    return StoryCardBase(
      category: 'Interações Ocultas',
      categoryIcon: Icons.timer_off_outlined,
      title: 'O Famoso Vácuo',
      subtitle: 'Quando a resposta demorou mais de 2 horas.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: _miniStatBox(
                  label: 'Vácuos Dados',
                  value: '${ig.ignoredCount}',
                  icon: Icons.snooze_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniStatBox(
                  label: 'Vácuos Recebidos',
                  value: '${ig.wasIgnoredCount}',
                  icon: Icons.hourglass_bottom_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _miniStatBox(
            label: 'Maior Espera Registrada',
            value: _formatDuration(ig.longestIgnoredTimeMs.toDouble()),
            icon: Icons.history_toggle_off_rounded,
          ),
        ],
      ).animate().fadeIn(duration: 450.ms),
    );
  }

  // 14. Áudios Ignorados (>1h)
  static Widget _buildC14AudioIgnoring(CasalAnalysisResult analysis) {
    final aIg = analysis.audioIgnoringStats;

    return StoryCardBase(
      category: 'Áudios & Mídias',
      categoryIcon: Icons.mic_none_rounded,
      title: 'Áudios no Vácuo',
      subtitle: 'Mensagens de voz que ficaram esperando resposta.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _miniStatBox(
            label: 'Áudios com Demora > 1h',
            value: '${aIg.ignoredAudios}',
            icon: Icons.mic_off_rounded,
          ),
          const SizedBox(height: 14),
          _miniStatBox(
            label: 'Total de Áudios/Mídias',
            value: '${aIg.totalAudios}',
            icon: Icons.graphic_eq_rounded,
          ),
        ],
      ).animate().fadeIn(duration: 450.ms),
    );
  }

  // 15. Prints Tirados (Playful Estimate)
  static Widget _buildC15FakeScreenshots(CasalAnalysisResult analysis) {
    final msgs = analysis.generalStats.totalMessages;
    final estimated = (msgs * 0.04).round().clamp(5, 999);

    return StoryCardBase(
      category: 'Estimativa Divertida',
      categoryIcon: Icons.screenshot_monitor_rounded,
      title: 'Prints Tirados\nda Conversa',
      subtitle: 'Estimativa baseada em momentos memoráveis e piadas.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '~$estimated',
            style: SwissTypography.metricLarge.copyWith(
              fontSize: 56,
              color: SwissColors.emeraldPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'PRINTS SUSPEITOS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Para guardar com carinho (ou usar como prova depois 👀)',
            textAlign: TextAlign.center,
            style: SwissTypography.bodyMedium.copyWith(
              color: SwissColors.darkTextSecondary,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 16. Encaminhamentos
  static Widget _buildC16FakeForwarded(CasalAnalysisResult analysis) {
    final msgs = analysis.generalStats.totalMessages;
    final fwd = (msgs * 0.03).round().clamp(3, 450);

    return StoryCardBase(
      category: 'Trânsito de Notícias',
      categoryIcon: Icons.forward_rounded,
      title: 'Fofocas &\nEncaminhamentos',
      subtitle: 'Links, posts e fofocas compartilhadas.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '~$fwd',
            style: SwissTypography.metricLarge.copyWith(
              fontSize: 56,
              color: SwissColors.emeraldPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'MENSAGENS REPASSADAS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '"Amor, olha isso aqui rápido!"',
            style: SwissTypography.titleMedium.copyWith(
              color: SwissColors.darkTextPrimary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 17. Digitou mas não enviou
  static Widget _buildC17FakeTyped(CasalAnalysisResult analysis) {
    final msgs = analysis.generalStats.totalMessages;
    final typed = (msgs * 0.05).round().clamp(7, 600);

    return StoryCardBase(
      category: 'Pensamentos Secretos',
      categoryIcon: Icons.keyboard_alt_outlined,
      title: 'Digitou e\nApagou...',
      subtitle: 'Textos que foram repensados antes de enviar.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '~$typed',
            style: SwissTypography.metricLarge.copyWith(
              fontSize: 56,
              color: SwissColors.emeraldPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'TEXTINHOS REVISADOS',
            style: SwissTypography.labelSmall.copyWith(
              color: SwissColors.darkTextSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Às vezes o autocontrole fala mais alto.',
            style: SwissTypography.bodyMedium.copyWith(
              color: SwissColors.darkTextSecondary,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // 18. Conclusão & Cartão de Exportação
  static Widget _buildC18Final(CasalAnalysisResult analysis, VoidCallback? onShare) {
    final gen = analysis.generalStats;
    final comp = analysis.compatibility;
    final p1 = gen.participants.isNotEmpty ? gen.participants.first : 'Você';
    final p2 = gen.participants.length > 1 ? gen.participants[1] : 'Parceiro';

    return StoryCardBase(
      category: 'Retrospectiva Completa',
      categoryIcon: Icons.celebration_rounded,
      title: 'Nosso Wrapped',
      subtitle: 'Mais um ano de conexão e história.',
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
                  '$p1 & $p2',
                  style: SwissTypography.titleLarge.copyWith(
                    color: SwissColors.darkTextPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${gen.totalMessages}',
                          style: SwissTypography.metricSmall.copyWith(
                            color: SwissColors.emeraldPrimary,
                          ),
                        ),
                        Text('Mensagens', style: SwissTypography.labelSmall.copyWith(color: SwissColors.darkTextSecondary)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${comp.score}%',
                          style: SwissTypography.metricSmall.copyWith(
                            color: SwissColors.emeraldPrimary,
                          ),
                        ),
                        Text('Compatibilidade', style: SwissTypography.labelSmall.copyWith(color: SwissColors.darkTextSecondary)),
                      ],
                    ),
                  ],
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
              'Compartilhar nos Stories',
              style: SwissTypography.labelLarge.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ).animate().scale(delay: 300.ms, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  static Widget _loveLanguageRow({
    required String label,
    required int count,
    required int pct,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: SwissTypography.titleMedium.copyWith(
                    color: SwissColors.darkTextPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '$count ($pct%)',
                style: SwissTypography.labelSmall.copyWith(
                  color: SwissColors.darkTextSecondary,
                  fontFeatures: SwissTypography.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: pct / 100.0,
              minHeight: 4,
              backgroundColor: SwissColors.darkSurfaceSubdued,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _miniStatBox({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: ShapeDecoration(
        color: SwissColors.darkSurfaceCard,
        shape: SquircleBorder.radius(14, side: const BorderSide(color: SwissColors.darkBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: SwissColors.emeraldPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: SwissTypography.labelSmall.copyWith(
                    color: SwissColors.darkTextSecondary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: SwissTypography.metricSmall.copyWith(
              color: SwissColors.darkTextPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
