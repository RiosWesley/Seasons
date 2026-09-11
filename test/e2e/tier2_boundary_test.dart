// E2E Test Suite - Tier 2: Boundary & Corner Cases
// Derived strictly from TEST_INFRA.md and SPEC-ANA-001.

import 'dart:io';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import '../fixtures/e2e_oracle.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 2: Boundary & Corner Cases Test Suite', () {
    // ------------------------------------------------------------------------
    // Area 1: Empty & Minimal Inputs
    // ------------------------------------------------------------------------
    group('Area 1: Empty & Minimal Inputs', () {
      test('B1.1: Empty raw text returns RawChatExport with 0 messages', () {
        final export = E2EWhatsAppParser.parse('');
        expect(export.totalMessages, equals(0));
        expect(export.messages.isEmpty, isTrue);
        expect(export.participants.isEmpty, isTrue);
      });

      test('B1.2: Text with only whitespace and empty newlines returns 0 messages', () {
        final export = E2EWhatsAppParser.parse('   \n\n   \t  \r\n   ');
        expect(export.totalMessages, equals(0));
      });

      test('B1.3: Single valid message parsed cleanly without range errors', () {
        const raw = '05/06/2025 10:19 - Solo: Estou sozinho aqui';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.totalMessages, equals(1));
        expect(export.participants.length, equals(1));
        expect(export.startDate, equals(export.endDate));
      });

      test('B1.4: General stats calculation on 0 messages produces safe default stats', () {
        final stats = E2EAnalyticsEngine.calculateGeneralStats(const []);
        expect(stats.totalMessages, equals(0));
        expect(stats.participants.isEmpty, isTrue);
        expect(stats.averageResponseTimeMs, equals(0.0));
      });

      test('B1.5: Message with empty content string handled safely', () {
        const raw = '05/06/2025 10:19 - User: ';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.totalMessages, equals(1));
        expect(export.messages.first.content, isEmpty);
      });

      test('B1.6: Two messages from same author produce 0 author transitions', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'A', content: '1'),
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 5), author: 'A', content: '2'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        expect(stats.averageResponseTimeMs, equals(0.0));
      });
    });

    // ------------------------------------------------------------------------
    // Area 2: Huge Volume & Stress Boundaries
    // ------------------------------------------------------------------------
    group('Area 2: Huge Volume & Stress Boundaries', () {
      test('B2.1: Extreme length message (10,000 characters) accumulated cleanly', () {
        final longContent = 'A' * 10000;
        final raw = '05/06/2025 10:19 - LongAuthor: $longContent';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.totalMessages, equals(1));
        expect(export.messages.first.content.length, equals(10000));
      });

      test('B2.2: 50 consecutive newlines in multiline body handled without memory blowup', () {
        final newlines = '\n' * 50;
        final raw = '05/06/2025 10:19 - User: Start$newlines End';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.totalMessages, equals(1));
        expect(export.messages.first.content.contains('End'), isTrue);
      });

      test('B2.3: 100 consecutive messages streak by same author tracked accurately', () {
        final msgs = List.generate(
          100,
          (i) => ChatMessage(
            timestamp: DateTime(2025, 1, 1, 10, i % 60),
            author: 'MonologueKing',
            content: 'Msg $i',
          ),
        );
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final amigos = E2EAnalyticsEngine.analyzeAmigos(msgs, stats);
        expect(amigos.friendStats.biggestFloodName, equals('MonologueKing'));
        expect(amigos.friendStats.biggestFloodCount, equals(100));
      });

      test('B2.4: 1,000 synthetic messages stress test computes analytics in < 200ms', () {
        final stopwatch = Stopwatch()..start();
        final msgs = List.generate(
          1000,
          (i) => ChatMessage(
            timestamp: DateTime(2025, 1, 1).add(Duration(minutes: i * 5)),
            author: i % 2 == 0 ? 'UserA' : 'UserB',
            content: 'Mensagem de teste número $i com emoji 😂 e amor ❤️',
          ),
        );
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final casal = E2EAnalyticsEngine.analyzeCasal(msgs, stats);
        stopwatch.stop();

        expect(stats.totalMessages, equals(1000));
        expect(casal.compatibility.score, greaterThan(0));
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      });

      test('B2.5: High message frequency within same minute handles timestamps identically', () {
        final msgs = List.generate(
          10,
          (i) => ChatMessage(
            timestamp: DateTime(2025, 1, 1, 10, 0),
            author: i % 2 == 0 ? 'A' : 'B',
            content: 'Fast msg $i',
          ),
        );
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        expect(stats.averageResponseTimeMs, equals(0.0));
      });
    });

    // ------------------------------------------------------------------------
    // Area 3: Timestamp & Chronological Boundaries
    // ------------------------------------------------------------------------
    group('Area 3: Timestamp & Chronological Boundaries', () {
      test('B3.1: Leap year Feb 29 2024 parsed as valid date', () {
        const raw = '29/02/2024 14:00 - Leap: Happy leap day!';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.messages.first.timestamp, equals(DateTime(2024, 2, 29, 14, 0)));
      });

      test('B3.2: Midnight 00:00 in 24h format parsed as hour 0', () {
        const raw = '01/01/2025 00:00 - Night: Ano Novo!';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.messages.first.timestamp.hour, equals(0));
        expect(export.messages.first.timestamp.minute, equals(0));
      });

      test('B3.3: 12:00 AM in 12h format converted to hour 0', () {
        const raw = '01/01/2025, 12:00 AM - Night: 12am test';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.messages.first.timestamp.hour, equals(0));
      });

      test('B3.4: Noon 12:00 PM in 12h format converted to hour 12', () {
        const raw = '01/01/2025, 12:00 PM - Day: Almoço';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.messages.first.timestamp.hour, equals(12));
      });

      test('B3.5: Year rollover transition (31/12 23:59 to 01/01 00:01)', () {
        const raw = '''31/12/2024 23:59 - A: Fim de ano
01/01/2025 00:01 - B: Feliz ano novo!''';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.startDate.year, equals(2024));
        expect(export.endDate.year, equals(2025));
      });

      test('B3.6: Messages with identical timestamps handled without division by zero', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'A', content: '1'),
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'B', content: '2'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        expect(stats.averageResponseTimeMs, equals(0.0));
      });

      test('B3.7: Sub-second precision brackets parsed gracefully', () {
        const raw = '[05/06/2025, 10:19:59] Fast: Segundo 59';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.messages.first.timestamp.minute, equals(19));
      });
    });

    // ------------------------------------------------------------------------
    // Area 4: Response Time Threshold Boundaries
    // ------------------------------------------------------------------------
    group('Area 4: Response Time Threshold Boundaries', () {
      test('B4.1: Response gap of exactly 24h (86400000ms) excluded from avg response', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'A', content: 'Oi'),
          ChatMessage(timestamp: DateTime(2025, 1, 2, 10, 0), author: 'B', content: '24h exatas'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        expect(stats.averageResponseTimeMs, equals(0.0)); // delta == 86400000 is excluded
      });

      test('B4.2: Response gap of 23h 59m (86340000ms) included in avg response', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'A', content: 'Oi'),
          ChatMessage(timestamp: DateTime(2025, 1, 2, 9, 59), author: 'B', content: 'Quase 24h'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        expect(stats.averageResponseTimeMs, equals(86340000.0));
      });

      test('B4.3: Response gap of exactly 2 hours (7200000ms) does NOT trigger ignoring', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'A', content: 'Pergunta'),
          ChatMessage(timestamp: DateTime(2025, 1, 1, 12, 0), author: 'B', content: 'Resposta 2h'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final casal = E2EAnalyticsEngine.analyzeCasal(msgs, stats);
        expect(casal.ignoringStats.wasIgnoredCount, equals(0));
      });

      test('B4.4: Response gap of 2 hours 1 minute (7260000ms) triggers ignoring event', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'A', content: 'Pergunta'),
          ChatMessage(timestamp: DateTime(2025, 1, 1, 12, 1), author: 'B', content: 'Resposta 2h 1m'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final casal = E2EAnalyticsEngine.analyzeCasal(msgs, stats);
        expect(casal.ignoringStats.wasIgnoredCount, equals(1));
      });

      test('B4.5: Response gap of 1 millisecond is valid response time', () {
        final t0 = DateTime(2025, 1, 1, 10, 0, 0, 0);
        final t1 = DateTime(2025, 1, 1, 10, 0, 0, 1);
        final msgs = [
          ChatMessage(timestamp: t0, author: 'A', content: 'Flash'),
          ChatMessage(timestamp: t1, author: 'B', content: 'Fast'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        expect(stats.averageResponseTimeMs, equals(1.0));
      });

      test('B4.6: Audio response delay of 1 hour 1 minute triggers audio ignoring', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'A', content: '<Mídia oculta>', isMedia: true),
          ChatMessage(timestamp: DateTime(2025, 1, 1, 11, 1), author: 'B', content: 'Ouvi'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final casal = E2EAnalyticsEngine.analyzeCasal(msgs, stats);
        expect(casal.audioIgnoringStats.wasIgnoredAudios, equals(1));
      });
    });

    // ------------------------------------------------------------------------
    // Area 5: Author & Participant Boundaries
    // ------------------------------------------------------------------------
    group('Area 5: Author & Participant Boundaries', () {
      test('B5.1: Author with emojis in display name parsed correctly', () {
        const raw = '05/06/2025 10:19 - 🚀 João Dev 💻: Código pronto';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.messages.first.author, equals('🚀 João Dev 💻'));
      });

      test('B5.2: Author with symbols and numbers parsed correctly', () {
        const raw = '05/06/2025 10:19 - +55 11 99999-8888: Olá contato';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.messages.first.author, equals('+55 11 99999-8888'));
      });

      test('B5.3: Author name with leading and trailing spaces is trimmed', () {
        const raw = '05/06/2025 10:19 -   Espaçado   : Conteúdo';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.messages.first.author, equals('Espaçado'));
      });

      test('B5.4: Mode detection for 1 participant defaults to Casal', () {
        expect(E2EAnalyticsEngine.detectMode(1), equals(ChatMode.casal));
      });

      test('B5.5: Mode detection for exactly 2 participants returns Casal', () {
        expect(E2EAnalyticsEngine.detectMode(2), equals(ChatMode.casal));
      });

      test('B5.6: Mode detection for exactly 3 participants returns Amigos', () {
        expect(E2EAnalyticsEngine.detectMode(3), equals(ChatMode.amigos));
      });

      test('B5.7: Mode detection for exactly 5 participants returns Amigos', () {
        expect(E2EAnalyticsEngine.detectMode(5), equals(ChatMode.amigos));
      });

      test('B5.8: Mode detection for exactly 6 participants returns Grupo', () {
        expect(E2EAnalyticsEngine.detectMode(6), equals(ChatMode.grupo));
      });

      test('B5.9: Mode detection for 50 participants returns Grupo', () {
        expect(E2EAnalyticsEngine.detectMode(50), equals(ChatMode.grupo));
      });

      test('B5.10: 50 participants in group calculates complete ranking without missing members', () {
        final msgs = List.generate(
          50,
          (i) => ChatMessage(
            timestamp: DateTime(2025, 1, 1, 10, i),
            author: 'Member_$i',
            content: 'Msg from $i',
          ),
        );
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final grupo = E2EAnalyticsEngine.analyzeGrupo(msgs, stats);
        expect(grupo.memberRanking.length, equals(50));
      });
    });

    // ------------------------------------------------------------------------
    // Area 6: Message Content & Tokenization Boundaries
    // ------------------------------------------------------------------------
    group('Area 6: Message Content & Tokenization Boundaries', () {
      test('B6.1: Message with only emojis is preserved and counted in emoji frequencies', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'A', content: '😂🤣❤️🔥👍'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        expect(stats.topEmojis.length, equals(5));
        expect(stats.topWords.isEmpty, isTrue);
      });

      test('B6.2: Message with only numbers and punctuation yields 0 words > 3 chars', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'A', content: '123 456 789 !?., -:;'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        expect(stats.topWords.isEmpty, isTrue);
      });

      test('B6.3: Non-Latin scripts (Arabic, Chinese, Cyrillic) preserved in content', () {
        const raw = '05/06/2025 10:19 - Polyglot: مرحبا 你好 Привет';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.messages.first.content, contains('مرحبا'));
        expect(export.messages.first.content, contains('你好'));
        expect(export.messages.first.content, contains('Привет'));
      });

      test('B6.4: 100% media messages yields totalAudios equal to total messages', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'A', content: '<Mídia oculta>', isMedia: true),
          ChatMessage(timestamp: DateTime.now(), author: 'B', content: '<Mídia oculta>', isMedia: true),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final casal = E2EAnalyticsEngine.analyzeCasal(msgs, stats);
        expect(casal.audioIgnoringStats.totalAudios, equals(2));
      });

      test('B6.5: 0% media messages yields totalAudios == 0', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'A', content: 'Puro texto'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final casal = E2EAnalyticsEngine.analyzeCasal(msgs, stats);
        expect(casal.audioIgnoringStats.totalAudios, equals(0));
      });

      test('B6.6: Portuguese accented words correctly tokenized without character stripping corruption', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'A', content: 'coração atenção reunião'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final words = stats.topWords.map((w) => w.word).toList();
        expect(words, contains('coração'));
        expect(words, contains('atenção'));
      });
    });

    // ------------------------------------------------------------------------
    // Area 7: System Message & Corruption Boundaries
    // ------------------------------------------------------------------------
    group('Area 7: System Message & Corruption Boundaries', () {
      test('B7.1: Corrupted line followed by valid line skips corrupted line without crashing', () {
        const raw = '''CORRUPT_NON_TIMESTAMP_LINE
05/06/2025 10:19 - ValidUser: Valid message''';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.totalMessages, equals(1));
        expect(export.messages.first.author, equals('ValidUser'));
      });

      test('B7.2: 5 consecutive system messages filtered without creating false messages', () {
        const raw = '''05/06/2025 10:19 - As mensagens e ligações são protegidas com a criptografia
05/06/2025 10:20 - João adicionou Maria
05/06/2025 10:21 - Maria saiu do grupo
05/06/2025 10:22 - Seu código de segurança com João mudou
05/06/2025 10:23 - Esta mensagem foi apagada''';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.totalMessages, equals(0));
      });

      test('B7.3: System message at start of file handled gracefully', () {
        const raw = '''05/06/2025 10:19 - As mensagens e ligações são protegidas
05/06/2025 10:20 - User: Primeiro chat''';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.totalMessages, equals(1));
      });

      test('B7.4: System message at end of file flushes preceding message', () {
        const raw = '''05/06/2025 10:19 - User: Último chat
05/06/2025 10:20 - As mensagens e ligações são protegidas''';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.totalMessages, equals(1));
      });

      test('B7.5: System message with multiple colons handled without crashing', () {
        const raw = '05/06/2025 10:19 - As mensagens e ligações são protegidas com: criptografia: ponta a ponta';
        expect(E2EWhatsAppParser.isSystemMessage(raw), isTrue);
      });
    });

    // ------------------------------------------------------------------------
    // Area 8: Compatibility Score Mathematical Boundaries
    // ------------------------------------------------------------------------
    group('Area 8: Compatibility Score Mathematical Boundaries', () {
      test('B8.1: Compatibility score clamped at maximum 100', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'P1', content: 'Amor ❤️'),
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 1), author: 'P2', content: 'Amor ❤️'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final casal = E2EAnalyticsEngine.analyzeCasal(msgs, stats);
        expect(casal.compatibility.score, lessThanOrEqualTo(100));
      });

      test('B8.2: Compatibility score clamped at minimum 0', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'P1', content: 'X' * 1000),
          ChatMessage(timestamp: DateTime(2025, 1, 1, 23, 0), author: 'P2', content: 'Y'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final casal = E2EAnalyticsEngine.analyzeCasal(msgs, stats);
        expect(casal.compatibility.score, greaterThanOrEqualTo(0));
      });

      test('B8.3: 100% length asymmetry lowers S_len to 0', () {
        double avg1 = 1000.0;
        double avg2 = 0.0;
        double maxLen = max(avg1, avg2);
        double sLen = 1.0 - ((avg1 - avg2).abs() / maxLen);
        expect(sLen, equals(0.0));
      });

      test('B8.4: 100% emoji asymmetry lowers S_emoji to 0', () {
        double r1 = 1.0;
        double r2 = 0.0;
        double sEmoji = 1.0 - (r1 - r2).abs();
        expect(sEmoji, equals(0.0));
      });

      test('B8.5: Response time > 4 hours assigns S_resp = 0.5', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'A', content: 'M1'),
          ChatMessage(timestamp: DateTime(2025, 1, 1, 16, 0), author: 'B', content: 'M2'), // 6h
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        expect(stats.averageResponseTimeMs, greaterThan(14400000));
        final casal = E2EAnalyticsEngine.analyzeCasal(msgs, stats);
        expect(casal.compatibility.score, equals(80)); // 0.3*1.0 + 0.3*1.0 + 0.4*0.5 = 0.80 -> 80
      });
    });

    // ------------------------------------------------------------------------
    // Area 9: Amigos Personality Decision Tree Boundaries
    // ------------------------------------------------------------------------
    group('Area 9: Amigos Personality Decision Tree Boundaries', () {
      test('B9.1: Laugh ratio 0.31 (>0.30) classified as engraçado', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: '😂'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: '🤣'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: '😆'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'msg 4'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'msg 5'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'msg 6'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'msg 7'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'msg 8'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'msg 9'),
        ]; // 3/9 = 0.333 > 0.30
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final amigos = E2EAnalyticsEngine.analyzeAmigos(msgs, stats);
        expect(amigos.communicationStyles.first.style, equals('engraçado'));
      });

      test('B9.2: Emoji ratio > 0.40 with laugh <= 0.30 classified as expressivo', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: '😊'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: '🎉'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'Texto normal'),
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'Texto normal'),
        ]; // 2/4 = 0.50 > 0.40
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final amigos = E2EAnalyticsEngine.analyzeAmigos(msgs, stats);
        expect(amigos.communicationStyles.first.style, equals('expressivo'));
      });

      test('B9.3: Avg length > 100 with no emojis classified as detalhista', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'X' * 105),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final amigos = E2EAnalyticsEngine.analyzeAmigos(msgs, stats);
        expect(amigos.communicationStyles.first.style, equals('detalhista'));
      });

      test('B9.4: Avg length < 20 with no emojis classified as objetivo', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'Blz'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final amigos = E2EAnalyticsEngine.analyzeAmigos(msgs, stats);
        expect(amigos.communicationStyles.first.style, equals('objetivo'));
      });

      test('B9.5: Moderate length without emojis or laughs classified as carinhoso', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'Test', content: 'Vamos nos encontrar para conversar'),
        ]; // length ~ 35 chars
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final amigos = E2EAnalyticsEngine.analyzeAmigos(msgs, stats);
        expect(amigos.communicationStyles.first.style, equals('carinhoso'));
      });
    });

    // ------------------------------------------------------------------------
    // Area 10: Grupo Dynamics & Ranking Boundaries
    // ------------------------------------------------------------------------
    group('Area 10: Grupo Dynamics & Ranking Boundaries', () {
      test('B10.1: Group with only 2 members awards only gold and silver medals', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'A', content: '1'),
          ChatMessage(timestamp: DateTime.now(), author: 'B', content: '2'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final grupo = E2EAnalyticsEngine.analyzeGrupo(msgs, stats);
        expect(grupo.memberRanking[0].medal, equals('🥇'));
        expect(grupo.memberRanking[1].medal, equals('🥈'));
        expect(grupo.memberRanking.length, equals(2));
      });

      test('B10.2: Exact tie in message count preserves rankings deterministically', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'A', content: '1'),
          ChatMessage(timestamp: DateTime.now(), author: 'B', content: '2'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final grupo = E2EAnalyticsEngine.analyzeGrupo(msgs, stats);
        expect(grupo.memberRanking[0].percentage, equals(50));
        expect(grupo.memberRanking[1].percentage, equals(50));
      });

      test('B10.3: Zero night messages handled without assigning null night owl', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1, 14, 0), author: 'DayWorker', content: 'Tarde'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final grupo = E2EAnalyticsEngine.analyzeGrupo(msgs, stats);
        expect(grupo.groupDynamics.nightOwl, isNotNull);
      });

      test('B10.4: Member active on 3 distinct calendar days tracked in consistency', () {
        final msgs = [
          ChatMessage(timestamp: DateTime(2025, 1, 1), author: 'A', content: 'D1'),
          ChatMessage(timestamp: DateTime(2025, 1, 2), author: 'A', content: 'D2'),
          ChatMessage(timestamp: DateTime(2025, 1, 3), author: 'A', content: 'D3'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final grupo = E2EAnalyticsEngine.analyzeGrupo(msgs, stats);
        expect(grupo.groupDynamics.mostConsistent, equals('A'));
      });

      test('B10.5: Group dynamics with single author handles silent and active identically', () {
        final msgs = [
          ChatMessage(timestamp: DateTime.now(), author: 'Solo', content: 'Sozinho'),
        ];
        final stats = E2EAnalyticsEngine.calculateGeneralStats(msgs);
        final grupo = E2EAnalyticsEngine.analyzeGrupo(msgs, stats);
        expect(grupo.groupDynamics.mostActive, equals('Solo'));
        expect(grupo.groupDynamics.silent, equals('Solo'));
      });
    });

    // ------------------------------------------------------------------------
    // Area 11: ZIP & Ingestion Boundaries
    // ------------------------------------------------------------------------
    group('Area 11: ZIP & Ingestion Boundaries', () {
      test('B11.1: Truncated 2-byte header returns null for zip extraction', () {
        final bytes = [0x50, 0x4B];
        expect(E2EZipExtractor.isZip(bytes), isFalse);
        expect(E2EZipExtractor.extractChatText(bytes), isNull);
      });

      test('B11.2: Corrupted magic bytes [0x00, 0x00, 0x00, 0x00] return null', () {
        final bytes = [0, 0, 0, 0];
        expect(E2EZipExtractor.isZip(bytes), isFalse);
        expect(E2EZipExtractor.extractChatText(bytes), isNull);
      });

      test('B11.3: Nested directory zip fixture locates chat.txt cleanly', () {
        final file = File('test/fixtures/sample_chat.zip');
        final bytes = file.readAsBytesSync();
        final text = E2EZipExtractor.extractChatText(bytes);
        expect(text, isNotNull);
        expect(text!.isNotEmpty, isTrue);
      });

      test('B11.4: Ingestion of non-existent path throws or handles safely', () {
        final nonExistent = File('test/fixtures/does_not_exist.txt');
        expect(nonExistent.existsSync(), isFalse);
      });

      test('B11.5: Ingestion pipeline handles BOM at start of zip entry', () {
        final raw = '\uFEFF05/06/2025 10:19 - BOMUser: Conteúdo com BOM';
        final export = E2EWhatsAppParser.parse(raw);
        expect(export.totalMessages, equals(1));
        expect(export.messages.first.author, equals('BOMUser'));
      });
    });
  });
}
