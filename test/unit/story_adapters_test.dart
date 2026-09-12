import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/analytics/chat_analyzer.dart';
import 'package:chat_wrapped/core/models/amigos_stats.dart';
import 'package:chat_wrapped/core/models/casal_stats.dart';
import 'package:chat_wrapped/core/models/general_stats.dart';
import 'package:chat_wrapped/core/models/grupo_stats.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';
import 'package:chat_wrapped/stories/adapters/amigos_story_adapter.dart';
import 'package:chat_wrapped/stories/adapters/casal_story_adapter.dart';
import 'package:chat_wrapped/stories/adapters/grupo_story_adapter.dart';

void main() {
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

  group('CasalStoryAdapter Tests', () {
    final adapter = CasalStoryAdapter(casalAnalysis as CasalAnalysisResult);

    test('Exposes partner identities and formatted names', () {
      expect(adapter.partner1, equals('Ana'));
      expect(adapter.partner2, equals('Carlos'));
      expect(adapter.partnerNames, equals('Ana & Carlos'));
      expect(adapter.participants.length, equals(2));
    });

    test('Computes volume, paces, and percentages deterministically', () {
      expect(adapter.totalMessages, equals(4));
      expect(adapter.daysTogether, greaterThanOrEqualTo(1));
      expect(adapter.dailyMessagePace, greaterThan(0));
      expect(adapter.dailyMessagePaceFormatted, isNotEmpty);
      expect(adapter.partner1Messages + adapter.partner2Messages, equals(adapter.totalMessages));
      expect(adapter.partner1Percentage + adapter.partner2Percentage, equals(100));
    });

    test('Exposes affection, love language, and compatibility', () {
      expect(adapter.loveLanguage, isNotNull);
      expect(adapter.dominantLoveLanguageName, isNotEmpty);
      expect(adapter.compatibilityScore, inInclusiveRange(0, 100));
      expect(adapter.compatibilityDescription, isNotEmpty);
    });

    test('Provides deterministic derivations without breaking models', () {
      expect(adapter.estimatedAudioMinutes, greaterThanOrEqualTo(1));
      expect(adapter.estimatedAudioMinutesFormatted, isNotEmpty);
      expect(adapter.audioListeningHero, isNotEmpty);
      expect(adapter.estimatedPrints, inInclusiveRange(1, 999));
      expect(adapter.forwardedMemes, inInclusiveRange(3, 450));
      expect(adapter.unsentDrafts, inInclusiveRange(2, 350));
      expect(adapter.mostPatientPartner, isNotEmpty);
      expect(adapter.topicStarter, isNotEmpty);
    });
  });

  group('AmigosStoryAdapter Tests', () {
    final adapter = AmigosStoryAdapter(amigosAnalysis as AmigosAnalysisResult);

    test('Exposes squad roster and volumes', () {
      expect(adapter.memberCount, equals(3));
      expect(adapter.squadRosterFormatted, contains('Lucas'));
      expect(adapter.totalMessages, equals(4));
      expect(adapter.sortedMemberVolumes, isNotEmpty);
    });

    test('Exposes communication styles and dynamics', () {
      expect(adapter.communicationStyles, isNotEmpty);
      expect(adapter.compatibilityScore, inInclusiveRange(0, 100));
      expect(adapter.compatibilityDescription, isNotEmpty);
      expect(adapter.primaryInsight, isNotEmpty);
    });

    test('Provides deterministic squad derivations', () {
      expect(adapter.biggestFloodAuthor, isNotEmpty);
      expect(adapter.biggestFloodCount, greaterThan(0));
      expect(adapter.fastestReplier, isNotEmpty);
      expect(adapter.podcasterAuthor, isNotEmpty);
      expect(adapter.estimatedAudioMinutes, inInclusiveRange(1, 9999));
      expect(adapter.estimatedPrints, inInclusiveRange(1, 999));
      expect(adapter.printInvestigator, isNotEmpty);
      expect(adapter.forwardedMemes, inInclusiveRange(5, 500));
      expect(adapter.memeSupplier, isNotEmpty);
      expect(adapter.unsentDrafts, inInclusiveRange(3, 400));
      expect(adapter.vacuumKing, isNotEmpty);
      expect(adapter.vacuumVictim, isNotEmpty);
    });
  });

  group('GrupoStoryAdapter Tests', () {
    final adapter = GrupoStoryAdapter(grupoAnalysis as GrupoAnalysisResult);

    test('Exposes community population and leaderboard', () {
      expect(adapter.memberCount, equals(6));
      expect(adapter.totalMessages, equals(6));
      expect(adapter.memberRanking, isNotEmpty);
      expect(adapter.top3Members.length, inInclusiveRange(1, 3));
      expect(adapter.champion, isNotNull);
    });

    test('Computes literary book equivalence and Pareto ratio', () {
      expect(adapter.literaryBookEquivalence, greaterThanOrEqualTo(1));
      expect(adapter.literaryBookDescription, contains('volumes de Dom Casmurro'));
      expect(adapter.paretoTopSharePercentage, inInclusiveRange(1, 100));
    });

    test('Provides deterministic group derivations', () {
      expect(adapter.interactionChampion, isNotEmpty);
      expect(adapter.interactionReplyCount, greaterThan(0));
      expect(adapter.vacuumChampion, isNotEmpty);
      expect(adapter.vacuumCount, greaterThan(0));
      expect(adapter.reporterName, isNotEmpty);
      expect(adapter.reporterPrintCount, inInclusiveRange(1, 999));
      expect(adapter.forwarderName, isNotEmpty);
      expect(adapter.forwardedCount, inInclusiveRange(10, 800));
      expect(adapter.unsendGhostName, isNotEmpty);
      expect(adapter.unsendCount, inInclusiveRange(5, 600));
    });
  });
}
