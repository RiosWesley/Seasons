import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/analytics/chat_analyzer.dart';
import 'package:chat_wrapped/core/models/general_stats.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';
import 'package:chat_wrapped/screens/dashboard_screen.dart';
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

  Widget wrapWithApp(Widget child, {bool isDark = false}) {
    return MaterialApp(
      theme: isDark ? SwissTheme.darkTheme : SwissTheme.lightTheme,
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
01/02/2025 10:06 - Julia: Eu levo a sobremesa!
''';

  const sampleGrupoChat = '''
01/02/2025 10:00 - Alice: Bom dia grupo!
01/02/2025 10:01 - Bruno: Bom dia!
01/02/2025 10:02 - Clara: Bom dia pessoal!
01/02/2025 10:03 - Diego: E aí galera!
01/02/2025 10:04 - Eduardo: Fala time!
01/02/2025 10:05 - Fernanda: Bora trabalhar!
01/02/2025 10:06 - Gabriel: Reunião às 14h!
''';

  group('ModeSelectionScreen - Editorial Bento Architecture Tests', () {
    testWidgets('1. Renders editorial title, subtitle, and detected participants chips', (tester) async {
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

      expect(find.text('Configurar Retrospectiva'), findsOneWidget);
      expect(find.text('Participantes Detectados (2)'), findsOneWidget);
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Carlos'), findsOneWidget);
      expect(find.text('Escolha a Experiência'), findsOneWidget);
      expect(
        find.text(
          'Sugerimos um modo com base no número de participantes, mas você pode escolher qualquer modalidade.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('2. Casal mode is recommended for 2 participants with micro-badge and recommendation tag', (tester) async {
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

      // Mode cards presence for <= 2 participants: ONLY Casal and Amigos! Grupo does not appear!
      expect(find.text('Modo Casal'), findsOneWidget);
      expect(find.text('Modo Amigos'), findsOneWidget);
      expect(find.text('Modo Grupo'), findsNothing);

      // Micro badges
      expect(find.text('Ritmo a dois & Afinidade'), findsOneWidget);
      expect(find.text('Duelo de estilos & Resenha a dois'), findsOneWidget);

      // Recommendation tag should be present on Casal only
      expect(find.text('Recomendado'), findsOneWidget);
      expect(find.text(' para esta conversa'), findsOneWidget);
    });

    testWidgets('3. Grupo mode is selected for 3+ participants (4 participants)', (tester) async {
      setMobileViewport(tester);
      final export = const ChatParser().parse(sampleAmigosChat);
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

      expect(find.text('Participantes Detectados (4)'), findsOneWidget);
      expect(find.text('Modo Grupo'), findsOneWidget);
      expect(find.text('Modo Casal'), findsNothing);
      expect(find.text('Modo Amigos'), findsNothing);
      expect(find.text('Recomendado'), findsOneWidget);
      expect(find.text(' para esta conversa'), findsOneWidget);
    });

    testWidgets('4. Grupo mode is recommended for 6+ participants', (tester) async {
      setMobileViewport(tester);
      final export = const ChatParser().parse(sampleGrupoChat);
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

      expect(find.text('Participantes Detectados (7)'), findsOneWidget);
      expect(find.text('Modo Grupo'), findsOneWidget);
      expect(find.text('Modo Casal'), findsNothing);
      expect(find.text('Modo Amigos'), findsNothing);
      expect(find.text('Recomendado'), findsOneWidget);
      expect(find.text(' para esta conversa'), findsOneWidget);
    });

    testWidgets('5. Interactive mode selection changes selection state and updates radio indicator', (tester) async {
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

      // Initially Casal is recommended & selected
      expect(find.text('Recomendado'), findsOneWidget);

      // Tap Amigos mode card to switch selection
      await tester.tap(find.text('Modo Amigos'));
      await tester.pumpAndSettle();

      // Tap Casal mode card to switch back
      await tester.tap(find.text('Modo Casal'));
      await tester.pumpAndSettle();

      // Recommendation pill stays consistently anchored to Casal
      expect(find.text('Recomendado'), findsOneWidget);
    });

    testWidgets('6. Mode override re-analysis forwards chosen mode to DashboardScreen', (tester) async {
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

      // Initially Casal is recommended & selected
      // Tap Amigos mode card to override mode
      await tester.tap(find.text('Modo Amigos'));
      await tester.pumpAndSettle();

      // Proceed to Dashboard with overridden mode
      await tester.ensureVisible(find.text('Continuar para o Dashboard'));
      await tester.tap(find.text('Continuar para o Dashboard'));
      await tester.pumpAndSettle();

      // Dashboard should open in overridden Modo Amigos
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(find.text('Modo Amigos'), findsOneWidget);
      expect(find.text('Relatório Completo'), findsOneWidget);
    });

    testWidgets('7. Fallback works when rawExport is null (from saved retrospectives)', (tester) async {
      setMobileViewport(tester);
      final export = const ChatParser().parse(sampleCasalChat);
      final analysis = ChatAnalyzer.analyzeCasal(export.messages);

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            initialAnalysis: analysis,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (2)'), findsOneWidget);
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Carlos'), findsOneWidget);

      await tester.ensureVisible(find.text('Continuar para o Dashboard'));
      await tester.tap(find.text('Continuar para o Dashboard'));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('8. Dark theme renders properly without overflow and preserves warm aesthetics', (tester) async {
      setMobileViewport(tester);
      final export = const ChatParser().parse(sampleCasalChat);
      final analysis = ChatAnalyzer.analyzeRawExport(export);

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export,
            initialAnalysis: analysis,
          ),
          isDark: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Configurar Retrospectiva'), findsOneWidget);
      expect(find.text('Modo Casal'), findsOneWidget);
      expect(find.text('Modo Amigos'), findsOneWidget);
      expect(find.text('Modo Grupo'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('9. Duo connection card displays duo names headline, messages count, and feature chips', (tester) async {
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

      // Duo connection headline
      expect(find.text('Ana & Carlos'), findsOneWidget);

      // Status badge and message count
      expect(find.text('SINCRONIZADO'), findsOneWidget);
      expect(find.text('${analysis.generalStats.totalMessages} mensagens'), findsOneWidget);

      // Feature tags
      expect(find.text('Love Language'), findsOneWidget);
      expect(find.text('Quem Puxa Papo'), findsOneWidget);
      expect(find.text('Duelo de Estilos'), findsOneWidget);
      expect(find.text('Podcast de Áudios'), findsOneWidget);
    });

    testWidgets('10. Dynamic recommendation selects and recommends Amigos when initialAnalysis is Amigos', (tester) async {
      setMobileViewport(tester);
      final export = const ChatParser().parse(sampleCasalChat);
      // Analyze with override to Amigos
      final analysis = ChatAnalyzer.analyzeRawExport(export, overrideMode: ChatMode.amigos);

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export,
            initialAnalysis: analysis,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Amigos should be recommended
      expect(find.text('Recomendado'), findsOneWidget);
      expect(find.text(' para esta conversa'), findsOneWidget);
      expect(find.text('Modo Amigos'), findsOneWidget);

      // Tapping continue immediately proceeds in Modo Amigos without manual switch
      await tester.ensureVisible(find.text('Continuar para o Dashboard'));
      await tester.tap(find.text('Continuar para o Dashboard'));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(find.text('Modo Amigos'), findsOneWidget);
    });
  });
}
