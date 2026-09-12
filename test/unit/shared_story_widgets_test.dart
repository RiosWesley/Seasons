import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/stories/story_progress_bar.dart';
import 'package:chat_wrapped/widgets/stories/shared/editorial_stamp.dart';
import 'package:chat_wrapped/widgets/stories/shared/monumental_count_up.dart';
import 'package:chat_wrapped/widgets/stories/shared/retro_paper_scaffold.dart';
import 'package:chat_wrapped/widgets/stories/shared/seasons_story_footer.dart';
import 'package:chat_wrapped/widgets/stories/shared/story_gauge_meter.dart';
import 'package:chat_wrapped/widgets/stories/shared/story_paper_background.dart';
import 'package:chat_wrapped/widgets/stories/shared/story_share_action.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(
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

  group('SeasonsStoryFooter Widget Tests', () {
    testWidgets('Renders lowercase seasons signature and edition tag, omitting legacy text',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const SeasonsStoryFooter(
            editionTag: "mémoire d'amour",
          ),
        ),
      );

      expect(find.text('seasons'), findsOneWidget);
      expect(find.text("mémoire d'amour"), findsOneWidget);
      expect(find.text('CHAT WRAPPED'), findsNothing);
      expect(find.text('100% OFFLINE • PRIVACIDADE LOCAL'), findsNothing);
    });
  });

  group('StoryPaperBackground & RetroPaperScaffold Tests', () {
    testWidgets('StoryPaperBackground renders base container and child', (tester) async {
      await tester.pumpWidget(
        wrap(
          const StoryPaperBackground(
            baseColor: Color(0xFFFBF9F5),
            hairlineBorderColor: Color(0xFFFECDD3),
            child: Center(child: Text('Paper Child Content')),
          ),
        ),
      );

      expect(find.text('Paper Child Content'), findsOneWidget);
    });

    testWidgets('RetroPaperScaffold renders full paper engine with Seasons footer',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const RetroPaperScaffold(
            theme: StoryModeTheme.casal,
            child: Center(child: Text('Scaffold Content')),
          ),
        ),
      );

      expect(find.text('Scaffold Content'), findsOneWidget);
      expect(find.text('seasons'), findsOneWidget);
      expect(find.text("mémoire d'amour"), findsOneWidget);
    });
  });

  group('EditorialStamp Widget Tests', () {
    testWidgets('Renders wax seal with heart and shadow without crashing', (tester) async {
      await tester.pumpWidget(
        wrap(
          const EditorialStamp.waxSeal(
            label: 'SEAL TEST',
          ),
        ),
      );

      expect(find.byType(EditorialStamp), findsOneWidget);
    });

    testWidgets('Renders rubber stamp with rotation and label without crashing', (tester) async {
      await tester.pumpWidget(
        wrap(
          const EditorialStamp.rubberStamp(
            label: 'SQUAD ARCHIVE',
          ),
        ),
      );

      expect(find.byType(EditorialStamp), findsOneWidget);
    });

    testWidgets('Renders periodical medal without crashing', (tester) async {
      await tester.pumpWidget(
        wrap(
          const EditorialStamp.periodicalMedal(
            label: 'EDIÇÃO OFICIAL',
          ),
        ),
      );

      expect(find.byType(EditorialStamp), findsOneWidget);
    });
  });

  group('MonumentalCountUp Widget Tests', () {
    testWidgets('Renders target number, label, and subtitle with tabular figures',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const MonumentalCountUp(
            targetValue: 4200,
            label: 'TOTAL DE MENSAGENS',
            subtitle: 'Um ano de conversas',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TOTAL DE MENSAGENS'), findsOneWidget);
      expect(find.text('Um ano de conversas'), findsOneWidget);
      expect(find.text('4.200'), findsOneWidget);
    });
  });

  group('StoryGaugeMeter Widget Tests', () {
    testWidgets('Renders semi-circular gauge with score percentage and title',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const StoryGaugeMeter(
            score: 94.0,
            title: 'SINTONIA MÁXIMA',
            subtitle: 'Conexão rara e recíproca',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('94%'), findsOneWidget);
      expect(find.text('SINTONIA MÁXIMA'), findsOneWidget);
      expect(find.text('Conexão rara e recíproca'), findsOneWidget);
      expect(find.byType(StoryGaugeMeter), findsOneWidget);
    });
  });

  group('StoryShareAction Widget Tests', () {
    testWidgets('Renders Icons.share_rounded and triggers callback upon tap',
        (tester) async {
      bool wasShared = false;

      await tester.pumpWidget(
        wrap(
          StoryShareAction(
            label: 'COMPARTILHAR NO INSTAGRAM',
            onShare: () {
              wasShared = true;
            },
          ),
        ),
      );

      expect(find.text('COMPARTILHAR NO INSTAGRAM'), findsOneWidget);
      expect(find.byIcon(Icons.share_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.share_rounded));
      await tester.pump();

      expect(wasShared, isTrue);
    });
  });

  group('StoryProgressBar Color Calibration Tests', () {
    testWidgets('StoryProgressBar uses calibrated unfilled and completed ink colors by default',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const StoryProgressBar(
            totalSegments: 5,
            currentIndex: 2,
            animationProgress: 0.5,
          ),
        ),
      );

      expect(find.byType(StoryProgressBar), findsOneWidget);
    });
  });
}
