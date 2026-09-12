import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Dynamic, textured, and animated background engine for Casal Mode Stories.
/// Implements bespoke Spotify Wrapped-level visual diversity across all 18 slides:
/// - Dark romantic velvet & twilight skies for moody chapters
/// - Warm champagne, kraft, and letterpress textures for memory chapters
/// - High-performance 60fps physics animations (heartbeats, soundwaves, drifting stars, bokeh, confetti)
class CasalBackgroundVariants {
  CasalBackgroundVariants._();

  /// Slide c1: Capa — Luxury Wine Velvet Paper with Floating Golden Stardust
  static Widget c1Cover() {
    return _TexturedDarkCanvas(
      imageAsset: 'assets/images/casal_bg_wine_velvet.jpg',
      fallbackGradient: const [Color(0xFF2E0814), Color(0xFF4A0E2E), Color(0xFF1B050B)],
      vignetteOpacity: 0.45,
      overlay: const _FloatingParticles(
        count: 16,
        color: Color(0xFFFFD166),
        speed: 0.35,
        minRadius: 1.0,
        maxRadius: 2.5,
      ),
    );
  }

  /// Slide c2: Total de Mensagens — Animated Champagne Cream Kinetic Glow
  static Widget c2Total() {
    return const _KineticAuraBackground(
      primaryColor: Color(0xFFFFF1F2),
      secondaryColor: Color(0xFFFFE4E6),
      accentColor: Color(0xFFFB7185),
      particleType: _ParticleShape.heartsAndCircles,
    );
  }

  /// Slide c3: Love Language — 4-Quadrant Soft Watercolor Mesh
  static Widget c3LoveLanguage() {
    return const _WatercolorQuadrantBackground();
  }

  /// Slide c4: Compatibilidade — Animated Concentric Heartbeat Rings
  static Widget c4Compatibility() {
    return const _HeartbeatPulseBackground();
  }

  /// Slide c5: Linha do Tempo — Twilight Dusk Sky with Drifting Stars
  static Widget c5Timeline() {
    return const _TexturedDarkCanvas(
      fallbackGradient: [Color(0xFF150B24), Color(0xFF380E2B), Color(0xFF1B0715)],
      vignetteOpacity: 0.3,
      overlay: _FloatingParticles(
        count: 24,
        color: Color(0xFFFDE047),
        speed: 0.25,
        minRadius: 1.0,
        maxRadius: 2.2,
      ),
    );
  }

  /// Slide c6: Top Palavras — Vintage Letterpress Cotton Paper
  static Widget c6TopWords() {
    return _TexturedLightCanvas(
      imageAsset: 'assets/images/casal_bg_vintage_letterpress.jpg',
      baseColor: const Color(0xFFF8F5EE),
      overlay: const _WatermarkGlyphsOverlay(),
    );
  }

  /// Slide c7: Heatmap — "A Nossa Hora" Deep Midnight with Glowing Amber Hearth
  static Widget c7Heatmap() {
    return const _MidnightGlowBackground();
  }

  /// Slide c8: Evolução de Emojis — Dreamy Radial Rose Bokeh
  static Widget c8EmojiEvolution() {
    return const _BokehRoseBackground();
  }

  /// Slide c9: Momentos Especiais — Vintage Scrapbook Kraft Album
  static Widget c9SpecialMoments() {
    return const _TexturedLightCanvas(
      imageAsset: 'assets/images/casal_bg_scrapbook_kraft.jpg',
      baseColor: Color(0xFFEADBCE),
      textureOpacity: 0.90,
    );
  }

  /// Slide c10: Comparativo de Hábitos — Animated Split Duotone Wave
  static Widget c10Habits() {
    return const _AnimatedDuotoneWaveBackground();
  }

  /// Slide c11: Estatísticas Diárias — Architectural Millimeter Grid
  static Widget c11DailyStats() {
    return const _MillimeterGridBackground();
  }

  /// Slide c12: Insight de Afeto — Deep Velvet Aubergine with Stardust
  static Widget c12Insight() {
    return const _TexturedDarkCanvas(
      fallbackGradient: [Color(0xFF1F0D22), Color(0xFF381042), Color(0xFF140818)],
      vignetteOpacity: 0.4,
      overlay: _FloatingParticles(
        count: 18,
        color: Color(0xFFFBCFE8),
        speed: 0.3,
        minRadius: 1.2,
        maxRadius: 2.8,
      ),
    );
  }

