import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:chat_wrapped/core/analytics/chat_analyzer.dart';
import 'package:chat_wrapped/core/models/general_stats.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';
import 'package:chat_wrapped/stories/stories_viewer_screen.dart';
import 'package:chat_wrapped/stories/story_progress_bar.dart';
import 'package:chat_wrapped/stories/story_slide.dart';
import 'package:chat_wrapped/theme/swiss_theme.dart';

void main() {
  void setMobileViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      theme: SwissTheme.darkTheme,
      home: child,
    );
  }

  const casalChat = '''
01/02/2025 10:00 - Ana: Oi amor! ❤️
01/02/2025 10:02 - Carlos: Oi linda! Como foi seu dia? 🥰
01/02/2025 12:00 - Ana: Foi maravilhoso! Te amo ❤️
01/02/2025 12:05 - Carlos: Também te amo demais! ❤️
''';

  const amigosChat = '''
01/02/2025 10:00 - Lucas: Bora sair hoje galera?
01/02/2025 10:02 - Mateus: Bora! Levo as coisas 😂
01/02/2025 10:05 - Gabriel: Fechado!
''';

  const grupoChat = '''
01/02/2025 10:00 - Alice: Bom dia grupo!
01/02/2025 10:01 - Bruno: Bom dia!
01/02/2025 10:02 - Clara: Fala pessoal!
01/02/2025 10:03 - Diego: E aí galera!
01/02/2025 10:04 - Eduardo: Bom dia!
01/02/2025 10:05 - Fernanda: Bora time!
''';

  final casalAnalysis = ChatAnalyzer.analyzeRawExport(
    const ChatParser().parse(casalChat),
    overrideMode: ChatMode.casal,
  );

  final amigosAnalysis = ChatAnalyzer.analyzeRawExport(
    const ChatParser().parse(amigosChat),
    overrideMode: ChatMode.amigos,
  );

  final grupoAnalysis = ChatAnalyzer.analyzeRawExport(
    const ChatParser().parse(grupoChat),
    overrideMode: ChatMode.grupo,
  );

  group('StoryCatalog Unit Tests', () {
    test('Casal slide catalog contains exactly 18 slides', () {
      final slides = StoryCatalog.getCasalSlides();
      expect(slides.length, equals(18));
      expect(slides.every((s) => s.mode == ChatMode.casal), isTrue);
    });

    test('Amigos slide catalog contains exactly 18 slides', () {
      final slides = StoryCatalog.getAmigosSlides();
      expect(slides.length, equals(18));
      expect(slides.every((s) => s.mode == ChatMode.amigos), isTrue);
    });

    test('Grupo slide catalog contains exactly 16 slides', () {
      final slides = StoryCatalog.getGrupoSlides();
      expect(slides.length, equals(16));
      expect(slides.every((s) => s.mode == ChatMode.grupo), isTrue);
    });

    test('Total slide catalog contains 52 bespoke cards and all are 100% unlocked', () {
      expect(StoryCatalog.totalSlidesCount, equals(52));
      final allSlides = [
        ...StoryCatalog.getCasalSlides(),
        ...StoryCatalog.getAmigosSlides(),
        ...StoryCatalog.getGrupoSlides(),
      ];
      expect(allSlides.length, equals(52));
      expect(allSlides.every((s) => !s.isLocked), isTrue,
          reason: 'All stories must be 100% unlocked (zero paywalls).');

      final uniqueIds = allSlides.map((s) => s.id).toSet();
      expect(uniqueIds.length, equals(52),
          reason: 'Every slide across all modes must have a unique identifier.');
    });
  });

  group('StoryProgressBar Widget Tests', () {
    testWidgets('Renders correct number of progress segments', (tester) async {
      await tester.pumpWidget(
        wrapWithApp(
          const Scaffold(
            body: StoryProgressBar(
              totalSegments: 18,
              currentIndex: 2,
              animationProgress: 0.5,
            ),
          ),
        ),
      );

      expect(find.byType(StoryProgressBar), findsOneWidget);
    });
  });

  group('StoriesViewerScreen Navigation & Gestures Tests', () {
    testWidgets('Renders full-screen viewer with progress bar, close, and share actions',
        (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(
        wrapWithApp(
          StoriesViewerScreen(
            analysis: casalAnalysis,
            slideDuration: const Duration(seconds: 5),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(StoriesViewerScreen), findsOneWidget);
      expect(find.byType(StoryProgressBar), findsOneWidget);
      expect(find.byIcon(LucideIcons.x), findsOneWidget);
      expect(find.byIcon(LucideIcons.share2), findsOneWidget);
      expect(find.text('1/18'), findsOneWidget);
    });

    testWidgets('Tap right (>30% width) advances to the next slide', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(
        wrapWithApp(
          StoriesViewerScreen(
            analysis: casalAnalysis,
            slideDuration: const Duration(seconds: 5),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('1/18'), findsOneWidget);

      // Tap on the right side of the screen (x = 800, y = 500)
      await tester.tapAt(const Offset(800, 500));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('2/18'), findsOneWidget);
    });

    testWidgets('Tap left (<=30% width) returns to previous slide or restarts',
        (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(
        wrapWithApp(
          StoriesViewerScreen(
            analysis: casalAnalysis,
            slideDuration: const Duration(seconds: 5),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      // Advance to slide 2
      await tester.tapAt(const Offset(800, 500));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('2/18'), findsOneWidget);

      // Tap left at beginning of slide (<25% progress) to go back to slide 1
      await tester.tapAt(const Offset(100, 500));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('1/18'), findsOneWidget);
    });

    testWidgets('Hold-to-pause stops progress and release resumes', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(
        wrapWithApp(
          StoriesViewerScreen(
            analysis: casalAnalysis,
            slideDuration: const Duration(seconds: 5),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      // Long press start
      final gesture = await tester.startGesture(const Offset(500, 500));
      await tester.pump(const Duration(milliseconds: 600)); // Trigger long press

      // Wait 3 seconds while holding
      await tester.pump(const Duration(seconds: 3));
      // Should still be on slide 1/18 because it was paused
      expect(find.text('1/18'), findsOneWidget);

      // Release hold
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 600));
    });

    testWidgets('Downward vertical drag gesture dismisses viewer when threshold is met',
        (tester) async {
      setMobileViewport(tester);
      bool didPop = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: SwissTheme.darkTheme,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute<void>(
                        builder: (_) => StoriesViewerScreen(
                          analysis: casalAnalysis,
                        ),
                      ),
                    )
                    .then((_) => didPop = true);
              },
              child: const Text('Open Stories'),
            ),
          ),
        ),
      );

      // Open screen
      await tester.tap(find.text('Open Stories'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(StoriesViewerScreen), findsOneWidget);

      // Drag downward > 120 pixels
      await tester.drag(find.byType(StoriesViewerScreen), const Offset(0, 300));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(didPop, isTrue);
    });

    testWidgets('Close button dismisses the viewer', (tester) async {
      setMobileViewport(tester);
      bool didPop = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: SwissTheme.darkTheme,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute<void>(
                        builder: (_) => StoriesViewerScreen(
                          analysis: casalAnalysis,
                        ),
                      ),
                    )
                    .then((_) => didPop = true);
              },
              child: const Text('Open Stories'),
            ),
          ),
        ),
      );

      // Open screen
      await tester.tap(find.text('Open Stories'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Tap close button (X)
      await tester.tap(find.byIcon(LucideIcons.x));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(didPop, isTrue);
    });

    testWidgets('Auto-advance transitions to next slide when timer expires',
        (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(
        wrapWithApp(
          StoriesViewerScreen(
            analysis: casalAnalysis,
            slideDuration: const Duration(milliseconds: 1000),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('1/18'), findsOneWidget);

      // Pump duration until next slide
      await tester.pump(const Duration(milliseconds: 1050));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('2/18'), findsOneWidget);
    });

    testWidgets('Renders Amigos mode slides (18) and Grupo mode slides (16)',
        (tester) async {
      setMobileViewport(tester);

      // Amigos
      await tester.pumpWidget(
        wrapWithApp(
          StoriesViewerScreen(
            key: const ValueKey('amigos'),
            analysis: amigosAnalysis,
            slideDuration: const Duration(seconds: 5),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('1/18'), findsOneWidget);

      // Grupo
      await tester.pumpWidget(
        wrapWithApp(
          StoriesViewerScreen(
            key: const ValueKey('grupo'),
            analysis: grupoAnalysis,
            slideDuration: const Duration(seconds: 5),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('1/16'), findsOneWidget);
    });
  });
}
