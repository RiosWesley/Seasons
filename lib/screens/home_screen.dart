import 'package:flutter/material.dart';
import '../core/analytics/chat_analyzer.dart';
import '../core/models/general_stats.dart';
import '../core/models/raw_chat_export.dart';
import '../core/parser/chat_parser.dart';
import '../core/services/file_ingestion_service.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';
import '../widgets/count_up_text.dart';
import '../widgets/metric_badge.dart';
import '../widgets/stage_progress_indicator.dart';
import '../widgets/swiss_button.dart';
import '../widgets/swiss_card.dart';
import 'mode_selection_screen.dart';

/// Summary metadata for a saved retrospective.
class SavedWrappedSummary {
  final String id;
  final String title;
  final ChatMode mode;
  final int messageCount;
  final int participantCount;
  final DateTime date;
  final ChatAnalysisResult analysisResult;

  const SavedWrappedSummary({
    required this.id,
    required this.title,
    required this.mode,
    required this.messageCount,
    required this.participantCount,
    required this.date,
    required this.analysisResult,
  });
}

/// Swiss-Minimalist Home Screen for Chat Wrapped.
/// Features a disciplined monotone surface, privacy badge, dropzone card,
/// stage progress feedback, and 100% free experience with zero paywalls.
class HomeScreen extends StatefulWidget {
  final FileIngestionService? ingestionService;
  final void Function(ChatAnalysisResult result)? onAnalysisComplete;

  const HomeScreen({
    super.key,
    this.ingestionService,
    this.onAnalysisComplete,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FileIngestionService _ingestionService;
  PipelineStage _currentStage = PipelineStage.idle;
  String? _statusMessage;
  String? _errorMessage;
  bool _isLoading = false;

  final List<SavedWrappedSummary> _savedWrappeds = [];

  static const String _demoChat = '''
12/01/2025 10:15 - Mariana: Oi amor! Bom dia ❤️
12/01/2025 10:16 - Lucas: Bom dia linda! Como você dormiu? 🥰
12/01/2025 10:18 - Mariana: Dormi super bem! Vamos almoçar juntos hoje?
12/01/2025 10:20 - Lucas: Claro, com certeza! Te pego ao meio-dia.
12/01/2025 10:21 - Mariana: Perfeito! Te amo ❤️
12/01/2025 10:22 - Lucas: Também te amo muito ❤️
13/01/2025 14:00 - Mariana: Vi esse meme e lembrei de você kkkk 😂
13/01/2025 14:05 - Lucas: kkkkkkkk sensacional!
14/01/2025 20:00 - Mariana: Já chegou em casa?
14/01/2025 20:02 - Lucas: Cheguei sim, amor! Vou tomar um banho rápido.
14/01/2025 22:30 - Mariana: Boa noite amor ✨
14/01/2025 22:31 - Lucas: Boa noite, sonha com os anjos 🥰
15/01/2025 09:00 - Mariana: Bom dia vida! ❤️
15/01/2025 09:05 - Lucas: Bom dia paixão! Tenha um ótimo dia de trabalho.
''';

  @override
  void initState() {
    super.initState();
    _ingestionService = widget.ingestionService ?? FileIngestionService();
  }

  Future<void> _handleFileSelection() async {
    setState(() {
      _isLoading = true;
      _currentStage = PipelineStage.decompressing;
      _statusMessage = 'Aguardando seleção do arquivo (.txt ou .zip)...';
      _errorMessage = null;
    });

    try {
      final export = await _ingestionService.pickAndIngestChatFile();
      if (export == null) {
        setState(() {
          _isLoading = false;
          _currentStage = PipelineStage.idle;
          _statusMessage = null;
        });
        return;
      }

      await _processExport(export);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _currentStage = PipelineStage.error;
        _errorMessage = 'Erro ao ler arquivo: ${e.toString()}';
      });
      _showErrorDialog(_errorMessage!);
    }
  }

