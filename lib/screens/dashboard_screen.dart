import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/models/amigos_stats.dart';
import '../core/models/casal_stats.dart';
import '../core/models/general_stats.dart';
import '../core/models/grupo_stats.dart';
import '../core/models/raw_chat_export.dart';
import '../stories/adapters/amigos_story_adapter.dart';
import '../stories/adapters/casal_story_adapter.dart';
import '../stories/adapters/grupo_story_adapter.dart';
import '../stories/stories_viewer_screen.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';
import '../widgets/count_up_text.dart';
import '../widgets/metric_badge.dart';
import '../widgets/swiss_button.dart';

/// Architectural Swiss-Editorial Dashboard Screen.
/// Displays comprehensive offline retrospective statistics, deep relationship analytics,
/// mode-specific Bento cards, tabular numerals, and a prominent trigger to launch the 9:16 Stories.
/// 100% Free with zero paywalls.
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

  static String _formatResponseTime(double ms) {
    if (ms <= 0) return 'Instantâneo';
    final seconds = (ms / 1000).round();
    if (seconds < 60) return '$seconds s';
    final minutes = (seconds / 60).round();
    if (minutes < 60) return '$minutes min';
    final hours = (minutes / 60).round();
    return '$hours h';
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  void _launchStories(BuildContext context) {
    HapticFeedback.selectionClick();
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
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final general = analysis.generalStats;

    final dateRange = '${_formatDate(general.startDate)} — ${_formatDate(general.endDate)}';
    final participantsLabel = general.participants.join(' • ');

    IconData modeIcon;
    String modeName;
    Color modeAccent;
    Color modeCardBg;
    Color modeBorder;

    switch (analysis.mode) {
      case ChatMode.casal:
        modeIcon = LucideIcons.heart;
        modeName = 'Modo Casal';
        modeAccent = const Color(0xFFE11D48);
        modeCardBg = const Color(0xFFFFF1F2);
        modeBorder = const Color(0xFFFECDD3);
        break;
      case ChatMode.amigos:
        modeIcon = LucideIcons.users;
        modeName = 'Modo Amigos';
        modeAccent = const Color(0xFF2563EB);
        modeCardBg = const Color(0xFFEFF6FF);
        modeBorder = const Color(0xFFBFDBFE);
        break;
      case ChatMode.grupo:
        modeIcon = LucideIcons.users;
        modeName = 'Modo Grupo';
        modeAccent = const Color(0xFF7C3AED);
        modeCardBg = const Color(0xFFFAF5FF);
        modeBorder = const Color(0xFFE9D5FF);
        break;
    }

    int affinityScore = 85;
    String affinityLabel = 'Sintonia';
    String affinityDesc = 'Conexão calibrada e fluida';
    if (analysis is CasalAnalysisResult) {
      final casal = analysis as CasalAnalysisResult;
      affinityScore = casal.compatibility.score;
      affinityLabel = 'Compatibilidade';
      affinityDesc = casal.compatibility.description;
    } else if (analysis is AmigosAnalysisResult) {
      final amigos = analysis as AmigosAnalysisResult;
      affinityScore = amigos.compatibility.score;
      affinityLabel = 'Harmonia do Squad';
      affinityDesc = amigos.compatibility.description;
    } else if (analysis is GrupoAnalysisResult) {
      affinityScore = 90;
      affinityLabel = 'Vitalidade do Grupo';
      affinityDesc = 'Comunidade ativa com engajamento constante';
    }

    return Scaffold(
      backgroundColor: isDark ? SwissColors.darkBackground : const Color(0xFFFBF9F5),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Paper Texture & Studio Lighting
          if (!isDark) ...[
            Positioned.fill(
              child: Opacity(
                opacity: 0.35,
                child: Image.asset(
                  'assets/images/home_paper_texture.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      modeAccent.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],

          // Main Scrollable Content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Editorial Top Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        Material(
                          color: isDark ? SwissColors.darkSurfaceCard : Colors.white,
                          shape: SquircleBorder.radius(14),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                LucideIcons.arrowLeft,
                                size: 18,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ),

                        // Title Branding
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'seasons',
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Relatório Completo',
                              style: SwissTypography.labelSmall.copyWith(
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w700,
                                color: modeAccent,
                              ),
                            ),
                          ],
                        ),

                        // Share / Stories Action
                        Material(
                          color: isDark ? SwissColors.darkSurfaceCard : Colors.white,
                          shape: SquircleBorder.radius(14),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => _launchStories(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  LucideIcons.share2,
                                  size: 18,
                                  color: modeAccent,
                                ),
                                tooltip: 'Exportar Relatório',
                                onPressed: () => _launchStories(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Report Body
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Mode badge & date range bar
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // HERO BENTO CARD: Total Messages & Affinity Score
                      _buildHeroBentoCard(
                        context: context,
                        participantsLabel: participantsLabel,
                        totalMessages: general.totalMessages,
                        affinityLabel: affinityLabel,
                        affinityScore: affinityScore,
                        affinityDesc: affinityDesc,
                        modeAccent: modeAccent,
                        modeCardBg: modeCardBg,
                        modeBorder: modeBorder,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 18),

                      // QUICK METRICS 2x2 GRID
                      _buildQuickMetricsGrid(
                        context: context,
                        general: general,
                        modeAccent: modeAccent,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      // MODE-SPECIFIC EXPANDED ANALYTICAL SECTIONS
                      if (analysis is CasalAnalysisResult)
                        _buildCasalComprehensiveReport(
                          context,
                          analysis as CasalAnalysisResult,
                          modeAccent,
                          isDark,
                        )
                      else if (analysis is AmigosAnalysisResult)
                        _buildAmigosSection(context, analysis as AmigosAnalysisResult)
                      else if (analysis is GrupoAnalysisResult)
                        _buildGrupoSection(context, analysis as GrupoAnalysisResult),

                      const SizedBox(height: 28),

                      // Bottom Return Button
                      SwissButton(
                        label: 'Voltar ao Início',
                        icon: LucideIcons.house,
                        type: SwissButtonType.secondary,
                        fullWidth: true,
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Minimal Offline Security Stamp
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.shieldCheck,
                              size: 13,
                              color: isDark ? SwissColors.darkTextMuted : SwissColors.lightTextMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'SEASONS • ANÁLISE 100% LOCAL & OFFLINE',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                                color: isDark ? SwissColors.darkTextMuted : SwissColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // HERO BENTO CARD
  // ==========================================================================
  Widget _buildHeroBentoCard({
    required BuildContext context,
    required String participantsLabel,
    required int totalMessages,
    required String affinityLabel,
    required int affinityScore,
    required String affinityDesc,
    required Color modeAccent,
    required Color modeCardBg,
    required Color modeBorder,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? SwissColors.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? SwissColors.darkBorder : modeBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: modeAccent.withValues(alpha: isDark ? 0.08 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow with participants
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: modeAccent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  participantsLabel,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Monumental Counter
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CountUpText(
                targetValue: totalMessages,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'mensagens',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Affinity Meter
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? SwissColors.darkSurfaceSubdued : modeCardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? SwissColors.darkBorder : modeBorder,
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      affinityLabel,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                      ),
                    ),
                    Text(
                      '$affinityScore%',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: modeAccent,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: affinityScore / 100.0,
                    minHeight: 7,
                    backgroundColor: isDark ? const Color(0xFF2D1620) : Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(modeAccent),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  affinityDesc,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: isDark ? SwissColors.darkTextSecondary : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Primary Stories CTA Button
          SwissButton(
            label: 'Iniciar Wrapped (9:16 Stories)',
            icon: LucideIcons.sparkles,
            type: SwissButtonType.primary,
            fullWidth: true,
            onPressed: () => _launchStories(context),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // QUICK METRICS 2x2 GRID
  // ==========================================================================
  Widget _buildQuickMetricsGrid({
    required BuildContext context,
    required GeneralStats general,
    required Color modeAccent,
    required bool isDark,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                icon: LucideIcons.calendar,
                title: 'Dias Ativos',
                value: '${general.activeDaysCount > 0 ? general.activeDaysCount : 1}',
                unit: 'dias',
                accentColor: modeAccent,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricTile(
                icon: LucideIcons.clock,
                title: 'Resposta Média',
                value: _formatResponseTime(general.averageResponseTimeMs),
                unit: 'velocidade',
                accentColor: modeAccent,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                icon: LucideIcons.messageCircle,
                title: 'Top Palavra',
                value: general.topWords.isNotEmpty ? general.topWords.first.word : 'N/A',
                unit: general.topWords.isNotEmpty ? '${general.topWords.first.count}x' : '',
                accentColor: modeAccent,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricTile(
                icon: LucideIcons.smile,
                title: 'Top Emojis',
                value: general.topEmojis.isNotEmpty
                    ? general.topEmojis.take(3).map((e) => e.emoji).join(' ')
                    : 'Nenhum',
                unit: 'expressão',
                accentColor: modeAccent,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required Color accentColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? SwissColors.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 16, color: accentColor),
              if (unit.isNotEmpty)
                Text(
                  unit.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: isDark ? SwissColors.darkTextMuted : SwissColors.lightTextMuted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // CASAL COMPREHENSIVE REPORT (BESPOKE EDITORIAL SYSTEM)
  // ==========================================================================
  Widget _buildCasalComprehensiveReport(
    BuildContext context,
    CasalAnalysisResult casal,
    Color modeAccent,
    bool isDark,
  ) {
    final adapter = CasalStoryAdapter(casal);
    final ll = casal.loveLanguage;
    final totalLl = ll.hearts + ll.romanticWords + ll.memes + ll.directTexts;
    final safeTotal = totalLl > 0 ? totalLl : 1;

    final cardBg = isDark ? SwissColors.darkSurfaceCard : Colors.white;
    final border = isDark ? SwissColors.darkBorder : const Color(0xFFFECDD3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------------------------------------------------------------
        // 1. BALANÇO DO CASAL (QUEM FALA MAIS)
        // --------------------------------------------------------------------
        _buildSectionHeader('Balanço da Parceria', 'Quem fala mais e o ritmo de cada um', modeAccent, isDark),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 1.0),
          ),
          child: Column(
            children: [
              // Dual percentage visual bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 14,
                  child: Row(
                    children: [
                      Expanded(
                        flex: adapter.partner1Percentage.clamp(5, 95),
                        child: Container(color: modeAccent),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        flex: adapter.partner2Percentage.clamp(5, 95),
                        child: Container(color: const Color(0xFFFB7185)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Partner 1 & Partner 2 columns
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: modeAccent),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                adapter.partner1,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${adapter.partner1Messages} msgs (${adapter.partner1Percentage}%)',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: modeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                adapter.partner2,
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFB7185)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${adapter.partner2Messages} msgs (${adapter.partner2Percentage}%)',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFB7185),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 28),
              // Daily pace & days together
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ritmo Diário de Mensagens',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '${adapter.dailyMessagePaceFormatted} msgs/dia',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // --------------------------------------------------------------------
        // 2. LINGUAGEM DO AMOR (LOVE LANGUAGE) - REQUIRED FOR TESTS
        // --------------------------------------------------------------------
        Text(
          'Linguagem do Amor (Love Language)',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Como o afeto se manifestou numericamente nas conversas.',
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dominant banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? SwissColors.darkSurfaceSubdued : const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border, width: 0.8),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.sparkles, size: 14, color: Color(0xFFE11D48)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Predominante: ${adapter.dominantLoveLanguageName} (${adapter.dominantLoveLanguagePercentage}%)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE11D48),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
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

        const SizedBox(height: 24),

        // --------------------------------------------------------------------
        // 3. ESTATÍSTICAS DE RESPOSTA & VÁCUO - REQUIRED FOR TESTS
        // --------------------------------------------------------------------
        Text(
          'Estatísticas de Resposta & Vácuo',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'A velocidade da conversa e momentos em que o mundo real chamou.',
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vácuos Registrados (>2h)',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '${casal.ignoringStats.ignoredCount}',
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Maior Tempo de Espera',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    _formatResponseTime(casal.ignoringStats.longestIgnoredTimeMs.toDouble()),
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Áudios não respondidos (>1h)',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '${casal.audioIgnoringStats.ignoredAudios}',
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Resposta Mais Rápida',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    adapter.fastestResponseFormatted,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: modeAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // --------------------------------------------------------------------
        // 4. "A NOSSA HORA" (PICO DE INTIMIDADE & HORÁRIOS)
        // --------------------------------------------------------------------
        _buildSectionHeader('A Nossa Hora', 'O horário sagrado em que a conversa mais esquenta', modeAccent, isDark),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 1.0),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? SwissColors.darkSurfaceSubdued : const Color(0xFFFFF1F2),
                      border: Border.all(color: border, width: 1.0),
                    ),
                    child: Icon(LucideIcons.clock, color: modeAccent, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pico Diário do Casal',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                          ),
                        ),
                        Text(
                          adapter.peakIntimacyFormatted,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: modeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'É nessa janela horária que ocorrem as conversas mais longas, trocas de áudio e desabafos do casal.',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontStyle: FontStyle.italic,
                  fontSize: 12.5,
                  color: isDark ? SwissColors.darkTextSecondary : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // --------------------------------------------------------------------
        // 5. ÁUDIOS & PODCASTS DO CASAL
        // --------------------------------------------------------------------
        _buildSectionHeader('Áudios & Podcasts', 'A minutagem de voz acumulada', modeAccent, isDark),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 1.0),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? SwissColors.darkSurfaceSubdued : const Color(0xFFFFF1F2),
                ),
                child: const Icon(LucideIcons.mic, color: Color(0xFFE11D48), size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${adapter.totalAudios} áudios gravados',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Aproximadamente ${adapter.estimatedAudioMinutesFormatted} de voz compartilhada.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // --------------------------------------------------------------------
        // 6. TOP PALAVRAS & VOCABULÁRIO AFETIVO
        // --------------------------------------------------------------------
        _buildSectionHeader('Vocabulário Afetivo', 'As palavras que definem o dialeto a dois', modeAccent, isDark),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 1.0),
          ),
          child: adapter.topWords.isEmpty
              ? const Text('Sem palavras suficientes para gerar nuvem.')
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: adapter.topWords.take(10).map((w) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? SwissColors.darkSurfaceSubdued : const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: border, width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            w.word,
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${w.count}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: modeAccent,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),

        const SizedBox(height: 24),

        // --------------------------------------------------------------------
        // 7. CRÔNICA EDITORIAL & INSIGHT
        // --------------------------------------------------------------------
        if (casal.insights.isNotEmpty) ...[
          _buildSectionHeader('Crônica do Casal', 'Diagnóstico sociológico e afetivo da relação', modeAccent, isDark),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: isDark ? SwissColors.darkSurfaceCard : const Color(0xFFFFF9F5),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: border, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '“',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 38,
                    height: 0.8,
                    color: Color(0xFFE11D48),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  casal.insights.first,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    fontSize: 14.5,
                    height: 1.5,
                    color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, Color accent, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
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
            Icon(icon, size: 14, color: const Color(0xFFE11D48)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '$count ($pct%)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: pct / 100.0,
            minHeight: 5,
            backgroundColor: isDark ? SwissColors.darkSurfaceSubdued : const Color(0xFFFEE2E2),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE11D48)),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // AMIGOS SECTION (PRESERVES EXISTING TEST EXPECTATIONS)
  // ==========================================================================
  // AMIGOS SECTION (PRESERVES EXISTING TEST EXPECTATIONS + EDITORIAL DEPTH)
  // ==========================================================================
  Widget _buildAmigosSection(BuildContext context, AmigosAnalysisResult amigos) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? SwissColors.darkSurfaceCard : Colors.white;
    const border = Color(0xFFBFDBFE);
    const accent = Color(0xFF2563EB);
    final adapter = AmigosStoryAdapter(amigos);
    final totalMsgs = adapter.totalMessages > 0 ? adapter.totalMessages : 1;

    final memberColors = [
      const Color(0xFF2563EB), // Electric Royal Blue
      const Color(0xFF38BDF8), // Vivid Sky Blue
      const Color(0xFFFACC15), // Amber / Yellow
      const Color(0xFF10B981), // Emerald Green
      const Color(0xFFF43F5E), // Rose Coral
      const Color(0xFF8B5CF6), // Purple
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. ROSTER & DISTRIBUIÇÃO DE VOZ DO SQUAD
        Text(
          'Distribuição de Voz do Squad',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented voice distribution bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 14,
                  child: Row(
                    children: adapter.sortedMemberVolumes.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final count = entry.value.value;
                      final flex = ((count / totalMsgs) * 1000).round().clamp(1, 1000);
                      return Expanded(
                        flex: flex,
                        child: Container(
                          color: memberColors[idx % memberColors.length],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Member rows
              ...adapter.sortedMemberVolumes.asMap().entries.map((entry) {
                final idx = entry.key;
                final name = entry.value.key;
                final count = entry.value.value;
                final pct = ((count / totalMsgs) * 100).toStringAsFixed(1);
                final col = memberColors[idx % memberColors.length];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: col,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '$count msgs',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: col.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$pct%',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: col,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 2. ESTILOS DE COMUNICAÇÃO DO SQUAD (Exact string expected by tests)
        Text(
          'Estilos de Comunicação do Squad',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        ...amigos.communicationStyles.map((style) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border, width: 0.8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDark ? SwissColors.darkSurfaceSubdued : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border.withValues(alpha: 0.5)),
                    ),
                    child: Center(
                      child: Text(
                        style.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          style.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Arquétipo: ${style.style}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
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

        const SizedBox(height: 24),

        // 3. DINÂMICA DO GRUPO (Exact strings expected by tests)
        Text(
          'Dinâmica do Grupo',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMetricRow(
                context,
                icon: LucideIcons.flame,
                iconColor: const Color(0xFFF97316),
                title: 'Iniciador de Conversas',
                value: amigos.groupDynamics.conversationStarter,
              ),
              const Divider(height: 24),
              _buildMetricRow(
                context,
                icon: LucideIcons.sparkles,
                iconColor: const Color(0xFF3B82F6),
                title: 'Mais Interativo',
                value: amigos.groupDynamics.mostInteractive,
              ),
              const Divider(height: 24),
              _buildMetricRow(
                context,
                icon: LucideIcons.zap,
                iconColor: const Color(0xFFEAB308),
                title: 'Mais Rápido na Resposta',
                value: amigos.friendStats.fastestReplyName,
              ),
              const Divider(height: 24),
              _buildMetricRow(
                context,
                icon: LucideIcons.messageSquareDashed,
                iconColor: const Color(0xFFEF4444),
                title: 'Recorde de Flood',
                value: '${adapter.biggestFloodAuthor} (${adapter.biggestFloodCount} msgs)',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 4. TELEMETRIA & DIPLOMACIA DO VÁCUO
        Text(
          'Telemetria de Respostas & Vácuo',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border, width: 0.8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tempo Médio de Resposta',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    adapter.averageResponseTimeFormatted,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'O Fantasma (Mais deixa no vácuo)',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    adapter.vacuumKing,
                    style: const TextStyle(fontFamily: 'serif', fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'O Mais Paciente (Mais ignorado)',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    adapter.vacuumVictim,
                    style: const TextStyle(fontFamily: 'serif', fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 5. CENTRAL DE MÍDIAS, PODCAST & MEMES
        Text(
          'Central de Mídias & Podcasts',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.mic, size: 20, color: Color(0xFF2563EB)),
                    const SizedBox(height: 10),
                    Text(
                      '${adapter.totalAudios} áudios',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '~${adapter.estimatedAudioMinutes} min (${adapter.podcasterAuthor})',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.image, size: 20, color: Color(0xFF06B6D4)),
                    const SizedBox(height: 10),
                    Text(
                      '${adapter.estimatedPrints} prints',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Detetive: ${adapter.printInvestigator}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 6. JARGÕES & VOCABULÁRIO DO SQUAD
        if (adapter.topWords.isNotEmpty) ...[
          Text(
            'Jargões & Vocabulário do Squad',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: border, width: 0.8),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 10,
              children: adapter.topWords.take(10).toList().asMap().entries.map((entry) {
                final idx = entry.key;
                final w = entry.value;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: idx < 3
                        ? const Color(0xFFEFF6FF)
                        : (isDark ? SwissColors.darkSurfaceSubdued : const Color(0xFFF8FAFC)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: idx < 3 ? border : Colors.transparent,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '#${idx + 1}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: idx < 3 ? accent : (isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        w.word,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${w.count})',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // 7. CRÔNICA DO SQUAD
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? SwissColors.darkSurfaceSubdued : const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 0.8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.quote, size: 22, color: accent),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  adapter.primaryInsight,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 14,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // GRUPO SECTION (PRESERVES EXISTING TEST EXPECTATIONS + BROADSHEET DEPTH)
  // ==========================================================================
  Widget _buildGrupoSection(BuildContext context, GrupoAnalysisResult grupo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? SwissColors.darkSurfaceCard : Colors.white;
    const border = Color(0xFFDDD6FE);
    const accent = Color(0xFF7C3AED);
    final adapter = GrupoStoryAdapter(grupo);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. PÓDIO DOS CAMPEÕES (Top 3 Members)
        if (adapter.top3Members.isNotEmpty) ...[
          Text(
            'Pódio da Comunidade',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: adapter.top3Members.asMap().entries.map((entry) {
              final idx = entry.key;
              final m = entry.value;
              final medals = ['🥇', '🥈', '🥉'];
              final medal = medals[idx % medals.length];
              final borderCol = idx == 0
                  ? const Color(0xFFEAB308)
                  : (idx == 1 ? const Color(0xFF94A3B8) : const Color(0xFFB45309));

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: idx == 0 ? 0 : 6,
                    right: idx == adapter.top3Members.length - 1 ? 0 : 6,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderCol.withValues(alpha: 0.6), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: borderCol.withValues(alpha: isDark ? 0.15 : 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(medal, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 6),
                      Text(
                        m.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${m.percentage}%',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: borderCol,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // 2. LEADERBOARD DE MEMBROS MAIS ATIVOS (Exact string expected by tests)
        Text(
          'Leaderboard de Membros Mais Ativos',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: grupo.memberRanking.map((member) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0),
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
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Text(
                          '${member.percentage}%',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w800,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: member.percentage / 100.0,
                        minHeight: 5,
                        backgroundColor: isDark ? SwissColors.darkSurfaceSubdued : const Color(0xFFF3E8FF),
                        valueColor: const AlwaysStoppedAnimation<Color>(accent),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 24),

        // 3. DESTAQUES DE INTERAÇÃO (Exact strings expected by tests)
        Text(
          'Destaques de Interação',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMetricRow(
                context,
                icon: LucideIcons.heart,
                iconColor: const Color(0xFFEC4899),
                title: 'Campeão de Reações',
                value: grupo.memberInteraction.reactionChampionName,
              ),
              const Divider(height: 24),
              _buildMetricRow(
                context,
                icon: LucideIcons.messageSquare,
                iconColor: const Color(0xFF7C3AED),
                title: 'Campeão de Respostas',
                value: grupo.memberInteraction.replyChampionName,
              ),
              const Divider(height: 24),
              _buildMetricRow(
                context,
                icon: LucideIcons.moon,
                iconColor: const Color(0xFF6366F1),
                title: 'Coruja da Madrugada',
                value: grupo.groupDynamics.nightOwl,
              ),
              if (grupo.groupDynamics.silent.isNotEmpty) ...[
                const Divider(height: 24),
                _buildMetricRow(
                  context,
                  icon: LucideIcons.eye,
                  iconColor: const Color(0xFF64748B),
                  title: 'Infiltrado / Observador',
                  value: grupo.groupDynamics.silent,
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 4. VOLUME LITERÁRIO & REGRA DE PARETO (80/20)
        Text(
          'Equivalência & Balança de Poder',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border, width: 0.8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.bookOpen, size: 20, color: Color(0xFF7C3AED)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Volume Literário',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          adapter.literaryBookDescription,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(LucideIcons.pieChart, size: 20, color: Color(0xFFEAB308)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Balança de Poder (Regra 80/20)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'O topo da lista concentra ${adapter.paretoTopSharePercentage}% de todo o volume do grupo.',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 13,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 5. TROFÉUS ESPECIAIS DO GRUPO
        Text(
          'Dossiê & Troféus Especiais',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.trophy, size: 20, color: Color(0xFFEAB308)),
                    const SizedBox(height: 10),
                    const Text(
                      'Vácuo de Ouro',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${adapter.vacuumChampion} (${adapter.vacuumCount} vácuos)',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.newspaper, size: 20, color: Color(0xFF7C3AED)),
                    const SizedBox(height: 10),
                    const Text(
                      'Repórter / Mídias',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${adapter.reporterName} (${adapter.reporterPrintCount} prints)',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 6. CRÔNICA DA COMUNIDADE
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? SwissColors.darkSurfaceSubdued : const Color(0xFFFBF8FF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 0.8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.quote, size: 22, color: accent),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  adapter.primaryInsight,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 14,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
