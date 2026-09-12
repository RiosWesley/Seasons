import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Dynamic, textured, and animated background engine for Grupo Mode Stories.
/// Implements bespoke Spotify Wrapped-level visual diversity across all 16 slides:
/// - Broadsheet gazette paper textures and ceremonial certificate parchment
/// - Regal imperial violet, obsidian plum, and medal gold palettes
/// - High-performance 60fps animations (podium rays, community matrix, gold dust, news broadcast)
class GrupoBackgroundVariants {
  GrupoBackgroundVariants._();

  /// Slide g1: Edição Extraordinária (Capa) — Broadsheet Paper with Violet Specks
  static Widget g1Cover() {
    return _TexturedPaperCanvas(
      imageAsset: 'assets/images/grupo_bg_broadsheet.jpg',
      fallbackColor: const Color(0xFFFAF6FD),
      overlay: const _FloatingSparks(
        count: 14,
        colors: [Color(0xFF7C3AED), Color(0xFFA855F7), Color(0xFFEAB308)],
        speed: 0.35,
      ),
    );
  }

  /// Slide g2: Volume Literário — Alabaster Paper with Floating Gold Page Dust
  static Widget g2LiteraryTotal() {
    return const _LiteraryVolumesBackground();
  }

  /// Slide g3: Pódio dos Tagarelas (Hall of Fame) — Imperial Violet with Rotating Golden Rays
  static Widget g3Podium() {
    return const _ImperialPodiumRaysBackground();
  }

  /// Slide g4: A Balança de Poder (Pareto 80/20) — Animated Dual-Tone Field
  static Widget g4Dynamics() {
    return const _ParetoBalanceBackground();
  }

  /// Slide g5: O Cronograma do Ano — Deep Obsidian Plum with Milestone Beacons
  static Widget g5Timeline() {
    return const _TexturedDarkCanvas(
      fallbackGradient: [Color(0xFF15082E), Color(0xFF2E1065), Color(0xFF120524)],
      vignetteOpacity: 0.35,
      overlay: _FloatingSparks(
        count: 20,
        colors: [Color(0xFFEAB308), Color(0xFFA855F7), Color(0xFFC084FC)],
        speed: 0.25,
      ),
    );
  }

  /// Slide g6: Pautas & Trending Topics — Gazette Broadsheet Column Guides
  static Widget g6TopicsCloud() {
    return const _GazetteColumnGridBackground();
  }

  /// Slide g7: O Turno da Madrugada — Obsidian Purple with Rising Warm Gold Hearth
  static Widget g7Heatmap() {
    return const _PlumMidnightAuraBackground();
  }

  /// Slide g8: Dicionário de Emojis — Floating Golden & Violet Spheres
  static Widget g8CollectiveEmojis() {
    return const _GoldenEmojiOrbsBackground();
  }

  /// Slide g9: Momento de Pânico (Flood) — Dramatic Amber & Crimson Alert Aura
  static Widget g9ChaoticFlood() {
    return const _CrimsonAlertFlashBackground();
  }

  /// Slide g10: O Conector do Grupo — Community Network Matrix Constellation
  static Widget g10NetworkMatrix() {
    return const _CommunityNetworkMatrixBackground();
  }

  /// Slide g11: Clima Geral & Vibe — Breathing Chromatic Violet & Gold Aurora
  static Widget g11CultureInsight() {
    return const _VibeGradientMorphBackground();
  }

  /// Slide g12: Troféu Vácuo de Ouro — Deep Plum Velvet with Rising Gold Dust
  static Widget g12GhostingTrophy() {
    return const _GoldTrophySpotlightBackground();
  }

  /// Slide g13: O Repórter do Grupo — Pressroom Viewfinder Frame Guides
  static Widget g13ReporterPrints() {
    return const _PressCameraFlashBackground();
  }

  /// Slide g14: O Correspondente Internacional — News Wire Radar Waves
  static Widget g14NewsForwarder() {
    return const _GlobalNewsRadarBackground();
  }

  /// Slide g15: Apagadores de Mensagens — Darkroom Smoky Haze Suspense
  static Widget g15UnsendDeleter() {
    return const _RedactedTextSmokeBackground();
  }

