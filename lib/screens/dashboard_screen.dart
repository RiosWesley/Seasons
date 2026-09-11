import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/models/amigos_stats.dart';
import '../core/models/casal_stats.dart';
import '../core/models/general_stats.dart';
import '../core/models/grupo_stats.dart';
import '../core/models/raw_chat_export.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';
import '../widgets/count_up_text.dart';
import '../widgets/metric_badge.dart';
import '../widgets/swiss_button.dart';
import '../widgets/swiss_card.dart';
import '../stories/stories_viewer_screen.dart';

/// Architectural Swiss-Minimalist Dashboard Screen.
/// Displays comprehensive offline retrospective statistics, mode-specific deep insights,
/// tabular numeral counters, and a prominent trigger to launch the 9:16 Stories experience.
/// Completely unlocked: 100% free with zero paywalls or subscription gates.
class DashboardScreen extends StatelessWidget {
  final ChatAnalysisResult analysis;
  final RawChatExport? rawExport;
  final VoidCallback? onStartStories;

  const DashboardScreen({
    super.key,
    required this.analysis,
    this.rawExport,
    this.onStartStories,
  });

  String _formatResponseTime(double ms) {
    if (ms <= 0) return 'Instantâneo';
    final seconds = (ms / 1000).round();
    if (seconds < 60) return '$seconds s';
    final minutes = (seconds / 60).round();
    if (minutes < 60) return '$minutes min';
    final hours = (minutes / 60).round();
    return '$hours h';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final general = analysis.generalStats;

    final dateRange = '${_formatDate(general.startDate)} — ${_formatDate(general.endDate)}';
    final participantsLabel = general.participants.join(' • ');

    IconData modeIcon;
    String modeName;
    switch (analysis.mode) {
      case ChatMode.casal:
        modeIcon = LucideIcons.heart;
        modeName = 'Modo Casal';
        break;
      case ChatMode.amigos:
        modeIcon = LucideIcons.users;
        modeName = 'Modo Amigos';
        break;
      case ChatMode.grupo:
        modeIcon = LucideIcons.users;
        modeName = 'Modo Grupo';
        break;
    }

    // Affinity percentage calculation
    int affinityScore = 85;
    String affinityLabel = 'Sintonia';
    if (analysis is CasalAnalysisResult) {
      affinityScore = (analysis as CasalAnalysisResult).compatibility.score;
      affinityLabel = 'Compatibilidade';
    } else if (analysis is AmigosAnalysisResult) {
      affinityScore = (analysis as AmigosAnalysisResult).compatibility.score;
      affinityLabel = 'Harmonia do Squad';
    } else if (analysis is GrupoAnalysisResult) {
      affinityScore = 90;
      affinityLabel = 'Vitalidade do Grupo';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório Completo', style: SwissTypography.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2),
            tooltip: 'Exportar Relatório',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => StoriesViewerScreen(
                    analysis: analysis,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          children: [
            // Metadata bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MetricBadge(
                  label: modeName,
                  icon: modeIcon,
                  isAccent: true,
                ),
                Text(
                  dateRange,
                  style: SwissTypography.labelSmall.copyWith(
                    color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Hero Card: Total Messages & Affinity
            SwissCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participantsLabel,
                    style: SwissTypography.labelSmall.copyWith(
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      CountUpText(
                        targetValue: general.totalMessages,
                        style: SwissTypography.metricLarge.copyWith(fontSize: 44),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'mensagens',
                        style: SwissTypography.titleMedium.copyWith(
                          color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Affinity bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        affinityLabel,
                        style: SwissTypography.labelSmall.copyWith(
                          color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                        ),
                      ),
                      Text(
                        '$affinityScore%',
                        style: SwissTypography.labelSmall.copyWith(
                          color: SwissColors.emeraldPrimary,
                          fontWeight: FontWeight.w700,
                          fontFeatures: SwissTypography.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: affinityScore / 100.0,
                      minHeight: 6,
                      backgroundColor: isDark
                          ? SwissColors.darkSurfaceSubdued
                          : SwissColors.lightSurfaceSubdued,
                      valueColor: const AlwaysStoppedAnimation<Color>(SwissColors.emeraldPrimary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Primary CTA: Start 9:16 Stories Experience
                  SwissButton(
                    label: 'Iniciar Wrapped (9:16 Stories)',
                    icon: LucideIcons.sparkles,
                    type: SwissButtonType.primary,
                    fullWidth: true,
                    onPressed: () {
                      if (onStartStories != null) {
                        onStartStories!();
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => StoriesViewerScreen(
                              analysis: analysis,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Metrics 2x2 Grid
            Row(
              children: [
                Expanded(
                  child: SwissCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.calendar, size: 16, color: SwissColors.emeraldPrimary),
                        const SizedBox(height: 10),
                        Text(
                          'Dias Ativos',
                          style: SwissTypography.labelSmall.copyWith(
                            color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        CountUpText(
                          targetValue: general.activeDaysCount > 0 ? general.activeDaysCount : 1,
                          style: SwissTypography.metricSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SwissCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.clock, size: 16, color: SwissColors.emeraldPrimary),
                        const SizedBox(height: 10),
                        Text(
                          'Resposta Média',
                          style: SwissTypography.labelSmall.copyWith(
                            color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatResponseTime(general.averageResponseTimeMs),
                          style: SwissTypography.metricSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: SwissCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.messageCircle, size: 16, color: SwissColors.emeraldPrimary),
                        const SizedBox(height: 10),
                        Text(
                          'Top Palavra',
                          style: SwissTypography.labelSmall.copyWith(
                            color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          general.topWords.isNotEmpty ? general.topWords.first.word : 'N/A',
                          style: SwissTypography.metricSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SwissCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.smile, size: 16, color: SwissColors.emeraldPrimary),
                        const SizedBox(height: 10),
                        Text(
                          'Top Emojis',
                          style: SwissTypography.labelSmall.copyWith(
                            color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          general.topEmojis.isNotEmpty
                              ? general.topEmojis.take(4).map((e) => e.emoji).join(' ')
                              : 'Nenhum',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Mode-specific analytical breakdown
            if (analysis is CasalAnalysisResult)
              _buildCasalSection(context, analysis as CasalAnalysisResult)
            else if (analysis is AmigosAnalysisResult)
              _buildAmigosSection(context, analysis as AmigosAnalysisResult)
            else if (analysis is GrupoAnalysisResult)
              _buildGrupoSection(context, analysis as GrupoAnalysisResult),

            const SizedBox(height: 24),

            // Return to Home CTA
            SwissButton(
              label: 'Voltar ao Início',
              icon: LucideIcons.house,
              type: SwissButtonType.secondary,
              fullWidth: true,
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCasalSection(BuildContext context, CasalAnalysisResult casal) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ll = casal.loveLanguage;
    final totalLl = ll.hearts + ll.romanticWords + ll.memes + ll.directTexts;
    final safeTotal = totalLl > 0 ? totalLl : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Linguagem do Amor (Love Language)',
          style: SwissTypography.titleLarge.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        SwissCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLoveLanguageRow(
                context,
                title: 'Corações & Emojis de Afeto',
                count: ll.hearts,
                pct: (ll.hearts / safeTotal * 100).round(),
                icon: LucideIcons.heart,
              ),
              const Divider(height: 20),
              _buildLoveLanguageRow(
                context,
                title: 'Palavras Românticas',
                count: ll.romanticWords,
                pct: (ll.romanticWords / safeTotal * 100).round(),
                icon: LucideIcons.messageCircle,
              ),
              const Divider(height: 20),
              _buildLoveLanguageRow(
                context,
                title: 'Memes & Risadas',
                count: ll.memes,
                pct: (ll.memes / safeTotal * 100).round(),
                icon: LucideIcons.smile,
              ),
              const Divider(height: 20),
              _buildLoveLanguageRow(
                context,
                title: 'Conversas Diretas & Textos',
                count: ll.directTexts,
                pct: (ll.directTexts / safeTotal * 100).round(),
                icon: LucideIcons.send,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Estatísticas de Resposta & Vácuo',
          style: SwissTypography.titleLarge.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        SwissCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vácuos Registrados (>2h)',
                    style: SwissTypography.bodyMedium.copyWith(
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '${casal.ignoringStats.ignoredCount}',
                    style: SwissTypography.metricSmall,
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Maior Tempo de Espera',
                    style: SwissTypography.bodyMedium.copyWith(
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    _formatResponseTime(casal.ignoringStats.longestIgnoredTimeMs.toDouble()),
                    style: SwissTypography.metricSmall,
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Áudios não respondidos (>1h)',
                    style: SwissTypography.bodyMedium.copyWith(
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '${casal.audioIgnoringStats.ignoredAudios}',
                    style: SwissTypography.metricSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoveLanguageRow(
    BuildContext context, {
    required String title,
    required int count,
    required int pct,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: SwissColors.emeraldPrimary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: SwissTypography.titleMedium.copyWith(fontSize: 14),
              ),
            ),
            Text(
              '$count ($pct%)',
              style: SwissTypography.labelSmall.copyWith(
                color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                fontFeatures: SwissTypography.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: pct / 100.0,
            minHeight: 4,
            backgroundColor: isDark
                ? SwissColors.darkSurfaceSubdued
                : SwissColors.lightSurfaceSubdued,
            valueColor: const AlwaysStoppedAnimation<Color>(SwissColors.emeraldPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildAmigosSection(BuildContext context, AmigosAnalysisResult amigos) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estilos de Comunicação do Squad',
          style: SwissTypography.titleLarge.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        ...amigos.communicationStyles.map((style) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SwissCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: ShapeDecoration(
                      color: isDark
                          ? SwissColors.darkSurfaceSubdued
                          : SwissColors.lightSurfaceSubdued,
                      shape: SquircleBorder.radius(10),
                    ),
                    child: Center(
                      child: Text(
                        style.emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          style.name,
                          style: SwissTypography.titleMedium.copyWith(fontSize: 15),
                        ),
                        Text(
                          'Arquétipo: ${style.style}',
                          style: SwissTypography.bodyMedium.copyWith(
                            fontSize: 12,
                            color: isDark
                                ? SwissColors.darkTextSecondary
                                : SwissColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Text(
          'Dinâmica do Grupo',
          style: SwissTypography.titleLarge.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        SwissCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Iniciador de Conversas',
                    style: SwissTypography.bodyMedium.copyWith(
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    amigos.groupDynamics.conversationStarter,
                    style: SwissTypography.metricSmall,
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mais Interativo',
                    style: SwissTypography.bodyMedium.copyWith(
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    amigos.groupDynamics.mostInteractive,
                    style: SwissTypography.metricSmall,
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mais Rápido na Resposta',
                    style: SwissTypography.bodyMedium.copyWith(
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    amigos.friendStats.fastestReplyName,
                    style: SwissTypography.metricSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrupoSection(BuildContext context, GrupoAnalysisResult grupo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leaderboard de Membros Mais Ativos',
          style: SwissTypography.titleLarge.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        SwissCard(
          child: Column(
            children: grupo.memberRanking.map((member) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (member.medal != null) ...[
                          Text(member.medal!, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            member.name,
                            style: SwissTypography.titleMedium.copyWith(fontSize: 14),
                          ),
                        ),
                        Text(
                          '${member.percentage}%',
                          style: SwissTypography.labelSmall.copyWith(
                            color: SwissColors.emeraldPrimary,
                            fontWeight: FontWeight.w700,
                            fontFeatures: SwissTypography.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: member.percentage / 100.0,
                        minHeight: 4,
                        backgroundColor: isDark
                            ? SwissColors.darkSurfaceSubdued
                            : SwissColors.lightSurfaceSubdued,
                        valueColor: const AlwaysStoppedAnimation<Color>(SwissColors.emeraldPrimary),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Destaques de Interação',
          style: SwissTypography.titleLarge.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        SwissCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Campeão de Reações',
                    style: SwissTypography.bodyMedium.copyWith(
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    grupo.memberInteraction.reactionChampionName,
                    style: SwissTypography.metricSmall,
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Campeão de Respostas',
                    style: SwissTypography.bodyMedium.copyWith(
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    grupo.memberInteraction.replyChampionName,
                    style: SwissTypography.metricSmall,
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Coruja da Madrugada',
                    style: SwissTypography.bodyMedium.copyWith(
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    grupo.groupDynamics.nightOwl,
                    style: SwissTypography.metricSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
