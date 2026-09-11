import 'package:flutter/material.dart';
import '../theme/swiss_typography.dart';

/// 60fps count-up micro-animation for statistical counters.
/// Mandates FontFeature.tabularFigures() to eliminate horizontal layout jitter
/// and uses easeOutCubic curve for smooth deceleration.
class CountUpText extends StatelessWidget {
  final num targetValue;
  final String? prefix;
  final String? suffix;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final bool formatWithGrouping;
  final int decimalPlaces;

  const CountUpText({
    super.key,
    required this.targetValue,
    this.prefix,
    this.suffix,
    this.style,
    this.duration = const Duration(milliseconds: 900),
    this.curve = Curves.easeOutCubic,
    this.formatWithGrouping = true,
    this.decimalPlaces = 1,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.headlineMedium ?? SwissTypography.metricMedium;
    final effectiveStyle = (style ?? defaultStyle).copyWith(
      fontFeatures: SwissTypography.tabularFigures,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: targetValue.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        final formattedNumber = _formatNumber(value);
        return Text(
          '${prefix ?? ''}$formattedNumber${suffix ?? ''}',
          style: effectiveStyle,
        );
      },
    );
  }

  String _formatNumber(double val) {
    if (targetValue is int) {
      final intVal = val.round();
      if (!formatWithGrouping) return intVal.toString();
      // Formats with dot grouping: 1.800, 47.382
      return intVal.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }
    return val.toStringAsFixed(decimalPlaces);
  }
}
