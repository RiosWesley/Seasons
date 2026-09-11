import 'package:flutter/material.dart';

/// Continuous squircle geometry helper adhering to G2 curvature continuity standards.
/// Produces signature smooth corner transitions using Flutter's ContinuousRectangleBorder.
class SquircleBorder {
  SquircleBorder._();

  // === RADIUS TOKENS ===
  static const double cardRadius = 24.0;
  static const double buttonRadius = 16.0;
  static const double badgeRadius = 12.0;
  static const double pillRadius = 999.0;

  /// Continuous squircle shape with given [radius] and optional [side].
  /// Flutter's ContinuousRectangleBorder uses an internal factor (~2.2 multiplier)
  /// to approximate standard iOS/macOS continuous squircle curvature.
  static ContinuousRectangleBorder radius(
    double radius, {
    BorderSide side = BorderSide.none,
  }) {
    return ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(radius * 2.2),
      side: side,
    );
  }

  /// Card shape with standard 24.0dp continuous squircle radius.
  static ContinuousRectangleBorder card({
    BorderSide side = BorderSide.none,
  }) {
    return radius(cardRadius, side: side);
  }

  /// Button shape with standard 16.0dp continuous squircle radius.
  static ContinuousRectangleBorder button({
    BorderSide side = BorderSide.none,
  }) {
    return radius(buttonRadius, side: side);
  }

  /// Badge / chip shape with standard 12.0dp continuous squircle radius.
  static ContinuousRectangleBorder badge({
    BorderSide side = BorderSide.none,
  }) {
    return radius(badgeRadius, side: side);
  }

  /// Pill shape for full stadium / capsule buttons.
  static ShapeBorder pill({
    BorderSide side = BorderSide.none,
  }) {
    return const StadiumBorder();
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
