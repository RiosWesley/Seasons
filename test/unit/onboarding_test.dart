import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat_wrapped/core/services/onboarding_preferences.dart';
import 'package:chat_wrapped/screens/home_screen.dart';
import 'package:chat_wrapped/screens/onboarding_screen.dart';
import 'package:chat_wrapped/theme/swiss_theme.dart';

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

  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      theme: SwissTheme.lightTheme,
      home: child,
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('OnboardingPreferences Unit Tests', () {
    test('Default hasSeenOnboarding is false when unset', () async {
      SharedPreferences.setMockInitialValues({});
      final hasSeen = await OnboardingPreferences.hasSeenOnboarding();
      expect(hasSeen, isFalse);
    });

    test('setHasSeenOnboarding updates preference to true', () async {
      SharedPreferences.setMockInitialValues({});
      await OnboardingPreferences.setHasSeenOnboarding(true);
      final hasSeen = await OnboardingPreferences.hasSeenOnboarding();
      expect(hasSeen, isTrue);
    });

    test('resetOnboarding resets preference back to false', () async {
      SharedPreferences.setMockInitialValues({'hasSeenOnboarding': true});
      await OnboardingPreferences.resetOnboarding();
      final hasSeen = await OnboardingPreferences.hasSeenOnboarding();
      expect(hasSeen, isFalse);
    });

    test('setHasSeenOnboarding with false persists false', () async {
      SharedPreferences.setMockInitialValues({'hasSeenOnboarding': true});
      await OnboardingPreferences.setHasSeenOnboarding(false);
      final hasSeen = await OnboardingPreferences.hasSeenOnboarding();
      expect(hasSeen, isFalse);
    });
  });

  group('OnboardingScreen Rendering & Content Tests', () {
    testWidgets('Page 1 renders brand, eyebrow label, and editorial value props', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(wrapWithApp(const OnboardingScreen()));
      await tester.pumpAndSettle();

      // Brand Top Bar
      expect(find.text('seasons'), findsOneWidget);
      expect(find.text('Pular'), findsOneWidget);

      // Page 1 Elements
      expect(find.text('ARQUIVO PESSOAL DE CONVERSAS'), findsOneWidget);
      expect(find.text('Suas conversas guardam histórias inesquecíveis.'), findsOneWidget);
      expect(find.text('Privacidade Inegociável'), findsOneWidget);
      expect(find.text('Análise Instantânea'), findsOneWidget);
      expect(find.text('Stories Prontos'), findsOneWidget);

      // Bottom Navigation
      expect(find.text('Continuar'), findsOneWidget);
    });

    testWidgets('Sequential navigation across all 4 pages with tap on Continuar', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(wrapWithApp(const OnboardingScreen()));
      await tester.pumpAndSettle();

      // Page 1 visible
      expect(find.text('ARQUIVO PESSOAL DE CONVERSAS'), findsOneWidget);

      // Advance to Page 2
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      // Page 2: What App Does & Modes
      expect(find.text('3 LENTES DE ANÁLISE + STORIES'), findsOneWidget);
      expect(find.text('Três formas de olhar para as suas conexões.'), findsOneWidget);
      expect(find.text('Modo Casal'), findsOneWidget);
      expect(find.text('Modo Amigos'), findsOneWidget);
      expect(find.text('Modo Grupo'), findsOneWidget);

      // Advance to Page 3
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      // Page 3: WhatsApp Export Guide
      expect(find.text('GUIA PRÁTICO EM 4 PASSOS'), findsOneWidget);
      expect(find.text('Como exportar sua conversa do WhatsApp.'), findsOneWidget);
      expect(find.text('Abra a conversa desejada'), findsOneWidget);
      expect(find.text('Menu Mais > Exportar conversa'), findsOneWidget);
      expect(find.text('Selecione SEMPRE "Sem mídia"'), findsOneWidget);
      expect(find.text('OBRIGATÓRIO: Sem mídia'), findsOneWidget);
      expect(find.text('Abra ou salve no Seasons'), findsOneWidget);

      // Advance to Page 4
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      // Page 4: Privacy & Launch
      expect(find.text('SEGURANÇA & PRIVACIDADE'), findsOneWidget);
      expect(find.text('Seus dados nunca saem do seu aparelho.'), findsOneWidget);
      expect(find.text('Selo de Garantia Local 100% Offline'), findsOneWidget);
      expect(find.text('Zero Servidores'), findsOneWidget);
      expect(find.text('Zero Rastreamento'), findsOneWidget);
      expect(find.text('Cálculo 100% Local'), findsOneWidget);

      // Final CTA is visible and Pular is faded/hidden
      expect(find.text('Começar a Explorar'), findsOneWidget);
    });

    testWidgets('Direct jump to any page via step indicator pills', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(wrapWithApp(const OnboardingScreen()));
      await tester.pumpAndSettle();

      // Find step pill gesture detectors (4 total)
      final pillFinders = find.byType(AnimatedContainer);
      expect(pillFinders, findsNWidgets(4));

      // Tap on 3rd pill (index 2 -> Page 3)
      await tester.tap(pillFinders.at(2));
      await tester.pumpAndSettle();

      expect(find.text('GUIA PRÁTICO EM 4 PASSOS'), findsOneWidget);
      expect(find.text('OBRIGATÓRIO: Sem mídia'), findsOneWidget);

      // Tap on 4th pill (index 3 -> Page 4)
      await tester.tap(pillFinders.at(3));
      await tester.pumpAndSettle();

      expect(find.text('Começar a Explorar'), findsOneWidget);

      // Tap on 1st pill (index 0 -> Page 1)
      await tester.tap(pillFinders.at(0));
      await tester.pumpAndSettle();

      expect(find.text('ARQUIVO PESSOAL DE CONVERSAS'), findsOneWidget);
    });

    testWidgets('initialPage parameter opens requested page immediately', (tester) async {
      setMobileViewport(tester);
      await tester.pumpWidget(
        wrapWithApp(
          const OnboardingScreen(initialPage: 2),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('GUIA PRÁTICO EM 4 PASSOS'), findsOneWidget);
      expect(find.text('Como exportar sua conversa do WhatsApp.'), findsOneWidget);
    });
  });

  group('Onboarding Navigation & Persistence Transitions', () {
    testWidgets('Tapping Pular persists hasSeenOnboarding and routes to HomeScreen', (tester) async {
      setMobileViewport(tester);
      SharedPreferences.setMockInitialValues({'hasSeenOnboarding': false});

      await tester.pumpWidget(wrapWithApp(const OnboardingScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Pular'), findsOneWidget);
      await tester.tap(find.text('Pular'));
      await tester.pumpAndSettle();

      // Should have persisted hasSeenOnboarding = true
      final hasSeen = await OnboardingPreferences.hasSeenOnboarding();
      expect(hasSeen, isTrue);

      // Should have transitioned to HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Como exportar do WhatsApp? Ver tutorial →'), findsOneWidget);
    });

    testWidgets('Tapping Começar a Explorar on Page 4 persists hasSeenOnboarding and routes to HomeScreen', (tester) async {
      setMobileViewport(tester);
      SharedPreferences.setMockInitialValues({'hasSeenOnboarding': false});

      await tester.pumpWidget(
        wrapWithApp(
          const OnboardingScreen(initialPage: 3),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Começar a Explorar'), findsOneWidget);
      await tester.tap(find.text('Começar a Explorar'));
      await tester.pumpAndSettle();

      final hasSeen = await OnboardingPreferences.hasSeenOnboarding();
      expect(hasSeen, isTrue);

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Como exportar do WhatsApp? Ver tutorial →'), findsOneWidget);
    });
  });

  group('Replay Mode Tests', () {
    testWidgets('Replay mode displays Fechar button and pops Navigator when tapped', (tester) async {
      setMobileViewport(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: SwissTheme.lightTheme,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const OnboardingScreen(isReplay: true),
                      ),
                    );
                  },
                  child: const Text('Open Replay'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open replay onboarding
      await tester.tap(find.text('Open Replay'));
      await tester.pumpAndSettle();

      // Replay mode has Fechar instead of Pular
      expect(find.text('Fechar'), findsOneWidget);
      expect(find.text('Pular'), findsNothing);

      // Tap Fechar -> pops back
      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();

      expect(find.text('Open Replay'), findsOneWidget);
    });

    testWidgets('Replay mode on Page 4 displays Concluir e Voltar and pops Navigator', (tester) async {
      setMobileViewport(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: SwissTheme.lightTheme,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const OnboardingScreen(
                          isReplay: true,
                          initialPage: 3,
                        ),
                      ),
                    );
                  },
                  child: const Text('Open Replay Page 4'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Replay Page 4'));
      await tester.pumpAndSettle();

      expect(find.text('Concluir e Voltar'), findsOneWidget);
      expect(find.text('Começar a Explorar'), findsNothing);

      await tester.tap(find.text('Concluir e Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('Open Replay Page 4'), findsOneWidget);
    });
  });
}
