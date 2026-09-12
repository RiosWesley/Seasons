import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/analytics/chat_analyzer.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';
import 'package:chat_wrapped/screens/dashboard_screen.dart';
import 'package:chat_wrapped/screens/home_screen.dart';
import 'package:chat_wrapped/screens/mode_selection_screen.dart';
import 'package:chat_wrapped/theme/swiss_theme.dart';

void main() {
  void setMobileViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
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

  const sampleCasalChat = '''
01/02/2025 10:00 - Ana: Oi meu amor! ❤️
01/02/2025 10:02 - Carlos: Oi linda! Como foi seu dia? 🥰
01/02/2025 12:00 - Ana: Foi ótimo! Te amo muito ❤️
01/02/2025 12:05 - Carlos: Também te amo! ❤️
''';

  const sampleAmigosChat = '''
01/02/2025 10:00 - Lucas: Galera, bora marcar aquele churrasco?
01/02/2025 10:02 - Mateus: Bora demais! Levo as carnes 😂
01/02/2025 10:05 - Gabriel: Fechado! Levo as bebidas!
''';

  const sampleGrupoChat = '''
01/02/2025 10:00 - Alice: Bom dia grupo!
01/02/2025 10:01 - Bruno: Bom dia!
01/02/2025 10:02 - Clara: Bom dia pessoal!
01/02/2025 10:03 - Diego: E aí galera!
01/02/2025 10:04 - Eduardo: Fala time!
01/02/2025 10:05 - Fernanda: Bora trabalhar!
''';

  group('HomeScreen Tests', () {
    testWidgets('Renders Swiss-minimalist hero, privacy badge, and action buttons', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(wrapWithApp(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('seasons'), findsOneWidget);
      expect(find.text('Como exportar do WhatsApp? Ver tutorial →'), findsOneWidget);
      expect(find.text('Experimentar com uma conversa de exemplo'), findsOneWidget);
      expect(find.text('ESCOLHA UMA LENTE DE ANÁLISE'), findsOneWidget);
    });

    testWidgets('Triggers demo retrospective and transitions to ModeSelectionScreen', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(wrapWithApp(const HomeScreen()));
      await tester.pumpAndSettle();

      // Tap demo button
      await tester.tap(find.text('Experimentar com uma conversa de exemplo'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Should have navigated to ModeSelectionScreen
      expect(find.text('Configurar Retrospectiva'), findsOneWidget);
      expect(find.text('Participantes Detectados (2)'), findsOneWidget);
      expect(find.text('Modo Casal'), findsOneWidget);
      expect(find.text('Recomendado'), findsOneWidget);
    });
  });

  group('ModeSelectionScreen Tests', () {
    testWidgets('Recommends Casal for 2 participants and allows mode confirmation', (tester) async {
      setMobileViewport(tester);
      final export = const ChatParser().parse(sampleCasalChat);
      final analysis = ChatAnalyzer.analyzeRawExport(export);

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export,
            initialAnalysis: analysis,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (2)'), findsOneWidget);
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Carlos'), findsOneWidget);
      expect(find.text('Modo Casal'), findsOneWidget);
      expect(find.text('Continuar para o Dashboard'), findsOneWidget);

      await tester.ensureVisible(find.text('Continuar para o Dashboard'));
      await tester.tap(find.text('Continuar para o Dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('Relatório Completo'), findsOneWidget);
    });

    testWidgets('3 participants routes to Grupo mode', (tester) async {
      setMobileViewport(tester);
      final amigosExport = const ChatParser().parse(sampleAmigosChat);
      final amigosAnalysis = ChatAnalyzer.analyzeRawExport(amigosExport);

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: amigosExport,
            initialAnalysis: amigosAnalysis,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (3)'), findsOneWidget);
      expect(find.text('Modo Grupo'), findsOneWidget);
      expect(find.text('Modo Amigos'), findsNothing);
    });
  });

  group('DashboardScreen Tests & 100% Free Verification', () {
    testWidgets('Casal Dashboard displays stats, love language, and zero paywalls', (tester) async {
      setMobileViewport(tester);
      final export = const ChatParser().parse(sampleCasalChat);
      final analysis = ChatAnalyzer.analyzeCasal(export.messages);

      await tester.pumpWidget(
        wrapWithApp(
          DashboardScreen(
            analysis: analysis,
            rawExport: export,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Relatório Completo'), findsOneWidget);
      expect(find.text('Modo Casal'), findsOneWidget);
      expect(find.text('Iniciar Wrapped (9:16 Stories)'), findsOneWidget);

      await tester.ensureVisible(find.text('Linguagem do Amor (Love Language)'));
      expect(find.text('Linguagem do Amor (Love Language)'), findsOneWidget);
      expect(find.text('Estatísticas de Resposta & Vácuo'), findsOneWidget);

      // Verify ZERO paywalls, zero subscription locks, zero "Pro" gates
      expect(find.text('Comprar Pro'), findsNothing);
      expect(find.text('Assine'), findsNothing);
      expect(find.text('Bloqueado'), findsNothing);
    });

    testWidgets('Amigos Dashboard displays squad communication archetypes', (tester) async {
      setMobileViewport(tester);
      final export = const ChatParser().parse(sampleAmigosChat);
      final analysis = ChatAnalyzer.analyzeAmigos(export.messages);

      await tester.pumpWidget(
        wrapWithApp(
          DashboardScreen(
            analysis: analysis,
            rawExport: export,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Modo Amigos'), findsOneWidget);
      await tester.ensureVisible(find.text('Estilos de Comunicação do Squad'));
      expect(find.text('Estilos de Comunicação do Squad'), findsOneWidget);
      expect(find.text('Dinâmica do Grupo'), findsOneWidget);
      expect(find.text('Comprar Pro'), findsNothing);
    });

    testWidgets('Grupo Dashboard displays member activity leaderboard and podium', (tester) async {
      setMobileViewport(tester);
      final export = const ChatParser().parse(sampleGrupoChat);
      final analysis = ChatAnalyzer.analyzeGrupo(export.messages);

      await tester.pumpWidget(
        wrapWithApp(
          DashboardScreen(
            analysis: analysis,
            rawExport: export,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Modo Grupo'), findsOneWidget);
      await tester.ensureVisible(find.text('Leaderboard de Membros Mais Ativos'));
      expect(find.text('Leaderboard de Membros Mais Ativos'), findsOneWidget);
      expect(find.text('Destaques de Interação'), findsOneWidget);
      expect(find.text('Comprar Pro'), findsNothing);
    });
  });
}
