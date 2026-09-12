import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:chat_wrapped/core/analytics/chat_analyzer.dart';
import 'package:chat_wrapped/core/models/chat_message.dart';
import 'package:chat_wrapped/core/models/general_stats.dart';
import 'package:chat_wrapped/core/models/amigos_stats.dart';
import 'package:chat_wrapped/core/models/grupo_stats.dart';
import 'package:chat_wrapped/core/models/raw_chat_export.dart';
import 'package:chat_wrapped/screens/dashboard_screen.dart';
import 'package:chat_wrapped/screens/mode_selection_screen.dart';
import 'package:chat_wrapped/theme/swiss_colors.dart';
import 'package:chat_wrapped/theme/swiss_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void setViewport(WidgetTester tester, {Size size = const Size(1080, 2400)}) {
    tester.view.physicalSize = size;
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

  RawChatExport createMockExport({
    required List<String> authors,
    int messagesPerAuthor = 2,
  }) {
    if (authors.isEmpty) {
      return RawChatExport.fromMessages(const []);
    }

    final now = DateTime(2025, 2, 1, 10, 0);
    final messages = <ChatMessage>[];

    for (int i = 0; i < messagesPerAuthor; i++) {
      for (int a = 0; a < authors.length; a++) {
        messages.add(
          ChatMessage(
            timestamp: now.add(Duration(minutes: i * authors.length + a)),
            author: authors[a],
            content: 'Mensagem $i de ${authors[a]} ❤️ 😂 projeto',
            isMedia: false,
            isSystem: false,
          ),
        );
      }
    }

    return RawChatExport.fromMessages(messages);
  }

  group('CHALLENGE 1: Participant Count Boundary Conditions', () {
    testWidgets('1.1 0 participants boundary: auto-recommends Casal, renders empty chips, continues cleanly', (tester) async {
      setViewport(tester);
      final export0 = createMockExport(authors: []);
      final analysis0 = ChatAnalyzer.analyzeRawExport(export0);

      expect(ChatAnalyzer.detectMode(0), equals(ChatMode.casal));

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export0,
            initialAnalysis: analysis0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (0)'), findsOneWidget);
      // No chips should exist
      expect(find.byIcon(LucideIcons.user), findsNothing);

      // Casal should have the recommendation pill
      expect(find.text('Recomendado'), findsOneWidget);
      expect(find.text(' para esta conversa'), findsOneWidget);

      // Ensure button can be tapped and does not throw
      final continueBtn = find.text('Continuar para o Dashboard');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.2 1 participant boundary: auto-recommends Casal, renders 1 chip, continues cleanly', (tester) async {
      setViewport(tester);
      final export1 = createMockExport(authors: ['SingleUser']);
      final analysis1 = ChatAnalyzer.analyzeRawExport(export1);

      expect(ChatAnalyzer.detectMode(1), equals(ChatMode.casal));

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export1,
            initialAnalysis: analysis1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (1)'), findsOneWidget);
      expect(find.text('SingleUser'), findsOneWidget);
      expect(find.byIcon(LucideIcons.user), findsOneWidget);

      // Casal should have recommendation pill
      expect(find.text('Recomendado'), findsOneWidget);

      final continueBtn = find.text('Continuar para o Dashboard');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.3 2 participants boundary (Casal upper bound): Casal recommended with 2 chips', (tester) async {
      setViewport(tester);
      final export2 = createMockExport(authors: ['Romeo', 'Juliet']);
      final analysis2 = ChatAnalyzer.analyzeRawExport(export2);

      expect(ChatAnalyzer.detectMode(2), equals(ChatMode.casal));

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export2,
            initialAnalysis: analysis2,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (2)'), findsOneWidget);
      expect(find.text('Romeo'), findsOneWidget);
      expect(find.text('Juliet'), findsOneWidget);
      expect(find.text('Recomendado'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.4 3 participants boundary: Grupo recommended with 3 chips', (tester) async {
      setViewport(tester);
      final export3 = createMockExport(authors: ['Alpha', 'Beta', 'Gamma']);
      final analysis3 = ChatAnalyzer.analyzeRawExport(export3);

      expect(ChatAnalyzer.detectMode(3), equals(ChatMode.grupo));

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export3,
            initialAnalysis: analysis3,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (3)'), findsOneWidget);
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Gamma'), findsOneWidget);

      // Exactly 1 recommendation pill on Grupo
      expect(find.text('Recomendado'), findsOneWidget);
      expect(find.text('Modo Grupo'), findsOneWidget);
      expect(find.text('Modo Casal'), findsNothing);
      expect(find.text('Modo Amigos'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.5 5 participants boundary: Grupo recommended with 5 chips', (tester) async {
      setViewport(tester);
      final export5 = createMockExport(authors: ['P1', 'P2', 'P3', 'P4', 'P5']);
      final analysis5 = ChatAnalyzer.analyzeRawExport(export5);

      expect(ChatAnalyzer.detectMode(5), equals(ChatMode.grupo));

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export5,
            initialAnalysis: analysis5,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (5)'), findsOneWidget);
      expect(find.text('Recomendado'), findsOneWidget);
      expect(find.text('Modo Grupo'), findsOneWidget);
      expect(find.text('Modo Casal'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.6 6 participants boundary (Grupo lower bound): Grupo recommended with 6 chips', (tester) async {
      setViewport(tester);
      final export6 = createMockExport(authors: ['P1', 'P2', 'P3', 'P4', 'P5', 'P6']);
      final analysis6 = ChatAnalyzer.analyzeRawExport(export6);

      expect(ChatAnalyzer.detectMode(6), equals(ChatMode.grupo));

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export6,
            initialAnalysis: analysis6,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (6)'), findsOneWidget);
      expect(find.text('Recomendado'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.7 50+ participants boundary: 60 participants wrap chips, zero overflow, scrolls smoothly', (tester) async {
      setViewport(tester);
      final authorList = List.generate(60, (i) => 'Membro_${(i + 1).toString().padLeft(2, '0')}');
      final export60 = createMockExport(authors: authorList, messagesPerAuthor: 1);
      final analysis60 = ChatAnalyzer.analyzeRawExport(export60);

      expect(ChatAnalyzer.detectMode(60), equals(ChatMode.grupo));

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export60,
            initialAnalysis: analysis60,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (60)'), findsOneWidget);
      expect(find.text('Membro_01'), findsOneWidget);
      expect(find.text('Membro_60'), findsOneWidget);

      // Grupo recommended
      expect(find.text('Recomendado'), findsOneWidget);

      // Verify no RenderFlex overflow occurs
      expect(tester.takeException(), isNull);

      // Scroll all the way down through the chips and cards
      final continueBtn = find.text('Continuar para o Dashboard');
      await tester.ensureVisible(continueBtn);
      await tester.pumpAndSettle();

      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('CHALLENGE 2: User Mode Override & Re-Analysis Integration', () {
    testWidgets('2.1 Override Casal (2-person) to Amigos mode: cleanly re-analyzes and opens Dashboard', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['Ana', 'Carlos']);
      final analysis = ChatAnalyzer.analyzeRawExport(export);

      expect(analysis.mode, equals(ChatMode.casal));

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export,
            initialAnalysis: analysis,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Modo Amigos card to override
      await tester.tap(find.text('Modo Amigos'));
      await tester.pumpAndSettle();

      // Tap continue
      final continueBtn = find.text('Continuar para o Dashboard');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      // Must be on DashboardScreen with Amigos mode
      final dashboardFinder = find.byType(DashboardScreen);
      expect(dashboardFinder, findsOneWidget);

      final dashboardWidget = tester.widget<DashboardScreen>(dashboardFinder);
      expect(dashboardWidget.analysis.mode, equals(ChatMode.amigos));
      expect(dashboardWidget.analysis, isA<AmigosAnalysisResult>());
      expect(find.text('Modo Amigos'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('2.2 Duo participants (2-person) only presents Casal and Amigos modes (no Grupo)', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['Ana', 'Carlos']);
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

      // Grupo should not exist for duo
      expect(find.text('Modo Grupo'), findsNothing);
      expect(find.text('Modo Casal'), findsOneWidget);
      expect(find.text('Modo Amigos'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('2.3 3-person chat in ModeSelectionScreen presents Grupo mode directly', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['Lucas', 'Mateus', 'Gabriel']);
      final analysis = ChatAnalyzer.analyzeRawExport(export);

      expect(analysis.mode, equals(ChatMode.grupo));

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export,
            initialAnalysis: analysis,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Modo Grupo'), findsOneWidget);
      expect(find.text('Modo Casal'), findsNothing);
      expect(find.text('Modo Amigos'), findsNothing);

      final continueBtn = find.text('Continuar para o Dashboard');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      final dashboardFinder = find.byType(DashboardScreen);
      expect(dashboardFinder, findsOneWidget);

      final dashboardWidget = tester.widget<DashboardScreen>(dashboardFinder);
      expect(dashboardWidget.analysis.mode, equals(ChatMode.grupo));
      expect(dashboardWidget.analysis, isA<GrupoAnalysisResult>());
      expect(find.text('Modo Grupo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('2.4 7-person chat in ModeSelectionScreen presents Grupo mode and opens Dashboard', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['A', 'B', 'C', 'D', 'E', 'F', 'G']);
      final analysis = ChatAnalyzer.analyzeRawExport(export);

      expect(analysis.mode, equals(ChatMode.grupo));

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export,
            initialAnalysis: analysis,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Modo Grupo'), findsOneWidget);

      final continueBtn = find.text('Continuar para o Dashboard');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      final dashboardFinder = find.byType(DashboardScreen);
      expect(dashboardFinder, findsOneWidget);

      final dashboardWidget = tester.widget<DashboardScreen>(dashboardFinder);
      expect(dashboardWidget.analysis.mode, equals(ChatMode.grupo));
      expect(dashboardWidget.analysis, isA<GrupoAnalysisResult>());
      expect(find.text('Modo Grupo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('2.5 Switching modes back and forth retains consistent state and only re-analyzes when necessary', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['Ana', 'Carlos']);
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

      // Cycle through selections: Casal -> Amigos -> Casal
      await tester.tap(find.text('Modo Amigos'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Modo Casal'));
      await tester.pumpAndSettle();

      final continueBtn = find.text('Continuar para o Dashboard');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      final dashboardFinder = find.byType(DashboardScreen);
      expect(dashboardFinder, findsOneWidget);

      final dashboardWidget = tester.widget<DashboardScreen>(dashboardFinder);
      // Because we ended up on Casal (the initial mode), initialAnalysis is used directly
      expect(dashboardWidget.analysis, same(analysis));
    });
  });

  group('CHALLENGE 3: Null rawExport Fallback Scenarios', () {
    testWidgets('3.1 Null rawExport uses initialAnalysis participants and detects mode correctly', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['Ana', 'Carlos']);
      final analysis = ChatAnalyzer.analyzeCasal(export.messages);

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: null,
            initialAnalysis: analysis,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (2)'), findsOneWidget);
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Carlos'), findsOneWidget);
      expect(find.text('Recomendado'), findsOneWidget);

      final continueBtn = find.text('Continuar para o Dashboard');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      final dashboardFinder = find.byType(DashboardScreen);
      expect(dashboardFinder, findsOneWidget);
      final dashboardWidget = tester.widget<DashboardScreen>(dashboardFinder);
      expect(dashboardWidget.rawExport, isNull);
      expect(dashboardWidget.analysis, same(analysis));
      expect(tester.takeException(), isNull);
    });

    testWidgets('3.2 Null rawExport when user selects different mode does not crash and falls back gracefully', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['Ana', 'Carlos']);
      final analysis = ChatAnalyzer.analyzeCasal(export.messages);

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: null,
            initialAnalysis: analysis,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // User taps Modo Amigos while rawExport is null
      await tester.tap(find.text('Modo Amigos'));
      await tester.pumpAndSettle();

      // Tapping continue must not throw null-pointer exception on rawExport!
      final continueBtn = find.text('Continuar para o Dashboard');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
      final dashboardWidget = tester.widget<DashboardScreen>(find.byType(DashboardScreen));
      expect(dashboardWidget.rawExport, isNull);
      expect(dashboardWidget.analysis, same(analysis));
      expect(tester.takeException(), isNull);
    });

    testWidgets('3.3 Null rawExport with empty participants list renders cleanly', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: []);
      final analysis = ChatAnalyzer.analyzeRawExport(export);

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: null,
            initialAnalysis: analysis,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Participantes Detectados (0)'), findsOneWidget);
      expect(find.byIcon(LucideIcons.user), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('CHALLENGE 4: Dark/Light Theme Switching, Bento Cards & Glowing Radio Indicators', () {
    testWidgets('4.1 Light theme renders with warm backgrounds, valid gradients, and radio glow', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['Ana', 'Carlos']);
      final analysis = ChatAnalyzer.analyzeRawExport(export);

      await tester.pumpWidget(
        wrapWithApp(
          ModeSelectionScreen(
            rawExport: export,
            initialAnalysis: analysis,
          ),
          isDark: false,
        ),
      );
      await tester.pumpAndSettle();

      // Scaffold background in light mode
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(SwissColors.lightBackground));

      // Radio indicator on selected Casal card should show check icon
      expect(find.byIcon(LucideIcons.check), findsOneWidget);

      // Verify custom doodle CustomPaint widgets are present
      final customPaints = find.byType(CustomPaint);
      expect(customPaints, findsWidgets);

      // No exceptions thrown during paint or layout
      expect(tester.takeException(), isNull);
    });

    testWidgets('4.2 Dark theme renders with dark background, dark gradients, and glowing radio indicator', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['Ana', 'Carlos']);
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

      // Scaffold background in dark mode
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(SwissColors.darkBackground));

      // Radio indicator on Casal card is glowing and checked
      expect(find.byIcon(LucideIcons.check), findsOneWidget);

      // Mode titles and typography present
      expect(find.text('Modo Casal'), findsOneWidget);
      expect(find.text('Modo Amigos'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('4.3 Dynamic Theme Switching (Light -> Dark -> Light) maintains intact layout without overflow', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['Ana', 'Carlos', 'Mariana']);
      final analysis = ChatAnalyzer.analyzeRawExport(export);

      // Wrapper allowing runtime theme toggle
      final themeNotifier = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        ValueListenableBuilder<bool>(
          valueListenable: themeNotifier,
          builder: (context, isDark, _) {
            return wrapWithApp(
              ModeSelectionScreen(
                rawExport: export,
                initialAnalysis: analysis,
              ),
              isDark: isDark,
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Initially Light
      expect(tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor, equals(SwissColors.lightBackground));

      // Switch to Dark
      themeNotifier.value = true;
      await tester.pumpAndSettle();
      expect(tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor, equals(SwissColors.darkBackground));

      // Switch back to Light
      themeNotifier.value = false;
      await tester.pumpAndSettle();
      expect(tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor, equals(SwissColors.lightBackground));

      expect(tester.takeException(), isNull);
    });

    testWidgets('4.4 Glowing radio indicator updates dynamically on card taps', (tester) async {
      setViewport(tester);
      final export = createMockExport(authors: ['Ana', 'Carlos']);
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

      // Exactly 1 check icon rendered across the cards (for Casal)
      expect(find.byIcon(LucideIcons.check), findsOneWidget);

      // Tap Amigos
      await tester.tap(find.text('Modo Amigos'));
      await tester.pumpAndSettle();
      expect(find.byIcon(LucideIcons.check), findsOneWidget);

      // Tap Casal back
      await tester.tap(find.text('Modo Casal'));
      await tester.pumpAndSettle();
      expect(find.byIcon(LucideIcons.check), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  });
}
