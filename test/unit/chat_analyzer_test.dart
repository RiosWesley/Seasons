import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/analytics/chat_analyzer.dart';
import 'package:chat_wrapped/core/models/amigos_stats.dart';
import 'package:chat_wrapped/core/models/casal_stats.dart';
import 'package:chat_wrapped/core/models/chat_message.dart';
import 'package:chat_wrapped/core/models/general_stats.dart';
import 'package:chat_wrapped/core/models/grupo_stats.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';

void main() {
  group('ChatAnalyzer Unit & Benchmark Tests', () {
    test('Mode auto-detection categorizes 1-2 as casal, 3-5 as amigos, 6+ as grupo', () {
      expect(ChatAnalyzer.detectMode(1), equals(ChatMode.casal));
      expect(ChatAnalyzer.detectMode(2), equals(ChatMode.casal));
      expect(ChatAnalyzer.detectMode(3), equals(ChatMode.amigos));
      expect(ChatAnalyzer.detectMode(4), equals(ChatMode.amigos));
      expect(ChatAnalyzer.detectMode(5), equals(ChatMode.amigos));
      expect(ChatAnalyzer.detectMode(6), equals(ChatMode.grupo));
      expect(ChatAnalyzer.detectMode(20), equals(ChatMode.grupo));
    });

    test('calculateGeneralStats extracts comprehensive timeline, hours, days, emojis, and words', () {
      final messages = [
        ChatMessage(
          timestamp: DateTime(2025, 6, 1, 10, 0),
          author: 'Alice',
          content: 'Bom dia mundo! ✨ praia e sol',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 6, 1, 10, 15),
          author: 'Bob',
          content: 'Bom dia Alice! ✨ vamos à praia',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 10, 15, 20, 0),
          author: 'Alice',
          content: 'Noite de outubro ✨ lua linda',
        ),
      ];

      final stats = ChatAnalyzer.calculateGeneralStats(messages);
      expect(stats.totalMessages, equals(3));
      expect(stats.participants, containsAll(['Alice', 'Bob']));
      expect(stats.startDate, equals(DateTime(2025, 6, 1, 10, 0)));
      expect(stats.endDate, equals(DateTime(2025, 10, 15, 20, 0)));

      // Timeline has Jun/2025 and Out/2025
      expect(stats.timeline.length, equals(2));
      expect(stats.timeline[0].month, equals('Jun'));
      expect(stats.timeline[0].count, equals(2));
      expect(stats.timeline[1].month, equals('Out'));
      expect(stats.timeline[1].count, equals(1));

      // Top emoji ✨
      expect(stats.topEmojis.first.emoji, equals('✨'));
      expect(stats.topEmojis.first.count, equals(3));

      // Top word 'praia'
      expect(stats.topWords.first.word, equals('praia'));
      expect(stats.topWords.first.count, equals(2));

      // Average response time: Turn 1: 15 min = 900,000 ms
      expect(stats.averageResponseTimeMs, equals(900000.0));
    });

    test('Mode override routes correctly regardless of participant count', () {
      final twoPersonMsgs = [
        ChatMessage(timestamp: DateTime.now(), author: 'A', content: '1'),
        ChatMessage(timestamp: DateTime.now(), author: 'B', content: '2'),
      ];

      // Forced to grupo
      final grupoResult = ChatAnalyzer.analyzeMessages(twoPersonMsgs, overrideMode: ChatMode.grupo);
      expect(grupoResult, isA<GrupoAnalysisResult>());
      expect(grupoResult.mode, equals(ChatMode.grupo));

      // Forced to amigos
      final amigosResult = ChatAnalyzer.analyzeMessages(twoPersonMsgs, overrideMode: ChatMode.amigos);
      expect(amigosResult, isA<AmigosAnalysisResult>());
      expect(amigosResult.mode, equals(ChatMode.amigos));

      // Default auto-detect to casal
      final casalResult = ChatAnalyzer.analyzeMessages(twoPersonMsgs);
      expect(casalResult, isA<CasalAnalysisResult>());
      expect(casalResult.mode, equals(ChatMode.casal));
    });

    test('Real-world Benchmark Test: "Conversa do WhatsApp com João Arthur Britto.txt"', () {
      final file = File('test/fixtures/benchmark_chat.txt');
      expect(file.existsSync(), isTrue);

      final rawContent = file.readAsStringSync();
      final export = const ChatParser().parse(rawContent);

      // 1. Ingestion verification
      expect(export.totalMessages, equals(15));
      expect(export.participants.length, equals(2));
      expect(export.participants, containsAll(['João Arthur Britto', 'wesley rios']));

      // 2. Participant message breakdown
      final wesleyMsgs = export.messages.where((m) => m.author == 'wesley rios').length;
      final joaoMsgs = export.messages.where((m) => m.author == 'João Arthur Britto').length;
      expect(wesleyMsgs, equals(8));
      expect(joaoMsgs, equals(7));

      // 3. Media message count
      final mediaCount = export.messages.where((m) => m.isMedia).length;
      expect(mediaCount, equals(3));

      // 4. Auto-detected mode
      final mode = ChatAnalyzer.detectMode(export.participants.length);
      expect(mode, equals(ChatMode.casal));

      // 5. General stats calculation
      final general = ChatAnalyzer.calculateGeneralStats(export.messages);
      expect(general.totalMessages, equals(15));
      expect(general.timeline.length, equals(2)); // Jun/2025: 13, Out/2025: 2

      final jun = general.timeline.firstWhere((t) => t.month == 'Jun' && t.year == 2025);
      final out = general.timeline.firstWhere((t) => t.month == 'Out' && t.year == 2025);
      expect(jun.count, equals(13));
      expect(out.count, equals(2));

      // 6. Response turnaround (< 24h filter): Exactly 30.0 minutes (1,800,000 ms)
      // Turn 1: João (10:20) -> wesley (11:45) = 85 min = 5,100,000 ms
      // Turn 2: wesley (11:46) -> João (11:51) = 5 min = 300,000 ms
      // Turn 3: wesley (09:05 17/10) -> João (09:05 17/10) = 0 ms
      // Gap between 05/06 and 17/10 is 133 days (>24h) and strictly ignored!
      expect(general.averageResponseTimeMs, equals(1800000.0));
      expect(general.averageResponseTimeMs / 60000, equals(30.0));

      // 7. Casal analysis
      final result = ChatAnalyzer.analyzeRawExport(export);
      expect(result, isA<CasalAnalysisResult>());
      final casal = (result as CasalAnalysisResult).stats;

      // Since avg response is 30min (<1h), S_resp = 0.9, compatibility is high
      expect(casal.compatibility.score, greaterThan(60));
      expect(casal.compatibility.description, isNotEmpty);

      // Ghosting count: 0 events exceeded 2-hour ignore threshold (85 min < 120 min)
      expect(casal.ignoringStats.wasIgnoredCount, equals(0));
      expect(casal.ignoringStats.ignoredCount, equals(0));

      // 8. Amigos analysis (when evaluated under amigos mode)
      final amigosResult = ChatAnalyzer.analyzeMessages(export.messages, overrideMode: ChatMode.amigos);
      expect(amigosResult, isA<AmigosAnalysisResult>());
      final amigos = (amigosResult as AmigosAnalysisResult).stats;

      // Wesley rios has a 7-message consecutive flood streak (Lines 10-16)
      expect(amigos.friendStats.biggestFloodName, equals('wesley rios'));
      expect(amigos.friendStats.biggestFloodCount, equals(7));
    });
  });
}
