import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:chat_wrapped/core/services/onboarding_preferences.dart';
import 'package:chat_wrapped/screens/home_screen.dart';
import 'package:chat_wrapped/screens/onboarding_screen.dart';
import 'package:chat_wrapped/widgets/floating_bottom_bar.dart';
import 'package:chat_wrapped/theme/swiss_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void setViewport(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Widget wrapWithApp(
    Widget child, {
    double textScale = 1.0,
    bool isDark = false,
  }) {
    return MaterialApp(
      theme: isDark ? SwissTheme.darkTheme : SwissTheme.lightTheme,
      home: Builder(
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(textScale),
            ),
            child: child,
          );
        },
      ),
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CHALLENGE 1: Onboarding Stress & Robustness', () {
    testWidgets('1.1 Rapid forward and backward page swiping in PageView', (tester) async {
      setViewport(tester, const Size(1080, 2400));
      await tester.pumpWidget(wrapWithApp(const OnboardingScreen()));
      await tester.pumpAndSettle();

      final pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      // Perform 15 rapid, aggressive fling and drag gestures back and forth
      for (int i = 0; i < 15; i++) {
        final offset = (i % 2 == 0) ? const Offset(-500, 0) : const Offset(500, 0);
        await tester.timedDrag(pageViewFinder, offset, const Duration(milliseconds: 60));
        await tester.pump(const Duration(milliseconds: 30));
      }

      // Settle animations and verify no unhandled exceptions
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Verify that the screen is still fully operational
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('1.2 Out of bounds / extreme initialPage values clamp gracefully', (tester) async {
      setViewport(tester, const Size(1080, 2400));

      // Negative initialPage
      await tester.pumpWidget(wrapWithApp(const OnboardingScreen(initialPage: -99)));
      await tester.pumpAndSettle();
      expect(find.text('ARQUIVO PESSOAL DE CONVERSAS'), findsOneWidget);

      // Excessive initialPage (> 3)
      await tester.pumpWidget(wrapWithApp(const OnboardingScreen(initialPage: 42)));
      await tester.pumpAndSettle();
      expect(find.text('SEGURANÇA & PRIVACIDADE'), findsOneWidget);
      expect(find.text('Começar a Explorar'), findsOneWidget);
    });

    testWidgets('1.3 Rapid consecutive taps on Continuar past the last page', (tester) async {
      setViewport(tester, const Size(1080, 2400));
      await tester.pumpWidget(wrapWithApp(const OnboardingScreen()));
      await tester.pumpAndSettle();

      // Tap Continuar multiple times in rapid succession without settling
      for (int i = 0; i < 8; i++) {
        final continueFinder = find.text('Continuar');
        if (continueFinder.evaluate().isNotEmpty) {
          await tester.tap(continueFinder);
          await tester.pump(const Duration(milliseconds: 40));
        }
      }

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // Once on page 4 (index 3), CTA switches to 'Começar a Explorar'
      expect(find.text('Começar a Explorar'), findsOneWidget);
      expect(find.text('Continuar'), findsNothing);
    });

    testWidgets('1.4 Rapid concurrent jump requests via step indicator pills', (tester) async {
      setViewport(tester, const Size(1080, 2400));
      await tester.pumpWidget(wrapWithApp(const OnboardingScreen()));
      await tester.pumpAndSettle();

      final pills = find.byType(AnimatedContainer);
      expect(pills, findsNWidgets(4));

      // Tap pills in non-sequential order rapidly while animations run
      await tester.tap(pills.at(3)); // jump to page 4
      await tester.pump(const Duration(milliseconds: 30));
      await tester.tap(pills.at(1)); // jump to page 2
      await tester.pump(const Duration(milliseconds: 30));
      await tester.tap(pills.at(0)); // jump to page 1
      await tester.pump(const Duration(milliseconds: 30));
      await tester.tap(pills.at(2)); // jump to page 3
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('GUIA PRÁTICO EM 4 PASSOS'), findsOneWidget);
    });

    test('1.5 Persistence race conditions & concurrent calls', () async {
      SharedPreferences.setMockInitialValues({});

      // Fire 30 concurrent read & write operations
      final futures = <Future<dynamic>>[];
      for (int i = 0; i < 15; i++) {
        futures.add(OnboardingPreferences.hasSeenOnboarding());
        futures.add(OnboardingPreferences.setHasSeenOnboarding(i.isEven));
        futures.add(OnboardingPreferences.resetOnboarding());
      }

      final results = await Future.wait(futures);
      expect(results, isNotNull);

      // Verify that after finishing, setHasSeenOnboarding works reliably
      await OnboardingPreferences.setHasSeenOnboarding(true);
      final finalVal = await OnboardingPreferences.hasSeenOnboarding();
      expect(finalVal, isTrue);
    });

    testWidgets('1.6 Extreme screen sizes and high accessibility font scale', (tester) async {
      // Test all 4 pages under various extreme conditions
      final testCases = [
        // Small device, high scale
        {'size': const Size(360, 640), 'scale': 1.6, 'page': 0},
        {'size': const Size(360, 640), 'scale': 1.6, 'page': 1},
        {'size': const Size(360, 640), 'scale': 1.6, 'page': 2},
        {'size': const Size(360, 640), 'scale': 1.6, 'page': 3},
        // Landscape mode
        {'size': const Size(800, 360), 'scale': 1.0, 'page': 0},
        {'size': const Size(800, 360), 'scale': 1.0, 'page': 2},
        // Large tablet
        {'size': const Size(1200, 1600), 'scale': 1.2, 'page': 1},
      ];

      for (final tc in testCases) {
        final size = tc['size'] as Size;
        final scale = tc['scale'] as double;
        final page = tc['page'] as int;

        setViewport(tester, size);
        await tester.pumpWidget(
          wrapWithApp(
            OnboardingScreen(initialPage: page),
            textScale: scale,
          ),
        );
        await tester.pumpAndSettle();

        // Must not trigger any RenderFlex overflow exception
        expect(tester.takeException(), isNull,
            reason: 'RenderFlex overflow detected on page $page with size $size and scale $scale');
      }
    });

    testWidgets('1.7 Top bar responsiveness under narrow width (320px) and 1.5x font scale', (tester) async {
      setViewport(tester, const Size(320, 600));
      await tester.pumpWidget(
        wrapWithApp(
          const OnboardingScreen(),
          textScale: 1.5,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Chat Wrapped'), findsOneWidget);
    });
  });

  group('CHALLENGE 2: Floating Bottom Navigation Bar Stress & Geometry', () {
    testWidgets('2.1 Rapid tab switching in quick succession (pill animation stability)', (tester) async {
      setViewport(tester, const Size(1080, 2400));
      int activeIndex = 0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return wrapWithApp(
              Scaffold(
                extendBody: true,
                body: const SizedBox.expand(),
                bottomNavigationBar: FloatingBottomNavBar(
                  currentIndex: activeIndex,
                  onTap: (index) => setState(() => activeIndex = index),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Rapidly switch between 0 -> 3 -> 1 -> 2 -> 0 with 40ms pump intervals
      final tabOrder = [3, 1, 2, 0, 3, 2, 1, 0];
      for (final targetIndex in tabOrder) {
        final itemFinder = find.byKey(ValueKey('floating_nav_item_$targetIndex'));
        expect(itemFinder, findsOneWidget);
        await tester.tap(itemFinder);
        await tester.pump(const Duration(milliseconds: 40));
      }

      // Settle and verify final state
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(activeIndex, 0);

      // Verify pill position matches index 0
      final animatedPositionedFinder = find.byType(AnimatedPositioned);
      expect(animatedPositionedFinder, findsOneWidget);
      final positioned = tester.widget<AnimatedPositioned>(animatedPositionedFinder);
      expect(positioned.left, isNotNull);
      expect(positioned.left!.isFinite, isTrue);
    });

    testWidgets('2.2 Scroll padding verification: bottommost content is clickable and not occluded', (tester) async {
      const viewportSize = Size(400, 800);
      setViewport(tester, viewportSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: SwissTheme.lightTheme,
          home: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Find the primary scrollable in HomeScreen
      final scrollableFinder = find.byType(Scrollable);
      expect(scrollableFinder, findsWidgets);

      // Scroll to the absolute bottom of HomeScreen
      final scrollableState = tester.state<ScrollableState>(scrollableFinder.first);
      scrollableState.position.jumpTo(scrollableState.position.maxScrollExtent);
      await tester.pumpAndSettle();

      // Find the bottommost element: the footer tagline
      final taglineFinder = find.text('CONVERSAS REAIS. PERSPECTIVAS EXTRAORDINÁRIAS.');
      expect(taglineFinder, findsOneWidget);

      final taglineRect = tester.getRect(taglineFinder);
      final navBarRect = tester.getRect(find.byType(FloatingBottomNavBar));

      // The bottom of the tagline MUST be above or clear of the floating bottom nav bar top!
      // In other words, navBarRect.top >= taglineRect.bottom
      expect(
        navBarRect.top,
        greaterThanOrEqualTo(taglineRect.bottom),
        reason: 'Bottommost tagline content is occluded by the floating bottom bar! '
            'Tagline bottom: ${taglineRect.bottom}, NavBar top: ${navBarRect.top}',
      );

      // Verify bottom interactive element (the second Bento card) is clickable
      final amigosModeCard = find.text('Modo Amigos');
      expect(amigosModeCard, findsOneWidget);
      final amigosRect = tester.getRect(amigosModeCard);
      expect(
        navBarRect.top,
        greaterThanOrEqualTo(amigosRect.bottom),
        reason: 'Modo Amigos card is occluded by the floating bottom bar!',
      );
    });

    testWidgets('2.3 Dynamic screen resize and orientation change (portrait to landscape to portrait)', (tester) async {
      int activeIndex = 1;

      Widget buildHarness() {
        return StatefulBuilder(
          builder: (context, setState) {
            return wrapWithApp(
              Scaffold(
                extendBody: true,
                body: const SizedBox.expand(),
                bottomNavigationBar: FloatingBottomNavBar(
                  currentIndex: activeIndex,
                  onTap: (index) => setState(() => activeIndex = index),
                ),
              ),
            );
          },
        );
      }

      // Step 1: Portrait (400 x 800)
      setViewport(tester, const Size(400, 800));
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      final pill1 = tester.widget<AnimatedPositioned>(find.byType(AnimatedPositioned));
      final pillLeftPortrait = pill1.left!;

      // Step 2: Rotate to Landscape (800 x 400)
      setViewport(tester, const Size(800, 400));
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      final pill2 = tester.widget<AnimatedPositioned>(find.byType(AnimatedPositioned));
      final pillLeftLandscape = pill2.left!;

      // In landscape (width 800 vs 400), tab 1 (Minhas Análises) should have shifted right
      expect(pillLeftLandscape, greaterThan(pillLeftPortrait));

      // Tap tab 2 (Modelos) in landscape
      await tester.tap(find.byKey(const ValueKey('floating_nav_item_2')));
      await tester.pumpAndSettle();
      expect(activeIndex, 2);

      // Step 3: Back to Portrait (400 x 800)
      setViewport(tester, const Size(400, 800));
      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      expect(activeIndex, 2);
      expect(tester.takeException(), isNull);
    });

    testWidgets('2.4 Degenerate indices and boundary conditions in FloatingBottomNavBar', (tester) async {
      setViewport(tester, const Size(400, 800));

      // Test negative index (-5) -> pill should hide gracefully (opacity 0)
      await tester.pumpWidget(
        wrapWithApp(
          FloatingBottomNavBar(
            currentIndex: -5,
            onTap: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final pillOpacity = tester.widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(AnimatedPositioned),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(pillOpacity.opacity, 0.0);

      // Test out-of-range positive index (10) -> pill should hide gracefully (opacity 0)
      await tester.pumpWidget(
        wrapWithApp(
          FloatingBottomNavBar(
            currentIndex: 10,
            onTap: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final pillOpacityOver = tester.widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(AnimatedPositioned),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(pillOpacityOver.opacity, 0.0);

      // Test single-item nav bar
      await tester.pumpWidget(
        wrapWithApp(
          FloatingBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
            items: const [
              FloatingBottomBarItem(icon: LucideIcons.sparkles, label: 'Solo'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Solo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
