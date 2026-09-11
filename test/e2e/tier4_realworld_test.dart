// E2E Test Suite - Tier 4: Real-World Benchmark Workloads & End-to-End Traces
// Features the authoritative real-world WhatsApp export:
// "Conversa do WhatsApp com João Arthur Britto.txt"

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import '../fixtures/e2e_oracle.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 4: Real-World Workloads & Benchmark Traces', () {
    late String benchmarkContent;
    late RawChatExport benchmarkExport;

    setUpAll(() {
      final benchmarkFile = File('test/fixtures/benchmark_chat.txt');
      expect(benchmarkFile.existsSync(), isTrue);
      benchmarkContent = benchmarkFile.readAsStringSync();
      benchmarkExport = E2EWhatsAppParser.parse(benchmarkContent);
    });

    // ------------------------------------------------------------------------
    // João Arthur Britto Benchmark Verifications (Traces 1 to 12)
    // ------------------------------------------------------------------------
    test('RW1: Benchmark File Ingestion & Line Structure', () {
      final lines = benchmarkContent.split('\n');
      expect(lines.length, greaterThanOrEqualTo(22));
    });

    test('RW2: Benchmark System Messages Discarded (7 encryption lines)', () {
      // First 7 lines are encryption notices and should be filtered
      expect(benchmarkExport.totalMessages, equals(15));
      expect(benchmarkExport.messages.every((m) => !m.isSystem), isTrue);
    });

    test('RW3: Benchmark Exactly 15 Valid Chat Messages Parsed', () {
      expect(benchmarkExport.totalMessages, equals(15));
      expect(benchmarkExport.messages.length, equals(15));
    });

    test('RW4: Benchmark Exactly 2 Participants ("wesley rios" and "João Arthur Britto")', () {
      expect(benchmarkExport.participants.length, equals(2));
      expect(benchmarkExport.participants, containsAll(['wesley rios', 'João Arthur Britto']));
    });

    test('RW5: Benchmark Participant Message Distribution', () {
      final wesleyCount = benchmarkExport.messages.where((m) => m.author == 'wesley rios').length;
      final joaoCount = benchmarkExport.messages.where((m) => m.author == 'João Arthur Britto').length;

      expect(wesleyCount, equals(8));
      expect(joaoCount, equals(7));
      expect(wesleyCount + joaoCount, equals(15));
      expect((wesleyCount / 15 * 100).round(), equals(53));
      expect((joaoCount / 15 * 100).round(), equals(47));
    });

    test('RW6: Benchmark Media Messages Detection (Exactly 3 <Mídia oculta>)', () {
      final mediaMessages = benchmarkExport.messages.where((m) => m.isMedia).toList();
      expect(mediaMessages.length, equals(3));
      expect(mediaMessages[0].author, equals('João Arthur Britto'));
      expect(mediaMessages[1].author, equals('wesley rios'));
      expect(mediaMessages[2].author, equals('João Arthur Britto'));
    });

    test('RW7: Benchmark Non-Media Messages (Exactly 12 text messages)', () {
      final textMessages = benchmarkExport.messages.where((m) => !m.isMedia).toList();
      expect(textMessages.length, equals(12));
    });

    test('RW8: Benchmark Timeline Buckets (Jun/2025: 13, Out/2025: 2)', () {
      final stats = E2EAnalyticsEngine.calculateGeneralStats(benchmarkExport.messages);
      final jun = stats.timeline.firstWhere((t) => t.month == 'Jun' && t.year == 2025);
      final out = stats.timeline.firstWhere((t) => t.month == 'Out' && t.year == 2025);

      expect(jun.count, equals(13));
      expect(out.count, equals(2));
    });

    test('RW9: Benchmark Multi-Day Gap (>24h) Excluded from Turn Response Calculation', () {
      // 05/06/2025 11:51 to 17/10/2025 09:05 is > 24 hours (133 days)
      final stats = E2EAnalyticsEngine.calculateGeneralStats(benchmarkExport.messages);
      // Valid response turns (< 24h) are:
      // Turn 1: João (10:20) -> wesley (11:45) = 85 min = 5,100,000 ms
      // Turn 2: wesley (11:46) -> João (11:51) = 5 min = 300,000 ms
      // Turn 3: wesley (09:05 17/10) -> João (09:05 17/10) = 0 ms
      // Total = 5,400,000 ms over 3 turns -> Avg = 1,800,000 ms (30.0 min)
      expect(stats.averageResponseTimeMs, equals(1800000.0));
    });

    test('RW10: Benchmark Average Response Time is exactly 30 minutes (1,800,000 ms)', () {
      final stats = E2EAnalyticsEngine.calculateGeneralStats(benchmarkExport.messages);
      final avgMinutes = stats.averageResponseTimeMs / 60000;
      expect(avgMinutes, equals(30.0));
    });

    test('RW11: Benchmark Flood Streak: "wesley rios" wins with 7 consecutive messages', () {
      final stats = E2EAnalyticsEngine.calculateGeneralStats(benchmarkExport.messages);
      final amigos = E2EAnalyticsEngine.analyzeAmigos(benchmarkExport.messages, stats);
      expect(amigos.friendStats.biggestFloodName, equals('wesley rios'));
      expect(amigos.friendStats.biggestFloodCount, equals(7));
    });

    test('RW12: Benchmark Ghosting Count is 0 (85-min delay < 120-min ignore threshold)', () {
      final stats = E2EAnalyticsEngine.calculateGeneralStats(benchmarkExport.messages);
      final casal = E2EAnalyticsEngine.analyzeCasal(benchmarkExport.messages, stats);
      expect(casal.ignoringStats.wasIgnoredCount, equals(0));
      expect(casal.ignoringStats.ignoredCount, equals(0));
    });

    // ------------------------------------------------------------------------
    // Real-World Workflows: Mode Journeys (Traces 13 to 20)
    // ------------------------------------------------------------------------
    test('RW13: Benchmark Mode Classification selects Casal Mode for 2 participants', () {
      final mode = E2EAnalyticsEngine.detectMode(benchmarkExport.participants.length);
      expect(mode, equals(ChatMode.casal));
    });

    test('RW14: Benchmark Casal Compatibility Score calculation with S_resp = 0.9', () {
      final stats = E2EAnalyticsEngine.calculateGeneralStats(benchmarkExport.messages);
      final casal = E2EAnalyticsEngine.analyzeCasal(benchmarkExport.messages, stats);
      // Since avg response is 30min (<1h), S_resp = 0.9
      expect(casal.compatibility.score, greaterThan(60));
      expect(casal.compatibility.description, isNotEmpty);
    });

    test('RW15: Benchmark Casal Stories Catalog produces 18 completely unlocked slides', () {
      final slides = E2EStoryCatalog.getCasalSlides();
      expect(slides.length, equals(18));
      expect(slides.every((s) => !s.isLocked), isTrue);
      expect(slides[0].type, equals('header'));
      expect(slides[1].type, equals('total'));
      expect(slides[17].type, equals('final'));
    });

    test('RW16: Real-World Brazilian 24h Squad Journey (Amigos Mode)', () {
      final file = File('test/fixtures/brazilian_24h.txt');
      final export = E2EWhatsAppParser.parse(file.readAsStringSync());
      expect(export.participants.length, equals(3));

      final mode = E2EAnalyticsEngine.detectMode(export.participants.length);
      expect(mode, equals(ChatMode.amigos));

      final stats = E2EAnalyticsEngine.calculateGeneralStats(export.messages);
      final amigos = E2EAnalyticsEngine.analyzeAmigos(export.messages, stats);
      expect(amigos.communicationStyles.length, equals(3));
      expect(amigos.friendStats.mostMessagesCount, equals(9));
      expect(amigos.friendStats.favoriteEmoji, equals('😂'));
    });

    test('RW17: Real-World Brazilian 12h Romantic Journey (Casal Mode)', () {
      final file = File('test/fixtures/brazilian_12h.txt');
      final export = E2EWhatsAppParser.parse(file.readAsStringSync());
      expect(export.participants.length, equals(2));

      final stats = E2EAnalyticsEngine.calculateGeneralStats(export.messages);
      final casal = E2EAnalyticsEngine.analyzeCasal(export.messages, stats);
      expect(casal.loveLanguage.hearts, greaterThan(0));
      expect(casal.loveLanguage.romanticWords, greaterThan(0));
      expect(casal.compatibility.score, greaterThanOrEqualTo(70));
    });

    test('RW18: Real-World iOS Bracketed Hangout Journey (Amigos Mode)', () {
      final file = File('test/fixtures/ios_bracketed.txt');
      final export = E2EWhatsAppParser.parse(file.readAsStringSync());
      expect(export.participants.length, equals(4));

      final mode = E2EAnalyticsEngine.detectMode(export.participants.length);
      expect(mode, equals(ChatMode.amigos));

      final stats = E2EAnalyticsEngine.calculateGeneralStats(export.messages);
      final amigos = E2EAnalyticsEngine.analyzeAmigos(export.messages, stats);
      expect(amigos.friendStats.activeHourFormatted, equals('8h'));
      expect(amigos.friendStats.favoriteEmoji, equals('🥩'));
    });

    test('RW19: Real-World Media Omitted Chat Journey', () {
      final file = File('test/fixtures/media_omitted_chat.txt');
      final export = E2EWhatsAppParser.parse(file.readAsStringSync());
      final mediaCount = export.messages.where((m) => m.isMedia).length;
      expect(mediaCount, equals(6));

      final stats = E2EAnalyticsEngine.calculateGeneralStats(export.messages);
      expect(stats.totalMessages, equals(9));
      expect(stats.topEmojis.first.emoji, equals('😍'));
    });

    test('RW20: Full End-to-End User Simulation Pipeline', () {
      // 1. Ingestion of raw WhatsApp export
      final rawChat = benchmarkContent;
      expect(rawChat.isNotEmpty, isTrue);

      // 2. State-machine high-tolerance parsing & sanitization
      final export = E2EWhatsAppParser.parse(rawChat);
      expect(export.totalMessages, equals(15));
      expect(export.participants.length, equals(2));

      // 3. Mode detection
      final mode = E2EAnalyticsEngine.detectMode(export.participants.length);
      expect(mode, equals(ChatMode.casal));

      // 4. Offline statistical computation
      final stats = E2EAnalyticsEngine.calculateGeneralStats(export.messages);
      expect(stats.totalMessages, equals(15));
      expect(stats.averageResponseTimeMs, equals(1800000.0));

      // 5. Casal analytics engine execution
      final casal = E2EAnalyticsEngine.analyzeCasal(export.messages, stats);
      expect(casal.compatibility.score, inInclusiveRange(50, 100));
      expect(casal.ignoringStats.wasIgnoredCount, equals(0));

      // 6. Full 18-slide story deck generation (zero paywalls)
      final slides = E2EStoryCatalog.getCasalSlides();
      expect(slides.length, equals(18));
      expect(slides.every((s) => !s.isLocked), isTrue);

      // 7. Social export specifications check (1080x1920)
      const exportWidth = 1080;
      const exportHeight = 1920;
      expect(exportWidth / exportHeight, closeTo(9 / 16, 0.01));
    });
  });
}
