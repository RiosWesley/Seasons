import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:chat_wrapped/screens/home_screen.dart';
import 'package:chat_wrapped/screens/onboarding_screen.dart';
import 'package:chat_wrapped/theme/swiss_colors.dart';
import 'package:chat_wrapped/theme/swiss_theme.dart';
import 'package:chat_wrapped/widgets/floating_bottom_bar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void setMobileViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Widget wrapWithTheme(
    Widget child, {
    bool isDark = false,
  }) {
    return MaterialApp(
      theme: isDark ? SwissTheme.darkTheme : SwissTheme.lightTheme,
      home: Scaffold(
        extendBody: true,
        body: const SizedBox.expand(),
        bottomNavigationBar: child,
      ),
    );
  }

  group('FloatingBottomBarItem Unit Tests', () {
    test('Constructs item with icon and label', () {
      const item = FloatingBottomBarItem(
        icon: LucideIcons.sparkles,
        label: 'Destaques',
      );
      expect(item.icon, LucideIcons.sparkles);
      expect(item.label, 'Destaques');
    });
  });

  group('FloatingBottomNavBar Rendering & Geometry Tests', () {
    testWidgets('Renders all 4 default items with correct Lucide icons and labels', (tester) async {
      int tappedIndex = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          FloatingBottomNavBar(
            currentIndex: 0,
            onTap: (index) => tappedIndex = index,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify labels
      expect(find.text('Início'), findsOneWidget);
      expect(find.text('Minhas Análises'), findsOneWidget);
      expect(find.text('Modelos'), findsOneWidget);
      expect(find.text('Configurações'), findsOneWidget);

      // Verify Lucide icons
      expect(find.byIcon(LucideIcons.house), findsOneWidget);
      expect(find.byIcon(LucideIcons.trendingUp), findsOneWidget);
      expect(find.byIcon(LucideIcons.layoutGrid), findsOneWidget);
      expect(find.byIcon(LucideIcons.settings), findsOneWidget);

      expect(tappedIndex, -1);
    });

    testWidgets('Renders custom items when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          FloatingBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
            items: const [
              FloatingBottomBarItem(icon: LucideIcons.heart, label: 'Amor'),
              FloatingBottomBarItem(icon: LucideIcons.users, label: 'Amigos'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Amor'), findsOneWidget);
      expect(find.text('Amigos'), findsOneWidget);
      expect(find.byIcon(LucideIcons.heart), findsOneWidget);
      expect(find.byIcon(LucideIcons.users), findsOneWidget);
    });

    testWidgets('Applies continuous squircle ClipRRect and BackdropFilter blur', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          FloatingBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // ClipRRect with radius 26
      final clipRRectFinder = find.byType(ClipRRect);
      expect(clipRRectFinder, findsOneWidget);
      final clipRRect = tester.widget<ClipRRect>(clipRRectFinder);
      expect(clipRRect.borderRadius, BorderRadius.circular(26));

      // BackdropFilter with 12x12 blur
      final backdropFilterFinder = find.byType(BackdropFilter);
      expect(backdropFilterFinder, findsOneWidget);
      final backdropFilter = tester.widget<BackdropFilter>(backdropFilterFinder);
      expect(backdropFilter.filter, ImageFilter.blur(sigmaX: 12, sigmaY: 12));
    });

    testWidgets('Applies floating margins and compensates for bottom safe area inset', (tester) async {
      const bottomInset = 34.0;
      await tester.pumpWidget(
        MaterialApp(
          theme: SwissTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800),
              padding: EdgeInsets.only(bottom: bottomInset),
            ),
            child: Scaffold(
              extendBody: true,
              body: const SizedBox.expand(),
              bottomNavigationBar: FloatingBottomNavBar(
                currentIndex: 0,
                onTap: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final outerPaddingFinder = find.descendant(
        of: find.byType(FloatingBottomNavBar),
        matching: find.byType(Padding),
      );
      expect(outerPaddingFinder, findsWidgets);

      final outerPadding = tester.widget<Padding>(outerPaddingFinder.first);
      expect(
        outerPadding.padding,
        const EdgeInsets.fromLTRB(20, 0, 20, 16 + bottomInset),
      );
    });

    testWidgets('Applies diffuse elevation shadow and semi-translucent fill', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          FloatingBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Outer container with shadow
      final outerContainerFinder = find.ancestor(
        of: find.byType(ClipRRect),
        matching: find.byType(Container),
      );
      expect(outerContainerFinder, findsWidgets);
      final outerContainer = tester.widget<Container>(outerContainerFinder.first);
      final outerDecoration = outerContainer.decoration as BoxDecoration;
      expect(outerDecoration.borderRadius, BorderRadius.circular(26));
      expect(outerDecoration.boxShadow, isNotEmpty);
      expect(outerDecoration.boxShadow!.first.blurRadius, 20);
      expect(outerDecoration.boxShadow!.first.offset, const Offset(0, 8));

      // Inner container with fill & border
      final innerContainerFinder = find.descendant(
        of: find.byType(BackdropFilter),
        matching: find.byType(Container),
      );
      expect(innerContainerFinder, findsWidgets);
      final innerContainer = tester.widget<Container>(innerContainerFinder.first);
      final innerDecoration = innerContainer.decoration as BoxDecoration;
      expect(innerDecoration.borderRadius, BorderRadius.circular(26));
      expect(innerDecoration.border, isNotNull);
      expect(innerDecoration.color, Colors.white.withValues(alpha: 0.82));
    });

    testWidgets('Supports Dark Theme styling with darkSurfaceCard and dark border', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          FloatingBottomNavBar(
            currentIndex: 1,
            onTap: (_) {},
          ),
          isDark: true,
        ),
      );
      await tester.pumpAndSettle();

      final innerContainerFinder = find.descendant(
        of: find.byType(BackdropFilter),
        matching: find.byType(Container),
      );
      final innerContainer = tester.widget<Container>(innerContainerFinder.first);
      final innerDecoration = innerContainer.decoration as BoxDecoration;
      expect(
        innerDecoration.color,
        SwissColors.darkSurfaceCard.withValues(alpha: 0.82),
      );
    });
  });

  group('FloatingBottomNavBar Interactivity & Animation Tests', () {
    testWidgets('Tapping on a tab invokes onTap callback with correct index', (tester) async {
      int tappedIndex = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          FloatingBottomNavBar(
            currentIndex: 0,
            onTap: (index) => tappedIndex = index,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap 'Minhas Análises' (index 1)
      await tester.tap(find.text('Minhas Análises'));
      await tester.pump();
      expect(tappedIndex, 1);

      // Tap 'Modelos' (index 2)
      await tester.tap(find.text('Modelos'));
      await tester.pump();
      expect(tappedIndex, 2);

      // Tap 'Configurações' (index 3)
      await tester.tap(find.text('Configurações'));
      await tester.pump();
      expect(tappedIndex, 3);

      // Tap 'Início' (index 0)
      await tester.tap(find.text('Início'));
      await tester.pump();
      expect(tappedIndex, 0);
    });

    testWidgets('Displays active indicator pill and animates when index changes', (tester) async {
      int activeIndex = 0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return wrapWithTheme(
              FloatingBottomNavBar(
                currentIndex: activeIndex,
                onTap: (index) => setState(() => activeIndex = index),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Verify AnimatedPositioned pill exists
      final animatedPositionedFinder = find.byType(AnimatedPositioned);
      expect(animatedPositionedFinder, findsOneWidget);
      final initialPositioned = tester.widget<AnimatedPositioned>(animatedPositionedFinder);
      expect(initialPositioned.curve, Curves.easeOutCubic);
      expect(initialPositioned.duration, const Duration(milliseconds: 260));
      final double initialLeft = initialPositioned.left!;

      // Tap on tab 2 ('Modelos')
      await tester.tap(find.text('Modelos'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 130)); // Halfway

      // Settle animation
      await tester.pumpAndSettle();

      final updatedPositioned = tester.widget<AnimatedPositioned>(animatedPositionedFinder);
      expect(updatedPositioned.left, greaterThan(initialLeft));
    });

    testWidgets('Active item has 1.05x scale, bold font, and visible active dot', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          FloatingBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Active item text style check (FontWeight.w700)
      final textWidgets = tester.widgetList<AnimatedDefaultTextStyle>(
        find.descendant(
          of: find.byType(FloatingBottomNavBar),
          matching: find.byType(AnimatedDefaultTextStyle),
        ),
      ).toList();
      expect(textWidgets.length, 4);
      expect(textWidgets[0].style.fontWeight, FontWeight.w700);
      expect(textWidgets[1].style.fontWeight, FontWeight.w500);

      // Active scale check (1.05 vs 0.95)
      final scaleWidgets = tester.widgetList<AnimatedScale>(
        find.descendant(
          of: find.byType(FloatingBottomNavBar),
          matching: find.byType(AnimatedScale),
        ),
      ).toList();
      expect(scaleWidgets.length, 4);
      expect(scaleWidgets[0].scale, 1.05);
      expect(scaleWidgets[1].scale, 0.95);

      // Active dot check (opacity 1.0 vs 0.0)
      final opacityWidgets = tester.widgetList<AnimatedOpacity>(
        find.descendant(
          of: find.byType(FloatingBottomNavBar),
          matching: find.byType(AnimatedOpacity),
        ),
      ).toList();
      // The first AnimatedOpacity is the pill itself, subsequent ones are the dots
      final dotOpacities = opacityWidgets.skip(1).toList();
      expect(dotOpacities[0].opacity, 1.0);
      expect(dotOpacities[1].opacity, 0.0);
    });

    testWidgets('Edge case: empty items list renders empty widget cleanly', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          FloatingBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
            items: const [],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FloatingBottomNavBar), findsOneWidget);
      expect(find.text('Início'), findsNothing);
    });

    testWidgets('Edge case: out of bounds index hides active pill gracefully without crashing', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          FloatingBottomNavBar(
            currentIndex: -1,
            onTap: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final pillOpacity = tester.widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(AnimatedPositioned),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(pillOpacity.opacity, 0.0);
    });
  });

  group('HomeScreen Integration with FloatingBottomNavBar & Settings', () {
    Widget wrapWithApp(Widget child) {
      return MaterialApp(
        theme: SwissTheme.lightTheme,
        home: child,
      );
    }

    testWidgets('HomeScreen integrates FloatingBottomNavBar with extendBody true', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(wrapWithApp(const HomeScreen()));
      await tester.pumpAndSettle();

      // Verify FloatingBottomNavBar is present
      expect(find.byType(FloatingBottomNavBar), findsOneWidget);

      // Verify Scaffold has extendBody: true
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.extendBody, isTrue);
    });

    testWidgets('Central ingestion card contains tutorial link opening Onboarding Page 3', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(wrapWithApp(const HomeScreen()));
      await tester.pumpAndSettle();

      final tutorialFinder = find.text('Como exportar do WhatsApp? Ver tutorial →');
      expect(tutorialFinder, findsOneWidget);

      // Tap tutorial link
      await tester.tap(tutorialFinder);
      await tester.pumpAndSettle();

      // Verify OnboardingScreen opened at export guide (Page 3)
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('Como exportar sua conversa do WhatsApp.'), findsOneWidget);
      expect(find.text('GUIA PRÁTICO EM 4 PASSOS'), findsOneWidget);
    });

    testWidgets('Tapping Configurações tab opens Settings modal bottom sheet with Rever Onboarding', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(wrapWithApp(const HomeScreen()));
      await tester.pumpAndSettle();

      // Tap tab 3 'Configurações'
      await tester.tap(find.text('Configurações'));
      await tester.pumpAndSettle();

      // Verify settings modal sheet content
      expect(find.text('Configurações'), findsWidgets);
      expect(find.text('Rever Onboarding'), findsOneWidget);
      expect(find.text('100% Offline e Privado'), findsOneWidget);

      // Tap 'Rever Onboarding'
      await tester.tap(find.text('Rever Onboarding'));
      await tester.pumpAndSettle();

      // Verify OnboardingScreen opened in replay mode (Page 1)
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('Fechar'), findsOneWidget);
      expect(find.text('Suas conversas guardam histórias inesquecíveis.'), findsOneWidget);
    });

    testWidgets('Tapping Modelos tab renders Bento cards matching ModeSelectionScreen styling', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(wrapWithApp(const HomeScreen()));
      await tester.pumpAndSettle();

      // Tap tab 2 'Modelos'
      await tester.tap(find.text('Modelos'));
      await tester.pumpAndSettle();

      // Verify title & subtitle
      expect(find.text('Modelos de Análise'), findsOneWidget);
      expect(find.text('Algoritmos calibrados para cada dinâmica de relacionamento.'), findsOneWidget);

      // Verify all 3 Bento cards are rendered with their eyebrows and badges
      expect(find.text('AFINIDADE & RITMO A DOIS'), findsOneWidget);
      expect(find.text('Modo Casal'), findsOneWidget);
      expect(find.text('Ritmo a dois & Afinidade'), findsOneWidget);

      expect(find.text('SQUAD & ARQUÉTIPOS'), findsOneWidget);
      expect(find.text('Modo Amigos'), findsOneWidget);
      expect(find.text('Arquétipos do squad & Dinâmica'), findsOneWidget);

      expect(find.text('LEADERBOARD GERAL & VIBES'), findsOneWidget);
      expect(find.text('Modo Grupo'), findsOneWidget);
      expect(find.text('Leaderboard geral & Radar de vibes'), findsOneWidget);

      // Verify 3 demo action buttons are present
      expect(find.text('Experimentar com conversa de exemplo'), findsNWidgets(3));
    });
  });
}