  /// Slide g16: Certificado de Sobrevivência — Official Parchment with Gold Confetti
  static Widget g16Certificate() {
    return _TexturedPaperCanvas(
      imageAsset: 'assets/images/casal_bg_passport_parchment.jpg',
      fallbackColor: const Color(0xFFFAF5FF),
      tintColor: const Color(0x127C3AED),
      overlay: const _FloatingSparks(
        count: 24,
        colors: [Color(0xFFEAB308), Color(0xFF7C3AED), Color(0xFFF59E0B), Color(0xFFA855F7)],
        speed: 0.45,
      ),
    );
  }
}

// ============================================================================
// 1. TEXTURED PAPER CANVAS
// ============================================================================
class _TexturedPaperCanvas extends StatelessWidget {
  final String? imageAsset;
  final Color fallbackColor;
  final Color? tintColor;
  final Widget? overlay;

  const _TexturedPaperCanvas({
    this.imageAsset,
    required this.fallbackColor,
    this.tintColor,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: fallbackColor),
        if (imageAsset != null)
          Opacity(
            opacity: 0.88,
            child: Image.asset(
              imageAsset!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        if (tintColor != null) Container(color: tintColor),
        ?overlay,
      ],
    );
  }
}

// ============================================================================
// 2. TEXTURED DARK CANVAS
// ============================================================================
class _TexturedDarkCanvas extends StatelessWidget {
  final List<Color> fallbackGradient;
  final double vignetteOpacity;
  final Widget? overlay;

  const _TexturedDarkCanvas({
    required this.fallbackGradient,
    this.vignetteOpacity = 0.3,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: fallbackGradient,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.1,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: vignetteOpacity),
              ],
            ),
          ),
        ),
        ?overlay,
      ],
    );
  }
}

// ============================================================================
// 3. LITERARY VOLUMES BACKGROUND (g2)
// ============================================================================
class _LiteraryVolumesBackground extends StatefulWidget {
  const _LiteraryVolumesBackground();

  @override
  State<_LiteraryVolumesBackground> createState() =>
      _LiteraryVolumesBackgroundState();
}

class _LiteraryVolumesBackgroundState extends State<_LiteraryVolumesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _BookSpinesPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _BookSpinesPainter extends CustomPainter {
  final double progress;

  _BookSpinesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFFBF8FF);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final linePaint = Paint()
      ..color = const Color(0xFFDDD6FE).withValues(alpha: 0.35)
      ..strokeWidth = 1.0;

    // Faint vertical broadsheet paper lines
    const spacing = 36.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Subtle gold foil shimmer beam
    final shimmerX = (progress * (size.width + 200)) - 100;
    final shimmerPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xFFEAB308).withValues(alpha: 0.08),
          const Color(0xFFA855F7).withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(shimmerX - 80, 0, 160, size.height));

    canvas.drawRect(Rect.fromLTWH(shimmerX - 80, 0, 160, size.height), shimmerPaint);
  }

  @override
  bool shouldRepaint(covariant _BookSpinesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ============================================================================
// 4. IMPERIAL PODIUM RAYS BACKGROUND (g3)
// ============================================================================
class _ImperialPodiumRaysBackground extends StatefulWidget {
  const _ImperialPodiumRaysBackground();

  @override
  State<_ImperialPodiumRaysBackground> createState() =>
      _ImperialPodiumRaysBackgroundState();
}

class _ImperialPodiumRaysBackgroundState
    extends State<_ImperialPodiumRaysBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _PodiumRaysPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _PodiumRaysPainter extends CustomPainter {
  final double progress;

  _PodiumRaysPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Deep royal purple background
    final bgPaint = Paint()..color = const Color(0xFF1E0A3C);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final center = Offset(size.width * 0.5, size.height * 0.45);
    final maxRadius = size.longestSide;
    const rayCount = 16;
    final angleStep = (2 * math.pi) / rayCount;
    final startAngle = progress * 2 * math.pi;

    final rayPaint = Paint()
      ..color = const Color(0xFFEAB308).withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < rayCount; i += 2) {
      final a1 = startAngle + i * angleStep;
      final a2 = a1 + (angleStep * 0.7);

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + math.cos(a1) * maxRadius, center.dy + math.sin(a1) * maxRadius)
        ..lineTo(center.dx + math.cos(a2) * maxRadius, center.dy + math.sin(a2) * maxRadius)
        ..close();

      canvas.drawPath(path, rayPaint);
    }

    // Radial gold vignette
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.1),
        radius: 0.9,
        colors: [
          const Color(0xFF7C3AED).withValues(alpha: 0.35),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, vignettePaint);
  }

  @override
  bool shouldRepaint(covariant _PodiumRaysPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ============================================================================
// 5. PARETO BALANCE DUAL-TONE BACKGROUND (g4)
// ============================================================================
class _ParetoBalanceBackground extends StatefulWidget {
  const _ParetoBalanceBackground();

  @override
  State<_ParetoBalanceBackground> createState() =>
      _ParetoBalanceBackgroundState();
}

class _ParetoBalanceBackgroundState extends State<_ParetoBalanceBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final dy = math.sin(t * math.pi) * 30;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFFFAF5FF)),
              // Top 20% Violet Aura
              Positioned(
                top: -50 + dy,
                left: -30,
                right: -30,
                height: 360,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, -0.6),
                      radius: 0.85,
                      colors: [
                        const Color(0xFF7C3AED).withValues(alpha: 0.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom 80% Gold Accent Glow
              Positioned(
                bottom: -60 - dy,
                right: -40,
                width: 280,
                height: 280,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFF59E0B).withValues(alpha: 0.14),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// 6. GAZETTE COLUMN GRID BACKGROUND (g6)
// ============================================================================
class _GazetteColumnGridBackground extends StatelessWidget {
  const _GazetteColumnGridBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFFFAF6FE)),
        CustomPaint(
          painter: _ColumnGridPainter(),
          size: Size.infinite,
        ),
      ],
    );
  }
}

