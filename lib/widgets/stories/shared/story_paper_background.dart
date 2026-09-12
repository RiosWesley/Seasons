import 'package:flutter/material.dart';

/// Reusable physical paper background canvas.
/// Renders Warm Ivory base, subtle organic lighting gradient,
/// creased paper texture with calibrated opacity, and hairline margins.
class StoryPaperBackground extends StatelessWidget {
  final Color baseColor;
  final Color? accentColor;
  final double textureOpacity;
  final Color? hairlineBorderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final Widget? child;

  const StoryPaperBackground({
    super.key,
    this.baseColor = const Color(0xFFFBF9F5),
    this.accentColor,
    this.textureOpacity = 0.40,
    this.hairlineBorderColor,
    this.borderRadius = 16.0,
    this.margin,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccent = accentColor ?? const Color(0xFFE11D48);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: Warm Ivory / Mode Tint solid plane
          Positioned.fill(
            child: ColoredBox(color: baseColor),
          ),

          // Layer 2: Organic studio radial lighting
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.4,
                  colors: [
                    effectiveAccent.withValues(alpha: 0.09),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Layer 3: Tactile creased paper texture
          Positioned.fill(
            child: Opacity(
              opacity: textureOpacity.clamp(0.0, 1.0),
              child: Image.asset(
                'assets/images/home_paper_texture.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),

          // Layer 4: Hairline internal framing border
          if (hairlineBorderColor != null)
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: hairlineBorderColor!.withValues(alpha: 0.45),
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius > 4 ? borderRadius - 4 : borderRadius),
                  ),
                ),
              ),
            ),

          // Layer 5: Foreground child content
          if (child != null) Positioned.fill(child: child!),
        ],
      ),
    );
  }
}
