import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:chat_wrapped/theme/swiss_colors.dart';
import 'package:chat_wrapped/theme/swiss_theme.dart';
import 'package:chat_wrapped/widgets/count_up_text.dart';
import 'package:chat_wrapped/widgets/metric_badge.dart';
import 'package:chat_wrapped/widgets/stage_progress_indicator.dart';
import 'package:chat_wrapped/widgets/swiss_button.dart';
import 'package:chat_wrapped/widgets/swiss_card.dart';

void main() {
  Widget wrapWithTheme(Widget child, {bool isDark = true}) {
    return MaterialApp(
      theme: isDark ? SwissTheme.darkTheme : SwissTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('SwissCard Widget Tests', () {
    testWidgets('Renders child content and applies continuous squircle border', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SwissCard(
            child: Text('Card Content'),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isA<ShapeDecoration>());
      final decoration = container.decoration as ShapeDecoration;
      expect(decoration.shape, isA<ContinuousRectangleBorder>());
    });

    testWidgets('Triggers onTap callback when pressed', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          SwissCard(
            onTap: () => tapped = true,
            child: const Text('Tappable Card'),
          ),
        ),
      );

      await tester.tap(find.text('Tappable Card'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('Highlight property applies emerald accent border', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SwissCard(
            highlight: true,
            child: Text('Highlighted Card'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as ShapeDecoration;
      final shape = decoration.shape as ContinuousRectangleBorder;
      expect(shape.side.color, equals(SwissColors.emeraldPrimary));
    });
  });

  group('SwissButton Widget Tests', () {
    testWidgets('Renders label, vector icon, and handles tap callback', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          SwissButton(
            label: 'Ação Principal',
            icon: Icons.arrow_forward_rounded,
            onPressed: () => pressed = true,
          ),
        ),
      );

      expect(find.text('Ação Principal'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

      await tester.tap(find.text('Ação Principal'));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
    });

    testWidgets('Press scale feedback uses 0.97 factor', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SwissButton(
            label: 'Escala Tátil',
            onPressed: () {},
          ),
        ),
      );

      final button = tester.widget<SwissButton>(find.byType(SwissButton));
      expect(button.scaleDownFactor, equals(0.97));

      // Test tap down triggers AnimatedScale
      final gesture = await tester.startGesture(tester.getCenter(find.text('Escala Tátil')));
      await tester.pump(const Duration(milliseconds: 50));
      final animatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.scale, equals(0.97));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('Displays CircularProgressIndicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SwissButton(
            label: 'Carregando',
            isLoading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('CountUpText Widget Tests', () {
    testWidgets('Animates number up to target value with tabular figures', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const CountUpText(
            targetValue: 1000,
            duration: Duration(milliseconds: 200),
          ),
        ),
      );

      // Verify widget builds and animates
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('1.000'), findsOneWidget);

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontFeatures, isNotNull);
    });
  });

  group('MetricBadge Widget Tests', () {
    testWidgets('Renders label and vector icon without emojis in chrome', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const MetricBadge(
            label: 'Privacidade Total',
            icon: Icons.verified_user_outlined,
            isAccent: true,
          ),
        ),
      );

      expect(find.text('Privacidade Total'), findsOneWidget);
      expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);
    });
  });

  group('StageProgressIndicator Widget Tests', () {
    testWidgets('Renders pipeline stages with smooth progress feedback', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const StageProgressIndicator(
            stage: PipelineStage.parsing,
          ),
        ),
      );

      expect(find.text('Processando Linhas'), findsOneWidget);
      expect(find.text('55%'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('Renders error state cleanly', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const StageProgressIndicator(
            stage: PipelineStage.error,
            customMessage: 'Arquivo corrompido',
          ),
        ),
      );

      expect(find.text('Erro no Processamento'), findsOneWidget);
      expect(find.text('Arquivo corrompido'), findsOneWidget);
      expect(find.byIcon(LucideIcons.alertCircle), findsOneWidget);
    });
  });
}
