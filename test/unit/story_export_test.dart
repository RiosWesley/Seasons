import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:chat_wrapped/core/analytics/chat_analyzer.dart';
import 'package:chat_wrapped/core/models/general_stats.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';
import 'package:chat_wrapped/export/story_export_service.dart';
import 'package:chat_wrapped/screens/dashboard_screen.dart';
import 'package:chat_wrapped/stories/cards/story_card_base.dart';
import 'package:chat_wrapped/stories/stories_viewer_screen.dart';
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
      home: Scaffold(
        body: child,
      ),
    );
  }

  const casalChat = '''
01/02/2025 10:00 - Ana: Oi amor! ❤️
01/02/2025 10:02 - Carlos: Oi linda! Como foi seu dia? 🥰
01/02/2025 12:00 - Ana: Foi maravilhoso! Te amo ❤️
01/02/2025 12:05 - Carlos: Também te amo demais! ❤️
''';

  final parsedExport = const ChatParser().parse(casalChat);
  final casalAnalysis = ChatAnalyzer.analyzeRawExport(
    parsedExport,
    overrideMode: ChatMode.casal,
  );

  group('StoryExportService Constants Tests', () {
    test('Standard dimensions adhere to 9:16 vertical stories format', () {
      expect(StoryExportService.exportWidth, equals(1080));
      expect(StoryExportService.exportHeight, equals(1920));
      expect(StoryExportService.targetAspectRatio, equals(9 / 16));
      expect(StoryExportService.exportFilePrefix, equals('chat_wrapped_story_'));
      expect(StoryExportService.defaultShareText, contains('WhatsApp Wrapped'));
    });
  });

  group('StoryExportService Resilience Tests', () {
    test('shareStoryImage handles empty image path without throwing', () async {
      await expectLater(
        StoryExportService.shareStoryImage(''),
        completes,
      );
    });

    test('shareStoryImage handles non-existent file path without throwing', () async {
      await expectLater(
        StoryExportService.shareStoryImage('/invalid/path/to/story_image.png'),
        completes,
      );
    });

    test('captureStoryCardToPng returns null for unmounted GlobalKey', () async {
      final unmountedKey = GlobalKey();
      final result = await StoryExportService.captureStoryCardToPng(unmountedKey);
      expect(result, isNull);
    });

    testWidgets('captureStoryCardToPng returns null when key is attached to non-RepaintBoundary widget',
        (tester) async {
      final containerKey = GlobalKey();
      await tester.pumpWidget(
        wrapWithApp(
          Container(
            key: containerKey,
            width: 300,
            height: 300,
            color: Colors.red,
          ),
        ),
      );
      await tester.pump();

      final result = await StoryExportService.captureStoryCardToPng(containerKey);
      expect(result, isNull);
    });

    testWidgets('exportAndShare shows SnackBar when capture fails and context is provided',
        (tester) async {
      final unmountedKey = GlobalKey();
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: SwissTheme.darkTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      await tester.pump();

      final success = await StoryExportService.exportAndShare(
        unmountedKey,
        context: testContext,
      );
      await tester.pump(); // Pump SnackBar animation

      expect(success, isFalse);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Erro ao gerar imagem para compartilhamento.'), findsOneWidget);
    });
  });

  group('StoryExportService RenderRepaintBoundary Tests', () {
    testWidgets('RepaintBoundary around StoryCardBase successfully attaches, lays out, and calculates export ratio',
        (tester) async {
      setMobileViewport(tester);
      final boundaryKey = GlobalKey();

      await tester.pumpWidget(
        wrapWithApp(
          RepaintBoundary(
            key: boundaryKey,
            child: const StoryCardBase(
              category: 'EXPORT TEST',
              categoryIcon: Icons.share_rounded,
              title: 'EXPORT 9:16',
              subtitle: 'Validating pixel pipeline',
              child: Center(
                child: Text('Test Content for PNG Capture'),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      expect(boundary, isNotNull);
      expect(boundary!.hasSize, isTrue);
      expect(boundary.size.width, greaterThan(0));
      expect(boundary.size.height, greaterThan(0));

      // Calculate pixelRatio target (1080 / logicalWidth)
      final logicalWidth = boundary.size.width;
      final targetRatio = StoryExportService.exportWidth / logicalWidth;
      expect(targetRatio, greaterThan(0));
      expect(boundary.isRepaintBoundary, isTrue);
    });
  });

  group('DashboardScreen Story Navigation Integration', () {
    testWidgets('Tapping Iniciar Wrapped button on DashboardScreen opens StoriesViewerScreen',
        (tester) async {
      setMobileViewport(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: SwissTheme.darkTheme,
          home: DashboardScreen(
            analysis: casalAnalysis,
            rawExport: parsedExport,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the hero button "Iniciar Wrapped (9:16 Stories)"
      final storyButtonFinder = find.text('Iniciar Wrapped (9:16 Stories)');
      expect(storyButtonFinder, findsOneWidget);

      await tester.tap(storyButtonFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // StoriesViewerScreen should now be mounted
      expect(find.byType(StoriesViewerScreen), findsOneWidget);
    });

    testWidgets('Tapping AppBar share button on DashboardScreen opens StoriesViewerScreen',
        (tester) async {
      setMobileViewport(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: SwissTheme.darkTheme,
          home: DashboardScreen(
            analysis: casalAnalysis,
            rawExport: parsedExport,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the action icon in AppBar
      final shareIconFinder = find.byIcon(LucideIcons.share2);
      expect(shareIconFinder, findsOneWidget);

      await tester.tap(shareIconFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // StoriesViewerScreen should now be mounted
      expect(find.byType(StoriesViewerScreen), findsOneWidget);
    });
  });
}