  Future<void> _handleDemoRetrospective() async {
    setState(() {
      _isLoading = true;
      _currentStage = PipelineStage.parsing;
      _statusMessage = 'Carregando demonstração interativa...';
      _errorMessage = null;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      setState(() {
        _currentStage = PipelineStage.parsing;
        _statusMessage = 'Processando linhas de conversa de demonstração...';
      });

      final parser = const ChatParser();
      final export = parser.parse(_demoChat);

      await Future<void>.delayed(const Duration(milliseconds: 250));
      setState(() {
        _currentStage = PipelineStage.analyzing;
        _statusMessage = 'Calculando afinidade e estatísticas locais...';
      });

      await _processExport(export, isDemo: true);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _currentStage = PipelineStage.error;
        _errorMessage = 'Erro na demonstração: ${e.toString()}';
      });
    }
  }

  Future<void> _processExport(RawChatExport export, {bool isDemo = false}) async {
    setState(() {
      _currentStage = PipelineStage.analyzing;
      _statusMessage = 'Calculando métricas e afinidade offline...';
    });

    await Future<void>.delayed(const Duration(milliseconds: 300));
    final analysis = ChatAnalyzer.analyzeRawExport(export);

    setState(() {
      _currentStage = PipelineStage.complete;
      _statusMessage = 'Análise concluída com sucesso!';
      _isLoading = false;

      final title = export.participants.length == 2
          ? '${export.participants.first} & ${export.participants.last}'
          : (isDemo ? 'Conversa de Demonstração' : 'Chat Wrapped');

      _savedWrappeds.insert(
        0,
        SavedWrappedSummary(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          mode: analysis.mode,
          messageCount: analysis.generalStats.totalMessages,
          participantCount: export.participants.length,
          date: DateTime.now(),
          analysisResult: analysis,
        ),
      );
    });

    if (widget.onAnalysisComplete != null) {
      widget.onAnalysisComplete!(analysis);
    }

    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => ModeSelectionScreen(
            rawExport: export,
            initialAnalysis: analysis,
          ),
        ),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: SquircleBorder.card(),
        backgroundColor: Theme.of(context).cardColor,
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: SwissColors.danger, size: 20),
            const SizedBox(width: 8),
            Text('Falha na Importação', style: SwissTypography.titleMedium),
          ],
        ),
        content: Text(
          '$message\n\nDica: Exporte a conversa do WhatsApp sem mídia para máxima velocidade e compatibilidade.',
          style: SwissTypography.bodyMedium,
        ),
        actions: [
          SwissButton(
            label: 'Entendido',
            type: SwissButtonType.secondary,
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentStage = PipelineStage.idle;
                _errorMessage = null;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalMessagesAnalyzed = _savedWrappeds.fold<int>(
      0,
      (sum, item) => sum + item.messageCount,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHAT WRAPPED',
          style: SwissTypography.titleMedium.copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: MetricBadge(
              label: '100% Offline',
              icon: Icons.verified_user_outlined,
              isAccent: true,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          children: [
            // Hero card
            SwissCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MetricBadge(
                    label: 'Privacidade Total',
                    icon: Icons.lock_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Sua Retrospectiva do WhatsApp',
                    style: SwissTypography.displayMedium.copyWith(
                      fontSize: 26,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Descubra sintonias, métricas de resposta, love languages e dinâmicas de grupo. Processado 100% no seu dispositivo, sem servidores ou anúncios.',
                    style: SwissTypography.bodyMedium.copyWith(
                      color: isDark
                          ? SwissColors.darkTextSecondary
                          : SwissColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SwissButton(
                          label: 'Importar Conversa',
                          icon: Icons.upload_file_rounded,
                          type: SwissButtonType.primary,
                          isLoading: _isLoading && _currentStage == PipelineStage.decompressing,
                          onPressed: _isLoading ? null : _handleFileSelection,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SwissButton(
                        label: 'Demonstração',
                        icon: Icons.play_arrow_rounded,
                        type: SwissButtonType.secondary,
                        isLoading: _isLoading && _currentStage == PipelineStage.parsing,
                        onPressed: _isLoading ? null : _handleDemoRetrospective,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pipeline Progress feedback (if active)
            if (_currentStage != PipelineStage.idle) ...[
              StageProgressIndicator(
                stage: _currentStage,
                customMessage: _statusMessage,
              ),
              const SizedBox(height: 16),
            ],

            // Aggregate metrics strip
            SwissCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Retrospectivas',
                          style: SwissTypography.labelSmall.copyWith(
                            color: isDark
                                ? SwissColors.darkTextSecondary
                                : SwissColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        CountUpText(
                          targetValue: _savedWrappeds.length,
                          style: SwissTypography.metricSmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mensagens',
                            style: SwissTypography.labelSmall.copyWith(
                              color: isDark
                                  ? SwissColors.darkTextSecondary
                                  : SwissColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          CountUpText(
                            targetValue: totalMessagesAnalyzed,
                            style: SwissTypography.metricSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privacidade',
                            style: SwissTypography.labelSmall.copyWith(
                              color: isDark
                                  ? SwissColors.darkTextSecondary
                                  : SwissColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '100% Local',
                            style: SwissTypography.metricSmall.copyWith(
                              color: SwissColors.emeraldPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section: Saved Wrappeds or Guide
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _savedWrappeds.isEmpty ? 'Como Exportar' : 'Retrospectivas Recentes',
                  style: SwissTypography.titleLarge.copyWith(fontSize: 18),
                ),
                if (_savedWrappeds.isNotEmpty)
                  Text(
                    '${_savedWrappeds.length} salvas',
                    style: SwissTypography.labelSmall.copyWith(
                      color: isDark
                          ? SwissColors.darkTextSecondary
                          : SwissColors.lightTextSecondary,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            if (_savedWrappeds.isEmpty) ...[
              // Export Instructions Card
              SwissCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGuideStep(
                      context,
                      step: '1',
                      title: 'Abra a conversa no WhatsApp',
                      subtitle: 'Selecione o chat com seu par, grupo de amigos ou squad.',
                      icon: Icons.forum_outlined,
                    ),
                    const Divider(height: 24),
                    _buildGuideStep(
                      context,
                      step: '2',
                      title: 'Toque nos 3 pontos verticais',
                      subtitle: 'No Android: Menu (⋮) > Mais > Exportar conversa.',
                      icon: Icons.more_vert_rounded,
                    ),
                    const Divider(height: 24),
                    _buildGuideStep(
                      context,
                      step: '3',
                      title: 'Selecione "Sem mídia"',
                      subtitle: 'O arquivo .txt ou .zip exportado conterá todo o histórico necessário.',
                      icon: Icons.check_circle_outline_rounded,
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Saved Retrospectives List
              ..._savedWrappeds.map((saved) {
                IconData modeIcon;
                String modeLabel;
                switch (saved.mode) {
                  case ChatMode.casal:
                    modeIcon = Icons.favorite_rounded;
                    modeLabel = 'Casal';
                    break;
                  case ChatMode.amigos:
                    modeIcon = Icons.people_alt_rounded;
                    modeLabel = 'Amigos';
                    break;
                  case ChatMode.grupo:
                    modeIcon = Icons.groups_rounded;
                    modeLabel = 'Grupo';
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: SwissCard(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => ModeSelectionScreen(
                            initialAnalysis: saved.analysisResult,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: ShapeDecoration(
                            color: SwissColors.accentSubdued(isDark),
                            shape: SquircleBorder.radius(12),
                          ),
                          child: Icon(
                            modeIcon,
                            color: SwissColors.emeraldPrimary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                saved.title,
                                style: SwissTypography.titleMedium.copyWith(fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$modeLabel • ${saved.messageCount} mensagens',
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
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: SwissColors.darkTextMuted,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGuideStep(
    BuildContext context, {
    required String step,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: ShapeDecoration(
            color: isDark ? SwissColors.darkSurfaceSubdued : SwissColors.lightSurfaceSubdued,
            shape: SquircleBorder.radius(10),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 16,
              color: SwissColors.emeraldPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: SwissTypography.titleMedium.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
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
      ],
    );
  }
}
