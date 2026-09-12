import 'package:flutter/material.dart';

/// Supported types of physical editorial stamps and seals.
enum EditorialStampType {
  waxSeal,
  rubberStamp,
  periodicalMedal,
}

/// Flexible physical stamp widget supporting:
/// - Wax Seal (Casal Mode: crimson/rose embossed seal)
/// - Zine Rubber Stamp (Amigos Mode: angled electric blue squad mark)
/// - Imperial Periodical Medal (Grupo Mode: golden/amethyst broadsheet medal)
class EditorialStamp extends StatelessWidget {
  final EditorialStampType type;
  final double size;
  final String? label;
  final double? rotationAngle;
  final Color? color;
  final VoidCallback? onTap;

  const EditorialStamp({
    super.key,
    required this.type,
    this.size = 72.0,
    this.label,
    this.rotationAngle,
    this.color,
    this.onTap,
  });

  const EditorialStamp.waxSeal({
    super.key,
    this.size = 72.0,
    this.label,
    this.rotationAngle = 0.0,
    this.color,
    this.onTap,
  }) : type = EditorialStampType.waxSeal;

  const EditorialStamp.rubberStamp({
    super.key,
    this.size = 72.0,
    this.label,
    this.rotationAngle = -0.08, // ~ -4.5 degrees
    this.color,
    this.onTap,
  }) : type = EditorialStampType.rubberStamp;

  const EditorialStamp.periodicalMedal({
    super.key,
    this.size = 72.0,
    this.label,
    this.rotationAngle = 0.0,
    this.color,
    this.onTap,
  }) : type = EditorialStampType.periodicalMedal;

  @override
  Widget build(BuildContext context) {
    final angle = rotationAngle ?? (type == EditorialStampType.rubberStamp ? -0.08 : 0.0);

    Widget content;
    switch (type) {
      case EditorialStampType.waxSeal:
        content = _buildWaxSeal();
        break;
      case EditorialStampType.rubberStamp:
        content = _buildRubberStamp();
        break;
      case EditorialStampType.periodicalMedal:
        content = _buildPeriodicalMedal();
        break;
    }

    Widget result = Transform.rotate(
      angle: angle,
      child: content,
    );

    if (onTap != null) {
      result = GestureDetector(
        onTap: onTap,
        child: result,
      );
    }

    return result;
  }

  Widget _buildWaxSeal() {
    final baseColor = color ?? const Color(0xFFE11D48);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Generated asset image
            Image.asset(
              'assets/images/casal_wax_seal.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildFallbackWaxSeal(baseColor),
            ),
            // Semi-transparent overlay ring for physical depth
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
            ),
            if (label != null)
              Center(
                child: Text(
                  label!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackWaxSeal(Color baseColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            baseColor.withValues(alpha: 0.9),
            const Color(0xFF881337),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.favorite_rounded,
          size: size * 0.45,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _buildRubberStamp() {
    final stampColor = color ?? const Color(0xFF2563EB);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: stampColor.withValues(alpha: 0.20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/amigos_zine_stamp.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildFallbackRubberStamp(stampColor),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: stampColor.withValues(alpha: 0.7),
                  width: 2.0,
                ),
              ),
            ),
            if (label != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  color: Colors.white.withValues(alpha: 0.8),
                  child: Text(
                    label!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      color: stampColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackRubberStamp(Color stampColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: stampColor, width: 2.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified_rounded, size: size * 0.35, color: stampColor),
          const SizedBox(height: 2),
          Text(
            'SQUAD',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: stampColor,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodicalMedal() {
    final medalColor = color ?? const Color(0xFF7C3AED);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: medalColor.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/grupo_periodical_seal.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildFallbackPeriodicalMedal(medalColor),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEAB308).withValues(alpha: 0.8), // Gold filigree
                  width: 1.5,
                ),
              ),
            ),
            if (label != null)
              Center(
                child: Text(
                  label!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1B4B),
                    letterSpacing: 0.6,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackPeriodicalMedal(Color medalColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFDE047),
            const Color(0xFFCA8A04),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.military_tech_rounded,
          size: size * 0.5,
          color: const Color(0xFF422006),
        ),
      ),
    );
  }
}
