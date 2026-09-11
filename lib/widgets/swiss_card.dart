import 'package:flutter/material.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';

/// Clean architectural squircle card with zero elevation, continuous G2 curvature (radius 24.0),
/// subtle structural borders, optional highlight state, and tactile press scaling.
class SwissCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool highlight;
  final double? width;
  final double? height;

  const SwissCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = SquircleBorder.cardRadius,
    this.highlight = false,
    this.width,
    this.height,
  });

  @override
  State<SwissCard> createState() => _SwissCardState();
}

class _SwissCardState extends State<SwissCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveBg = widget.backgroundColor ??
        (isDark ? SwissColors.darkSurfaceCard : SwissColors.lightSurfaceCard);

    final effectiveBorderColor = widget.borderColor ??
        (widget.highlight
            ? SwissColors.emeraldPrimary
            : (isDark ? SwissColors.darkBorder : SwissColors.lightBorder));

    final effectiveBorderWidth = widget.highlight ? 1.5 : 1.0;

    final cardContent = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: ShapeDecoration(
        color: effectiveBg,
        shape: SquircleBorder.radius(
          widget.borderRadius,
          side: BorderSide(color: effectiveBorderColor, width: effectiveBorderWidth),
        ),
      ),
      child: widget.child,
    );

    if (widget.onTap == null) {
      return cardContent;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: cardContent,
      ),
    );
  }
}
