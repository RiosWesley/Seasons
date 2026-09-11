import 'package:flutter/material.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';

/// Architectural pill badge with subtle border, tinted background, and vector iconography.
/// Strictly prohibits emoji icons in accordance with Swiss-minimalist chrome guidelines.
class MetricBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconColor;
  final EdgeInsetsGeometry padding;
  final bool isAccent;
  final double iconSize;

  const MetricBadge({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.isAccent = false,
    this.iconSize = 13.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveBg = backgroundColor ??
        (isAccent
            ? SwissColors.accentSubdued(isDark)
            : (isDark ? SwissColors.darkSurfaceSubdued : SwissColors.lightSurfaceSubdued));

    final effectiveBorder = borderColor ??
        (isAccent
            ? SwissColors.emeraldPrimary.withValues(alpha: 0.35)
            : (isDark ? SwissColors.darkBorder : SwissColors.lightBorder));

    final effectiveText = textColor ??
        (isAccent
            ? SwissColors.emeraldPrimary
            : (isDark ? SwissColors.darkTextPrimary : SwissColors.lightTextPrimary));

    final effectiveIconColor = iconColor ?? effectiveText;

    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: effectiveBg,
        shape: SquircleBorder.radius(
          SquircleBorder.badgeRadius,
          side: BorderSide(color: effectiveBorder, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize,
              color: effectiveIconColor,
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: SwissTypography.labelSmall.copyWith(
              color: effectiveText,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
