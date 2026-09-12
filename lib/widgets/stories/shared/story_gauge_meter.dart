import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Semi-circular retro physical gauge meter for compatibility and affinity scores.
/// Features a smooth arc track, animated fill sweep, tick marks,
/// and tabular percentage numeral display.
class StoryGaugeMeter extends StatelessWidget {
  final double score; // 0.0 to 100.0
  final double size;
  final Color activeColor;
  final Color trackColor;
  final Color textColor;
  final String? title;
  final String? subtitle;
  final Duration duration;

  const StoryGaugeMeter({
    super.key,
    required this.score,
    this.size = 200.0,
    this.activeColor = const Color(0xFFE11D48),
    this.trackColor = const Color(0x1F1E1B4B),
    this.textColor = const Color(0xFF1E1B4B),
    this.title,
    this.subtitle,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size * 0.62,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: (score / 100.0).clamp(0.0, 1.0)),
            duration: duration,
            curve: Curves.easeOutCubic,
            builder: (context, progress, child) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomPaint(
                    size: Size(size, size * 0.62),
                    painter: _RetroGaugePainter(
                      progress: progress,
                      activeColor: activeColor,
                      trackColor: trackColor,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(progress * 100).round()}%',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: size * 0.20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.0,
                            color: textColor,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        if (title != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            title!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: textColor.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
                fontSize: 13,
                height: 1.35,
                color: textColor.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _RetroGaugePainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color trackColor;

  _RetroGaugePainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.085;
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = (size.width - strokeWidth) / 2;

    const startAngle = math.pi;
    const sweepAngle = math.pi;

    // Track Arc
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(arcRect, startAngle, sweepAngle, false, trackPaint);

    // Active Progress Arc
    if (progress > 0.0) {
      final activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        arcRect,
        startAngle,
        sweepAngle * progress.clamp(0.01, 1.0),
        false,
        activePaint,
      );
    }

    // Tick marks along the outer perimeter
    final tickPaint = Paint()
      ..color = trackColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const totalTicks = 11;
    for (int i = 0; i < totalTicks; i++) {
      final angle = startAngle + (sweepAngle / (totalTicks - 1)) * i;
      final outerRadius = radius + strokeWidth * 0.75;
      final innerRadius = radius + strokeWidth * 0.45;

      final p1 = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RetroGaugePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.activeColor != activeColor ||
      oldDelegate.trackColor != trackColor;
}
