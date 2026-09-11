import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/analytics/chat_analyzer.dart';
import 'package:chat_wrapped/core/models/general_stats.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';
import 'package:chat_wrapped/stories/cards/story_card_base.dart';
import 'package:chat_wrapped/stories/cards/story_card_factory.dart';
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
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox(
            width: 450,
            height: 800,
            child: child,
          ),
        ),
      ),
    );
  }

  const casalChat = '''
01/02/2025 10:00 - Ana: Oi amor! ❤️
01/02/2025 10:02 - Carlos: Oi linda! Como foi seu dia? 🥰
01/02/2025 12:00 - Ana: Foi maravilhoso! Desculpa a demora! Te amo ❤️
01/02/2025 12:05 - Carlos: Também te amo demais! ❤️
''';

  const amigosChat = '''
01/02/2025 10:00 - Lucas: Bora sair hoje galera?
01/02/2025 10:02 - Mateus: Bora! Levo as coisas 😂
01/02/2025 10:05 - Gabriel: Fechado!
01/02/2025 23:30 - Lucas: Cheguei em casa!
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

  group('StoryCardBase Tests', () {
    testWidgets('Renders header badge, title, subtitle, and watermark footer', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(
        wrapWithApp(
          const StoryCardBase(
            category: 'TESTE CATEGORIA',
            categoryIcon: Icons.star_rounded,
            title: 'TITULO TESTE',
            subtitle: 'Subtítulo explicativo',
            child: Center(child: Text('Corpo do Card')),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('TESTE CATEGORIA'), findsOneWidget);
      expect(find.text('TITULO TESTE'), findsOneWidget);
      expect(find.text('Subtítulo explicativo'), findsOneWidget);
      expect(find.text('Corpo do Card'), findsOneWidget);
      expect(find.text('CHAT WRAPPED'), findsOneWidget);
      expect(find.text('100% OFFLINE • PRIVACIDADE LOCAL'), findsOneWidget);
    });
  });

  group('Casal Story Cards (18 slides)', () {
    final casalSlides = StoryCatalog.getCasalSlides();

    test('Casal slide catalog contains exactly 18 slides', () {
      expect(casalSlides.length, equals(18));
    });

    for (final slide in casalSlides) {
      testWidgets('Renders Casal slide ${slide.id} (${slide.title}) without error', (tester) async {
        setMobileViewport(tester);
        await tester.pumpWidget(
          wrapWithApp(
            StoryCardFactory.buildCard(
              slide: slide,
              analysis: casalAnalysis,
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));

        // Must render at least one text from the slide
        expect(find.byType(StoryCardBase), findsOneWidget);

        // Zero paywalls check
        expect(find.text('Comprar Pro'), findsNothing);
        expect(find.text('Assine'), findsNothing);
        expect(find.text('Bloqueado'), findsNothing);
        expect(find.byIcon(Icons.lock), findsNothing);
      });
    }

    testWidgets('Slide c18 triggers onShare callback when share button tapped', (tester) async {
      setMobileViewport(tester);
      bool shareCalled = false;
      final slide18 = casalSlides.firstWhere((s) => s.id == 'c18');

      await tester.pumpWidget(
        wrapWithApp(
          StoryCardFactory.buildCard(
            slide: slide18,
            analysis: casalAnalysis,
            onShare: () => shareCalled = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byIcon(Icons.share_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.share_rounded));
      await tester.pump(const Duration(milliseconds: 600));

      expect(shareCalled, isTrue);
    });
  });

  group('Amigos Story Cards (18 slides)', () {
    final amigosSlides = StoryCatalog.getAmigosSlides();

    test('Amigos slide catalog contains exactly 18 slides', () {
      expect(amigosSlides.length, equals(18));
    });

    for (final slide in amigosSlides) {
      testWidgets('Renders Amigos slide ${slide.id} (${slide.title}) without error', (tester) async {
        setMobileViewport(tester);
        await tester.pumpWidget(
          wrapWithApp(
            StoryCardFactory.buildCard(
              slide: slide,
              analysis: amigosAnalysis,
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));

        expect(find.byType(StoryCardBase), findsOneWidget);

        // Zero paywalls check
        expect(find.text('Comprar Pro'), findsNothing);
        expect(find.text('Assine'), findsNothing);
        expect(find.text('Bloqueado'), findsNothing);
        expect(find.byIcon(Icons.lock), findsNothing);
      });
    }

    testWidgets('Slide a18 triggers onShare callback when share button tapped', (tester) async {
      setMobileViewport(tester);
      bool shareCalled = false;
      final slide18 = amigosSlides.firstWhere((s) => s.id == 'a18');

      await tester.pumpWidget(
        wrapWithApp(
          StoryCardFactory.buildCard(
            slide: slide18,
            analysis: amigosAnalysis,
            onShare: () => shareCalled = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byIcon(Icons.share_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.share_rounded));
      await tester.pump(const Duration(milliseconds: 600));

      expect(shareCalled, isTrue);
    });
  });

  group('Grupo Story Cards (16 slides)', () {
    final grupoSlides = StoryCatalog.getGrupoSlides();

    test('Grupo slide catalog contains exactly 16 slides', () {
      expect(grupoSlides.length, equals(16));
    });

    for (final slide in grupoSlides) {
      testWidgets('Renders Grupo slide ${slide.id} (${slide.title}) without error', (tester) async {
        setMobileViewport(tester);
        await tester.pumpWidget(
          wrapWithApp(
            StoryCardFactory.buildCard(
              slide: slide,
              analysis: grupoAnalysis,
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));

        expect(find.byType(StoryCardBase), findsOneWidget);

        // Zero paywalls check
        expect(find.text('Comprar Pro'), findsNothing);
        expect(find.text('Assine'), findsNothing);
        expect(find.text('Bloqueado'), findsNothing);
        expect(find.byIcon(Icons.lock), findsNothing);
      });
    }

    testWidgets('Slide g16 triggers onShare callback when share button tapped', (tester) async {
      setMobileViewport(tester);
      bool shareCalled = false;
      final slide16 = grupoSlides.firstWhere((s) => s.id == 'g16');

      await tester.pumpWidget(
        wrapWithApp(
          StoryCardFactory.buildCard(
            slide: slide16,
            analysis: grupoAnalysis,
            onShare: () => shareCalled = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byIcon(Icons.share_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.share_rounded));
      await tester.pump(const Duration(milliseconds: 600));

      expect(shareCalled, isTrue);
    });
  });
}
