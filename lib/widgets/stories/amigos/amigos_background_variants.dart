import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Dynamic, textured, and animated background engine for Amigos Mode Stories.
/// Implements bespoke Spotify Wrapped-level visual diversity across all 18 slides:
/// - Tactile indie zine & risograph paper textures (halftone pulp, wheatpaste, blueprint)
/// - High-performance 60fps animations (electric grid, network constellation, radar sweep, oscilloscope)
/// - Neon cyberpunk streetlights and darkroom film aesthetics for night chapters
class AmigosBackgroundVariants {
  AmigosBackgroundVariants._();

  /// Slide a1: Zine Cover — Tactile Risograph Paper with Subtle Ink Flecks
  static Widget a1Cover() {
    return _TexturedPaperCanvas(
      imageAsset: 'assets/images/amigos_bg_riso_texture.jpg',
      fallbackColor: const Color(0xFFF4F8FD),
      overlay: const _FloatingGeometry(
        count: 14,
        colors: [Color(0xFF2563EB), Color(0xFF38BDF8), Color(0xFFFACC15)],
        speed: 0.35,
      ),
    );
  }

  /// Slide a2: Impacto Total — Electric Blueprint Grid with Scanning Beam
  static Widget a2TotalImpact() {
    return const _BlueprintGridBackground();
  }

  /// Slide a3: Estilos de Comunicação — Risograph Duo-Color Breathing Mesh
  static Widget a3Styles() {
    return const _RisographMeshBackground();
  }

  /// Slide a4: Sintonia do Squad — Electric Network Constellation (Chemistry)
  static Widget a4Compatibility() {
    return const _ConstellationNetworkBackground();
  }

  /// Slide a5: Linha do Tempo — Deep Cobalt Studio Sweep with Cyan Stardust
  static Widget a5Timeline() {
    return const _TexturedDarkCanvas(
      fallbackGradient: [Color(0xFF0A1128), Color(0xFF1C2D5A), Color(0xFF0D1527)],
      vignetteOpacity: 0.35,
      overlay: _FloatingGeometry(
        count: 20,
        colors: [Color(0xFF38BDF8), Color(0xFF60A5FA), Color(0xFFFCD34D)],
        speed: 0.25,
      ),
    );
  }

  /// Slide a6: Top Conversas — Vintage Newsprint Halftone Dots
  static Widget a6TopConversations() {
    return _TexturedPaperCanvas(
      imageAsset: 'assets/images/amigos_bg_halftone.jpg',
      fallbackColor: const Color(0xFFF8FAFC),
      overlay: const _FloatingGeometry(
        count: 10,
        colors: [Color(0xFF94A3B8), Color(0xFF3B82F6)],
        speed: 0.2,
      ),
    );
  }

  /// Slide a7: O Turno do Squad (Heatmap) — Neon Cyberpunk Street Glow
  static Widget a7Heatmap() {
    return const _NeonStreetGlowBackground();
  }

  /// Slide a8: Cultura de Emojis — Pop Confetti & Sticker Float
  static Widget a8EmojiCulture() {
    return const _PopConfettiBackground();
  }

  /// Slide a9: Flood Moments — Blueprint Architectural Grid
  static Widget a9FloodMoments() {
    return const _TexturedPaperCanvas(
      imageAsset: 'assets/images/amigos_bg_blueprint.jpg',
      fallbackColor: Color(0xFF1D4ED8),
      tintColor: Color(0x10000000),
    );
  }

  /// Slide a10: Arquétipos & Personalidades — Diagonal Hazard & Risograph Split
  static Widget a10Personalities() {
    return const _DiagonalHazardSplitBackground();
  }

  /// Slide a11: Estatísticas do Squad — Cyan Oscilloscope Wave
  static Widget a11SquadStats() {
    return const _OscilloscopeWaveBackground();
  }

