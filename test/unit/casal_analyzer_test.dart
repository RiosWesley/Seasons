import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/analytics/casal_analyzer.dart';
import 'package:chat_wrapped/core/models/chat_message.dart';

void main() {
  group('CasalAnalyzer Unit Tests', () {
    test('Calculates Love Language breakdown accurately', () {
      final messages = [
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 10, 0),
          author: 'Alice',
          content: 'Bom dia meu amor ❤️ te amo tanto 💕',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 10, 5),
          author: 'Bob',
          content: 'Bom dia! Olha esse meme 😂🤣',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 11, 0),
          author: 'Alice',
          content: 'Aqui está um texto bem longo sem corações e sem risadas com mais de cinquenta caracteres.',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 11, 30),
          author: 'Bob',
          content: '<Mídia oculta>',
          isMedia: true,
        ),
      ];

      final casal = CasalAnalyzer.analyze(messages);
      expect(casal.loveLanguage.hearts, equals(2)); // ❤️, 💕
      expect(casal.loveLanguage.romanticWords, equals(1)); // 'amor', 'te amo' in Alice's msg
      expect(casal.loveLanguage.memes, equals(1)); // 😂🤣 in Bob's msg
      expect(casal.loveLanguage.directTexts, equals(1)); // Alice's long text
    });

    test('Computes Compatibility Score with parity and response time tiers', () {
      // 1. High parity and rapid response (< 1 hour)
      final fastParityMsgs = [
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 10, 0),
          author: 'Alice',
          content: 'Oi amor ❤️ tudo bem com você?',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 10, 10),
          author: 'Bob',
          content: 'Oi linda 💕 tudo ótimo e você?',
        ),
      ];

      final fastCasal = CasalAnalyzer.analyze(fastParityMsgs);
      expect(fastCasal.compatibility.score, greaterThanOrEqualTo(85));
      expect(fastCasal.compatibility.description, equals('Vocês combinam demais! 💕'));

      // 2. Slower response time between 1h and 4h (S_resp = 0.7)
      final mediumMsgs = [
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 10, 0),
          author: 'Alice',
          content: 'Mensagem teste',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 12, 0), // 2 hours
          author: 'Bob',
          content: 'Resposta duas horas depois',
        ),
      ];
      final mediumCasal = CasalAnalyzer.analyze(mediumMsgs);
      expect(mediumCasal.compatibility.score, inInclusiveRange(50, 85));

      // 3. Very slow response (> 4h) (S_resp = 0.5)
      final slowMsgs = [
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 10, 0),
          author: 'Alice',
          content: 'A' * 200,
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 18, 0), // 8 hours
          author: 'Bob',
          content: 'Ok',
        ),
      ];
      final slowCasal = CasalAnalyzer.analyze(slowMsgs);
      expect(slowCasal.compatibility.score, lessThan(70));
    });

    test('ParticipantStats extracts personal top emojis, words, active hour, and active day', () {
      final messages = [
        ChatMessage(
          timestamp: DateTime(2025, 5, 5, 14, 0), // Monday (Segunda)
          author: 'Alice',
          content: 'viagem incrível praia praia ✨✨',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 5, 14, 2),
          author: 'Bob',
          content: 'futebol hoje à noite ⚽⚽',
        ),
      ];

      final casal = CasalAnalyzer.analyze(messages);
      expect(casal.participantStats.length, equals(2));

      final alice = casal.participantStats.firstWhere((p) => p.name == 'Alice');
      expect(alice.topEmoji, equals('✨'));
      expect(alice.topWord, equals('praia'));
      expect(alice.activeHour, equals(14));
      expect(alice.activeDay, equals('Segunda'));

      final bob = casal.participantStats.firstWhere((p) => p.name == 'Bob');
      expect(bob.topEmoji, equals('⚽'));
      expect(bob.topWord, equals('futebol'));
    });

    test('Ignoring and Ghosting metrics track 2h thresholds and exclude >24h', () {
      final messages = [
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 10, 0),
          author: 'Alice',
          content: 'Oi Bob',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 13, 30), // 3.5h later (ghosting event)
          author: 'Bob',
          content: 'Desculpa a demora',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 14, 0),
          author: 'Alice',
          content: 'Sem problemas',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 4, 10, 0), // 3 days later (>24h lull)
          author: 'Bob',
          content: 'E aí tudo bem?',
        ),
      ];

      final casal = CasalAnalyzer.analyze(messages);
      expect(casal.ignoringStats.wasIgnoredCount, equals(1)); // Alice was left waiting
      expect(casal.ignoringStats.ignoredCount, equals(0)); // Alice didn't ignore Bob
      expect(casal.ignoringStats.longestIgnoredTimeMs, equals(12600000)); // 3.5h = 12,600,000 ms
    });

    test('Audio ignoring detects media left waiting > 1 hour', () {
      final messages = [
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 10, 0),
          author: 'Alice',
          content: '<Mídia oculta>',
          isMedia: true,
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 11, 45), // 1h45min delay
          author: 'Bob',
          content: 'Ouvi o áudio!',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 12, 0),
          author: 'Bob',
          content: '<Mídia oculta>',
          isMedia: true,
        ),
        ChatMessage(
          timestamp: DateTime(2025, 5, 1, 12, 10), // 10min response
          author: 'Alice',
          content: 'Rápido!',
        ),
      ];

      final casal = CasalAnalyzer.analyze(messages);
      expect(casal.audioIgnoringStats.totalAudios, equals(2));
      expect(casal.audioIgnoringStats.wasIgnoredAudios, equals(1)); // Alice's audio delayed
      expect(casal.audioIgnoringStats.ignoredAudios, equals(0)); // Bob's audio answered quickly
    });

    test('ResponseTimeStats computes fastest, slowest, and turnaround average', () {
      final messages = [
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'Alice', content: '1'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 5), author: 'Bob', content: '2'), // 5 min = 300,000 ms
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 20), author: 'Alice', content: '3'), // 15 min = 900,000 ms
      ];

      final casal = CasalAnalyzer.analyze(messages);
      expect(casal.responseTimeStats.fastestResponseMs, equals(300000));
      expect(casal.responseTimeStats.slowestResponseMs, equals(900000));
      expect(casal.responseTimeStats.averageResponseTimeMs, equals(600000.0)); // 10 min
      expect(casal.responseTimeStats.responseCount, equals(2));
    });

    test('Handles empty messages gracefully', () {
      final casal = CasalAnalyzer.analyze([]);
      expect(casal.general.totalMessages, equals(0));
      expect(casal.compatibility.score, inInclusiveRange(0, 100));
      expect(casal.loveLanguage.hearts, equals(0));
    });
  });
}