  /// Slide c13: Interações Ocultas — Pink Crumpled Love Note Paper
  static Widget c13HiddenInteractions() {
    return const _CrumpledNoteBackground();
  }

  /// Slide c14: Áudios — Retro Vinyl Groove Soundwave Ripples
  static Widget c14Audios() {
    return const _VinylSoundwaveBackground();
  }

  /// Slide c15: Prints Arquivados — Vintage Darkroom Film Grain
  static Widget c15Prints() {
    return const _FilmGrainDarkroomBackground();
  }

  /// Slide c16: Encaminhamentos — Vintage Airmail Envelope Border
  static Widget c16Forwarded() {
    return const _AirmailEnvelopeBackground();
  }

  /// Slide c17: Digitou mas não enviou — Moody Smoked Crimson & Typing Glow
  static Widget c17TypedUnsend() {
    return const _TypingGlowDarkBackground();
  }

  /// Slide c18: Passaporte do Casal / Final — Official Gold-Embossed Parchment & Confetti
  static Widget c18Passport() {
    return _TexturedLightCanvas(
      imageAsset: 'assets/images/casal_bg_passport_parchment.jpg',
      baseColor: const Color(0xFFF9F5EA),
      textureOpacity: 0.92,
      overlay: const _CelebratoryConfettiOverlay(),
    );
  }
}

// ============================================================================
// REUSABLE CANVASES & ANIMATED SHADERS
// ============================================================================

/// Dark textured background canvas with image asset or fallback gradient + vignette
class _TexturedDarkCanvas extends StatelessWidget {
  final String? imageAsset;
  final List<Color> fallbackGradient;
  final double vignetteOpacity;
  final Widget? overlay;

  const _TexturedDarkCanvas({
    this.imageAsset,
    required this.fallbackGradient,
    this.vignetteOpacity = 0.35,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: fallbackGradient,
            ),
          ),
        ),

        // Optional texture image
        if (imageAsset != null)
          Opacity(
            opacity: 0.85,
            child: Image.asset(
              imageAsset!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),

        // Deep vignette
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

        // Decorative overlay
        if (overlay != null) Positioned.fill(child: overlay!),
      ],
    );
  }
}

/// Light textured canvas for vintage papers & parchments
class _TexturedLightCanvas extends StatelessWidget {
  final String imageAsset;
  final Color baseColor;
  final double textureOpacity;
  final Widget? overlay;

  const _TexturedLightCanvas({
    required this.imageAsset,
    this.baseColor = const Color(0xFFFBF9F5),
    this.textureOpacity = 0.75,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: baseColor),
        Opacity(
          opacity: textureOpacity,
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ),
        if (overlay != null) Positioned.fill(child: overlay!),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// ANIMATED PARTICLES & AURAS
// ----------------------------------------------------------------------------

enum _ParticleShape { heartsAndCircles }

class _FloatingParticles extends StatefulWidget {
  final int count;
  final Color color;
  final double speed;
  final double minRadius;
  final double maxRadius;

  const _FloatingParticles({
    required this.count,
    required this.color,
    this.speed = 0.5,
    this.minRadius = 1.0,
    this.maxRadius = 3.0,
  });

  @override
  State<_FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<_FloatingParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_ParticleData> _particles;

  @override
  void initState() {
    super.initState();
    final random = math.Random(42);
    _particles = List.generate(widget.count, (i) {
      return _ParticleData(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: widget.minRadius + random.nextDouble() * (widget.maxRadius - widget.minRadius),
        opacity: 0.2 + random.nextDouble() * 0.6,
        speedX: (random.nextDouble() - 0.5) * 0.08 * widget.speed,
        speedY: (0.05 + random.nextDouble() * 0.12) * widget.speed,
      );
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _ParticlesPainter(
            particles: _particles,
            progress: _controller.value,
            baseColor: widget.color,
          ),
        );
      },
    );
  }
}

class _ParticleData {
  double x;
  double y;
  final double radius;
  final double opacity;
  final double speedX;
  final double speedY;