class _ColumnGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = const Color(0xFFDDD6FE).withValues(alpha: 0.4)
      ..strokeWidth = 0.8;

    // 3 Gazette editorial columns
    final colW = size.width / 3;
    canvas.drawLine(Offset(colW, 40), Offset(colW, size.height - 40), borderPaint);
    canvas.drawLine(Offset(colW * 2, 40), Offset(colW * 2, size.height - 40), borderPaint);

    // Subtle horizontal rules
    canvas.drawLine(const Offset(20, 120), Offset(size.width - 20, 120), borderPaint);
    canvas.drawLine(Offset(20, size.height - 120), Offset(size.width - 20, size.height - 120), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// 7. PLUM MIDNIGHT AURA BACKGROUND (g7)
// ============================================================================
class _PlumMidnightAuraBackground extends StatefulWidget {
  const _PlumMidnightAuraBackground();

  @override
  State<_PlumMidnightAuraBackground> createState() =>
      _PlumMidnightAuraBackgroundState();
}

class _PlumMidnightAuraBackgroundState
    extends State<_PlumMidnightAuraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final goldAlpha = 0.18 + t * 0.12;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFF130826)),
              // Rising gold hearth at bottom
              Positioned(
                bottom: -80,
                left: -40,
                right: -40,
                height: 360,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, 0.9),
                      radius: 1.0,
                      colors: [
                        const Color(0xFFEAB308).withValues(alpha: goldAlpha),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Top midnight plum wash
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1E0B38),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// 8. GOLDEN EMOJI ORBS BACKGROUND (g8)
// ============================================================================
class _GoldenEmojiOrbsBackground extends StatefulWidget {
  const _GoldenEmojiOrbsBackground();

  @override
  State<_GoldenEmojiOrbsBackground> createState() =>
      _GoldenEmojiOrbsBackgroundState();
}

class _GoldenEmojiOrbsBackgroundState extends State<_GoldenEmojiOrbsBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final dy1 = math.sin(t * math.pi) * 24;
          final dy2 = math.cos(t * math.pi) * 20;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFFFAF5FF)),
              Positioned(
                top: 100 + dy1,
                left: 30,
                width: 200,
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFEAB308).withValues(alpha: 0.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 140 + dy2,
                right: 20,
                width: 240,
                height: 240,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFA855F7).withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// 9. CRIMSON ALERT FLASH BACKGROUND (g9)
// ============================================================================
class _CrimsonAlertFlashBackground extends StatefulWidget {
  const _CrimsonAlertFlashBackground();

  @override
  State<_CrimsonAlertFlashBackground> createState() =>
      _CrimsonAlertFlashBackgroundState();
}

