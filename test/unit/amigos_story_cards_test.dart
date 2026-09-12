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

  const squad5Chat = '''
01/01/2025 10:00 - Felipe: Salve squad! Hoje tem churrasco?
01/01/2025 10:01 - Caio: Opa com certeza! Levo a carne 🔥
01/01/2025 10:02 - Rodrigo: Eu levo as bebidas 🍻
01/01/2025 10:03 - Bruno: Fechou demais galera 😂
01/01/2025 10:04 - Thiago: Chego mais tarde!
01/01/2025 10:05 - Felipe: Blz galera!
01/01/2025 10:06 - Felipe: Não esqueçam do gelo
01/01/2025 10:07 - Felipe: Alô?
01/01/2025 10:08 - Felipe: Alguém responde aí kkkk
01/01/2025 23:30 - Caio: Foi épico demais!
''';

  final squadAnalysis = ChatAnalyzer.analyzeRawExport(
    const ChatParser().parse(squad5Chat),
    overrideMode: ChatMode.amigos,
  );

  group('Dedicated Amigos Mode Story Cards Test Suite (a1..a18)', () {
    final slides = StoryCatalog.getAmigosSlides();

    test('Catalog holds exactly 18 Amigos slides', () {
      expect(slides.length, equals(18));
    });

    for (final slide in slides) {
      testWidgets('Slide ${slide.id} (${slide.title}) renders cleanly with StoryCardBase and zero paywall', (tester) async {
        setMobileViewport(tester);
        await tester.pumpWidget(
          wrapWithApp(
            StoryCardFactory.buildCard(
              slide: slide,
              analysis: squadAnalysis,
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));

        // Must render StoryCardBase
        expect(find.byType(StoryCardBase), findsOneWidget);

        // Zero paywalls
        expect(find.text('Comprar Pro'), findsNothing);
        expect(find.text('Assine'), findsNothing);
        expect(find.text('Bloqueado'), findsNothing);
        expect(find.byIcon(Icons.lock), findsNothing);

        // Zero legacy brandings
        expect(find.text('CHAT WRAPPED'), findsNothing);
        expect(find.text('100% OFFLINE'), findsNothing);
      });
    }

    testWidgets('Slide a18 triggers onShare callback on tap', (tester) async {
      setMobileViewport(tester);
      bool shareCalled = false;
      final slide18 = slides.firstWhere((s) => s.id == 'a18');

      await tester.pumpWidget(
        wrapWithApp(
          StoryCardFactory.buildCard(
            slide: slide18,
            analysis: squadAnalysis,
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
