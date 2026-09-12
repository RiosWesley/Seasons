import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/services/onboarding_preferences.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';
import '../widgets/swiss_button.dart';
import 'home_screen.dart';

/// Interactive, fluid 4-page editorial onboarding experience for Chat Wrapped Flutter.
///
/// Features:
/// - Warm Ivory palette (#FBF9F5), serif editorial typography, continuous squircles.
/// - Page 1: Welcome & Personal Archive (100% offline value proposition).
/// - Page 2: 3 Calibrated Analysis Models (Casal, Amigos, Grupo) + 9:16 Stories.
/// - Page 3: Step-by-Step WhatsApp Export Guide with mandatory "Sem mídia" badge.
/// - Page 4: Privacy Guarantee Seal (zero servers, zero tracking) & primary launch CTA.
/// - Smooth PageView with animated pill indicator, "Pular" button, and tactile advance buttons.
/// - Replay mode support (`isReplay: true`) returning via [Navigator.pop].
class OnboardingScreen extends StatefulWidget {
  final bool isReplay;
  final int initialPage;

  const OnboardingScreen({
    super.key,
    this.isReplay = false,
    this.initialPage = 0,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(0, 3);
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void didUpdateWidget(covariant OnboardingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPage != widget.initialPage) {
      final targetPage = widget.initialPage.clamp(0, 3);
      if (targetPage != _currentPage) {
        setState(() {
          _currentPage = targetPage;
        });
        if (_pageController.hasClients) {
          _pageController.jumpToPage(targetPage);
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    final clamped = page.clamp(0, 3);
    if (clamped == _currentPage) return;
    HapticFeedback.selectionClick();
    setState(() {
      _currentPage = clamped;
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        clamped,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _nextPage() {
    if (_currentPage < 3) {
      HapticFeedback.lightImpact();
      final targetPage = (_currentPage + 1).clamp(0, 3);
      setState(() {
        _currentPage = targetPage;
      });
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  Future<void> _skipOnboarding() async {
    HapticFeedback.selectionClick();
    await OnboardingPreferences.setHasSeenOnboarding(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  void _closeReplay() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pop();
  }

  Future<void> _finishOnboarding() async {
    HapticFeedback.mediumImpact();
    if (widget.isReplay) {
      Navigator.of(context).pop();
    } else {
      await OnboardingPreferences.setHasSeenOnboarding(true);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwissColors.lightBackground,
      body: Stack(
        children: [
          // Subtle Crumpled Paper Texture Background Layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.55,
              child: Image.asset(
                'assets/images/home_paper_texture.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),

          // Primary SafeArea layout
          SafeArea(
            child: Column(
              children: [
                // Top Brand & Action Bar
                _buildTopBar(),

                // Scrollable PageView
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildPage1Welcome(),
                      _buildPage2Features(),
                      _buildPage3ExportGuide(),
                      _buildPage4PrivacyLaunch(),
                    ],
                  ),
                ),

                // Bottom Controls (Pills & Tactile Advance CTA)
                _buildBottomControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TOP BRAND & ACTION BAR
  // ==========================================
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Brand Icon + 'Chat Wrapped' title & subtitle
          Expanded(
            child: Row(
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
                      LucideIcons.sparkles,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Chat Wrapped',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: SwissTypography.labelSmall.copyWith(
                          fontSize: 9.5,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w700,
                          color: SwissColors.irisPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Right: 'Fechar' (Replay) or 'Pular' (First Run)
          if (widget.isReplay)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeReplay,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF1F5F9),
                  shape: SquircleBorder.radius(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.x, size: 14, color: Color(0xFF475569)),
                    SizedBox(width: 4),
                    Text(
                      'Fechar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _currentPage == 3 ? 0.0 : 1.0,
              child: IgnorePointer(
                ignoring: _currentPage == 3,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _skipOnboarding,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: ShapeDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: SquircleBorder.radius(
                        8,
                        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                    ),
                    child: const Text(
                      'Pular',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
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
  // PAGE 1: BOAS-VINDAS & APRESENTAÇÃO
  // ==========================================
  Widget _buildPage1Welcome() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Pill & 100% OFFLINE Badge
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: ShapeDecoration(
                  color: const Color(0xFFEEF2FF),
                  shape: SquircleBorder.radius(
                    8,
                    side: const BorderSide(color: Color(0xFFE0E7FF), width: 1.0),
                  ),
                ),
                child: const Text(
                  'ARQUIVO PESSOAL DE CONVERSAS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
              // Security Pill (matches smoke test: '100% OFFLINE')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: const ShapeDecoration(
                  color: Color(0xFFEEF2FF),
                  shape: StadiumBorder(
                    side: BorderSide(color: Color(0xFFE0E7FF), width: 1.0),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.lock,
                      size: 13,
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
            ],
          ),

          const SizedBox(height: 18),

          // Editorial Headline
          const Text(
            'Suas conversas guardam histórias inesquecíveis.',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              height: 1.22,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 10),

          // Subtitle
          const Text(
            'Transforme arquivos de conversas do WhatsApp em uma retrospectiva interativa e profunda, com insights que você nunca viu antes.',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xFF475569),
            ),
          ),

          const SizedBox(height: 20),

          // Hero Visual Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: SquircleBorder.card(
                side: const BorderSide(color: Color(0xFFEBE6DF), width: 1.0),
              ),
              shadows: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chat bubbles preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF8FAFC),
                    shape: SquircleBorder.radius(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEEF2FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(LucideIcons.messageCircle, size: 14, color: Color(0xFF4F46E5)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: SquircleBorder.radius(
                                  12,
                                  side: const BorderSide(color: Color(0xFFE2E8F0), width: 0.8),
                                ),
                              ),
                              child: const Text(
                                'Lembra de tudo que a gente conversou esse ano?',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 240),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: ShapeDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                                ),
                                shape: SquircleBorder.radius(12),
                              ),
                              child: const Text(
                                'Incrível rever nossas histórias em retrospectiva! ✨',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Script Annotation Quote
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.quote, size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Mais do que dados: a narrativa das suas relações.',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Core Value Propositions Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: SquircleBorder.card(
                side: const BorderSide(color: Color(0xFFEBE6DF), width: 1.0),
              ),
            ),
            child: Column(
              children: [
                _buildValuePropRow(
                  icon: LucideIcons.shieldCheck,
                  iconColor: const Color(0xFF10B981),
                  bgColor: const Color(0xFFECFDF5),
                  title: 'Privacidade Inegociável',
                  subtitle: 'Zero servidores externos. Nenhum dado sai do seu aparelho.',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                ),
                _buildValuePropRow(
                  icon: LucideIcons.sparkles,
                  iconColor: SwissColors.irisPrimary,
                  bgColor: const Color(0xFFEEF2FF),
                  title: 'Análise Instantânea',
                  subtitle: 'Cálculos estatísticos processados em milissegundos localmente.',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                ),
                _buildValuePropRow(
                  icon: LucideIcons.share2,
                  iconColor: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFEF3C7),
                  title: 'Stories 9:16 Prontos',
                  subtitle: 'Retrospectiva visual cinematográfica para Instagram e WhatsApp.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuePropRow({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: ShapeDecoration(
            color: bgColor,
            shape: SquircleBorder.radius(10),
          ),
          child: Center(
            child: Icon(icon, size: 18, color: iconColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // PAGE 2: O QUE O APP FAZ & MODOS
  // ==========================================
  Widget _buildPage2Features() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: ShapeDecoration(
              color: const Color(0xFFEEF2FF),
              shape: SquircleBorder.radius(
                8,
                side: const BorderSide(color: Color(0xFFE0E7FF), width: 1.0),
              ),
            ),
            child: const Text(
              '3 LENTES DE ANÁLISE + STORIES',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: Color(0xFF4F46E5),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Editorial Headline
          const Text(
            'Três formas de olhar para as suas conexões.',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              height: 1.22,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 10),

          // Subtitle
          const Text(
            'Modelos matemáticos calibrados especificamente para a dinâmica e o número de participantes de cada conversa.',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xFF475569),
            ),
          ),

          const SizedBox(height: 18),

          // Mode 1: Casal Bento Card
          _buildModelCard(
            title: 'Modo Casal',
            badgeText: '2 PARTICIPANTES',
            icon: LucideIcons.heart,
            accentColor: const Color(0xFFF43F5E),
            bgColors: const [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
            borderColor: const Color(0xFFFECDD3),
            description:
                'Índice de sintonia & compatibilidade, linguagens do amor (corações, apelidos carinhosos), equilíbrio de mensagens e horários favoritos.',
          ),

          const SizedBox(height: 12),

          // Mode 2: Amigos Bento Card
          _buildModelCard(
            title: 'Modo Amigos',
            badgeText: '3 A 5 PARTICIPANTES',
            icon: LucideIcons.users,
            accentColor: const Color(0xFF0284C7),
            bgColors: const [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            borderColor: const Color(0xFFBAE6FD),
            description:
                'Arquétipos de comunicação, índice de vácuo, velocidade de resposta, campeão de áudios e memes do squad.',
          ),

          const SizedBox(height: 12),

          // Mode 3: Grupo Bento Card
          _buildModelCard(
            title: 'Modo Grupo',
            badgeText: '6+ PARTICIPANTES',
            icon: LucideIcons.layoutGrid,
            accentColor: const Color(0xFF7C3AED),
            bgColors: const [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
            borderColor: const Color(0xFFDDD6FE),
            description:
                'Leaderboard geral de mensagens, pódio de engajamento, radar de vibes e horários da madrugada (22h–06h).',
          ),

          const SizedBox(height: 14),

          // Interactive Stories 9:16 Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: SquircleBorder.card(),
              shadows: [
                BoxShadow(
                  color: const Color(0xFF1E1B4B).withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: ShapeDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: SquircleBorder.radius(12),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.smartphone, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Stories Interativos 9:16',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Inspirado no Spotify Wrapped: toque para avançar, segure para pausar e exporte cards prontos para compartilhar.',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                          color: Color(0xFFC7D2FE),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelCard({
    required String title,
    required String badgeText,
    required IconData icon,
    required Color accentColor,
    required List<Color> bgColors,
    required Color borderColor,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: bgColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: SquircleBorder.card(
          side: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: ShapeDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: SquircleBorder.radius(9),
                          ),
                          child: Center(
                            child: Icon(icon, size: 16, color: accentColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: SquircleBorder.radius(
                    6,
                    side: BorderSide(color: accentColor.withValues(alpha: 0.3), width: 0.8),
                  ),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.45,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PAGE 3: COMO EXPORTAR CONVERSA DO WHATSAPP
  // ==========================================
  Widget _buildPage3ExportGuide() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: ShapeDecoration(
              color: const Color(0xFFEEF2FF),
              shape: SquircleBorder.radius(
                8,
                side: const BorderSide(color: Color(0xFFE0E7FF), width: 1.0),
              ),
            ),
            child: const Text(
              'GUIA PRÁTICO EM 4 PASSOS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: Color(0xFF4F46E5),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Editorial Headline
          const Text(
            'Como exportar sua conversa do WhatsApp.',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              height: 1.22,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 10),

          // Subtitle
          const Text(
            'Leva menos de 30 segundos. Siga o passo a passo abaixo direto no seu WhatsApp.',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xFF475569),
            ),
          ),

          const SizedBox(height: 18),

          // Step 1
          _buildStepCard(
            stepNumber: 1,
            icon: LucideIcons.messageCircle,
            title: 'Abra a conversa desejada',
            description:
                'Vá até o chat individual ou grupo do WhatsApp que você deseja analisar.',
            imageAsset: 'assets/images/passo-1.png',
          ),

          const SizedBox(height: 14),

          // Step 2
          _buildStepCard(
            stepNumber: 2,
            icon: LucideIcons.moreVertical,
            title: 'Menu Mais > Exportar conversa',
            description:
                'No canto superior direito, toque nos três pontinhos (⋮) > Mais > Exportar conversa. (No iPhone: toque no nome do contato e role até o fim).',
            imageAsset: 'assets/images/passo-2.png',
          ),

          const SizedBox(height: 14),

          // Step 3 (Mandatory 'Sem mídia' badge)
          _buildStepCard(
            stepNumber: 3,
            icon: LucideIcons.fileText,
            title: 'Selecione SEMPRE "Sem mídia"',
            isMandatory: true,
            description:
                'Quando o WhatsApp perguntar, selecione obrigatoriamente "Sem mídia". Isso gera um arquivo leve (.txt ou .zip) e garante processamento instantâneo de 100% das mensagens.',
            calloutNote:
                'Arquivos com mídia (fotos/vídeos) tornam o arquivo pesado e não alteram o resultado das análises estatísticas.',
            imageAsset: 'assets/images/passo-3.png',
          ),

          const SizedBox(height: 14),

          // Step 4
          _buildStepCard(
            stepNumber: 4,
            icon: LucideIcons.share2,
            title: 'Abra ou salve no Chat Wrapped',
            description:
                'Selecione o Chat Wrapped diretamente na folha de compartilhamento do Android, ou salve o arquivo gerado e selecione-o no app.',
            imageAsset: 'assets/images/passo-4.png',
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required int stepNumber,
    required IconData icon,
    required String title,
    required String description,
    bool isMandatory = false,
    String? calloutNote,
    String? imageAsset,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: SquircleBorder.card(
          side: BorderSide(
            color: isMandatory ? const Color(0xFFFDE68A) : const Color(0xFFEBE6DF),
            width: isMandatory ? 1.5 : 1.0,
          ),
        ),
        shadows: isMandatory
            ? [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Step number indicator
              Container(
                width: 28,
                height: 28,
                decoration: ShapeDecoration(
                  color: isMandatory ? const Color(0xFFFEF3C7) : const Color(0xFFEEF2FF),
                  shape: SquircleBorder.radius(8),
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isMandatory ? const Color(0xFFB45309) : const Color(0xFF4F46E5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, size: 16, color: isMandatory ? const Color(0xFFD97706) : const Color(0xFF64748B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isMandatory ? const Color(0xFF92400E) : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          if (isMandatory) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: const ShapeDecoration(
                color: Color(0xFFFEF3C7),
                shape: StadiumBorder(
                  side: BorderSide(color: Color(0xFFFDE68A), width: 1.0),
                ),
              ),
              child: const Text(
                'OBRIGATÓRIO: Sem mídia',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Color(0xFFB45309),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                    color: Color(0xFF475569),
                  ),
                ),
                if (calloutNote != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFFFBEB),
                      shape: SquircleBorder.radius(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.info, size: 13, color: Color(0xFFD97706)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            calloutNote,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (imageAsset != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isMandatory ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0),
                          width: 1.0,
                        ),
                      ),
                      child: Image.asset(
                        imageAsset,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PAGE 4: PRIVACIDADE & INÍCIO
  // ==========================================
  Widget _buildPage4PrivacyLaunch() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: ShapeDecoration(
              color: const Color(0xFFECFDF5),
              shape: SquircleBorder.radius(
                8,
                side: const BorderSide(color: Color(0xFFA7F3D0), width: 1.0),
              ),
            ),
            child: const Text(
              'SEGURANÇA & PRIVACIDADE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: Color(0xFF047857),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Editorial Headline
          const Text(
            'Seus dados nunca saem do seu aparelho.',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              height: 1.22,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 10),

          // Subtitle
          const Text(
            'Privacidade não é uma promessa — é a própria arquitetura do Chat Wrapped.',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xFF475569),
            ),
          ),

          const SizedBox(height: 18),

          // Hero Privacy Guarantee Seal
          Container(
            padding: const EdgeInsets.all(20),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: SquircleBorder.card(
                side: const BorderSide(color: Color(0xFFC7D2FE), width: 1.2),
              ),
              shadows: [
                BoxShadow(
                  color: SwissColors.irisPrimary.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Glowing Seal Icon
                Center(
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        colors: [SwissColors.irisPrimary, SwissColors.violetSecondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: SquircleBorder.radius(18),
                      shadows: [
                        BoxShadow(
                          color: SwissColors.irisPrimary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.shieldCheck,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Selo de Garantia Local 100% Offline',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Arquitetura soberana: processamento exclusivo em memória local.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 18),

                // 3 Privacy Pillar Rows
                _buildPrivacyPillar(
                  icon: LucideIcons.cloudOff,
                  title: 'Zero Servidores',
                  description: 'Não possuímos servidores em nuvem nem banco de dados externo.',
                ),
                const SizedBox(height: 12),
                _buildPrivacyPillar(
                  icon: LucideIcons.eyeOff,
                  title: 'Zero Rastreamento',
                  description: 'Sem anúncios, sem cookies, sem telemetria e sem identificadores.',
                ),
                const SizedBox(height: 12),
                _buildPrivacyPillar(
                  icon: LucideIcons.cpu,
                  title: 'Cálculo 100% Local',
                  description: 'Todas as métricas são calculadas instantaneamente no chip do seu celular.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Airplane Mode Reassurance Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: ShapeDecoration(
              color: const Color(0xFFF8FAFC),
              shape: SquircleBorder.card(
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
              ),
            ),
            child: Row(
              children: const [
                Icon(LucideIcons.plane, size: 18, color: Color(0xFF6366F1)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Você pode até mesmo ativar o Modo Avião antes de importar: o app funcionará perfeitamente.',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: Color(0xFF475569),
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

  Widget _buildPrivacyPillar({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: ShapeDecoration(
            color: const Color(0xFFEEF2FF),
            shape: SquircleBorder.radius(8),
          ),
          child: Center(
            child: Icon(icon, size: 16, color: SwissColors.irisPrimary),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // BOTTOM CONTROLS & STEP INDICATOR PILLS
  // ==========================================
  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: _currentPage < 3
          ? LayoutBuilder(
              builder: (context, constraints) {
                final textScale = MediaQuery.textScalerOf(context).scale(1.0);
                final isCompact = constraints.maxWidth < 310 || textScale > 1.25;
                if (isCompact) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStepIndicators(),
                      const SizedBox(height: 10),
                      SwissButton(
                        label: 'Continuar',
                        icon: LucideIcons.arrowRight,
                        fullWidth: true,
                        onPressed: _nextPage,
                      ),
                    ],
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Step Indicator Pills
                    _buildStepIndicators(),

                    // Advance Button
                    SwissButton(
                      label: 'Continuar',
                      icon: LucideIcons.arrowRight,
                      onPressed: _nextPage,
                    ),
                  ],
                );
              },
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStepIndicators(),
                const SizedBox(height: 14),
                SwissButton(
                  label: widget.isReplay ? 'Concluir e Voltar' : 'Começar a Explorar',
                  icon: LucideIcons.sparkles,
                  fullWidth: true,
                  onPressed: _finishOnboarding,
                ),
              ],
            ),
    );
  }

  Widget _buildStepIndicators() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final isActive = index == _currentPage;
        return GestureDetector(
          onTap: () => _goToPage(index),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 6.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              width: isActive ? 28.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: isActive ? SwissColors.irisPrimary : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        );
      }),
    );
  }
}
