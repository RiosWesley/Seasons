import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/theme/squircle_border.dart';
import 'package:chat_wrapped/theme/swiss_colors.dart';
import 'package:chat_wrapped/theme/swiss_theme.dart';
import 'package:chat_wrapped/theme/swiss_typography.dart';

void main() {
  group('SwissColors Unit Tests', () {
    test('Monotone neutral dark palette tokens match exact specifications', () {
      expect(SwissColors.darkBackground.toARGB32(), equals(0xFF0B0C0E));
      expect(SwissColors.darkSurface.toARGB32(), equals(0xFF14171A));
      expect(SwissColors.darkSurfaceCard.toARGB32(), equals(0xFF181D27));
      expect(SwissColors.darkBorder.toARGB32(), equals(0xFF24292E));
    });

    test('Monotone neutral light palette tokens match exact specifications', () {
      expect(SwissColors.lightBackground.toARGB32(), equals(0xFFF8F9FA));
      expect(SwissColors.lightSurface.toARGB32(), equals(0xFFFFFFFF));
      expect(SwissColors.lightSurfaceCard.toARGB32(), equals(0xFFFFFFFF));
      expect(SwissColors.lightBorder.toARGB32(), equals(0xFFE5E7EB));
    });

    test('Disciplined emerald accent tokens match specifications', () {
      expect(SwissColors.emeraldPrimary.toARGB32(), equals(0xFF00DC82));
      expect(SwissColors.emeraldSecondary.toARGB32(), equals(0xFF10B981));
      expect(SwissColors.accent, equals(SwissColors.emeraldPrimary));
    });

    test('Luminance and color channel relationships verify Swiss precision', () {
      // Emerald green channel dominates red and blue
      final emeraldInt = SwissColors.emeraldPrimary.toARGB32();
      final red = (emeraldInt >> 16) & 0xFF;
      final green = (emeraldInt >> 8) & 0xFF;
      final blue = emeraldInt & 0xFF;
      expect(green, greaterThan(red));
      expect(green, greaterThan(blue));

      // Neutral contrast hierarchy
      expect(SwissColors.darkBackground.toARGB32() < SwissColors.darkSurface.toARGB32(), isTrue);
      expect(SwissColors.lightBackground.toARGB32() < SwissColors.lightSurface.toARGB32(), isTrue);
    });

    test('Adaptive color resolvers return appropriate mode tokens', () {
      expect(SwissColors.background(true), equals(SwissColors.darkBackground));
      expect(SwissColors.background(false), equals(SwissColors.lightBackground));
      expect(SwissColors.surface(true), equals(SwissColors.darkSurface));
      expect(SwissColors.surface(false), equals(SwissColors.lightSurface));
      expect(SwissColors.cardSurface(true), equals(SwissColors.darkSurfaceCard));
      expect(SwissColors.cardSurface(false), equals(SwissColors.lightSurfaceCard));
      expect(SwissColors.border(true), equals(SwissColors.darkBorder));
      expect(SwissColors.border(false), equals(SwissColors.lightBorder));
      expect(SwissColors.textPrimary(true), equals(SwissColors.darkTextPrimary));
      expect(SwissColors.textPrimary(false), equals(SwissColors.lightTextPrimary));
    });
  });

  group('SwissTypography Unit Tests', () {
    test('Tabular figures feature specifies "tnum"', () {
      const feature = FontFeature.tabularFigures();
      expect(feature.feature, equals('tnum'));
      expect(SwissTypography.tabularFigures.contains(feature), isTrue);
    });

    test('Metric and display styles mandate tabular figures', () {
      expect(SwissTypography.metricLarge.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(SwissTypography.metricMedium.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(SwissTypography.metricSmall.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(SwissTypography.displayLarge.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(SwissTypography.displayMedium.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(SwissTypography.labelSmall.fontFeatures, contains(const FontFeature.tabularFigures()));
    });

    test('TextTheme factory produces complete typography for dark and light modes', () {
      final darkTheme = SwissTypography.createTextTheme(isDark: true);
      final lightTheme = SwissTypography.createTextTheme(isDark: false);

      expect(darkTheme.displayLarge?.color, equals(SwissColors.darkTextPrimary));
      expect(lightTheme.displayLarge?.color, equals(SwissColors.lightTextPrimary));
      expect(darkTheme.bodyMedium?.color, equals(SwissColors.darkTextSecondary));
      expect(lightTheme.bodyMedium?.color, equals(SwissColors.lightTextSecondary));
    });
  });

  group('SquircleBorder Geometry Tests', () {
    test('Continuous squircle standard radii tokens', () {
      expect(SquircleBorder.cardRadius, equals(24.0));
      expect(SquircleBorder.buttonRadius, equals(16.0));
      expect(SquircleBorder.badgeRadius, equals(12.0));
      expect(SquircleBorder.pillRadius, equals(999.0));

      expect(SquircleBorder.cardRadius, greaterThan(SquircleBorder.buttonRadius));
      expect(SquircleBorder.buttonRadius, greaterThan(SquircleBorder.badgeRadius));
    });

    test('SquircleBorder helpers create ContinuousRectangleBorder instances', () {
      final cardBorder = SquircleBorder.card();
      expect(cardBorder, isA<ContinuousRectangleBorder>());

      final buttonBorder = SquircleBorder.button();
      expect(buttonBorder, isA<ContinuousRectangleBorder>());

      final badgeBorder = SquircleBorder.badge();
      expect(badgeBorder, isA<ContinuousRectangleBorder>());

      final pillBorder = SquircleBorder.pill();
      expect(pillBorder, isA<StadiumBorder>());
    });

    test('SquircleBorder.decoration creates ShapeDecoration with ContinuousRectangleBorder', () {
      final decoration = SquircleBorder.decoration(
        radius: 20.0,
        color: SwissColors.darkSurfaceCard,
      );
      expect(decoration, isA<ShapeDecoration>());
      expect(decoration.shape, isA<ContinuousRectangleBorder>());
      expect(decoration.color, equals(SwissColors.darkSurfaceCard));
    });
  });

  group('SwissTheme ThemeData Tests', () {
    test('Dark theme adheres to Swiss specifications', () {
      final dark = SwissTheme.darkTheme;
      expect(dark.brightness, equals(Brightness.dark));
      expect(dark.scaffoldBackgroundColor, equals(SwissColors.darkBackground));
      expect(dark.cardColor, equals(SwissColors.darkSurfaceCard));
      expect(dark.colorScheme.primary, equals(SwissColors.emeraldPrimary));
      expect(dark.cardTheme.elevation, equals(0));
      expect(dark.appBarTheme.elevation, equals(0));
      expect(dark.cardTheme.shape, isA<ContinuousRectangleBorder>());
    });

    test('Light theme adheres to Swiss specifications', () {
      final light = SwissTheme.lightTheme;
      expect(light.brightness, equals(Brightness.light));
      expect(light.scaffoldBackgroundColor, equals(SwissColors.lightBackground));
      expect(light.cardColor, equals(SwissColors.lightSurfaceCard));
      expect(light.colorScheme.primary, equals(SwissColors.emeraldPrimary));
      expect(light.cardTheme.elevation, equals(0));
      expect(light.appBarTheme.elevation, equals(0));
      expect(light.cardTheme.shape, isA<ContinuousRectangleBorder>());
    });
  });
}
