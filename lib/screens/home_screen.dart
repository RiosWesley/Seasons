import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/analytics/chat_analyzer.dart';
import '../core/models/general_stats.dart';
import '../core/models/raw_chat_export.dart';
import '../core/parser/chat_parser.dart';
import '../core/services/file_ingestion_service.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';
import '../widgets/stage_progress_indicator.dart';
import '../widgets/swiss_button.dart';
import 'mode_selection_screen.dart';

/// Summary metadata for a saved retrospective.
class SavedWrappedSummary {
  final String id;
  final String title;
  final String dateText;
  final ChatMode mode;
  final int messageCount;
  final int participantCount;
  final ChatAnalysisResult analysisResult;

  const SavedWrappedSummary({
    required this.id,
    required this.title,
    required this.dateText,
    required this.mode,
    required this.messageCount,
    required this.participantCount,
    required this.analysisResult,
  });
}

/// Luxury Editorial Home Screen reproducing the user's reference design pixel-for-pixel:
/// - Warm ivory/cream canvas with editorial serif headline
/// - WhatsApp & chat cards 3D tilted illustration with script annotation
/// - Three horizontal security/feature badges
/// - Dashed squircle central ingestion card with primary periwinkle CTA & demo pill
/// - "Retrospectivas Recentes" list with "Ver análise →" actions
/// - 2-Column Bento Grid for "Escolha uma lente de análise" (Casal & Amigos)
/// - Docked 4-item bottom navigation bar (Início, Minhas Análises, Modelos, Configurações)
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

  int _selectedTabIndex = 0;
  PipelineStage _currentStage = PipelineStage.idle;
  String? _statusMessage;
  String? _errorMessage;
  bool _isLoading = false;

  final List<SavedWrappedSummary> _savedWrappeds = [];

  // Demo datasets for Casal, Amigos, Grupo
  static const String _demoChatCasal = '''
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

  static const String _demoChatAmigos = '''
10/02/2025 18:00 - Pedro: Galera, bora marcar aquele churrasco sábado?
10/02/2025 18:01 - Julia: Eu topo demais!! Quem leva a carne?
10/02/2025 18:02 - Lucas: <Mídia oculta>
10/02/2025 18:02 - Lucas: Comprei a picanha ontem já hahaha
10/02/2025 18:05 - Pedro: Boa garoto! Levo as bebidas.
10/02/2025 18:10 - Mariana: Gente, chego por volta das 15h pode ser?
10/02/2025 18:11 - Julia: Fechado! Todo mundo confirma presença.
11/02/2025 23:30 - Pedro: Alguém acordado ainda?
11/02/2025 23:35 - Lucas: Só os guerreiros da madrugada kkkk
11/02/2025 23:36 - Julia: dormindo quase kkk
''';

  static const String _demoChatGrupo = '''
