import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';

/// Reusable editorial Bento Card for displaying retrospective modes (Casal, Amigos, Grupo).
class ModelBentoCard extends StatelessWidget {
  final String title;
  final String eyebrow;
  final String participantHint;
  final IconData icon;
  final IconData microBadgeIcon;
  final String microBadgeLabel;
  final String description;
  final List<String> featureTags;
  final Color accentColor;
  final List<Color> bgLightGradient;
  final List<Color> bgDarkGradient;
  final Color borderLight;
  final Color borderDark;
  final Color avatarBgLight;
  final Color avatarBgDark;
  final CustomPainter doodlePainter;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isRecommended;
  final bool showRadio;

  const ModelBentoCard({
    super.key,
    required this.title,
    required this.eyebrow,
    required this.participantHint,
    required this.icon,
    required this.microBadgeIcon,
    required this.microBadgeLabel,
    required this.description,
    this.featureTags = const [],
    required this.accentColor,
    required this.bgLightGradient,
    required this.bgDarkGradient,
    required this.borderLight,
    required this.borderDark,
    required this.avatarBgLight,
    required this.avatarBgDark,
    required this.doodlePainter,
    this.onTap,
    this.isSelected = false,
    this.isRecommended = false,
    this.showRadio = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? bgDarkGradient : bgLightGradient,
        ),
        shadows: isSelected
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: isDark ? 0.32 : 0.20),
                  blurRadius: 22,
                  offset: const Offset(0, 6),
                  spreadRadius: -2,
                ),
              ]
            : [
                BoxShadow(
                  color: isDark ? Colors.black26 : const Color(0x060F172A),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
        shape: SquircleBorder.radius(
          22,
          side: BorderSide(
            color: isSelected ? accentColor : (isDark ? borderDark : borderLight),
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
              painter: doodlePainter,
            ),
          ),

          // Foreground content
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar squircle + Eyebrow/Title + (Radio or Badge)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar Squircle
                    Container(
                      width: 44,
                      height: 44,
                      decoration: ShapeDecoration(
                        color: isDark ? avatarBgDark : avatarBgLight,
                        shape: SquircleBorder.radius(
                          14,
                          side: BorderSide(
                            color: accentColor.withValues(alpha: 0.35),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 22,
                          color: accentColor,
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
                            eyebrow,
                            style: TextStyle(
                              fontSize: 9.5,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w800,
                              color: accentColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                title,
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
                                  participantHint,
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

                    if (showRadio) ...[
                      const SizedBox(width: 8),
                      // Stylized Radio Indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? accentColor : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? accentColor
                                : (isDark
                                    ? SwissColors.darkBorderStrong
                                    : SwissColors.lightBorderStrong),
                            width: 2.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: accentColor.withValues(alpha: 0.40),
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
                      color: accentColor.withValues(alpha: 0.12),
                      shape: SquircleBorder.radius(
                        10,
                        side: BorderSide(
                          color: accentColor.withValues(alpha: 0.40),
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
                          color: accentColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Recomendado',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            color: accentColor,
                          ),
                        ),
                        Text(
                          ' para esta conversa',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                            color: accentColor.withValues(alpha: 0.85),
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
                        color: accentColor.withValues(alpha: 0.25),
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        microBadgeIcon,
                        size: 11.5,
                        color: accentColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        microBadgeLabel,
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
                  description,
                  style: SwissTypography.bodyMedium.copyWith(
                    fontSize: 13,
                    height: 1.45,
                    color: isDark
                        ? SwissColors.darkTextSecondary
                        : SwissColors.lightTextSecondary,
                  ),
                ),

                // Feature Tags / Preview Chips
                if (featureTags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: featureTags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3.5,
                        ),
                        decoration: ShapeDecoration(
                          color: isDark
                              ? accentColor.withValues(alpha: 0.14)
                              : accentColor.withValues(alpha: 0.08),
                          shape: SquircleBorder.radius(
                            8,
                            side: BorderSide(
                              color: accentColor.withValues(
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
                                color: accentColor.withValues(alpha: 0.85),
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
                                    : accentColor.withValues(alpha: 0.95),
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
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap!();
        },
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Custom painter that draws a subtle tilted heart doodle on the Casal Bento card
class HeartDoodlePainter extends CustomPainter {
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
class AmigosDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
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
class GrupoDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final arcPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width * 0.90, size.height * 0.76);
    canvas.drawCircle(center, 22, arcPaint);
    canvas.drawCircle(center, 44, arcPaint);

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
