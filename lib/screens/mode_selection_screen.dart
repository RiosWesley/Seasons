import 'package:flutter/material.dart';
import '../core/analytics/chat_analyzer.dart';
import '../core/models/general_stats.dart';
import '../core/models/raw_chat_export.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';
import '../widgets/metric_badge.dart';
import '../widgets/swiss_button.dart';
import '../widgets/swiss_card.dart';
import 'dashboard_screen.dart';

/// Screen allowing the user to inspect detected chat participants
/// and choose or confirm the retrospective analysis mode (Casal, Amigos, Grupo).
class ModeSelectionScreen extends StatefulWidget {
  final RawChatExport? rawExport;
  final ChatAnalysisResult initialAnalysis;

  const ModeSelectionScreen({
    super.key,
    this.rawExport,
    required this.initialAnalysis,
  });

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  late ChatMode _selectedMode;
  late ChatMode _recommendedMode;
  late List<String> _participants;

  @override
  void initState() {
    super.initState();
    _participants = widget.rawExport?.participants.toList() ??
        widget.initialAnalysis.generalStats.participants;

    _recommendedMode = widget.rawExport != null
        ? ChatAnalyzer.detectMode(widget.rawExport!.participants.length)
        : widget.initialAnalysis.mode;

    _selectedMode = _recommendedMode;
  }

  void _proceedToDashboard() {
    ChatAnalysisResult analysisToUse = widget.initialAnalysis;

    if (widget.rawExport != null && _selectedMode != widget.initialAnalysis.mode) {
      analysisToUse = ChatAnalyzer.analyzeRawExport(
        widget.rawExport!,
        overrideMode: _selectedMode,
      );
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DashboardScreen(
          analysis: analysisToUse,
          rawExport: widget.rawExport,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final modeOptions = [
      (
        mode: ChatMode.casal,
        title: 'Modo Casal',
        icon: Icons.favorite_rounded,
        participantHint: '2 participantes',
        description:
            'Índice de sintonia amorosa, love language (corações, afeto, memes), horários a dois e métricas de resposta.',
      ),
      (
        mode: ChatMode.amigos,
        title: 'Modo Amigos',
        icon: Icons.people_alt_rounded,
        participantHint: '3 a 5 participantes',
        description:
            'Arquétipos de comunicação (Tagarela, Fantasma, Áudio-maníaco), dinâmicas do squad, ghosting e quem inicia conversas.',
      ),
      (
        mode: ChatMode.grupo,
        title: 'Modo Grupo',
        icon: Icons.groups_rounded,
        participantHint: '6 ou mais participantes',
        description:
            'Leaderboard geral com pódios e porcentagens, matriz de interação, ranking de vibes e corujas da madrugada.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurar Retrospectiva', style: SwissTypography.titleMedium),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          children: [
            // Participants detected header card
            SwissCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.group_outlined,
                        size: 18,
                        color: SwissColors.emeraldPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Participantes Detectados (${_participants.length})',
                        style: SwissTypography.titleMedium.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _participants.map((name) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: ShapeDecoration(
                          color: isDark
                              ? SwissColors.darkSurfaceSubdued
                              : SwissColors.lightSurfaceSubdued,
                          shape: SquircleBorder.radius(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_outline_rounded,
                              size: 13,
                              color: SwissColors.emeraldPrimary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              name,
                              style: SwissTypography.labelSmall.copyWith(
                                color: isDark
                                    ? SwissColors.darkTextPrimary
                                    : SwissColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Escolha a Experiência',
              style: SwissTypography.titleLarge.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              'Sugerimos um modo com base no número de participantes, mas você pode escolher qualquer modalidade.',
              style: SwissTypography.bodyMedium.copyWith(
                fontSize: 13,
                color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
              ),
            ),

            const SizedBox(height: 16),

            // Mode Cards List
            ...modeOptions.map((opt) {
              final isSelected = _selectedMode == opt.mode;
              final isRecommended = _recommendedMode == opt.mode;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SwissCard(
                  highlight: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedMode = opt.mode;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: ShapeDecoration(
                              color: isSelected
                                  ? SwissColors.accentSubdued(isDark)
                                  : (isDark
                                      ? SwissColors.darkSurfaceSubdued
                                      : SwissColors.lightSurfaceSubdued),
                              shape: SquircleBorder.radius(10),
                            ),
                            child: Icon(
                              opt.icon,
                              size: 18,
                              color: isSelected
                                  ? SwissColors.emeraldPrimary
                                  : (isDark
                                      ? SwissColors.darkTextSecondary
                                      : SwissColors.lightTextSecondary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      opt.title,
                                      style: SwissTypography.titleMedium.copyWith(fontSize: 16),
                                    ),
                                    if (isRecommended) ...[
                                      const SizedBox(width: 8),
                                      const MetricBadge(
                                        label: 'Recomendado',
                                        isAccent: true,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  opt.participantHint,
                                  style: SwissTypography.labelSmall.copyWith(
                                    color: isDark
                                        ? SwissColors.darkTextMuted
                                        : SwissColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? SwissColors.emeraldPrimary
                                    : (isDark
                                        ? SwissColors.darkBorder
                                        : SwissColors.lightBorder),
                                width: 2,
                              ),
                              color: isSelected
                                  ? SwissColors.emeraldPrimary
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: Colors.black,
                                  )
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        opt.description,
                        style: SwissTypography.bodyMedium.copyWith(
                          fontSize: 13,
                          color: isDark
                              ? SwissColors.darkTextSecondary
                              : SwissColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Proceed CTA
            SwissButton(
              label: 'Continuar para o Dashboard',
              icon: Icons.arrow_forward_rounded,
              type: SwissButtonType.primary,
              fullWidth: true,
              onPressed: _proceedToDashboard,
            ),
          ],
        ),
      ),
    );
  }
}