  /// Slide a12: Crônica do Squad (Insight) — Deep Navy Starlight Vignette
  static Widget a12Insight() {
    return const _TexturedDarkCanvas(
      fallbackGradient: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0A0F1D)],
      vignetteOpacity: 0.4,
      overlay: _FloatingGeometry(
        count: 18,
        colors: [Color(0xFF38BDF8), Color(0xFFFDE047)],
        speed: 0.2,
      ),
    );
  }

  /// Slide a13: Interações Ocultas (Vácuo) — Ghost Radar Sweep
  static Widget a13HiddenInteractions() {
    return const _RadarSweepBackground();
  }

  /// Slide a14: Áudios & Podcaster — Cassette Tape Soundwave Glow
  static Widget a14Audios() {
    return const _SoundwaveEqualizerBackground();
  }

  /// Slide a15: Prints & Segredos — Darkroom Blueprint Film with Camera Guides
  static Widget a15Prints() {
    return const _BlueprintFilmBackground();
  }

  /// Slide a16: Memes & Encaminhados — Floating Post-It Sticky Notes
  static Widget a16Forwarded() {
    return const _FloatingPostItBackground();
  }

  /// Slide a17: Digitou e Apagou (Tribunal) — Acid Yellow Suspense Warning Glow
  static Widget a17Draft() {
    return const _SuspenseGlowBackground();
  }

  /// Slide a18: Pôster da Turnê (Poster) — Raw Wheatpaste Gig Poster with Confetti
  static Widget a18SquadPoster() {
    return _TexturedPaperCanvas(
      imageAsset: 'assets/images/amigos_bg_gig_poster.jpg',
      fallbackColor: const Color(0xFFF1F5F9),
      overlay: const _FloatingGeometry(
        count: 22,
        colors: [Color(0xFF2563EB), Color(0xFFFACC15), Color(0xFFEF4444), Color(0xFF10B981)],
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
// 3. ELECTRIC BLUEPRINT GRID BACKGROUND (a2)
// ============================================================================
class _BlueprintGridBackground extends StatefulWidget {
  const _BlueprintGridBackground();

  @override
  State<_BlueprintGridBackground> createState() => _BlueprintGridBackgroundState();
}

class _BlueprintGridBackgroundState extends State<_BlueprintGridBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
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
            painter: _BlueprintGridPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _BlueprintGridPainter extends CustomPainter {
  final double progress;

  _BlueprintGridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Light cyan-blue background
    final bgPaint = Paint()..color = const Color(0xFFF0F7FF);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFBFDBFE).withValues(alpha: 0.5)
      ..strokeWidth = 0.8;

    const spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Scanning vertical accent beam
    final beamY = size.height * progress;
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF2563EB).withValues(alpha: 0.12),
          const Color(0xFF38BDF8).withValues(alpha: 0.25),
          const Color(0xFF2563EB).withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, beamY - 60, size.width, 120));

    canvas.drawRect(Rect.fromLTWH(0, beamY - 60, size.width, 120), beamPaint);

    // Glowing scanline
    final linePaint = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.4)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, beamY), Offset(size.width, beamY), linePaint);
  }

  @override
  bool shouldRepaint(covariant _BlueprintGridPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ============================================================================
// 4. RISOGRAPH DUO-COLOR MESH BACKGROUND (a3)
// ============================================================================
class _RisographMeshBackground extends StatefulWidget {
  const _RisographMeshBackground();

  @override
  State<_RisographMeshBackground> createState() => _RisographMeshBackgroundState();
}

class _RisographMeshBackgroundState extends State<_RisographMeshBackground>
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
          final dx1 = math.sin(t * math.pi) * 30;
          final dy1 = math.cos(t * math.pi) * 25;
          final dx2 = math.cos(t * math.pi) * -25;
          final dy2 = math.sin(t * math.pi) * -30;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFFF8FAFC)),
              // Cobalt blob
              Positioned(
                top: 80 + dy1,
                left: -40 + dx1,
                width: 260,
                height: 260,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF2563EB).withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Sky Blue blob
              Positioned(
                bottom: 120 + dy2,
                right: -50 + dx2,
                width: 300,
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF38BDF8).withValues(alpha: 0.20),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Subtle Yellow Tape spark blob
              Positioned(
                top: 350 + dy2 * 0.5,
                right: 20 + dx1 * 0.5,
                width: 140,
                height: 140,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFACC15).withValues(alpha: 0.14),
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
// 5. CONSTELLATION / SQUAD SYNERGY NETWORK BACKGROUND (a4)
// ============================================================================
class _ConstellationNetworkBackground extends StatefulWidget {
  const _ConstellationNetworkBackground();

