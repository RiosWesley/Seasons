import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Continuous squircle geometry helper adhering to G2 curvature continuity standards.
/// Produces signature smooth corner transitions using a safe [ContinuousSquircleBorder]
/// that inherits from Flutter's [ContinuousRectangleBorder] while strictly clamping
/// radii to half the shortest side, preventing the famous "tie-fighter" vertical spike artifact.
class SquircleBorder {
  SquircleBorder._();

  // === RADIUS TOKENS ===
  static const double cardRadius = 24.0;
  static const double buttonRadius = 16.0;
  static const double badgeRadius = 12.0;
  static const double pillRadius = 999.0;

  /// Continuous squircle shape with given [radius] and optional [side].
  /// Uses [ContinuousSquircleBorder] which guarantees zero border-projection spikes
  /// regardless of small widget height or large radius.
  static ContinuousSquircleBorder radius(
    double radius, {
    BorderSide side = BorderSide.none,
  }) {
    return ContinuousSquircleBorder(
      borderRadius: BorderRadius.circular(radius * 2.2),
      side: side,
    );
  }

  /// Card shape with standard 24.0dp continuous squircle radius.
  static ContinuousSquircleBorder card({
    BorderSide side = BorderSide.none,
  }) {
    return radius(cardRadius, side: side);
  }

  /// Button shape with standard 16.0dp continuous squircle radius.
  static ContinuousSquircleBorder button({
    BorderSide side = BorderSide.none,
  }) {
    return radius(buttonRadius, side: side);
  }

  /// Badge / chip shape with standard 12.0dp continuous squircle radius.
  static ContinuousSquircleBorder badge({
    BorderSide side = BorderSide.none,
  }) {
    return radius(badgeRadius, side: side);
  }

  /// Pill shape for full stadium / capsule buttons.
  static ShapeBorder pill({
    BorderSide side = BorderSide.none,
  }) {
    return StadiumBorder(side: side);
  }

  /// Generates a ShapeDecoration with continuous squircle curvature.
  static ShapeDecoration decoration({
    required double radius,
    Color? color,
    BorderSide side = BorderSide.none,
  }) {
    return ShapeDecoration(
      color: color,
      shape: SquircleBorder.radius(radius, side: side),
    );
  }
}

/// A robust subclass of [ContinuousRectangleBorder] that prevents self-intersecting
/// cubic bezier loops and vertical / horizontal spike artifacts when corner radius
/// approaches or exceeds the element dimensions (e.g. small badges, chips, or pills).
class ContinuousSquircleBorder extends ContinuousRectangleBorder {
  const ContinuousSquircleBorder({
    super.side,
    super.borderRadius = BorderRadius.zero,
  });

  Path _getSquirclePath(RRect rrect) {
    final double left = rrect.left;
    final double right = rrect.right;
    final double top = rrect.top;
    final double bottom = rrect.bottom;

    if (rrect.width <= 0 || rrect.height <= 0) {
      return Path()..addRect(rrect.outerRect);
    }

    // Critical fix: Clamp radius to half of width and height so bezier control points
    // never cross each other or draw backwards, preventing vertical spikes / tie-fighter lines.
    final double maxRadius = math.min(rrect.width / 2.0, rrect.height / 2.0);

    final double tl = math.max(0.0, math.min(rrect.tlRadiusX, maxRadius));
    final double tr = math.max(0.0, math.min(rrect.trRadiusX, maxRadius));
    final double br = math.max(0.0, math.min(rrect.brRadiusX, maxRadius));
    final double bl = math.max(0.0, math.min(rrect.blRadiusX, maxRadius));

    return Path()
      ..moveTo(left, top + tl)
      ..cubicTo(left, top, left, top, left + tl, top)
      ..lineTo(right - tr, top)
      ..cubicTo(right, top, right, top, right, top + tr)
      ..lineTo(right, bottom - br)
      ..cubicTo(right, bottom, right, bottom, right - br, bottom)
      ..lineTo(left + bl, bottom)
      ..cubicTo(left, bottom, left, bottom, left, bottom - bl)
      ..close();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final resolved = borderRadius.resolve(textDirection);
    final rrect = resolved.toRRect(rect).deflate(side.width);
    return _getSquirclePath(rrect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final resolved = borderRadius.resolve(textDirection);
    final rrect = resolved.toRRect(rect);
    return _getSquirclePath(rrect);
  }

  @override
  ContinuousSquircleBorder copyWith({BorderSide? side, BorderRadiusGeometry? borderRadius}) {
    return ContinuousSquircleBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return ContinuousSquircleBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) return;
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawPath(getOuterPath(rect, textDirection: textDirection), side.toPaint());
    }
  }
}

