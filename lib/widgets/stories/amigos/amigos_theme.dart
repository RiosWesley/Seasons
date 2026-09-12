import 'package:flutter/material.dart';

/// Design tokens and visual primitives for Amigos Mode (Indie Zine & Squad Aesthetic).
class AmigosTheme {
  AmigosTheme._();

  static const Color paperBase = Color(0xFFF4F8FD); // Kraft Ivory azulado
  static const Color inkPrimary = Color(0xFF0F172A); // Deep navy ink
  static const Color inkSecondary = Color(0xFF334155); // Slate ink
  static const Color accentPrimary = Color(0xFF2563EB); // Electric Royal Blue
  static const Color accentSecondary = Color(0xFF38BDF8); // Vivid Sky Blue
  static const Color cardSurface = Color(0xFFEFF6FF); // Papel zine ice blue
  static const Color hairlineBorder = Color(0xFFBFDBFE); // Cobalt hairline
  static const Color stickerPop = Color(0xFFFACC15); // Amarelo fita adesiva
  static const Color dangerRed = Color(0xFFDC2626); // Vermelho carimbo / alerta

  static const List<BoxShadow> risoShadow = [
    BoxShadow(
      color: Color(0x240F172A),
      offset: Offset(3, 3),
      blurRadius: 0,
    ),
  ];

  static const List<BoxShadow> risoShadowLight = [
    BoxShadow(
      color: Color(0x180F172A),
      offset: Offset(2, 2),
      blurRadius: 0,
    ),
  ];

  static BoxDecoration cardDecoration({
    Color? color,
    Color? borderColor,
    double radius = 16.0,
    bool withShadow = true,
  }) {
    return BoxDecoration(
      color: color ?? cardSurface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? hairlineBorder,
        width: 1.5,
      ),
      boxShadow: withShadow ? risoShadowLight : null,
    );
  }
}

/// Decorative diagonal hazard / tape banner
class HazardTapeBanner extends StatelessWidget {
  final String text;
  final double angle;
  final Color backgroundColor;
  final Color textColor;

  const HazardTapeBanner({
    super.key,
    required this.text,
    this.angle = -0.04,
    this.backgroundColor = AmigosTheme.stickerPop,
    this.textColor = AmigosTheme.inkPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2A000000),
              offset: Offset(1, 2),
              blurRadius: 2,
            ),
          ],
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

/// Decorative barcode widget for zines and tour posters
class ZineBarcode extends StatelessWidget {
  final String code;
  final double height;
  final Color color;

  const ZineBarcode({
    super.key,
    this.code = 'SQD-2025-ARCHIVE-916',
    this.height = 32.0,
    this.color = AmigosTheme.inkPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(160, height),
          painter: _BarcodePainter(color),
        ),
        const SizedBox(height: 3),
        Text(
          code,
          style: TextStyle(
            color: color.withValues(alpha: 0.6),
            fontSize: 8,
            fontFamily: 'monospace',
            letterSpacing: 2.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _BarcodePainter extends CustomPainter {
  final Color color;

  _BarcodePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.square;

    const pattern = [2, 1, 3, 1, 1, 2, 4, 1, 2, 3, 1, 1, 3, 2, 1, 4, 2, 1, 2, 1, 3, 1, 2];
    double totalUnits = 0;
    for (final p in pattern) {
      totalUnits += p;
    }

    final unitWidth = size.width / (totalUnits * 1.5);
    double x = 0;
    bool isBar = true;

    for (final p in pattern) {
      final w = p * unitWidth;
      if (isBar) {
        paint.strokeWidth = w;
        canvas.drawLine(Offset(x + w / 2, 0), Offset(x + w / 2, size.height), paint);
      }
      x += w * 1.3;
      isBar = !isBar;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