  _ParticleData({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
    required this.speedX,
    required this.speedY,
  });
}

class _ParticlesPainter extends CustomPainter {
  final List<_ParticleData> particles;
  final double progress;
  final Color baseColor;

  _ParticlesPainter({
    required this.particles,
    required this.progress,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final currentY = (p.y - progress * p.speedY * 5) % 1.0;
      final currentX = (p.x + math.sin(progress * 2 * math.pi + p.y * 10) * 0.02) % 1.0;

      final dx = currentX * size.width;
      final dy = currentY * size.height;

      paint.color = baseColor.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(dx, dy), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) => true;
}

// ----------------------------------------------------------------------------
// SLIDE-SPECIFIC ANIMATED BACKGROUND WIDGETS
// ----------------------------------------------------------------------------

/// Slide c2: Champagne Cream Kinetic Glow with floating subtle hearts
class _KineticAuraBackground extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final _ParticleShape particleType;

  const _KineticAuraBackground({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.particleType,
  });

  @override
  State<_KineticAuraBackground> createState() => _KineticAuraBackgroundState();
}

class _KineticAuraBackgroundState extends State<_KineticAuraBackground>
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.primaryColor,
                    widget.secondaryColor,
                  ],
                ),
              ),
            ),
            // Floating champagne aura
            Positioned(
              top: 80 + 30 * math.sin(t * math.pi),
              left: -40 + 20 * math.cos(t * math.pi),
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.accentColor.withValues(alpha: 0.12),
                ),
              ),
            ),
            // Tactile paper grain
            Opacity(
              opacity: 0.35,
              child: Image.asset(
                'assets/images/home_paper_texture.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Slide c3: 4-Quadrant Watercolor Breathing Mesh
class _WatercolorQuadrantBackground extends StatefulWidget {
  const _WatercolorQuadrantBackground();

  @override
  State<_WatercolorQuadrantBackground> createState() => _WatercolorQuadrantBackgroundState();
}

class _WatercolorQuadrantBackgroundState extends State<_WatercolorQuadrantBackground>
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xFFFFF9F9)),
            // Quadrant 1: Rose Quartz (Top-Left)
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF43F5E).withValues(alpha: 0.08 + 0.04 * t),
                ),
              ),
            ),
            // Quadrant 2: Warm Amber (Top-Right)
            Positioned(
              top: -40,
              right: -50,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.07 + 0.03 * (1 - t)),
                ),
              ),
            ),
            // Quadrant 3: Peony Violet (Bottom-Left)
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.06 + 0.03 * (1 - t)),
                ),
              ),
            ),
            // Quadrant 4: Coral Pink (Bottom-Right)
            Positioned(
              bottom: -60,
              right: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFB7185).withValues(alpha: 0.08 + 0.03 * t),
                ),
              ),
            ),
            // Paper grain
            Opacity(
              opacity: 0.40,
              child: Image.asset(
                'assets/images/home_paper_texture.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Slide c4: Heartbeat Pulse Rings behind Compatibility Gauge
class _HeartbeatPulseBackground extends StatefulWidget {
  const _HeartbeatPulseBackground();

  @override
  State<_HeartbeatPulseBackground> createState() => _HeartbeatPulseBackgroundState();
}

class _HeartbeatPulseBackgroundState extends State<_HeartbeatPulseBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final val = _controller.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xFFFFF6F7)),
            // Concentric expanding ring 1
            Center(
              child: Container(
                width: 140 + 120 * val,
                height: 140 + 120 * val,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE11D48).withValues(alpha: (1.0 - val) * 0.35),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Concentric expanding ring 2
            Center(
              child: Container(
                width: 100 + 100 * ((val + 0.4) % 1.0),
                height: 100 + 100 * ((val + 0.4) % 1.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFB7185).withValues(alpha: (1.0 - ((val + 0.4) % 1.0)) * 0.25),
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: 0.38,
              child: Image.asset(
                'assets/images/home_paper_texture.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Slide c7: Midnight Glow with Warm Romantic Hearth Lamp
class _MidnightGlowBackground extends StatefulWidget {
  const _MidnightGlowBackground();

  @override
  State<_MidnightGlowBackground> createState() => _MidnightGlowBackgroundState();
}

class _MidnightGlowBackgroundState extends State<_MidnightGlowBackground>
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF090D1E),
                    Color(0xFF160A24),
                    Color(0xFF0F0717),
                  ],
                ),
              ),
            ),
            // Warm glowing hearth lamp in the upper half
            Center(
              child: Transform.translate(
                offset: const Offset(0, -60),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFF59E0B).withValues(alpha: 0.22 + 0.08 * t),
                        const Color(0xFFE11D48).withValues(alpha: 0.12 + 0.05 * t),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Slide c8: Dreamy Rose Bokeh
class _BokehRoseBackground extends StatelessWidget {
  const _BokehRoseBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF0F3),
                Color(0xFFFFE4E8),
                Color(0xFFFFF5F7),
              ],
            ),
          ),
        ),
        // Bokeh orbs
        Positioned(
          top: 60,
          left: 30,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFB7185).withValues(alpha: 0.14),
            ),
          ),
        ),
        Positioned(
          top: 220,
          right: 20,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFDA4AF).withValues(alpha: 0.18),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: 40,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFECDD3).withValues(alpha: 0.20),
            ),
          ),
        ),
        Opacity(
          opacity: 0.35,
          child: Image.asset(
            'assets/images/home_paper_texture.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

/// Slide c10: Animated Duotone Wave (Partner 1 vs Partner 2 balance)
class _AnimatedDuotoneWaveBackground extends StatefulWidget {
  const _AnimatedDuotoneWaveBackground();

  @override
  State<_AnimatedDuotoneWaveBackground> createState() => _AnimatedDuotoneWaveBackgroundState();
}

class _AnimatedDuotoneWaveBackgroundState extends State<_AnimatedDuotoneWaveBackground>
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _DuotoneWavePainter(progress: _controller.value),
          child: Opacity(
            opacity: 0.32,
            child: Image.asset(
              'assets/images/home_paper_texture.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}

class _DuotoneWavePainter extends CustomPainter {
  final double progress;

  _DuotoneWavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Partner 1: Warm blush ivory
    final paint1 = Paint()..color = const Color(0xFFFFF1F2);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint1);

    // Partner 2: Peony rose wave from bottom
    final paint2 = Paint()..color = const Color(0xFFFFE4E6);
    final path = Path();

    final midY = size.height * 0.52;
    path.moveTo(0, midY);

    for (double x = 0; x <= size.width; x += 10) {
      final y = midY + 18 * math.sin((x / size.width * 2 * math.pi) + (progress * 2 * math.pi));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint2);
  }

  @override
  bool shouldRepaint(covariant _DuotoneWavePainter oldDelegate) => true;
}

/// Slide c11: Millimeter / Pauta Fina Note Paper Grid
class _MillimeterGridBackground extends StatelessWidget {
  const _MillimeterGridBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFFBF8F3)),
        CustomPaint(
          painter: _GridLinesPainter(),
        ),
        Opacity(
          opacity: 0.30,
          child: Image.asset(
            'assets/images/home_paper_texture.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _GridLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2D9C8).withValues(alpha: 0.45)
      ..strokeWidth = 0.5;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Slide c13: Crumpled Love Note Paper
class _CrumpledNoteBackground extends StatelessWidget {
  const _CrumpledNoteBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFFFF0F5)),
        Opacity(
          opacity: 0.70,
          child: Image.asset(
            'assets/images/home_paper_texture.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

/// Slide c14: Vinyl Soundwave Ripples (Expanding Concentric Circles)
class _VinylSoundwaveBackground extends StatefulWidget {
  const _VinylSoundwaveBackground();

  @override
  State<_VinylSoundwaveBackground> createState() => _VinylSoundwaveBackgroundState();
}

class _VinylSoundwaveBackgroundState extends State<_VinylSoundwaveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF190610),
                    Color(0xFF2C0A1E),
                    Color(0xFF14040D),
                  ],
                ),
              ),
            ),
            // Concentric vinyl grooves
            Center(
              child: CustomPaint(
                size: const Size(360, 360),
                painter: _VinylGroovesPainter(progress: t),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _VinylGroovesPainter extends CustomPainter {
  final double progress;

  _VinylGroovesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 4; i++) {
      final waveProgress = (progress + i * 0.25) % 1.0;
      final radius = 60 + waveProgress * 140;
      final alpha = (1.0 - waveProgress) * 0.45;

      paint.color = const Color(0xFFFB7185).withValues(alpha: alpha);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _VinylGroovesPainter oldDelegate) => true;
}

/// Slide c15: Darkroom Film Grain Wash
class _FilmGrainDarkroomBackground extends StatelessWidget {
  const _FilmGrainDarkroomBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1C1318),
                Color(0xFF2B1C25),
                Color(0xFF140D11),
              ],
            ),
          ),
        ),
        // Center photo exposure spotlight
        Center(
          child: Container(
            width: 280,
            height: 380,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFB7185).withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Slide c16: Airmail Envelope Border with Diagonal Chevrons
class _AirmailEnvelopeBackground extends StatelessWidget {
  const _AirmailEnvelopeBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFFBF8F2)),
        // Top and bottom airmail candy stripes
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 10,
          child: CustomPaint(painter: _AirmailStripePainter()),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 10,
          child: CustomPaint(painter: _AirmailStripePainter()),
        ),
        Opacity(
          opacity: 0.40,
          child: Image.asset(
            'assets/images/home_paper_texture.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _AirmailStripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bluePaint = Paint()..color = const Color(0xFF2563EB);
    final redPaint = Paint()..color = const Color(0xFFE11D48);

    const stripeWidth = 14.0;
    int index = 0;
    for (double x = 0; x < size.width; x += stripeWidth) {
      final paint = (index % 2 == 0) ? redPaint : bluePaint;
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + stripeWidth * 0.8, 0)
        ..lineTo(x + stripeWidth * 0.4, size.height)
        ..lineTo(x - stripeWidth * 0.4, size.height)
        ..close();
      canvas.drawPath(path, paint);
      index++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Slide c17: Typing Ellipsis Dark Glow ("...")
class _TypingGlowDarkBackground extends StatefulWidget {
  const _TypingGlowDarkBackground();

  @override
  State<_TypingGlowDarkBackground> createState() => _TypingGlowDarkBackgroundState();
}

class _TypingGlowDarkBackgroundState extends State<_TypingGlowDarkBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF14070F),
                    Color(0xFF230C1C),
                    Color(0xFF0F040C),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFB7185).withValues(alpha: 0.16 + 0.08 * math.sin(t * 2 * math.pi)),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Overlay for Slide c6: Watermark typography
