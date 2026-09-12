import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';

enum SwissButtonType {
  primary,
  secondary,
  outline,
  ghost,
  danger,
}

/// Swiss-minimalist button with tactile 0.97 scale feedback on press,
/// continuous squircle geometry (radius 16.0), loading states, and vector icons.
class SwissButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final SwissButtonType type;
  final bool isLoading;
  final bool fullWidth;
  final EdgeInsetsGeometry padding;
  final double scaleDownFactor;
  final Duration animationDuration;
  final Color? customBackgroundColor;
  final Gradient? customGradient;

  const SwissButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.type = SwissButtonType.primary,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.scaleDownFactor = 0.97,
    this.animationDuration = const Duration(milliseconds: 110),
    this.customBackgroundColor,
    this.customGradient,
  });

  @override
  State<SwissButton> createState() => _SwissButtonState();
}

class _SwissButtonState extends State<SwissButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color? backgroundColor;
    Gradient? backgroundGradient;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;
    List<BoxShadow>? shadows;

    switch (widget.type) {
      case SwissButtonType.primary:
        if (_isEnabled) {
          if (widget.customGradient != null) {
            backgroundGradient = widget.customGradient;
            backgroundColor = null;
          } else {
            backgroundColor = widget.customBackgroundColor ??
                (isDark ? const Color(0xFF2563EB) : const Color(0xFF0F172A));
          }
          foregroundColor = Colors.white;
          borderSide = BorderSide(
            color: widget.customBackgroundColor != null
                ? Colors.white.withValues(alpha: 0.18)
                : (isDark ? const Color(0x4060A5FA) : const Color(0x20000000)),
            width: 1.0,
          );
          final activeGlowColor = widget.customBackgroundColor ??
              (isDark ? const Color(0xFF2563EB) : const Color(0xFF0F172A));
          shadows = [
            BoxShadow(
              color: activeGlowColor.withValues(alpha: isDark ? 0.35 : 0.22),
              blurRadius: 14,
              offset: const Offset(0, 4),
              spreadRadius: -1,
            ),
          ];
        } else {
          backgroundColor = isDark
              ? SwissColors.darkSurfaceSubdued
              : SwissColors.lightSurfaceSubdued;
          foregroundColor = isDark
              ? SwissColors.darkTextMuted
              : SwissColors.lightTextMuted;
        }
        break;

      case SwissButtonType.secondary:
        backgroundColor = isDark
            ? SwissColors.darkSurfaceCard
            : SwissColors.lightSurfaceCard;
        foregroundColor = isDark
            ? SwissColors.darkTextPrimary
            : SwissColors.lightTextPrimary;
        borderSide = BorderSide(
          color: isDark ? SwissColors.darkBorder : SwissColors.lightBorder,
          width: 1.0,
        );
        break;

      case SwissButtonType.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark
            ? SwissColors.darkTextPrimary
            : SwissColors.lightTextPrimary;
        borderSide = BorderSide(
          color: isDark ? SwissColors.darkBorderStrong : SwissColors.lightBorderStrong,
          width: 1.0,
        );
        break;

      case SwissButtonType.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark
            ? SwissColors.darkTextSecondary
            : SwissColors.lightTextSecondary;
        break;

      case SwissButtonType.danger:
        backgroundColor = SwissColors.danger.withValues(alpha: 0.15);
        foregroundColor = SwissColors.danger;
        borderSide = const BorderSide(
          color: SwissColors.danger,
          width: 1.0,
        );
        break;
    }

    final buttonContent = Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: foregroundColor,
            ),
          ),
          const SizedBox(width: 10),
        ] else if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: 18,
            color: foregroundColor,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: SwissTypography.labelLarge.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _isEnabled
          ? (_) {
              HapticFeedback.selectionClick();
              setState(() => _isPressed = true);
            }
          : null,
      onTapUp: _isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: _isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: _isEnabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleDownFactor : 1.0,
        duration: widget.animationDuration,
        curve: Curves.easeOutCubic,
        child: Container(
          padding: widget.padding,
          decoration: ShapeDecoration(
            color: backgroundColor,
            gradient: backgroundGradient,
            shadows: shadows,
            shape: SquircleBorder.button(side: borderSide),
          ),
          child: widget.fullWidth
              ? Center(child: buttonContent)
              : buttonContent,
        ),
      ),
    );
  }
}
