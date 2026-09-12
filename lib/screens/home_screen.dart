import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/analytics/chat_analyzer.dart';
import '../core/models/general_stats.dart';
import '../core/models/raw_chat_export.dart';
import '../core/parser/chat_parser.dart';
import '../core/services/file_ingestion_service.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';
import '../widgets/floating_bottom_bar.dart';
import '../widgets/stage_progress_indicator.dart';
import '../widgets/swiss_button.dart';
import 'mode_selection_screen.dart';
import 'onboarding_screen.dart';

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

  late final ScrollController _homeScrollController;

  @override
  void initState() {
    super.initState();
    _homeScrollController = ScrollController();
    _ingestionService = widget.ingestionService ?? FileIngestionService();
  }

  @override
  void dispose() {
    _homeScrollController.dispose();
    super.dispose();
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
            const Icon(LucideIcons.alertCircle, color: SwissColors.danger, size: 20),
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
            label: 'OK',
            type: SwissButtonType.primary,
            onPressed: () => Navigator.of(context).pop(),
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
                icon: LucideIcons.heart,
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
                icon: LucideIcons.users,
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
                icon: LucideIcons.users,
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
            const Icon(LucideIcons.chevronRight, color: Color(0xFF94A3B8), size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final scrollCompensation = 100.0 + bottomInset;

    return Scaffold(
      backgroundColor: SwissColors.lightBackground, // Warm Ivory #FBF9F5
      extendBody: true,
      bottomNavigationBar: FloatingBottomNavBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          HapticFeedback.selectionClick();
          if (index == 0 && _selectedTabIndex == 0) {
            if (_homeScrollController.hasClients) {
              _homeScrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
              );
            }
          } else {
            setState(() => _selectedTabIndex = index);
          }
        },
      ),
      body: Stack(
        children: [
          // Subtle Crumpled Paper Texture Background Layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.55,
              child: Image.asset(
                'assets/images/home_paper_texture.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Primary Content Switcher via IndexedStack
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                _buildHomeTab(scrollCompensation),
                _buildMinhasAnalisesTab(scrollCompensation),
                _buildModelosTab(scrollCompensation),
                _buildConfiguracoesTab(scrollCompensation),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 0: HOME CONTENT
  // ==========================================
  Widget _buildHomeTab(double scrollCompensation) {
    return SingleChildScrollView(
      controller: _homeScrollController,
      padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, scrollCompensation),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Editorial Brand Header
          _buildTopBar(),

          const SizedBox(height: 20),

          // 2. Hero Greeting + Editorial Headline + 3D Cards Illustration
          _buildHeroSection(),

          const SizedBox(height: 20),

          // 3. Tutorial Action Card ("Como gerar seu Wrapped")
          _buildTutorialActionCard(),

          const SizedBox(height: 20),

          // Pipeline Progress Indicator (during decompression/parsing)
          if (_currentStage != PipelineStage.idle) ...[
            StageProgressIndicator(
              stage: _currentStage,
              customMessage: _statusMessage,
            ),
            const SizedBox(height: 20),
          ],

          // 4. Retrospectivas Recentes
          _buildRecentRetrospectivesSection(),

          const SizedBox(height: 26),

          // 5. Escolha uma Lente de Análise (2-Column Bento Grid)
          _buildLenteDeAnaliseSection(),

          const SizedBox(height: 28),

          // 6. Footer Tagline
          _buildFooterTagline(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: MINHAS ANÁLISES
  // ==========================================
  Widget _buildMinhasAnalisesTab(double scrollCompensation) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, scrollCompensation),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(),
          const SizedBox(height: 20),
          const Text(
            'Minhas Análises',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Histórico de retrospectivas geradas localmente neste aparelho.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          _buildRecentRetrospectivesSection(),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                const Text(
                  'Quer analisar uma nova conversa?',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Abra o WhatsApp, toque em Exportar Conversa (Sem Mídia) e selecione o Seasons.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const OnboardingScreen(
                          isReplay: true,
                          initialPage: 2,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(LucideIcons.bookOpen, size: 14, color: Color(0xFF4F46E5)),
                        SizedBox(width: 6),
                        Text(
                          'Ver tutorial ilustrado',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: MODELOS DE ANÁLISE
  // ==========================================
  Widget _buildModelosTab(double scrollCompensation) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, scrollCompensation),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(),
          const SizedBox(height: 20),
          const Text(
            'Modelos de Análise',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Algoritmos calibrados para cada dinâmica de relacionamento.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          _buildModelExpandedCard(
            title: 'Modo Casal (2 participantes)',
            subtitle: 'Sincronia de respostas, horários mais íntimos, equilíbrio de mensagens e linguagens de afeto.',
            badges: ['❤️ Love Language', '⚡ Sincronia a Dois', '📈 Índice de Afeto'],
            color: const Color(0xFFF43F5E),
            bgColor: const Color(0xFFFFF1F2),
            icon: LucideIcons.heart,
            onTap: () => _handleDemoRetrospective(_demoChatCasal, 'Mariana & Lucas (Casal)'),
          ),
          const SizedBox(height: 14),
          _buildModelExpandedCard(
            title: 'Modo Amigos (3 a 5 participantes)',
            subtitle: 'Índice de vácuo, tempos médios de resposta, quem envia mais áudios e memes do squad.',
            badges: ['👻 Vácuômetro', '👑 O Agitador', '😂 Top Memes'],
            color: const Color(0xFF0284C7),
            bgColor: const Color(0xFFF0F9FF),
            icon: LucideIcons.users,
            onTap: () => _handleDemoRetrospective(_demoChatAmigos, 'Resenha do Squad (Amigos)'),
          ),
          const SizedBox(height: 14),
          _buildModelExpandedCard(
            title: 'Modo Grupo (6+ participantes)',
            subtitle: 'Leaderboard de mensagens, radar de vibe, horários caóticos e análise de rede.',
            badges: ['🏆 Leaderboard', '🌙 Madrugadores', '📊 Radar de Vibes'],
            color: const Color(0xFF8B5CF6),
            bgColor: const Color(0xFFF5F3FF),
            icon: LucideIcons.messagesSquare,
            onTap: () => _handleDemoRetrospective(_demoChatGrupo, 'Turma Completa (Grupo)'),
          ),
        ],
      ),
    );
  }

  Widget _buildModelExpandedCard({
    required String title,
    required String subtitle,
    required List<String> badges,
    required Color color,
    required Color bgColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(icon, color: color, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF475569),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: badges
                .map(
                  (b) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      b,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Experimentar com exemplo →',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: CONFIGURAÇÕES
  // ==========================================
  Widget _buildConfiguracoesTab(double scrollCompensation) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, scrollCompensation),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(),
          const SizedBox(height: 20),
          const Text(
            'Configurações',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Preferências, privacidade e ajuda do Seasons.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEEF2FF),
                      shape: SquircleBorder.radius(10),
                    ),
                    child: const Center(
                      child: Icon(LucideIcons.bookOpen, color: SwissColors.irisPrimary, size: 18),
                    ),
                  ),
                  title: const Text('Rever Onboarding', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Guia passo a passo de como exportar do WhatsApp', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  trailing: const Icon(LucideIcons.chevronRight, size: 18, color: Color(0xFF94A3B8)),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const OnboardingScreen(isReplay: true),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
                ListTile(
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEEF2FF),
                      shape: SquircleBorder.radius(10),
                    ),
                    child: const Center(
                      child: Icon(LucideIcons.fileUp, color: SwissColors.irisPrimary, size: 18),
                    ),
                  ),
                  title: const Text('Importar Arquivo Manualmente', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Selecione um arquivo .txt ou .zip exportado', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  trailing: const Icon(LucideIcons.chevronRight, size: 18, color: Color(0xFF94A3B8)),
                  onTap: _handleFileSelection,
                ),
                const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
                ListTile(
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFECFDF5),
                      shape: SquircleBorder.radius(10),
                    ),
                    child: const Center(
                      child: Icon(LucideIcons.shieldCheck, color: Color(0xFF10B981), size: 18),
                    ),
                  ),
                  title: const Text('100% Offline e Privado', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Processamento local. Zero servidores ou nuvem.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: const ShapeDecoration(
                      color: Color(0xFFECFDF5),
                      shape: StadiumBorder(),
                    ),
                    child: const Text('ATIVO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION 1: TOP BRAND BAR ("seasons")
  // ==========================================
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Smaller App Logo + "seasons"
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: ShapeDecoration(
                shape: SquircleBorder.radius(8),
                shadows: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/icone.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'seasons',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: -0.3,
                color: Color(0xFF1E1B4B),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Eyebrow + Headline
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
            ],
          ),
        ),

        const SizedBox(width: 10),

        // Right Column: Composed WhatsApp 3D Tilted Cards & Arrow Annotation
        const SizedBox(
          width: 132,
          height: 130,
          child: _HeroChatIllustration(),
        ),
      ],
    );
  }

  // ==========================================
  // SECTION 3: TUTORIAL ACTION CARD
  // ==========================================
  Widget _buildTutorialActionCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Icon badge + Title & Subtitle
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: SquircleBorder.radius(13),
                  shadows: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    LucideIcons.sparkles,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMO FUNCIONA',
                      style: SwissTypography.labelSmall.copyWith(
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Como gerar seu Wrapped',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Exporte a conversa no WhatsApp em 15 segundos para gerar sua retrospectiva.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Primary Button: Takes user directly to the illustrated tutorial
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const OnboardingScreen(
                      isReplay: true,
                      initialPage: 2,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.30),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      LucideIcons.bookOpen,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Como exportar do WhatsApp? Ver tutorial →',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Secondary Tactile Action: "Experimentar com uma conversa de exemplo"
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading
                  ? null
                  : () => _handleDemoRetrospective(_demoChatCasal, 'Mariana & Lucas (Casal)'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      LucideIcons.circlePlay,
                      size: 15,
                      color: Color(0xFF6366F1),
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Experimentar com uma conversa de exemplo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF4F46E5),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            const Text(
              'RETROSPECTIVAS RECENTES',
              style: TextStyle(
                fontSize: 11.5,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5B647B),
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
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    LucideIcons.arrowRight,
                    size: 13,
                    color: Color(0xFF4F46E5),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Static Showcase Card 1: "Meu Amor 💕"
        _buildRecentWrappedCard(
          avatarBg: const Color(0xFFFDE8EA),
          iconColor: const Color(0xFFE11D48),
          icon: LucideIcons.heart,
          title: 'Meu Amor 💕',
          subtitle: '1.248 mensagens  •  12 de mar. de 2024',
          onTap: () => _handleDemoRetrospective(_demoChatCasal, 'Meu Amor 💕'),
        ),

        const SizedBox(height: 10),

        // Static Showcase Card 2: "Resenha do Squad"
        _buildRecentWrappedCard(
          avatarBg: const Color(0xFFE0EDFD),
          iconColor: const Color(0xFF2563EB),
          icon: LucideIcons.users,
          title: 'Resenha do Squad',
          subtitle: '8.732 mensagens  •  3 de mar. de 2024',
          onTap: () => _handleDemoRetrospective(_demoChatAmigos, 'Resenha do Squad'),
        ),

        // Newly added user imports
        ..._savedWrappeds.map(
          (saved) => Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _buildRecentWrappedCard(
              avatarBg: saved.mode == ChatMode.casal
                  ? const Color(0xFFFDE8EA)
                  : const Color(0xFFE0EDFD),
              iconColor: saved.mode == ChatMode.casal
                  ? const Color(0xFFE11D48)
                  : const Color(0xFF2563EB),
              icon: saved.mode == ChatMode.casal
                  ? LucideIcons.heart
                  : LucideIcons.users,
              title: saved.title,
              subtitle: '${saved.messageCount} mensagens  •  ${saved.dateText}',
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
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1EFEA), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          // Squircle Avatar (50x50)
          Container(
            width: 50,
            height: 50,
            decoration: ShapeDecoration(
              color: avatarBg,
              shape: SquircleBorder.radius(16),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 24),
            ),
          ),
          const SizedBox(width: 14),

          // Title & Subtitle Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Pill Action Button: "Ver análise →"
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading ? null : onTap,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: const ShapeDecoration(
                  color: Color(0xFFF8FAFC),
                  shape: StadiumBorder(
                    side: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x04000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Ver análise',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      LucideIcons.arrowRight,
                      size: 12,
                      color: Color(0xFF0F172A),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          // Vertical 3-Dots Menu
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showAllModelsBottomSheet,
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  LucideIcons.moreVertical,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
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
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            const Text(
              'ESCOLHA UMA LENTE DE ANÁLISE',
              style: TextStyle(
                fontSize: 11.5,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5B647B),
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
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    LucideIcons.arrowRight,
                    size: 13,
                    color: Color(0xFF4F46E5),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // 2-Column Bento Grid: Casal & Amigos with Watercolor Textures & Vector Doodles
        Row(
          children: [
            // Card 1: Casal
            Expanded(
              child: _buildBentoCard(
                eyebrow: 'AFINIDADE & RITMO',
                title: 'Modo Casal',
                description: 'Entenda a dinâmica,\no afeto e os momentos\nmais especiais.',
                bgAsset: 'assets/images/casal_bento_bg.jpg',
                doodlePainter: _HeartDoodlePainter(),
                borderColor: const Color(0xFFFCD3D8),
                accentColor: const Color(0xFFE11D48),
                eyebrowColor: const Color(0xFFE11D48),
                icon: LucideIcons.heart,
                avatarBg: const Color(0xFFFDE8EA),
                onTap: () => _handleDemoRetrospective(_demoChatCasal, 'Mariana & Lucas (Casal)'),
              ),
            ),

            const SizedBox(width: 14),

            // Card 2: Amigos
            Expanded(
              child: _buildBentoCard(
                eyebrow: 'DINÂMICA & SQUAD',
                title: 'Modo Amigos',
                description: 'Descubra os padrões,\nos memes, os áudios\ne quem manda mais.',
                bgAsset: 'assets/images/amigos_bento_bg.jpg',
                doodlePainter: _AmigosDoodlePainter(),
                borderColor: const Color(0xFFBAE6FD),
                accentColor: const Color(0xFF2563EB),
                eyebrowColor: const Color(0xFF2563EB),
                icon: LucideIcons.users,
                avatarBg: const Color(0xFFE0EDFD),
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
    required String bgAsset,
    required CustomPainter doodlePainter,
    required Color borderColor,
    required Color accentColor,
    required Color eyebrowColor,
    required Color avatarBg,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 196,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: 1.0),
            image: DecorationImage(
              image: AssetImage(bgAsset),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Vector doodle layer (Heart or Rays+Wave)
              Positioned.fill(
                child: CustomPaint(
                  painter: doodlePainter,
                ),
              ),

              // Foreground card content
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Avatar Icon + Column(Eyebrow, Title)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: avatarBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor.withValues(alpha: 0.6),
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Icon(icon, color: accentColor, size: 20),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eyebrow,
                                style: TextStyle(
                                  fontSize: 9,
                                  letterSpacing: 0.9,
                                  fontWeight: FontWeight.w800,
                                  color: eyebrowColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                title,
                                style: const TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Description (3 lines)
                    Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF475569),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Bottom Right: Circular White Floating Action Button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.24),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            LucideIcons.arrowRight,
                            size: 16,
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
          LucideIcons.sparkles,
          size: 14,
          color: Color(0xFF818CF8),
        ),
        SizedBox(width: 6),
        Flexible(
          child: Text(
            'CONVERSAS REAIS. PERSPECTIVAS EXTRAORDINÁRIAS.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              color: Color(0xFF818CF8),
            ),
          ),
        ),
      ],
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
                      color: const Color(0xFFEEF2FF),
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
                    LucideIcons.heart,
                    size: 13,
                    color: Color(0xFFEF4444),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Chat Brand Icon (Floating top-left)
        Positioned(
          top: 0,
          left: 12,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [SwissColors.irisPrimary, SwissColors.violetSecondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: SwissColors.irisPrimary.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                LucideIcons.messageCircle,
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

/// Custom painter that draws the delicate white line-art heart doodle on the Casal Bento card
class _HeartDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.90)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width * 0.77, size.height * 0.46);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(0.22); // ~12 degrees tilt

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

/// Custom painter that draws the spark rays and soft translucent organic wave on the Amigos Bento card
class _AmigosDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Soft organic translucent wave/hill in lower right corner
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final wavePath = Path();
    wavePath.moveTo(size.width * 0.40, size.height);
    wavePath.quadraticBezierTo(
      size.width * 0.70,
      size.height * 0.72,
      size.width,
      size.height * 0.62,
    );
    wavePath.lineTo(size.width, size.height);
    wavePath.close();
    canvas.drawPath(wavePath, wavePaint);

    // 2. Three radiating spark rays in upper right
    final rayPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.90)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width * 0.82;
    final cy = size.height * 0.36;

    // Ray 1: angled down-left
    canvas.drawLine(Offset(cx - 10, cy + 6), Offset(cx - 18, cy + 12), rayPaint);
    // Ray 2: angled up-left
    canvas.drawLine(Offset(cx - 8, cy - 6), Offset(cx - 15, cy - 14), rayPaint);
    // Ray 3: angled up-right
    canvas.drawLine(Offset(cx + 6, cy - 8), Offset(cx + 14, cy - 16), rayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

