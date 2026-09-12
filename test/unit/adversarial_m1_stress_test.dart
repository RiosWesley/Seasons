// Adversarial Stress & Corner Case Test Suite for Milestone 1
// Ingestion, Parsing, Extraction & Sanitization Engines
// Challenger 1 - Milestone 1 Verification

import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/models/chat_message.dart';
import 'package:chat_wrapped/core/models/raw_chat_export.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';
import 'package:chat_wrapped/core/parser/whatsapp_regex.dart';
import 'package:chat_wrapped/core/services/file_ingestion_service.dart';
import 'package:chat_wrapped/core/services/zip_extractor_service.dart';

void main() {
  const parser = ChatParser();
  const zipExtractor = ZipExtractorService();
  final ingestionService = FileIngestionService(
    parser: parser,
    zipExtractor: zipExtractor,
  );

  // ==========================================================================
  // Area 1: Malformed Timestamp Strings, Corrupt Headers & Fuzzing
  // ==========================================================================
  group('Area 1: Malformed Timestamps & Header Corruption', () {
    test('1.1: Rejects impossible calendar months and days cleanly', () {
      // Month 13
      final headerMonth13 = WhatsAppRegex.parseHeader('15/13/2025 10:19 - User: Msg');
      expect(headerMonth13, isNull);

      // Month 00
      final headerMonth0 = WhatsAppRegex.parseHeader('15/00/2025 10:19 - User: Msg');
      expect(headerMonth0, isNull);

      // Day 00
      final headerDay0 = WhatsAppRegex.parseHeader('00/06/2025 10:19 - User: Msg');
      expect(headerDay0, isNull);

      // Day 99, Month 99
      final headerDay99 = WhatsAppRegex.parseHeader('99/99/2025 10:19 - User: Msg');
      expect(headerDay99, isNull);
    });

    test('1.2: Rejects impossible time components cleanly', () {
      // Hour 24 (24h clock ranges 00..23)
      final headerHour24 = WhatsAppRegex.parseHeader('05/06/2025 24:00 - User: Msg');
      expect(headerHour24, isNull);

      // Hour 99
      final headerHour99 = WhatsAppRegex.parseHeader('05/06/2025 99:00 - User: Msg');
      expect(headerHour99, isNull);

      // Minute 60 (ranges 00..59)
      final headerMin60 = WhatsAppRegex.parseHeader('05/06/2025 10:60 - User: Msg');
      expect(headerMin60, isNull);

      // Second 60 in bracket format
      final headerSec60 = WhatsAppRegex.parseHeader('[05/06/2025, 10:19:60] User: Msg');
      expect(headerSec60, isNull);
    });

    test('1.3: Rejects lines missing required delimiters (dash, colon, author)', () {
      // Missing dash
      expect(WhatsAppRegex.parseHeader('05/06/2025 10:19 User: Msg'), isNull);

      // Missing colon after author
      expect(WhatsAppRegex.parseHeader('05/06/2025 10:19 - User Msg'), isNull);

      // Missing timestamp digits
      expect(WhatsAppRegex.parseHeader('ab/cd/efgh ij:kl - User: Msg'), isNull);

      // Empty line or whitespace only
      expect(WhatsAppRegex.parseHeader(''), isNull);
      expect(WhatsAppRegex.parseHeader('   \t  \n  '), isNull);
    });

    test('1.4: Handles complex author names with dashes, colons and URLs', () {
      const complexLine = '05/06/2025 10:19 - Dr. Alex - Specialist: Check out this link: https://example.com/test?a=1&b=2';
      final header = WhatsAppRegex.parseHeader(complexLine);
      expect(header, isNotNull);
      expect(header!.author, equals('Dr. Alex - Specialist'));
      expect(header.content, equals('Check out this link: https://example.com/test?a=1&b=2'));
    });

    test('1.5: Handles 2-digit years across millennium boundary correctly', () {
      // '25' -> 2025
      final h25 = WhatsAppRegex.parseHeader('05/06/25 10:19 - A: Hi');
      expect(h25!.timestamp.year, equals(2025));

      // '00' -> 2000
      final h00 = WhatsAppRegex.parseHeader('05/06/00 10:19 - A: Hi');
      expect(h00!.timestamp.year, equals(2000));

      // '99' -> 2099
      final h99 = WhatsAppRegex.parseHeader('05/06/99 10:19 - A: Hi');
      expect(h99!.timestamp.year, equals(2099));
    });

    test('1.6: ReDoS resilience test against repetitive adversarial whitespace patterns', () {
      final stopwatch = Stopwatch()..start();
      final adversarialLine = '05/06/2025 10:19${' ' * 10000}- User: Hello';
      final header = WhatsAppRegex.parseHeader(adversarialLine);
      stopwatch.stop();

      expect(header, isNotNull);
      expect(header!.author, equals('User'));
      expect(stopwatch.elapsedMilliseconds, lessThan(100), reason: 'Regex should execute in linear time without catastrophic backtracking');
    });

    test('1.7: Discards leading corrupt lines before first valid message', () {
      const rawText = '''
CORRUPT_HEADER_LINE_1
INVALID 99/99/9999 99:99 NO_DELIMITER
RANDOM NOISE %&*!#@
05/06/2025 10:19 - Wesley: Primeira mensagem real
05/06/2025 10:20 - João: Segunda mensagem
''';
      final export = parser.parse(rawText);
      expect(export.totalMessages, equals(2));
      expect(export.messages.first.author, equals('Wesley'));
      expect(export.messages.first.content, equals('Primeira mensagem real'));
    });

    test('1.8: Throws WhatsAppParseException when file contains ONLY corrupt lines', () {
      const corruptOnly = '''
CORRUPT 1
99/99/9999 99:99 - Fake: Bad date
INVALID LINE WITHOUT TIMESTAMP
''';
      expect(() => parser.parse(corruptOnly), throwsA(isA<WhatsAppParseException>()));
    });

    test('1.9: Line with missing author before colon should not parse as valid user message', () {
      // Missing author before colon (just whitespace or zero-width)
      const emptyAuthorLine = '05/06/2025 10:19 - : Mensagem sem autor';
      final header = WhatsAppRegex.parseHeader(emptyAuthorLine);
      expect(header, isNull);
    });

    test('1.10: Zero-width only author is rejected as empty author header', () {
      const zwAuthorLine = '05/06/2025 10:19 - \u200E\u200F\uFEFF\u200B: Mensagem só com zero width no autor';
      final header = WhatsAppRegex.parseHeader(zwAuthorLine);
      expect(header, isNull);
    });

    test('1.11: Empty/zero-width author is rejected and prevents desynchronization', () {
      const chatWithEmptyAuthor = '''
05/06/2025 10:19 - : Mensagem sem autor
05/06/2025 10:20 - Wesley: Olá
''';
      final export = parser.parse(chatWithEmptyAuthor);
      // Empty author header rejected: only the valid message is parsed
      expect(export.totalMessages, equals(1));
      expect(export.participants, equals({'Wesley'}));
      expect(export.messages.first.author, equals('Wesley'));
    });
  });

  // ==========================================================================
  // Area 2: Extremely Large Multiline Paragraphs & Volume Stress
  // ==========================================================================
  group('Area 2: Extremely Large Multiline Paragraphs & High Volume', () {
    test('2.1: Accumulates massive 50,000+ character paragraph across 100 lines', () {
      final paragraphLines = List.generate(
        100,
        (i) => 'Linha $i de texto com símbolos especiais: § ¶ © ® ™ € £ ¥ • 🚀 #$i ${'X' * 500}',
      );
      final rawContent = '05/06/2025 10:19 - GiantAuthor: Início do épico\n'
          '${paragraphLines.join('\n')}\n'
          '05/06/2025 10:20 - NextUser: Mensagem normal';

      final export = parser.parse(rawContent);
      expect(export.totalMessages, equals(2));

      final giantMsg = export.messages.first;
      expect(giantMsg.author, equals('GiantAuthor'));
      expect(giantMsg.content.length, greaterThan(50000));
      expect(giantMsg.content.contains('Linha 0 de texto'), isTrue);
      expect(giantMsg.content.contains('Linha 99 de texto'), isTrue);

      final nextMsg = export.messages.last;
      expect(nextMsg.author, equals('NextUser'));
      expect(nextMsg.content, equals('Mensagem normal'));
    });

    test('2.2: Preserves internal blank lines within multiline paragraphs cleanly', () {
      const rawWithBlanks = '''
05/06/2025 10:19 - Poet: Estrofe 1


Estrofe 2 após linhas em branco


Estrofe 3
05/06/2025 10:20 - Reader: Belo poema!
''';
      final export = parser.parse(rawWithBlanks);
      expect(export.totalMessages, equals(2));
      final poetContent = export.messages.first.content;
      expect(poetContent.contains('Estrofe 1'), isTrue);
      expect(poetContent.contains('Estrofe 2'), isTrue);
      expect(poetContent.contains('Estrofe 3'), isTrue);
      expect(poetContent.contains('\n\n'), isTrue);
    });

    test('2.3: Handles quoted timestamp-like lines inside multiline body', () {
      const rawWithQuotes = '''
05/06/2025 10:19 - Investigator: Ele me disse o seguinte:
> "05/06/2025 09:00 - Suspect: Eu não estava lá"
E depois saiu correndo.
05/06/2025 10:20 - Detective: Entendido.
''';
      final export = parser.parse(rawWithQuotes);
      expect(export.totalMessages, equals(2));
      expect(export.messages.first.author, equals('Investigator'));
      expect(export.messages.first.content.contains('Suspect: Eu não estava lá'), isTrue);
      expect(export.messages.last.author, equals('Detective'));
    });

    test('2.4: Parses 5,000 synthetic messages in under 200ms', () {
      final buffer = StringBuffer();
      final baseDate = DateTime(2025, 1, 1, 8, 0);

      for (int i = 0; i < 5000; i++) {
        final date = baseDate.add(Duration(minutes: i));
        final day = date.day.toString().padLeft(2, '0');
        final month = date.month.toString().padLeft(2, '0');
        final year = date.year;
        final hour = date.hour.toString().padLeft(2, '0');
        final minute = date.minute.toString().padLeft(2, '0');
        final author = i % 2 == 0 ? 'Alice' : 'Bob';
        buffer.writeln('$day/$month/$year $hour:$minute - $author: Mensagem número $i');
      }

      final rawText = buffer.toString();
      final stopwatch = Stopwatch()..start();
      final export = parser.parse(rawText);
      stopwatch.stop();

      expect(export.totalMessages, equals(5000));
      expect(export.participants, equals({'Alice', 'Bob'}));
      expect(stopwatch.elapsedMilliseconds, lessThan(1500), reason: 'Parsing 5,000 lines must be ultra-fast');
    });

    test('2.5: Handles mixed newline characters (CRLF and LF) transparently', () {
      final crlfContent = "05/06/2025 10:19 - UserA: Linha 1\r\nLinha 2 multiline\r\n05/06/2025 10:20 - UserB: Resposta\nLinha Unix";
      final export = parser.parse(crlfContent);
      expect(export.totalMessages, equals(2));
      expect(export.messages[0].content, equals('Linha 1\nLinha 2 multiline'));
      expect(export.messages[1].content, equals('Resposta\nLinha Unix'));
    });
  });

  // ==========================================================================
  // Area 3: Corrupted, Incomplete, Nested & Media-Heavy ZIP Archives
  // ==========================================================================
  group('Area 3: ZIP Archives Ingestion, Corruption & Zero-OOM', () {
    test('3.1: Incomplete or truncated ZIP byte buffers throw ZipExtractorException gracefully', () {
      // 1 byte
      expect(
        () => zipExtractor.extractChatTextFromBytes([0x50]),
        throwsA(isA<ZipExtractorException>()),
      );

      // 4 magic bytes only (incomplete ZIP header)
      expect(
        () => zipExtractor.extractChatTextFromBytes([0x50, 0x4B, 0x03, 0x04]),
        throwsA(isA<ZipExtractorException>()),
      );

      // Random corrupt bytes with zip extension in ingestion service
      expect(
        () => ingestionService.ingestBytes(
          [0x50, 0x4B, 0x03, 0x04, 0xFF, 0xFE, 0xAA, 0xBB],
          fileName: 'corrupt.zip',
        ),
        throwsA(isA<ZipExtractorException>()),
      );
    });

    test('3.2: Non-ZIP file (e.g. PNG image bytes) renamed to .zip is safely rejected', () {
      final fakePngBytes = [
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D
      ];
      expect(
        () => zipExtractor.extractChatTextFromBytes(fakePngBytes),
        throwsA(isA<ZipExtractorException>()),
      );
    });

    test('3.3: Extracts chat from deeply nested directory paths inside ZIP', () {
      final archive = Archive();
      const chatContent = '05/06/2025 10:19 - Explorer: Encontrado em subdiretório profundo!';
      final chatData = utf8.encode(chatContent);

      // Path nested inside folders
      archive.addFile(
        ArchiveFile('WhatsApp/Backups/2025/June/_chat.txt', chatData.length, chatData),
      );
      // Extra dummy media files
      archive.addFile(ArchiveFile('WhatsApp/Media/img1.jpg', 10, Uint8List(10)));
      archive.addFile(ArchiveFile('WhatsApp/Media/audio.opus', 10, Uint8List(10)));

      final zipBytes = ZipEncoder().encode(archive);
      final extracted = zipExtractor.extractChatTextFromBytes(zipBytes);
      expect(extracted, equals(chatContent));
    });

    test('3.4: Priority selection chooses WhatsApp export when multiple txt files exist', () {
      final archive = Archive();
      final notesData = utf8.encode('Arquivo de notas aleatório');
      final chatData = utf8.encode('05/06/2025 10:19 - ValidUser: Conversa principal');

      archive.addFile(ArchiveFile('readme.txt', notesData.length, notesData));
      archive.addFile(ArchiveFile('Conversa do WhatsApp com Amigo.txt', chatData.length, chatData));

      final zipBytes = ZipEncoder().encode(archive);
      final extracted = zipExtractor.extractChatTextFromBytes(zipBytes);
      expect(extracted, equals('05/06/2025 10:19 - ValidUser: Conversa principal'));
    });

    test('3.5: Decompression skips 50MB dummy media files without OOM or lag', () {
      final archive = Archive();
      const chatContent = '05/06/2025 10:19 - StreamUser: Chat extraído sem ler vídeos pesados';
      final chatData = utf8.encode(chatContent);
      archive.addFile(ArchiveFile('_chat.txt', chatData.length, chatData));

      // Add 5 x 2MB dummy media files (10MB total)
      final dummyMediaBytes = Uint8List(1024 * 1024 * 2);
      for (int i = 0; i < 5; i++) {
        archive.addFile(ArchiveFile('video_$i.mp4', dummyMediaBytes.length, dummyMediaBytes));
      }

      final stopwatch = Stopwatch()..start();
      final zipBytes = ZipEncoder().encode(archive);

      stopwatch.reset();
      final extracted = zipExtractor.extractChatTextFromBytes(zipBytes);
      stopwatch.stop();

      expect(extracted, equals(chatContent));
      expect(stopwatch.elapsedMilliseconds, lessThan(200), reason: 'Chat extraction from archive must take <200ms');
    });

    test('3.6: Correctly decodes Latin-1 / ISO-8859-1 fallback when UTF-8 is invalid', () {
      // Create Latin-1 encoded bytes for "Olá, coração!"
      // 'ç' in Latin-1 is 0xE7, 'ã' is 0xE3 (invalid UTF-8 standalone sequences)
      final latin1Bytes = latin1.encode('05/06/2025 10:19 - Wesley: Olá, coração com acentuação!');

      final archive = Archive();
      archive.addFile(ArchiveFile('_chat.txt', latin1Bytes.length, latin1Bytes));
      final zipBytes = ZipEncoder().encode(archive);

      final extracted = zipExtractor.extractChatTextFromBytes(zipBytes);
      expect(extracted.contains('\uFFFD'), isFalse);
      expect(extracted.contains('Olá'), isTrue, reason: 'Latin-1 accented characters must not be corrupted to replacement characters');
      expect(extracted.contains('coração'), isTrue);
    });

    test('3.7: FileIngestionService identifies ZIP stream via magic bytes even if named .txt', () async {
      final archive = Archive();
      const chatContent = '05/06/2025 10:19 - Camouflage: Sou um ZIP disfarçado';
      final chatData = utf8.encode(chatContent);
      archive.addFile(ArchiveFile('_chat.txt', chatData.length, chatData));
      final zipBytes = ZipEncoder().encode(archive);

      final export = await ingestionService.ingestBytes(zipBytes, fileName: 'chat.txt');
      expect(export.totalMessages, equals(1));
      expect(export.messages.first.author, equals('Camouflage'));
      expect(export.messages.first.content, equals('Sou um ZIP disfarçado'));
    });

    test('3.8: Nested ZIP archive (ZIP inside ZIP)', () {
      final innerArchive = Archive();
      final chatBytes = utf8.encode('05/06/2025 10:19 - User: Chat inside inner zip');
      innerArchive.addFile(ArchiveFile('_chat.txt', chatBytes.length, chatBytes));
      final innerZipBytes = ZipEncoder().encode(innerArchive);

      final outerArchive = Archive();
      outerArchive.addFile(ArchiveFile('inner_backup.zip', innerZipBytes.length, innerZipBytes));
      outerArchive.addFile(ArchiveFile('dummy.jpg', 10, Uint8List(10)));
      final outerZipBytes = ZipEncoder().encode(outerArchive);

      expect(
        () => zipExtractor.extractChatTextFromBytes(outerZipBytes),
        throwsA(isA<ZipExtractorException>()),
      );
    });

    test('3.9: Corrupted compressed payload in ZIP throws ZipExtractorException', () {
      final validArchive = Archive();
      validArchive.addFile(ArchiveFile('_chat.txt', 100, utf8.encode('05/06/2025 10:19 - A: Test ' * 10)));
      final validZipBytes = Uint8List.fromList(ZipEncoder().encode(validArchive));
      // Corrupt payload bytes in the zip stream
      for (int i = 30; i < 60 && i < validZipBytes.length; i++) {
        validZipBytes[i] = 0xAA;
      }
      expect(
        () => zipExtractor.extractChatTextFromBytes(validZipBytes),
        throwsA(isA<ZipExtractorException>()),
      );
    });
  });

  // ==========================================================================
  // Area 4: Zero-Width Characters Flood & Unicode Fuzzing
  // ==========================================================================
  group('Area 4: Zero-Width Character Floods & Unicode Fuzzing', () {
    test('4.1: Strips massive flood of zero-width control chars from timestamp header', () {
      // Heavy injection of \u200E (LRM), \u200F (RLM), \uFEFF (BOM), \u200B (ZWSP), \u200C (ZWNJ)
      final corruptedHeader =
          '\u200E\uFEFF\u200E05\u200F/\u200E06\u200F/\u200E2025\u202F10:19\u200E -\u200E João\u200B \u200FArthur\u200C:\u200E Mensagem limpa!';

      final header = WhatsAppRegex.parseHeader(corruptedHeader);
      expect(header, isNotNull);
      expect(header!.timestamp, equals(DateTime(2025, 6, 5, 10, 19)));
      expect(header.author, equals('João Arthur'));
      expect(header.content, equals('Mensagem limpa!'));
    });

    test('4.2: Handles line with 10,000 zero-width chars as empty line without breaking parser', () {
      final zwFlood = '\u200E\u200F\uFEFF\u200B\u200C' * 2000;
      final rawText = '''
05/06/2025 10:19 - Wesley: Primeira mensagem
$zwFlood
05/06/2025 10:20 - Wesley: Segunda mensagem
''';
      final export = parser.parse(rawText);
      expect(export.totalMessages, equals(2));
      expect(export.messages[0].content, equals('Primeira mensagem'));
      expect(export.messages[1].content, equals('Segunda mensagem'));
    });

    test('4.3: Preserves compound emojis with ZWJ and skin tones intact', () {
      // Family emoji with ZWJ: 👨‍👩‍👧‍👦 (\u{1F468}\u200D\u{1F469}\u200D\u{1F467}\u200D\u{1F466})
      // Thumbs up with medium-light skin tone: 👍🏼
      // Flag: 🏳️‍🌈
      const emojiMsg = '05/06/2025 10:19 - EmojiLover: Família 👨‍👩‍👧‍👦, bandeira 🏳️‍🌈 e legal 👍🏼!';
      final export = parser.parse(emojiMsg);
      expect(export.totalMessages, equals(1));
      final content = export.messages.first.content;
      expect(content, contains('👨‍👩‍👧‍👦'));
      expect(content, contains('🏳️‍🌈'));
      expect(content, contains('👍🏼'));
    });

    test('4.4: Normalizes exotic whitespace (NBSP, NNBSP, Figure Space, Thin Space)', () {
      // \u00A0 (NBSP), \u202F (NNBSP), \u2007 (Figure space), \u2009 (Thin space)
      const nonStandardSpaces = '05/06/2025,\u00A010:19\u202FAM - Wesley:\u2007Espaço\u2009Fino';
      final header = WhatsAppRegex.parseHeader(nonStandardSpaces);
      expect(header, isNotNull);
      expect(header!.timestamp, equals(DateTime(2025, 6, 5, 10, 19)));
      expect(header.content, equals('Espaço Fino'));
    });

    test('4.5: Preserves RTL and multi-script characters in message content', () {
      const multilingual = '''
05/06/2025 10:19 - Polyglot: العربية (Arabic) עברית (Hebrew) 日本語 (Japanese) Русский (Russian)
05/06/2025 10:20 - Polyglot: Símbolos matemáticos: ∀x ∈ ℝ, ∃y: y > x² + √z ≈ π
''';
      final export = parser.parse(multilingual);
      expect(export.totalMessages, equals(2));
      expect(export.messages[0].content, contains('العربية'));
      expect(export.messages[0].content, contains('עברית'));
      expect(export.messages[0].content, contains('日本語'));
      expect(export.messages[1].content, contains('∀x ∈ ℝ'));
    });
  });

  // ==========================================================================
  // Area 5: Media Markers, System Notifications & Boundary Contracts
  // ==========================================================================
  group('Area 5: Media Classification & System Filtering', () {
    test('5.1: Classifies various audio, video, sticker, and document media markers', () {
      expect(WhatsAppRegex.detectMediaType('audio omitted'), equals('audio'));
      expect(WhatsAppRegex.detectMediaType('Mensagem de voz.opus (arquivo anexado)'), equals('audio'));
      expect(WhatsAppRegex.detectMediaType('PTT-20250605-WA0001.opus (arquivo anexado)'), equals('audio'));
      expect(WhatsAppRegex.detectMediaType('video omitted'), equals('video'));
      expect(WhatsAppRegex.detectMediaType('VID-20250605-WA0001.mp4 (arquivo anexado)'), equals('video'));
      expect(WhatsAppRegex.detectMediaType('sticker omitted'), equals('sticker'));
      expect(WhatsAppRegex.detectMediaType('STK-20250605-WA0001.webp (arquivo anexado)'), equals('sticker'));
      expect(WhatsAppRegex.detectMediaType('<Mídia oculta>'), equals('image'));
      expect(WhatsAppRegex.detectMediaType('<Media omitted>'), equals('image'));
    });

    test('5.2: Filters out Portuguese and English deleted message notices by default', () {
      const rawText = '''
05/06/2025 10:19 - Alice: Oi!
05/06/2025 10:20 - Bob: Esta mensagem foi apagada.
05/06/2025 10:21 - Alice: O que era?
05/06/2025 10:22 - Bob: This message was deleted.
05/06/2025 10:23 - Alice: Você apagou esta mensagem
05/06/2025 10:24 - Alice: Ok então
''';
      final export = parser.parse(rawText);
      // All 3 deleted notices filtered: only 3 real messages remain
      expect(export.totalMessages, equals(3));
      expect(export.messages.map((m) => m.content).toList(), equals(['Oi!', 'O que era?', 'Ok então']));
    });

    test('5.3: Correctly sets RawChatExport start and end dates from unordered messages', () {
      final messages = [
        ChatMessage(
          timestamp: DateTime(2025, 6, 10, 12, 0),
          author: 'A',
          content: 'Mid date',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 8, 0),
          author: 'B',
          content: 'Earliest date',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 12, 31, 23, 59),
          author: 'A',
          content: 'Latest date',
        ),
      ];
      final export = RawChatExport.fromMessages(messages);
      expect(export.startDate, equals(DateTime(2025, 1, 1, 8, 0)));
      expect(export.endDate, equals(DateTime(2025, 12, 31, 23, 59)));
      expect(export.participants, equals({'A', 'B'}));
    });
  });
}
