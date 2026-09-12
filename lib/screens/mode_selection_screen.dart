import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:chat_wrapped/core/analytics/chat_analyzer.dart';
import 'package:chat_wrapped/core/models/general_stats.dart';
import 'package:chat_wrapped/core/models/raw_chat_export.dart';
import 'package:chat_wrapped/theme/squircle_border.dart';
import 'package:chat_wrapped/theme/swiss_colors.dart';
import 'package:chat_wrapped/theme/swiss_typography.dart';
import 'package:chat_wrapped/widgets/swiss_button.dart';
import 'package:chat_wrapped/screens/dashboard_screen.dart';

/// Screen allowing the user to inspect detected chat participants
/// and choose or confirm the retrospective analysis mode (Casal, Amigos, Grupo).
/// Redesigned with warm editorial identity, continuous squircle bento cards,
/// subtle textures, dedicated semantic palettes, and dynamic recommendations.
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

    if (_participants.length <= 2) {
      if (widget.initialAnalysis.mode == ChatMode.amigos) {
        _recommendedMode = ChatMode.amigos;
        _selectedMode = ChatMode.amigos;
      } else {
        _recommendedMode = ChatMode.casal;
        _selectedMode = ChatMode.casal;
      }
    } else {
      _recommendedMode = ChatMode.grupo;
      _selectedMode = ChatMode.grupo;
    }
  }

  Color get _currentActionColor {
    switch (_selectedMode) {
      case ChatMode.casal:
        return const Color(0xFFE11D48);
      case ChatMode.amigos:
        return SwissColors.brandCobalt;
      case ChatMode.grupo:
        return SwissColors.brandSapphire;
    }
  }

  LinearGradient get _currentActionGradient {
    switch (_selectedMode) {
      case ChatMode.casal:
        return const LinearGradient(
          colors: [Color(0xFFE11D48), Color(0xFFBE123C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ChatMode.amigos:
        return const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ChatMode.grupo:
        return const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  void _proceedToDashboard() {
    HapticFeedback.mediumImpact();
    ChatAnalysisResult analysisToUse = widget.initialAnalysis;

    final targetMode = _participants.length >= 3 ? ChatMode.grupo : _selectedMode;

    if (widget.rawExport != null && targetMode != widget.initialAnalysis.mode) {
      analysisToUse = ChatAnalyzer.analyzeRawExport(
        widget.rawExport!,
        overrideMode: targetMode,
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

  String _getInitial(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.characters.first.toUpperCase();
  }

  Widget _buildAvatarSquircle({
    required String initial,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  color.withValues(alpha: 0.25),
                  color.withValues(alpha: 0.12),
                ]
              : [
                  color.withValues(alpha: 0.14),
                  color.withValues(alpha: 0.05),
                ],
        ),
        shape: SquircleBorder.radius(
          16,
          side: BorderSide(
            color: color.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        shadows: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsCard(bool isDark, bool isDuo) {
    final p1 = _participants.isNotEmpty ? _participants[0] : '';
    final p2 = _participants.length > 1 ? _participants[1] : '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: isDark ? SwissColors.darkSurfaceCard : Colors.white,
        shape: SquircleBorder.radius(
          22,
          side: BorderSide(
            color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
            width: 1.0,
          ),
        ),
        shadows: [
          BoxShadow(
            color: isDark ? Colors.black45 : const Color(0x0A0F172A),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Duo Connection Card Hero (2 participants)
          if (_participants.length == 2) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Participant 1 Avatar
                _buildAvatarSquircle(
                  initial: _getInitial(p1),
                  color: SwissColors.brandCobalt,
                  isDark: isDark,
                ),
                // Connection Bridge in the middle
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  SwissColors.brandCobalt.withValues(alpha: 0.3),
                                  _currentActionColor.withValues(alpha: 0.6),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: ShapeDecoration(
                            color: isDark
                                ? _currentActionColor.withValues(alpha: 0.16)
                                : _currentActionColor.withValues(alpha: 0.08),
                            shape: SquircleBorder.radius(
                              10,
                              side: BorderSide(
                                color: _currentActionColor.withValues(alpha: 0.35),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _selectedMode == ChatMode.casal
                                    ? LucideIcons.heart
                                    : LucideIcons.sparkles,
                                size: 13,
                                color: _currentActionColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _selectedMode == ChatMode.casal ? 'CONEXÃO' : 'DUPLA',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  color: _currentActionColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _currentActionColor.withValues(alpha: 0.6),
                                  const Color(0xFFE11D48).withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Participant 2 Avatar
                _buildAvatarSquircle(
                  initial: _getInitial(p2),
                  color: const Color(0xFFE11D48),
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Duo Names Headline in Warm Serif Typography
            Center(
              child: Text(
                '$p1 & $p2',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: SwissTypography.titleLarge.copyWith(
                  fontFamily: 'serif',
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: isDark ? SwissColors.darkTextPrimary : SwissColors.lightTextPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Message Count and Status Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: ShapeDecoration(
                    color: isDark
                        ? SwissColors.darkSurfaceSubdued
                        : SwissColors.lightSurfaceSubdued,
                    shape: SquircleBorder.radius(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.messageSquare,
                        size: 11,
                        color: isDark ? SwissColors.darkTextMuted : SwissColors.lightTextMuted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${widget.initialAnalysis.generalStats.totalMessages} mensagens',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: ShapeDecoration(
                    color: isDark
                        ? const Color(0xFF0F2E1E)
                        : const Color(0xFFECFDF5),
                    shape: SquircleBorder.radius(
                      8,
                      side: const BorderSide(
                        color: Color(0xFF10B981),
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'SINCRONIZADO',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              height: 1,
              thickness: 0.8,
              color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
            ),
            const SizedBox(height: 14),
          ] else if (_participants.length >= 3) ...[
            // Collective Multi-Participant Header (3+ participants)
            Row(
              children: [
                // Overlapping Avatars stack
                SizedBox(
                  width: 74,
                  height: 38,
                  child: Stack(
                    children: [
                      for (int i = 0; i < _participants.take(3).length; i++)
                        Positioned(
                          left: i * 18.0,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: ShapeDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                              shape: SquircleBorder.radius(
                                12,
                                side: BorderSide(
                                  color: isDark ? SwissColors.darkSurfaceCard : Colors.white,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _getInitial(_participants[i]),
                                style: const TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: SwissColors.brandCobalt,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conversa Coletiva',
                        style: SwissTypography.titleMedium.copyWith(
                          fontFamily: 'serif',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.initialAnalysis.generalStats.totalMessages} mensagens analisadas',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? SwissColors.darkTextMuted : SwissColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: ShapeDecoration(
                    color: isDark ? SwissColors.darkSurfaceSubdued : SwissColors.lightSurfaceSubdued,
                    shape: SquircleBorder.radius(6),
                  ),
                  child: Text(
                    'MULTI',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(
              height: 1,
              thickness: 0.8,
              color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
            ),
            const SizedBox(height: 14),
          ] else if (_participants.length == 1) ...[
            // Single participant
            Row(
              children: [
                _buildAvatarSquircle(
                  initial: _getInitial(p1),
                  color: SwissColors.brandCobalt,
                  isDark: isDark,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conversa Individual',
                        style: SwissTypography.titleMedium.copyWith(
                          fontFamily: 'serif',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.initialAnalysis.generalStats.totalMessages} mensagens analisadas',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? SwissColors.darkTextMuted : SwissColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(
              height: 1,
              thickness: 0.8,
              color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
            ),
            const SizedBox(height: 14),
          ],

          // Detected participants chips header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.usersRound,
                    size: 15,
                    color: SwissColors.brandCobalt,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Participantes Detectados (${_participants.length})',
                    style: SwissTypography.titleMedium.copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (_participants.length <= 2)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: ShapeDecoration(
                    color: isDark ? SwissColors.darkSurfaceSubdued : SwissColors.lightSurfaceSubdued,
                    shape: SquircleBorder.radius(6),
                  ),
                  child: Text(
                    _participants.length == 2 ? '1-A-1' : 'INDIVIDUAL',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                    ),
                  ),
                ),
            ],
          ),

          // Chips Wrap (using LucideIcons.user for participant chips as expected by widget tests)
          if (_participants.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _participants.map((name) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: ShapeDecoration(
                    color: isDark
                        ? SwissColors.darkSurfaceSubdued
                        : SwissColors.lightSurfaceSubdued,
                    shape: SquircleBorder.radius(
                      12,
                      side: BorderSide(
                        color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.user,
                        size: 13,
                        color: SwissColors.brandCobalt,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        name,
                        style: SwissTypography.labelSmall.copyWith(
                          color: isDark
                              ? SwissColors.darkTextPrimary
                              : SwissColors.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDuo = _participants.length <= 2;

    final modeOptions = [
      if (isDuo) ...[
        (
          mode: ChatMode.casal,
          title: 'Modo Casal',
          eyebrow: 'AFINIDADE & RITMO A DOIS',
          icon: LucideIcons.heart,
          participantHint: '2 participantes',
          microBadgeIcon: LucideIcons.heartHandshake,
          microBadgeLabel: 'Ritmo a dois & Afinidade',
          accentColor: const Color(0xFFE11D48),
          accentSecondary: const Color(0xFFF43F5E),
          bgLightGradient: const [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
          bgDarkGradient: const [Color(0xFF1E1015), Color(0xFF2D121B)],
          borderLight: const Color(0xFFFECDD3),
          borderDark: const Color(0xFF4C1D2A),
          avatarBgLight: const Color(0xFFFDE8EA),
          avatarBgDark: const Color(0xFF3B121E),
          doodlePainter: _HeartDoodlePainter(),
          description:
              'Índice de sintonia amorosa, love language (corações, afeto, memes), horários a dois e métricas de resposta.',
          featureTags: const [
            'Love Language',
            'Quem Puxa Papo',
            'Horário do Amor',
            'Sintonia 360°',
          ],
        ),
        (
          mode: ChatMode.amigos,
          title: 'Modo Amigos',
          eyebrow: 'PARCERIA, RESENHA & ZOEIRA',
          icon: LucideIcons.users,
          participantHint: '2 amigos (dupla)',
          microBadgeIcon: LucideIcons.sparkles,
          microBadgeLabel: 'Duelo de estilos & Resenha a dois',
          accentColor: const Color(0xFF2563EB),
          accentSecondary: const Color(0xFF3B82F6),
          bgLightGradient: const [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
          bgDarkGradient: const [Color(0xFF0C192E), Color(0xFF112240)],
          borderLight: const Color(0xFFBAE6FD),
          borderDark: const Color(0xFF1E3A8A),
          avatarBgLight: const Color(0xFFE0EDFD),
          avatarBgDark: const Color(0xFF13274A),
          doodlePainter: _AmigosDoodlePainter(),
          description:
              'A amizade a dois: quem responde mais rápido, duelo de estilos, áudios intermináveis de podcast, vácuos históricos e cumplicidade.',
          featureTags: const [
            'Duelo de Estilos',
            'Podcast de Áudios',
            'Ranking do Vácuo',
            'Cultura de Emojis',
          ],
        ),
      ] else ...[
        (
          mode: ChatMode.grupo,
          title: 'Modo Grupo',
          eyebrow: 'LEADERBOARD GERAL & VIBES',
          icon: LucideIcons.messagesSquare,
          participantHint: '${_participants.length} participantes',
          microBadgeIcon: LucideIcons.trophy,
          microBadgeLabel: 'Leaderboard geral & Radar de vibes',
          accentColor: const Color(0xFF1D4ED8),
          accentSecondary: const Color(0xFF2563EB),
          bgLightGradient: const [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
          bgDarkGradient: const [Color(0xFF0B1728), Color(0xFF13284C)],
          borderLight: const Color(0xFFBFDBFE),
          borderDark: const Color(0xFF1E40AF),
          avatarBgLight: const Color(0xFFDBEAFE),
          avatarBgDark: const Color(0xFF172554),
          doodlePainter: _GrupoDoodlePainter(),
          description:
              'Leaderboard geral com pódios e porcentagens, matriz de interação, ranking de vibes e corujas da madrugada.',
          featureTags: const [
            'Pódio Geral',
            'Radar de Vibes',
            'Corujas da Madrugada',
            'Matriz de Interação',
          ],
        ),
      ],
    ];

    return Scaffold(
      backgroundColor: isDark ? SwissColors.darkBackground : SwissColors.lightBackground,
      appBar: AppBar(
        title: Text(
          'Configurar Retrospectiva',
          style: SwissTypography.titleMedium.copyWith(
            fontFamily: 'serif',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).maybePop();
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: ShapeDecoration(
                  color: isDark ? SwissColors.darkSurfaceCard : Colors.white,
                  shape: SquircleBorder.radius(
                    11,
                    side: BorderSide(
                      color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
                      width: 1.0,
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : const Color(0x060F172A),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.arrowLeft,
                    size: 18,
                    color: isDark ? SwissColors.darkTextPrimary : SwissColors.lightTextPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: ShapeDecoration(
                  color: isDark ? SwissColors.darkSurfaceSubdued : SwissColors.lightSurfaceSubdued,
                  shape: SquircleBorder.radius(
                    8,
                    side: BorderSide(
                      color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDuo ? SwissColors.brandCobalt : SwissColors.brandSapphire,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isDuo ? 'DUPLA (1-A-1)' : 'GRUPO',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle warm paper texture layer over SwissColors.lightBackground
          if (!isDark)
            Positioned.fill(
              child: Opacity(
                opacity: 0.50,
                child: Image.asset(
                  'assets/images/home_paper_texture.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),

          // Primary scrollable content
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              children: [
                // Redesigned Participants Connection Card
                _buildParticipantsCard(isDark, isDuo),

                const SizedBox(height: 24),

                // Section Headline: Editorial Warm Typography
                Text(
                  'Escolha a Experiência',
                  style: SwissTypography.titleLarge.copyWith(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: isDark ? SwissColors.darkTextPrimary : SwissColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sugerimos um modo com base no número de participantes, mas você pode escolher qualquer modalidade.',
                  style: SwissTypography.bodyMedium.copyWith(
                    fontSize: 13.5,
                    color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 18),

                // Expressive Bento Cards List
                ...modeOptions.map((opt) {
                  final isSelected = _selectedMode == opt.mode;
                  final isRecommended = _recommendedMode == opt.mode;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedMode = opt.mode;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark ? opt.bgDarkGradient : opt.bgLightGradient,
                          ),
                          shadows: isSelected
                              ? [
                                  BoxShadow(
                                    color: opt.accentColor.withValues(alpha: isDark ? 0.32 : 0.20),
                                    blurRadius: 22,
                                    offset: const Offset(0, 6),
                                    spreadRadius: -2,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: isDark ? Colors.black26 : const Color(0x04000000),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                          shape: SquircleBorder.radius(
                            22,
                            side: BorderSide(
                              color: isSelected
                                  ? opt.accentColor
                                  : (isDark ? opt.borderDark : opt.borderLight),
                              width: isSelected ? 2.2 : 1.0,
                            ),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            // Subtle vector doodle layer
                            Positioned.fill(
                              child: CustomPaint(
                                painter: opt.doodlePainter,
                              ),
                            ),

                            // Foreground content
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top Row: Avatar squircle + Eyebrow/Title + Stylized Radio
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Avatar Squircle
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: ShapeDecoration(
                                          color: isDark ? opt.avatarBgDark : opt.avatarBgLight,
                                          shape: SquircleBorder.radius(
                                            14,
                                            side: BorderSide(
                                              color: opt.accentColor.withValues(alpha: 0.35),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            opt.icon,
                                            size: 22,
                                            color: opt.accentColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Eyebrow & Title Column
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              opt.eyebrow,
                                              style: TextStyle(
                                                fontSize: 9.5,
                                                letterSpacing: 1.1,
                                                fontWeight: FontWeight.w800,
                                                color: opt.accentColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                Text(
                                                  opt.title,
                                                  style: TextStyle(
                                                    fontFamily: 'serif',
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: -0.3,
                                                    color: isDark
                                                        ? SwissColors.darkTextPrimary
                                                        : SwissColors.lightTextPrimary,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 7,
                                                    vertical: 2,
                                                  ),
                                                  decoration: ShapeDecoration(
                                                    color: isDark
                                                        ? Colors.white.withValues(alpha: 0.08)
                                                        : Colors.black.withValues(alpha: 0.05),
                                                    shape: SquircleBorder.radius(6),
                                                  ),
                                                  child: Text(
                                                    opt.participantHint,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                      color: isDark
                                                          ? SwissColors.darkTextMuted
                                                          : SwissColors.lightTextMuted,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Stylized Radio Indicator
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 180),
                                        curve: Curves.easeOutCubic,
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected ? opt.accentColor : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? opt.accentColor
                                                : (isDark
                                                    ? SwissColors.darkBorderStrong
                                                    : SwissColors.lightBorderStrong),
                                            width: 2.0,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: opt.accentColor.withValues(alpha: 0.40),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: isSelected
                                            ? const Center(
                                                child: Icon(
                                                  LucideIcons.check,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),

                                  // Dynamic Recommendation Badge (if recommended)
                                  if (isRecommended) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: opt.accentColor.withValues(alpha: 0.12),
                                        shape: SquircleBorder.radius(
                                          10,
                                          side: BorderSide(
                                            color: opt.accentColor.withValues(alpha: 0.40),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            LucideIcons.sparkles,
                                            size: 12,
                                            color: opt.accentColor,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            'Recomendado',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.2,
                                              color: opt.accentColor,
                                            ),
                                          ),
                                          Text(
                                            ' para esta conversa',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.1,
                                              color: opt.accentColor.withValues(alpha: 0.85),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 10),

                                  // Micro-Badge of specific lens capability
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                    decoration: ShapeDecoration(
                                      color: isDark
                                      ? Colors.white.withValues(alpha: 0.07)
                                      : Colors.white.withValues(alpha: 0.70),
                                      shape: SquircleBorder.radius(
                                        8,
                                        side: BorderSide(
                                          color: opt.accentColor.withValues(alpha: 0.25),
                                          width: 0.8,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          opt.microBadgeIcon,
                                          size: 11.5,
                                          color: opt.accentColor,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          opt.microBadgeLabel,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.1,
                                            color: isDark
                                                ? SwissColors.darkTextPrimary
                                                : const Color(0xFF1E293B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // Narrative Description
                                  Text(
                                    opt.description,
                                    style: SwissTypography.bodyMedium.copyWith(
                                      fontSize: 13,
                                      height: 1.45,
                                      color: isDark
                                          ? SwissColors.darkTextSecondary
                                          : SwissColors.lightTextSecondary,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Feature Tags / Preview Chips
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: opt.featureTags.map((tag) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3.5,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: isDark
                                              ? opt.accentColor.withValues(alpha: 0.14)
                                              : opt.accentColor.withValues(alpha: 0.08),
                                          shape: SquircleBorder.radius(
                                            8,
                                            side: BorderSide(
                                              color: opt.accentColor.withValues(
                                                alpha: isSelected ? 0.35 : 0.18,
                                              ),
                                              width: 0.8,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 4,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: opt.accentColor.withValues(alpha: 0.85),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              tag,
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.2,
                                                color: isDark
                                                    ? Colors.white.withValues(alpha: 0.9)
                                                    : opt.accentColor.withValues(alpha: 0.95),
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
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 8),

                // Tactile Continue Button with dynamic mode accent / cobalt brand color
                SwissButton(
                  label: 'Continuar para o Dashboard',
                  icon: LucideIcons.arrowRight,
                  type: SwissButtonType.primary,
                  customBackgroundColor: _currentActionColor,
                  customGradient: _currentActionGradient,
                  fullWidth: true,
                  onPressed: _proceedToDashboard,
                ),
                const SizedBox(height: 14),

                // Privacy / offline security reassurance
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.shieldCheck,
                      size: 13,
                      color: isDark ? SwissColors.darkTextMuted : SwissColors.lightTextMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '100% offline. Seus dados nunca saem deste aparelho.',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? SwissColors.darkTextMuted : SwissColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter that draws a subtle tilted heart doodle on the Casal Bento card
class _HeartDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.80)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width * 0.84, size.height * 0.50);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(0.20); // subtle tilt

    final path = Path();
    path.moveTo(0, 16);
    path.cubicTo(-18, 5, -20, -10, -7, -15);
    path.cubicTo(-1, -17, 0, -10, 0, -8);
    path.cubicTo(0, -10, 1, -17, 7, -15);
    path.cubicTo(20, -10, 18, 5, 0, 16);

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter that draws spark rays and a soft organic hill wave on the Amigos Bento card
class _AmigosDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Soft organic translucent wave in lower right
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.30)
      ..style = PaintingStyle.fill;

    final wavePath = Path();
    wavePath.moveTo(size.width * 0.45, size.height);
    wavePath.quadraticBezierTo(
      size.width * 0.72,
      size.height * 0.72,
      size.width,
      size.height * 0.60,
    );
    wavePath.lineTo(size.width, size.height);
    wavePath.close();
    canvas.drawPath(wavePath, wavePaint);

    // 2. Three radiating spark rays
    final rayPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.80)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width * 0.86;
    final cy = size.height * 0.32;

    canvas.drawLine(Offset(cx - 10, cy + 6), Offset(cx - 18, cy + 12), rayPaint);
    canvas.drawLine(Offset(cx - 8, cy - 6), Offset(cx - 15, cy - 14), rayPaint);
    canvas.drawLine(Offset(cx + 6, cy - 8), Offset(cx + 14, cy - 16), rayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter that draws radar pulse arcs and connected interaction nodes on the Grupo Bento card
class _GrupoDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Concentric radar pulse arcs in lower right corner
    final arcPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width * 0.90, size.height * 0.76);
    canvas.drawCircle(center, 22, arcPaint);
    canvas.drawCircle(center, 44, arcPaint);

    // 2. Connected network triad nodes in upper right
    final nodePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1.3;

    final n1 = Offset(size.width * 0.80, size.height * 0.28);
    final n2 = Offset(size.width * 0.92, size.height * 0.18);
    final n3 = Offset(size.width * 0.88, size.height * 0.40);

    canvas.drawLine(n1, n2, linePaint);
    canvas.drawLine(n2, n3, linePaint);
    canvas.drawLine(n1, n3, linePaint);

    canvas.drawCircle(n1, 3.5, nodePaint);
    canvas.drawCircle(n2, 3.0, nodePaint);
    canvas.drawCircle(n3, 3.2, nodePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