class _CrimsonAlertFlashBackgroundState
    extends State<_CrimsonAlertFlashBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final pulse = 0.10 + t * 0.18;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFF18081E)),
              Center(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFEF4444).withValues(alpha: pulse),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// 10. COMMUNITY NETWORK MATRIX (g10)
// ============================================================================
class _CommunityNetworkMatrixBackground extends StatefulWidget {
  const _CommunityNetworkMatrixBackground();

  @override
  State<_CommunityNetworkMatrixBackground> createState() =>
      _CommunityNetworkMatrixBackgroundState();
}

class _CommunityNetworkMatrixBackgroundState
    extends State<_CommunityNetworkMatrixBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_MatrixNode> _nodes = [];
  final math.Random _rnd = math.Random(61);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    for (int i = 0; i < 16; i++) {
      _nodes.add(_MatrixNode(
        x: _rnd.nextDouble(),
        y: _rnd.nextDouble(),
        vx: (_rnd.nextDouble() - 0.5) * 0.08,
        vy: (_rnd.nextDouble() - 0.5) * 0.08,
        radius: 2.0 + _rnd.nextDouble() * 2.5,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _MatrixConstellationPainter(
              nodes: _nodes,
              progress: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _MatrixNode {
  double x;
  double y;
  final double vx;
  final double vy;
  final double radius;

  _MatrixNode({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
  });
}

class _MatrixConstellationPainter extends CustomPainter {
  final List<_MatrixNode> nodes;
  final double progress;

  _MatrixConstellationPainter({required this.nodes, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF9F5FF);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF7C3AED).withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    final nodePaint = Paint()..color = const Color(0xFFA855F7).withValues(alpha: 0.35);

    final offsets = nodes.map((n) {
      final curX = ((n.x + n.vx * progress) % 1.0) * size.width;
      final curY = ((n.y + n.vy * progress) % 1.0) * size.height;
      return Offset(curX, curY);
    }).toList();

    for (int i = 0; i < offsets.length; i++) {
      for (int j = i + 1; j < offsets.length; j++) {
        final dist = (offsets[i] - offsets[j]).distance;
        if (dist < 125) {
          final alpha = (1.0 - (dist / 125)).clamp(0.0, 1.0) * 0.22;
          linePaint.color = const Color(0xFF7C3AED).withValues(alpha: alpha);
          canvas.drawLine(offsets[i], offsets[j], linePaint);
        }
      }
    }

    for (int i = 0; i < offsets.length; i++) {
      canvas.drawCircle(offsets[i], nodes[i].radius, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixConstellationPainter oldDelegate) => true;
}

// ============================================================================
// 11. VIBE GRADIENT MORPH BACKGROUND (g11)
// ============================================================================
class _VibeGradientMorphBackground extends StatefulWidget {
  const _VibeGradientMorphBackground();

  @override
  State<_VibeGradientMorphBackground> createState() =>
      _VibeGradientMorphBackgroundState();
}

class _VibeGradientMorphBackgroundState
    extends State<_VibeGradientMorphBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.8 + t * 0.4, -1.0),
                end: Alignment(0.8 - t * 0.4, 1.0),
                colors: const [
                  Color(0xFFFAF5FF),
                  Color(0xFFF3E8FF),
                  Color(0xFFFEF3C7),
                  Color(0xFFFAF5FF),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// 12. GOLD TROPHY SPOTLIGHT (g12)
// ============================================================================
class _GoldTrophySpotlightBackground extends StatelessWidget {
  const _GoldTrophySpotlightBackground();

  @override
  Widget build(BuildContext context) {
    return const _TexturedDarkCanvas(
      fallbackGradient: [Color(0xFF1B0B33), Color(0xFF2E1065), Color(0xFF120526)],
      vignetteOpacity: 0.4,
      overlay: _FloatingSparks(
        count: 22,
        colors: [Color(0xFFEAB308), Color(0xFFFDE047)],
        speed: 0.35,
      ),
    );
  }
}

// ============================================================================
// 13. PRESS CAMERA FLASH BACKGROUND (g13)
// ============================================================================
class _PressCameraFlashBackground extends StatelessWidget {
  const _PressCameraFlashBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFF0F0A1A)),
        CustomPaint(
          painter: _PressViewfinderPainter(),
          size: Size.infinite,
        ),
      ],
    );
  }
}