class _WatermarkGlyphsOverlay extends StatelessWidget {
  const _WatermarkGlyphsOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Opacity(
          opacity: 0.04,
          child: Text(
            'LOVE',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 160,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -10,
            ),
          ),
        ),
      ),
    );
  }
}

/// Overlay for Slide c18: Celebratory Gold Confetti
class _CelebratoryConfettiOverlay extends StatefulWidget {
  const _CelebratoryConfettiOverlay();

  @override
  State<_CelebratoryConfettiOverlay> createState() => _CelebratoryConfettiOverlayState();
}

class _CelebratoryConfettiOverlayState extends State<_CelebratoryConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_ConfettiPiece> _pieces;

  @override
  void initState() {
    super.initState();
    final random = math.Random(19);
    _pieces = List.generate(28, (i) {
      return _ConfettiPiece(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 3 + random.nextDouble() * 5,
        color: [
          const Color(0xFFD97706),
          const Color(0xFFE11D48),
          const Color(0xFFF59E0B),
          const Color(0xFFFB7185),
        ][i % 4],
        rotationSpeed: (random.nextDouble() - 0.5) * 4,
        fallSpeed: 0.08 + random.nextDouble() * 0.14,
      );
    });

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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _ConfettiPainter(
            pieces: _pieces,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _ConfettiPiece {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double rotationSpeed;
  final double fallSpeed;

  _ConfettiPiece({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.rotationSpeed,
    required this.fallSpeed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double progress;

  _ConfettiPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      final currentY = (p.y + progress * p.fallSpeed * 5) % 1.0;
      final currentX = (p.x + math.sin(progress * 2 * math.pi + p.y * 6) * 0.02) % 1.0;

      final dx = currentX * size.width;
      final dy = currentY * size.height;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(progress * p.rotationSpeed * math.pi);

      final paint = Paint()
        ..color = p.color.withValues(alpha: 0.75)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