  @override
  State<_ConstellationNetworkBackground> createState() =>
      _ConstellationNetworkBackgroundState();
}

class _ConstellationNetworkBackgroundState
    extends State<_ConstellationNetworkBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_NetworkNode> _nodes = [];
  final math.Random _rnd = math.Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < 14; i++) {
      _nodes.add(_NetworkNode(
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
            painter: _ConstellationPainter(
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

class _NetworkNode {
  double x;
  double y;
  final double vx;
  final double vy;
  final double radius;

  _NetworkNode({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
  });
}

class _ConstellationPainter extends CustomPainter {
  final List<_NetworkNode> nodes;
  final double progress;

  _ConstellationPainter({required this.nodes, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF1F5F9);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF3B82F6).withValues(alpha: 0.18)
      ..strokeWidth = 1.0;

    final nodePaint = Paint()..color = const Color(0xFF2563EB).withValues(alpha: 0.35);

    // Calculate updated coordinates
    final offsets = nodes.map((n) {
      final curX = ((n.x + n.vx * progress) % 1.0) * size.width;
      final curY = ((n.y + n.vy * progress) % 1.0) * size.height;
      return Offset(curX, curY);
    }).toList();

    // Draw connecting edges
    for (int i = 0; i < offsets.length; i++) {
      for (int j = i + 1; j < offsets.length; j++) {
        final dist = (offsets[i] - offsets[j]).distance;
        if (dist < 130) {
          final alpha = (1.0 - (dist / 130)).clamp(0.0, 1.0) * 0.25;
          linePaint.color = const Color(0xFF2563EB).withValues(alpha: alpha);
          canvas.drawLine(offsets[i], offsets[j], linePaint);
        }
      }
    }

    // Draw nodes
    for (int i = 0; i < offsets.length; i++) {
      canvas.drawCircle(offsets[i], nodes[i].radius, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) => true;
}

// ============================================================================
// 6. NEON STREET GLOW BACKGROUND (a7)
// ============================================================================
class _NeonStreetGlowBackground extends StatefulWidget {
  const _NeonStreetGlowBackground();

  @override
  State<_NeonStreetGlowBackground> createState() => _NeonStreetGlowBackgroundState();
}

class _NeonStreetGlowBackgroundState extends State<_NeonStreetGlowBackground>
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
          final cyanAlpha = 0.22 + t * 0.12;
          final amberAlpha = 0.16 + (1.0 - t) * 0.10;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Midnight slate base
              Container(color: const Color(0xFF0B0F19)),

              // Rising Cyan Streetlight Glow
              Positioned(
                bottom: -80,
                left: -40,
                right: -40,
                height: 380,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, 0.9),
                      radius: 1.0,
                      colors: [
                        const Color(0xFF06B6D4).withValues(alpha: cyanAlpha),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Rising Amber accent glow
              Positioned(
                bottom: -100,
                right: -20,
                width: 240,
                height: 280,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.bottomRight,
                      radius: 0.9,
                      colors: [
                        const Color(0xFFF59E0B).withValues(alpha: amberAlpha),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Studio vignette
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
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
// 7. POP CONFETTI & STICKER FLOAT (a8)
// ============================================================================
class _PopConfettiBackground extends StatefulWidget {
  const _PopConfettiBackground();

  @override
  State<_PopConfettiBackground> createState() => _PopConfettiBackgroundState();
}

class _PopConfettiBackgroundState extends State<_PopConfettiBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final math.Random _rnd = math.Random(99);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    final colors = [
      const Color(0xFF2563EB), // Royal Blue
      const Color(0xFF38BDF8), // Sky Blue
      const Color(0xFFFACC15), // Yellow
      const Color(0xFFF43F5E), // Rose
      const Color(0xFF10B981), // Green
    ];

    for (int i = 0; i < 28; i++) {
      _particles.add(_ConfettiParticle(
        x: _rnd.nextDouble(),
        y: _rnd.nextDouble(),
        speed: 0.4 + _rnd.nextDouble() * 0.6,
        rotation: _rnd.nextDouble() * 2 * math.pi,
        rotSpeed: (_rnd.nextDouble() - 0.5) * 4,
        size: 5.0 + _rnd.nextDouble() * 6.0,
        color: colors[_rnd.nextInt(colors.length)],
        isTriangle: _rnd.nextBool(),
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
            painter: _ConfettiPainter(
              particles: _particles,
              progress: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ConfettiParticle {
  final double x;
  final double y;
  final double speed;
  final double rotation;
  final double rotSpeed;
  final double size;
  final Color color;
  final bool isTriangle;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.rotation,
    required this.rotSpeed,
    required this.size,
    required this.color,
    required this.isTriangle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFFAF5FF);
    canvas.drawRect(Offset.zero & size, bgPaint);

    for (final p in particles) {
      final curY = ((p.y + p.speed * progress) % 1.0) * size.height;
      final curX = p.x * size.width + math.sin(progress * 2 * math.pi + p.x * 10) * 12;
      final rot = p.rotation + p.rotSpeed * progress * 2 * math.pi;

      canvas.save();
      canvas.translate(curX, curY);
      canvas.rotate(rot);

      final paint = Paint()
        ..color = p.color.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill;

      if (p.isTriangle) {
        final path = Path()
          ..moveTo(0, -p.size)
          ..lineTo(p.size * 0.86, p.size * 0.5)
          ..lineTo(-p.size * 0.86, p.size * 0.5)
          ..close();
        canvas.drawPath(path, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

// ============================================================================
// 8. DIAGONAL HAZARD & RISOGRAPH SPLIT (a10)
// ============================================================================
class _DiagonalHazardSplitBackground extends StatefulWidget {
  const _DiagonalHazardSplitBackground();

  @override
  State<_DiagonalHazardSplitBackground> createState() =>
      _DiagonalHazardSplitBackgroundState();
}

class _DiagonalHazardSplitBackgroundState
    extends State<_DiagonalHazardSplitBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
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
            painter: _HazardSplitPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _HazardSplitPainter extends CustomPainter {
  final double progress;

  _HazardSplitPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Top light paper
    final topPaint = Paint()..color = const Color(0xFFF1F5F9);
    canvas.drawRect(Offset.zero & size, topPaint);

    // Diagonal hazard stripe band in the background
    final stripePaint = Paint()
      ..color = const Color(0xFFFACC15).withValues(alpha: 0.15)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke;

    final offset = progress * 60;
    canvas.save();
    canvas.rotate(-0.06);
    for (double y = -100; y < size.height + 150; y += 60) {
      canvas.drawLine(
        Offset(-50, y + offset),
        Offset(size.width + 100, y + offset),
        stripePaint,
      );
    }
    canvas.restore();

    // Subtle blue edge wash
    final washPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFF2563EB).withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, washPaint);
  }

  @override
  bool shouldRepaint(covariant _HazardSplitPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ============================================================================
// 9. CYAN OSCILLOSCOPE WAVE BACKGROUND (a11)
// ============================================================================
class _OscilloscopeWaveBackground extends StatefulWidget {
  const _OscilloscopeWaveBackground();

  @override
  State<_OscilloscopeWaveBackground> createState() =>
      _OscilloscopeWaveBackgroundState();
}

class _OscilloscopeWaveBackgroundState extends State<_OscilloscopeWaveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
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
            painter: _OscilloscopePainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _OscilloscopePainter extends CustomPainter {
  final double progress;

  _OscilloscopePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF8FAFC);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final midY = size.height * 0.52;

    void drawSine(double frequency, double amplitude, double phase, Color color, double width) {
      final path = Path();
      final paint = Paint()
        ..color = color
        ..strokeWidth = width
        ..style = PaintingStyle.stroke;

      path.moveTo(0, midY);
      for (double x = 0; x <= size.width; x += 3) {
        final normX = x / size.width;
        final y = midY + math.sin(normX * frequency * 2 * math.pi + phase) * amplitude;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }

    final p = progress * 2 * math.pi;
    drawSine(1.5, 45, p, const Color(0xFF38BDF8).withValues(alpha: 0.35), 2.5);
    drawSine(2.2, 30, -p * 1.2, const Color(0xFF2563EB).withValues(alpha: 0.25), 1.8);
    drawSine(3.0, 18, p * 0.8, const Color(0xFFFACC15).withValues(alpha: 0.30), 1.5);
  }

  @override
  bool shouldRepaint(covariant _OscilloscopePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ============================================================================
// 10. GHOST RADAR SWEEP BACKGROUND (a13)
// ============================================================================
class _RadarSweepBackground extends StatefulWidget {
  const _RadarSweepBackground();

  @override
  State<_RadarSweepBackground> createState() => _RadarSweepBackgroundState();
}

class _RadarSweepBackgroundState extends State<_RadarSweepBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
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
            painter: _RadarSweepPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _RadarSweepPainter extends CustomPainter {
  final double progress;

  _RadarSweepPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final center = Offset(size.width * 0.5, size.height * 0.48);
    final maxRadius = size.width * 0.42;

    // Concentric radar circles
    final circlePaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, maxRadius * (i / 4), circlePaint);
    }

    // Crosshairs
    canvas.drawLine(
      Offset(center.dx - maxRadius, center.dy),
      Offset(center.dx + maxRadius, center.dy),
      circlePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - maxRadius),
      Offset(center.dx, center.dy + maxRadius),
      circlePaint,
    );

    // Sweeping radar wedge
    final angle = progress * 2 * math.pi;
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: FractionalOffset(center.dx / size.width, center.dy / size.height),
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          const Color(0xFF38BDF8).withValues(alpha: 0.35),
          Colors.transparent,
        ],
        transform: GradientRotation(angle),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    canvas.drawCircle(center, maxRadius, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarSweepPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ============================================================================
// 11. CASSETTE TAPE SOUNDWAVE GLOW (a14)
// ============================================================================
class _SoundwaveEqualizerBackground extends StatefulWidget {
  const _SoundwaveEqualizerBackground();

  @override
  State<_SoundwaveEqualizerBackground> createState() =>
      _SoundwaveEqualizerBackgroundState();
}

class _SoundwaveEqualizerBackgroundState
    extends State<_SoundwaveEqualizerBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
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
          return CustomPaint(
            painter: _EqualizerBarsPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _EqualizerBarsPainter extends CustomPainter {
  final double progress;

  _EqualizerBarsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0D1527);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final barPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.18)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    const count = 28;
    final startX = size.width * 0.1;
    final endX = size.width * 0.9;
    final step = (endX - startX) / count;
    final baseY = size.height * 0.85;

    for (int i = 0; i < count; i++) {
      final x = startX + i * step;
      final wave = math.sin((i / count) * math.pi * 3 + progress * math.pi * 2);
      final height = 20 + (wave.abs() * 70);
      canvas.drawLine(Offset(x, baseY), Offset(x, baseY - height), barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EqualizerBarsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ============================================================================
// 12. DARKROOM BLUEPRINT FILM (a15)
// ============================================================================
class _BlueprintFilmBackground extends StatelessWidget {
  const _BlueprintFilmBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFF0F172A)),
        CustomPaint(
          painter: _FilmFramePainter(),
          size: Size.infinite,
        ),
      ],
    );
  }
}

class _FilmFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.22)
      ..strokeWidth = 1.0;

    const margin = 24.0;
    const len = 20.0;

    // Camera viewfinder corner brackets
    // Top-Left
    canvas.drawLine(const Offset(margin, margin), const Offset(margin + len, margin), linePaint);
    canvas.drawLine(const Offset(margin, margin), const Offset(margin, margin + len), linePaint);
    // Top-Right
    canvas.drawLine(Offset(size.width - margin, margin), Offset(size.width - margin - len, margin), linePaint);
    canvas.drawLine(Offset(size.width - margin, margin), Offset(size.width - margin, margin + len), linePaint);
    // Bottom-Left
    canvas.drawLine(Offset(margin, size.height - margin), Offset(margin + len, size.height - margin), linePaint);
    canvas.drawLine(Offset(margin, size.height - margin), Offset(margin, size.height - margin - len), linePaint);
    // Bottom-Right
    canvas.drawLine(Offset(size.width - margin, size.height - margin), Offset(size.width - margin - len, size.height - margin), linePaint);
    canvas.drawLine(Offset(size.width - margin, size.height - margin), Offset(size.width - margin, size.height - margin - len), linePaint);

    // Center crosshair
    final center = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawLine(Offset(center.dx - 8, center.dy), Offset(center.dx + 8, center.dy), linePaint);
    canvas.drawLine(Offset(center.dx, center.dy - 8), Offset(center.dx, center.dy + 8), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// 13. FLOATING POST-IT MOSAIC (a16)
// ============================================================================
class _FloatingPostItBackground extends StatelessWidget {
  const _FloatingPostItBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFFF1F5F9)),
        // Tilted Post-it 1 (Yellow)
        Positioned(
          top: 70,
          right: -20,
          child: Transform.rotate(
            angle: 0.08,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF08A).withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    offset: Offset(2, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Tilted Post-it 2 (Cyan)
        Positioned(
          bottom: 100,
          left: -30,
          child: Transform.rotate(
            angle: -0.06,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFBAE6FD).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    offset: Offset(2, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 14. ACID YELLOW SUSPENSE GLOW (a17)
// ============================================================================
class _SuspenseGlowBackground extends StatefulWidget {
  const _SuspenseGlowBackground();

  @override
  State<_SuspenseGlowBackground> createState() => _SuspenseGlowBackgroundState();
}

class _SuspenseGlowBackgroundState extends State<_SuspenseGlowBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
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
          final yellowAlpha = 0.12 + t * 0.16;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFF111827)),
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFACC15).withValues(alpha: yellowAlpha),
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
// 15. FLOATING GEOMETRY PARTICLES
// ============================================================================
class _FloatingGeometry extends StatefulWidget {
  final int count;
  final List<Color> colors;
  final double speed;

  const _FloatingGeometry({
    required this.count,
    required this.colors,
    this.speed = 0.3,
  });

  @override
  State<_FloatingGeometry> createState() => _FloatingGeometryState();
}

class _FloatingGeometryState extends State<_FloatingGeometry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ParticleItem> _items = [];
  final math.Random _rnd = math.Random(77);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (10000 / widget.speed).round()),
    )..repeat();

    for (int i = 0; i < widget.count; i++) {
      _items.add(_ParticleItem(
        x: _rnd.nextDouble(),
        y: _rnd.nextDouble(),
        speed: 0.5 + _rnd.nextDouble() * 0.5,
        radius: 1.5 + _rnd.nextDouble() * 2.0,
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
            painter: _ParticlePainter(
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

class _ParticleItem {
  final double x;
  final double y;
  final double speed;
  final double radius;
  final Color color;

  _ParticleItem({
    required this.x,
    required this.y,
    required this.speed,
    required this.radius,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_ParticleItem> items;
  final double progress;

  _ParticlePainter({required this.items, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final it in items) {
      final curY = ((it.y + it.speed * progress) % 1.0) * size.height;
      final curX = it.x * size.width;
      final paint = Paint()..color = it.color.withValues(alpha: 0.4);
      canvas.drawCircle(Offset(curX, curY), it.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