05/03/2025 09:00 - Rodrigo: Bom dia time! Reunião hoje às 14h?
05/03/2025 09:02 - Amanda: Confirmado!
05/03/2025 09:03 - Carlos: Beleza, estarei lá.
05/03/2025 09:05 - Beatriz: Apresentação pronta já.
05/03/2025 09:10 - Gabriel: Fechado!
05/03/2025 09:12 - Larissa: Vou chegar 5 min atrasada mas vou.
05/03/2025 09:15 - Felipe: <Mídia oculta>
05/03/2025 09:16 - Felipe: Olhem o gráfico novo que saiu
05/03/2025 14:00 - Rodrigo: Entrando no link galera!
05/03/2025 14:01 - Carlos: Conectando...
''';

  @override
  void initState() {
    super.initState();
    _ingestionService = widget.ingestionService ?? FileIngestionService();
  }

  Future<void> _handleFileSelection() async {
    HapticFeedback.lightImpact();
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

  Future<void> _handleDemoRetrospective([String? customChatRaw, String? demoName]) async {
    HapticFeedback.mediumImpact();
    final rawText = customChatRaw ?? _demoChatCasal;

    setState(() {
      _isLoading = true;
      _currentStage = PipelineStage.parsing;
      _statusMessage = 'Processando conversa de exemplo...';
      _errorMessage = null;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      setState(() {
        _currentStage = PipelineStage.parsing;
        _statusMessage = 'Higienizando dados e identificando autores...';
      });

      const parser = ChatParser();
      final export = parser.parse(rawText);

      await Future<void>.delayed(const Duration(milliseconds: 150));
      setState(() {
        _currentStage = PipelineStage.analyzing;
        _statusMessage = 'Calculando métricas e afinidade offline...';
      });

      await _processExport(export, isDemo: true, customTitle: demoName);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _currentStage = PipelineStage.error;
        _errorMessage = 'Erro na demonstração: ${e.toString()}';
      });
    }
  }

  Future<void> _processExport(
    RawChatExport export, {
    bool isDemo = false,
    String? customTitle,
  }) async {
    setState(() {
      _currentStage = PipelineStage.analyzing;
      _statusMessage = 'Consolidando estatísticas locais...';
    });

    await Future<void>.delayed(const Duration(milliseconds: 200));
    final analysis = ChatAnalyzer.analyzeRawExport(export);

    setState(() {
      _currentStage = PipelineStage.complete;
      _statusMessage = 'Análise gerada com sucesso!';
      _isLoading = false;

      final title = customTitle ??
          (export.participants.length == 2
              ? '${export.participants.first} & ${export.participants.last}'
              : (isDemo ? 'Conversa de Exemplo' : 'Retrospectiva WhatsApp'));

      _savedWrappeds.insert(
        0,
        SavedWrappedSummary(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          dateText: 'Hoje',
          mode: analysis.mode,
          messageCount: analysis.generalStats.totalMessages,
          participantCount: export.participants.length,
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
            Text('Falha na Leitura', style: SwissTypography.titleMedium),
          ],
        ),
        content: Text(
          '$message\n\nDica: Exporte a conversa do WhatsApp sem mídia para máxima velocidade.',
          style: SwissTypography.bodyMedium,
        ),
        actions: [
          SwissButton(
            label: 'Compreendi',
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

  void _showAllModelsBottomSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Modelos de Análise',
                style: SwissTypography.titleLarge.copyWith(
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Algoritmos locais calibrados para cada tipo de dinâmica de conversa.',
                style: SwissTypography.bodyMedium.copyWith(color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              _buildModelDetailTile(
                icon: Icons.favorite_border_rounded,
                title: 'Casal (2 participantes)',
                subtitle: 'Sincronia de respostas, horários mais íntimos, equilíbrio de mensagens e linguagens de afeto.',
                color: const Color(0xFFF43F5E),
                bgColor: const Color(0xFFFFF1F2),
                onTap: () {
                  Navigator.pop(context);
                  _handleDemoRetrospective(_demoChatCasal, 'Mariana & Lucas (Casal)');
                },
              ),
              const SizedBox(height: 12),
              _buildModelDetailTile(
                icon: Icons.people_alt_outlined,
                title: 'Amigos (3 a 5 participantes)',
                subtitle: 'Índice de vácuo, tempos médios de resposta, quem envia mais áudios e memes do squad.',
                color: const Color(0xFF0284C7),
                bgColor: const Color(0xFFF0F9FF),
                onTap: () {
                  Navigator.pop(context);
                  _handleDemoRetrospective(_demoChatAmigos, 'Resenha do Squad (Amigos)');
                },
              ),
              const SizedBox(height: 12),
              _buildModelDetailTile(
                icon: Icons.groups_outlined,
                title: 'Grupo (6+ participantes)',
                subtitle: 'Leaderboard de mensagens, radar de vibe, horários caóticos e análise de rede.',
                color: const Color(0xFF8B5CF6),
                bgColor: const Color(0xFFF5F3FF),
                onTap: () {
                  Navigator.pop(context);
                  _handleDemoRetrospective(_demoChatGrupo, 'Turma Completa (Grupo)');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelDetailTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: SwissTypography.titleMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: SwissTypography.bodyMedium.copyWith(
                      fontSize: 12.5,
                      color: const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwissColors.lightBackground, // Warm Ivory #FBF9F5
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          children: [
            // 1. Editorial Brand Header with 100% Offline Pill
            _buildTopBar(),

            const SizedBox(height: 24),

            // 2. Hero Greeting + Editorial Headline + 3D Cards Illustration
            _buildHeroSection(),

            const SizedBox(height: 20),

            // 3. Three Guarantee Feature Badges
            _buildFeatureBadgesRow(),

            const SizedBox(height: 24),

            // 4. Central Dashed Ingestion Card ("Importe sua conversa")
            _buildMainIngestionCard(),

            const SizedBox(height: 20),

            // Pipeline Progress Indicator (during decompression/parsing)
            if (_currentStage != PipelineStage.idle) ...[
              StageProgressIndicator(
                stage: _currentStage,
                customMessage: _statusMessage,
              ),
              const SizedBox(height: 20),
            ],

            // 5. Retrospectivas Recentes
            _buildRecentRetrospectivesSection(),

            const SizedBox(height: 26),

            // 6. Escolha uma Lente de Análise (2-Column Bento Grid)
            _buildLenteDeAnaliseSection(),

            const SizedBox(height: 28),

            // 7. Footer Tagline
            _buildFooterTagline(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SECTION 1: TOP BRAND BAR & SECURITY PILL
  // ==========================================
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Squircle Sparkle Icon + "Chat Wrapped" & "ARCHIVE EDITION"
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  colors: [SwissColors.irisPrimary, SwissColors.violetSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: SquircleBorder.radius(12),
                shadows: [
                  BoxShadow(
                    color: SwissColors.irisPrimary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chat Wrapped',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: -0.3,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                Text(
                  'ARCHIVE EDITION',
                  style: SwissTypography.labelSmall.copyWith(
                    fontSize: 9.5,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                    color: SwissColors.irisPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Right: "100% OFFLINE" pill + Subtitle "Seus dados ficam apenas neste aparelho."
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const ShapeDecoration(
                color: Color(0xFFEEF2FF),
                shape: StadiumBorder(
                  side: BorderSide(color: Color(0xFFE0E7FF), width: 1.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.lock_rounded,
                    size: 12,
                    color: Color(0xFF4F46E5),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '100% OFFLINE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: Color(0xFF4338CA),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Seus dados ficam\napenas neste aparelho.',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 9,
                color: Color(0xFF64748B),
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // SECTION 2: HERO GREETING & 3D ILLUSTRATION
  // ==========================================
  Widget _buildHeroSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Eyebrow + Headline + Pitch
        Expanded(
          flex: 11,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BOM TE VER POR AQUI',
                style: SwissTypography.labelSmall.copyWith(
                  fontSize: 9.5,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF818CF8),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pronto para reviver\nsuas conversas?',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  letterSpacing: -0.6,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Transforme seu arquivo do WhatsApp em uma retrospectiva interativa e cheia de insights.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // Right Column: Composed WhatsApp 3D Tilted Cards & Arrow Annotation
        const SizedBox(
          width: 132,
          height: 145,
          child: _HeroChatIllustration(),
        ),
      ],
    );
  }

  // ==========================================
  // SECTION 3: 3 GUARANTEE FEATURE BADGES
  // ==========================================
  Widget _buildFeatureBadgesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFeatureBadgeItem(
          icon: Icons.shield_outlined,
          line1: 'Privacidade',
          line2: 'garantida',
        ),
        _buildFeatureBadgeItem(
          icon: Icons.cloud_off_outlined,
          line1: 'Funciona',
          line2: '100% offline',
        ),
        _buildFeatureBadgeItem(
          icon: Icons.bar_chart_rounded,
          line1: 'Seus dados,',
          line2: 'suas histórias',
        ),
      ],
    );
  }

  Widget _buildFeatureBadgeItem({
    required IconData icon,
    required String line1,
    required String line2,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFEEF2FF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              size: 16,
              color: const Color(0xFF4F46E5),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$line1\n$line2',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SECTION 4: MAIN INGESTION CARD ("Importe sua conversa")
  // ==========================================
  Widget _buildMainIngestionCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFD5DDFF),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Centered Document Upload Icon in Soft Lavender Squircle
          Container(
            width: 52,
            height: 52,
            decoration: ShapeDecoration(
              color: const Color(0xFFEEF2FF),
              shape: SquircleBorder.radius(16),
            ),
            child: const Center(
              child: Icon(
                Icons.drive_folder_upload_outlined,
                color: SwissColors.irisPrimary,
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Title
          const Text(
            'Importe sua conversa',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),

          // Subtitle
          const Text(
            'Selecione o arquivo .zip ou .txt exportado do WhatsApp\n(sem mídia).',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),

          // Primary Periwinkle CTA: "Selecionar arquivo"
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isLoading ? null : _handleFileSelection,
                borderRadius: BorderRadius.circular(14),
                child: Ink(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isLoading && _currentStage == PipelineStage.decompressing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.file_upload_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Selecionar arquivo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Thin "ou" divider
          Row(
            children: const [
              Expanded(child: Divider(color: Color(0xFFE2E8F0), height: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'ou',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
              Expanded(child: Divider(color: Color(0xFFE2E8F0), height: 1)),
            ],
          ),

          const SizedBox(height: 14),

          // Secondary Pill Button: "Experimentar com uma conversa de exemplo"
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading
                  ? null
                  : () => _handleDemoRetrospective(_demoChatCasal, 'Mariana & Lucas (Casal)'),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const ShapeDecoration(
                  color: Color(0xFFF0F3FF),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Color(0xFFE0E7FF),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      size: 18,
                      color: SwissColors.irisPrimary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Experimentar com uma conversa de exemplo',
                        style: TextStyle(
                          color: Color(0xFF4F46E5),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: SwissColors.irisPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION 5: RETROSPECTIVAS RECENTES
  // ==========================================
  Widget _buildRecentRetrospectivesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: "RETROSPECTIVAS RECENTES" + "Ver todas →"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RETROSPECTIVAS RECENTES',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
            InkWell(
              onTap: _showAllModelsBottomSheet,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Ver todas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: SwissColors.irisPrimary,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 12,
                    color: SwissColors.irisPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Static Showcase Card 1: "Meu Amor 💕"
        _buildRecentWrappedCard(
          avatarBg: const Color(0xFFFFF1F2),
          iconColor: const Color(0xFFF43F5E),
          icon: Icons.favorite_border_rounded,
          title: 'Meu Amor 💕',
          subtitle: '1.248 mensagens • 12 de mar. de 2024',
          onTap: () => _handleDemoRetrospective(_demoChatCasal, 'Meu Amor 💕'),
        ),

        const SizedBox(height: 10),

        // Static Showcase Card 2: "Resenha do Squad"
        _buildRecentWrappedCard(
          avatarBg: const Color(0xFFF0F9FF),
          iconColor: const Color(0xFF0284C7),
          icon: Icons.people_alt_outlined,
          title: 'Resenha do Squad',
          subtitle: '8.732 mensagens • 3 de mar. de 2024',
          onTap: () => _handleDemoRetrospective(_demoChatAmigos, 'Resenha do Squad'),
        ),

        // Newly added user imports
        ..._savedWrappeds.map(
          (saved) => Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _buildRecentWrappedCard(
              avatarBg: saved.mode == ChatMode.casal
                  ? const Color(0xFFFFF1F2)
                  : const Color(0xFFF0F9FF),
              iconColor: saved.mode == ChatMode.casal
                  ? const Color(0xFFF43F5E)
                  : const Color(0xFF0284C7),
              icon: saved.mode == ChatMode.casal
                  ? Icons.favorite_border_rounded
                  : Icons.people_alt_outlined,
              title: saved.title,
              subtitle: '${saved.messageCount} mensagens • ${saved.dateText}',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => ModeSelectionScreen(
                      initialAnalysis: saved.analysisResult,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentWrappedCard({
    required Color avatarBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE8E1), width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Squircle Avatar
          Container(
            width: 42,
            height: 42,
            decoration: ShapeDecoration(
              color: avatarBg,
              shape: SquircleBorder.radius(12),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Subtitle Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action Button: "Ver análise →"
          InkWell(
            onTap: _isLoading ? null : onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Ver análise',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 11,
                    color: Color(0xFF0F172A),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 4),

          // 3-Dots Menu
          const Icon(
            Icons.more_vert_rounded,
            size: 18,
            color: Color(0xFF94A3B8),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION 6: ESCOLHA UMA LENTE DE ANÁLISE (2-COLUMN BENTO GRID)
  // ==========================================
  Widget _buildLenteDeAnaliseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: "ESCOLHA UMA LENTE DE ANÁLISE" + "Conheça todos os modelos →"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ESCOLHA UMA LENTE DE ANÁLISE',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
            InkWell(
              onTap: _showAllModelsBottomSheet,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Conheça todos os modelos',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: SwissColors.irisPrimary,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 12,
                    color: SwissColors.irisPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 2-Column Bento Grid: Casal & Amigos
        Row(
          children: [
            // Card 1: Casal (Pastel Rose)
            Expanded(
              child: _buildBentoCard(
                eyebrow: 'AFINIDADE & RITMO',
                title: 'Casal',
                description: 'Entenda a dinâmica, o afeto e os momentos mais especiais.',
                bgGradient: const LinearGradient(
                  colors: [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderColor: const Color(0xFFFECDD3),
                accentColor: const Color(0xFFF43F5E),
                eyebrowColor: const Color(0xFFE11D48),
                icon: Icons.favorite_border_rounded,
                watermarkIcon: Icons.favorite_border_rounded,
                onTap: () => _handleDemoRetrospective(_demoChatCasal, 'Mariana & Lucas (Casal)'),
              ),
            ),

            const SizedBox(width: 12),

            // Card 2: Amigos (Pastel Sky Blue)
            Expanded(
              child: _buildBentoCard(
                eyebrow: 'DINÂMICA & SQUAD',
                title: 'Amigos',
                description: 'Descubra os padrões, os memes, os áudios e quem manda mais.',
                bgGradient: const LinearGradient(
                  colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderColor: const Color(0xFFBAE6FD),
                accentColor: const Color(0xFF0284C7),
                eyebrowColor: const Color(0xFF0284C7),
                icon: Icons.people_alt_outlined,
                watermarkIcon: Icons.chat_bubble_outline_rounded,
                onTap: () => _handleDemoRetrospective(_demoChatAmigos, 'Resenha do Squad (Amigos)'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoCard({
    required String eyebrow,
    required String title,
    required String description,
    required Gradient bgGradient,
    required Color borderColor,
    required Color accentColor,
    required Color eyebrowColor,
    required IconData icon,
    required IconData watermarkIcon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 165,
          decoration: BoxDecoration(
            gradient: bgGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Subtle background watermark icon
              Positioned(
                right: -8,
                bottom: 8,
                child: Icon(
                  watermarkIcon,
                  size: 72,
                  color: accentColor.withValues(alpha: 0.12),
                ),
              ),

              // Content Layout
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Icon Container + Eyebrow & Title Column
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: accentColor, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eyebrow,
                                style: TextStyle(
                                  fontSize: 8.5,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w700,
                                  color: eyebrowColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Description
                    Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 11.5,
                          height: 1.35,
                          color: Color(0xFF475569),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Bottom Right: Circular Arrow Action
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.18),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SECTION 7: FOOTER TAGLINE
  // ==========================================
  Widget _buildFooterTagline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.auto_awesome_rounded,
          size: 14,
          color: Color(0xFF818CF8),
        ),
        SizedBox(width: 6),
        Text(
          'CONVERSAS REAIS. PERSPECTIVAS EXTRAORDINÁRIAS.',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: Color(0xFF818CF8),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SECTION 8: BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_rounded,
              label: 'Início',
              isActive: _selectedTabIndex == 0,
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.bar_chart_rounded,
              label: 'Minhas Análises',
              isActive: _selectedTabIndex == 1,
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.menu_book_outlined,
              label: 'Modelos',
              isActive: _selectedTabIndex == 2,
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.settings_outlined,
              label: 'Configurações',
              isActive: _selectedTabIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedTabIndex = index);
        if (index == 2) {
          _showAllModelsBottomSheet();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: const ShapeDecoration(
                  color: Color(0xFFEEF2FF),
                  shape: StadiumBorder(),
                ),
                child: Icon(icon, color: const Color(0xFF6366F1), size: 20),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
              ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 2),
            if (isActive)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF6366F1),
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3D TILTED CARDS & WHATSAPP ILLUSTRATION
// ==========================================
class _HeroChatIllustration extends StatelessWidget {
  const _HeroChatIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background soft radial warmth
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFEEF2FF).withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Card 1: Chat Bubbles Card (Tilted -6 degrees)
        Positioned(
          top: 18,
          left: 10,
          child: Transform.rotate(
            angle: -0.10,
            child: Container(
              width: 82,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 52,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Card 2: Bar Chart + Heart Card (Tilted +10 degrees in front)
        Positioned(
          top: 36,
          right: 6,
          child: Transform.rotate(
            angle: 0.14,
            child: Container(
              width: 66,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 7,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Container(
                        width: 7,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFF818CF8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Container(
                        width: 7,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7D2FE),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.favorite_rounded,
                    size: 13,
                    color: Color(0xFFEF4444),
                  ),
                ],
              ),
            ),
          ),
        ),

        // WhatsApp Green Badge Icon (Floating top-left)
        Positioned(
          top: 0,
          left: 12,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF25D366),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF25D366).withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.chat_bubble_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),

        // Handwritten Annotation with Sketched Arrow: "Mais do que mensagens, boas histórias."
        Positioned(
          bottom: 0,
          right: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomPaint(
                size: const Size(20, 26),
                painter: _CurvedArrowPainter(),
              ),
              const SizedBox(width: 3),
              const Text(
                'Mais\ndo que mensagens,\nboas histórias.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 8.5,
                  height: 1.15,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom painter that draws a delicate curved sketched arrow
class _CurvedArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.8, 2);
    path.quadraticBezierTo(
      0,
      size.height * 0.4,
      size.width * 0.3,
      size.height - 2,
    );
    canvas.drawPath(path, paint);

    // Arrowhead
    canvas.drawLine(
      Offset(size.width * 0.3, size.height - 2),
      Offset(size.width * 0.1, size.height - 6),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, size.height - 2),
      Offset(size.width * 0.5, size.height - 6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