class _PressViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFA855F7).withValues(alpha: 0.25)
      ..strokeWidth = 1.2;

    const margin = 26.0;
    const len = 22.0;

    // Corner brackets
    canvas.drawLine(const Offset(margin, margin), const Offset(margin + len, margin), linePaint);
    canvas.drawLine(const Offset(margin, margin), const Offset(margin, margin + len), linePaint);
    canvas.drawLine(Offset(size.width - margin, margin), Offset(size.width - margin - len, margin), linePaint);
    canvas.drawLine(Offset(size.width - margin, margin), Offset(size.width - margin, margin + len), linePaint);
    canvas.drawLine(Offset(margin, size.height - margin), Offset(margin + len, size.height - margin), linePaint);
    canvas.drawLine(Offset(margin, size.height - margin), Offset(margin, size.height - margin - len), linePaint);
    canvas.drawLine(Offset(size.width - margin, size.height - margin), Offset(size.width - margin - len, size.height - margin), linePaint);
    canvas.drawLine(Offset(size.width - margin, size.height - margin), Offset(size.width - margin, size.height - margin - len), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// 14. NEWS WIRE RADAR WAVES (g14)
// ============================================================================
class _GlobalNewsRadarBackground extends StatefulWidget {
  const _GlobalNewsRadarBackground();

  @override
  State<_GlobalNewsRadarBackground> createState() =>
      _GlobalNewsRadarBackgroundState();
}

class _GlobalNewsRadarBackgroundState extends State<_GlobalNewsRadarBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _NewsRadarPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _NewsRadarPainter extends CustomPainter {
  final double progress;

  _NewsRadarPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFFAF6FE);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final center = Offset(size.width * 0.5, size.height * 0.5);
    final maxRadius = size.width * 0.46;

    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 4; i++) {
      final p = ((progress + (i * 0.25)) % 1.0);
      final r = p * maxRadius;
      final alpha = (1.0 - p) * 0.3;
      circlePaint.color = const Color(0xFF7C3AED).withValues(alpha: alpha);
      canvas.drawCircle(center, r, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NewsRadarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ============================================================================
// 15. REDACTED TEXT SMOKE SUSPENSE (g15)
// ============================================================================
class _RedactedTextSmokeBackground extends StatefulWidget {
  const _RedactedTextSmokeBackground();

  @override
  State<_RedactedTextSmokeBackground> createState() =>
      _RedactedTextSmokeBackgroundState();
}

class _RedactedTextSmokeBackgroundState
    extends State<_RedactedTextSmokeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final pulse = 0.08 + t * 0.12;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFF0F0A18)),
              Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFA855F7).withValues(alpha: pulse),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// 16. FLOATING SPARKS & CELEBRATION DUST
// ============================================================================
class _FloatingSparks extends StatefulWidget {
  final int count;
  final List<Color> colors;
  final double speed;

  const _FloatingSparks({
    required this.count,
    required this.colors,
    this.speed = 0.3,
  });

  @override
  State<_FloatingSparks> createState() => _FloatingSparksState();
}

class _FloatingSparksState extends State<_FloatingSparks>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_SparkItem> _items = [];
  final math.Random _rnd = math.Random(88);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (10000 / widget.speed).round()),
    )..repeat();

    for (int i = 0; i < widget.count; i++) {
      _items.add(_SparkItem(
        x: _rnd.nextDouble(),
        y: _rnd.nextDouble(),
        speed: 0.5 + _rnd.nextDouble() * 0.5,
        radius: 1.2 + _rnd.nextDouble() * 2.2,
        color: widget.colors[_rnd.nextInt(widget.colors.length)],
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _SparkPainter(
              items: _items,
              progress: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _SparkItem {
  final double x;
  final double y;
  final double speed;
  final double radius;
  final Color color;

  _SparkItem({
    required this.x,
    required this.y,
    required this.speed,
    required this.radius,
    required this.color,
  });
}

class _SparkPainter extends CustomPainter {
  final List<_SparkItem> items;
  final double progress;

  _SparkPainter({required this.items, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final it in items) {
      final curY = ((it.y + it.speed * progress) % 1.0) * size.height;
      final curX = it.x * size.width;
      final paint = Paint()..color = it.color.withValues(alpha: 0.45);
      canvas.drawCircle(Offset(curX, curY), it.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkPainter oldDelegate) => true;
}
