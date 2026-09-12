import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/analytics/chat_analyzer.dart';
import 'package:chat_wrapped/core/models/general_stats.dart';
import 'package:chat_wrapped/core/models/grupo_stats.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';
import 'package:chat_wrapped/stories/adapters/grupo_story_adapter.dart';
import 'package:chat_wrapped/stories/cards/grupo_story_cards.dart';
import 'package:chat_wrapped/stories/cards/story_card_base.dart';
import 'package:chat_wrapped/theme/swiss_theme.dart';
import 'package:chat_wrapped/widgets/stories/grupo/grupo_theme.dart';

void main() {
  const sampleGrupoChat = '''
01/01/2025 10:00 - Alice: Bom dia galera! Hoje tem churrasco? 😂
01/01/2025 10:02 - Bob: Com certeza! Eu levo a carne e as bebidas. 🔥
01/01/2025 10:05 - Charlie: Confirmadíssimo, levo o carvão e o som. 👏
01/01/2025 10:06 - Diana: Maravilha, eu preparo as saladas e sobremesas! ❤️
01/01/2025 10:10 - Eduardo: Fechado, chego lá pelas 13h.
01/01/2025 10:15 - Fernanda: Estou dentro também!
01/01/2025 14:00 - Alice: Chegando no local do churrasco galera!
01/01/2025 14:05 - Bob: O fogo já tá aceso! 🔥🔥
01/01/2025 14:10 - Charlie: Alguém traz mais gelo por favor!
01/01/2025 14:12 - Diana: Estou levando!
01/01/2025 21:00 - Alice: Valeu demais galera, melhor encontro do ano! 😂👏
01/01/2025 21:05 - Bob: Foi épico demais!
01/01/2025 21:10 - Charlie: Próximo mês tem de novo!
''';

  final parsed = const ChatParser().parse(sampleGrupoChat);
  final analysis = ChatAnalyzer.analyzeRawExport(
    parsed,
    overrideMode: ChatMode.grupo,
  ) as GrupoAnalysisResult;

  void setMobileViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2.0;
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

  group('GrupoStoryAdapter Derivations with Real Analysis', () {
    test('Calculates literary book equivalence and Pareto share properly', () {
      final adapter = GrupoStoryAdapter(analysis);
      expect(adapter.totalMessages, greaterThan(0));
      expect(adapter.memberCount, equals(6));
      expect(adapter.literaryBookEquivalence, greaterThanOrEqualTo(1));
      expect(adapter.literaryBookDescription, contains('volumes de Dom Casmurro'));
      expect(adapter.paretoTopSharePercentage, inInclusiveRange(1, 100));
      expect(adapter.primaryInsight, isNotEmpty);
    });

    test('Derives all champion identities safely', () {
      final adapter = GrupoStoryAdapter(analysis);
      expect(adapter.interactionChampion, isNotEmpty);
      expect(adapter.vacuumChampion, isNotEmpty);
      expect(adapter.reporterName, isNotEmpty);
      expect(adapter.forwarderName, isNotEmpty);
      expect(adapter.unsendGhostName, isNotEmpty);
      expect(adapter.reporterPrintCount, greaterThanOrEqualTo(1));
      expect(adapter.forwardedCount, greaterThanOrEqualTo(10));
      expect(adapter.unsendCount, greaterThanOrEqualTo(5));
    });
  });

  group('Grupo Story Cards 16 Slides Rendering and Verification', () {
    final slideIds = [
      'g1', 'g2', 'g3', 'g4', 'g5', 'g6', 'g7', 'g8',
      'g9', 'g10', 'g11', 'g12', 'g13', 'g14', 'g15', 'g16',
    ];

    for (final slideId in slideIds) {
      testWidgets('Slide $slideId renders StoryCardBase and contains zero paywall / forbidden text', (tester) async {
        setMobileViewport(tester);
        await tester.pumpWidget(
          wrapWithApp(
            GrupoStoryCards.buildSlide(
              slideId: slideId,
              analysis: analysis,
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));

        // Must find StoryCardBase
        expect(find.byType(StoryCardBase), findsOneWidget);

        // Zero paywalls
        expect(find.text('Comprar Pro'), findsNothing);
        expect(find.text('Assine'), findsNothing);
        expect(find.text('Bloqueado'), findsNothing);
        expect(find.byIcon(Icons.lock), findsNothing);

        // Zero legacy branding
        expect(find.text('CHAT WRAPPED'), findsNothing);
        expect(find.text('100% OFFLINE'), findsNothing);
      });
    }

    testWidgets('Slide g16 triggers onShare callback when share button is tapped', (tester) async {
      setMobileViewport(tester);
      bool shareTriggered = false;

      await tester.pumpWidget(
        wrapWithApp(
          GrupoStoryCards.buildSlide(
            slideId: 'g16',
            analysis: analysis,
            onShare: () => shareTriggered = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      final shareFinder = find.byIcon(Icons.share_rounded);
      expect(shareFinder, findsOneWidget);

      await tester.tap(shareFinder);
      await tester.pump(const Duration(milliseconds: 600));

      expect(shareTriggered, isTrue);
    });

    test('GrupoTheme constants conform to aesthetic specifications', () {
      expect(GrupoTheme.paperBase, equals(const Color(0xFFFAF6FD)));
      expect(GrupoTheme.inkPrimary, equals(const Color(0xFF1E1B4B)));
      expect(GrupoTheme.accentPrimary, equals(const Color(0xFF7C3AED)));
      expect(GrupoTheme.medalGold, equals(const Color(0xFFEAB308)));
    });
  });
}
