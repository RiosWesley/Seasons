import 'package:flutter/material.dart';

/// Monumental editorial statistical numeral with jitter-free count-up animation.
/// Mandates [FontFeature.tabularFigures()] and tabular numeral spacing to prevent
/// horizontal layout shifts during progressive count-up reveals.
class MonumentalCountUp extends StatelessWidget {
  final num targetValue;
  final String? prefix;
  final String? suffix;
  final String? label;
  final String? subtitle;
  final TextStyle? numberStyle;
  final Color? color;
  final double fontSize;
  final Duration duration;
  final Curve curve;
  final bool formatWithGrouping;
  final int decimalPlaces;
  final CrossAxisAlignment crossAxisAlignment;

  const MonumentalCountUp({
    super.key,
    required this.targetValue,
    this.prefix,
    this.suffix,
    this.label,
    this.subtitle,
    this.numberStyle,
    this.color,
    this.fontSize = 56.0,
    this.duration = const Duration(milliseconds: 1100),
    this.curve = Curves.easeOutCubic,
    this.formatWithGrouping = true,
    this.decimalPlaces = 1,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? const Color(0xFF1E1B4B);

    final effectiveNumberStyle = (numberStyle ??
            TextStyle(
              fontFamily: 'serif',
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              height: 1.05,
              color: effectiveColor,
            ))
        .copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: effectiveColor.withValues(alpha: 0.60),
            ),
          ),
          const SizedBox(height: 8),
        ],

        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: targetValue.toDouble()),
          duration: duration,
          curve: curve,
          builder: (context, value, child) {
            final formatted = _format(value);
            return Text(
              '${prefix ?? ''}$formatted${suffix ?? ''}',
              style: effectiveNumberStyle,
              textAlign: crossAxisAlignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : TextAlign.start,
            );
          },
        ),

        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: effectiveColor.withValues(alpha: 0.70),
              height: 1.3,
            ),
            textAlign: crossAxisAlignment == CrossAxisAlignment.center
                ? TextAlign.center
                : TextAlign.start,
          ),
        ],
      ],
    );
  }

  String _format(double val) {
    if (targetValue is int) {
      final intVal = val.round();
      if (!formatWithGrouping) return intVal.toString();
      return intVal.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          );
    }
    return val.toStringAsFixed(decimalPlaces);
  }
}
