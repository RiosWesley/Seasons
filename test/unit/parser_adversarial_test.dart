import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';
import 'package:chat_wrapped/core/services/file_ingestion_service.dart';
import 'package:chat_wrapped/core/services/zip_extractor_service.dart';

void main() {
  const parser = ChatParser();
  const zipExtractor = ZipExtractorService();
  final ingestionService = FileIngestionService(
    parser: parser,
    zipExtractor: zipExtractor,
  );

  group('Adversarial 1: Rapid Succession Timestamps', () {
    test('parses 100 rapid succession messages in the exact same minute without dropping or merging', () {
      final buffer = StringBuffer();
      for (int i = 0; i < 100; i++) {
        final author = i.isEven ? 'Alice' : 'Bob';
        buffer.writeln('05/06/2025 10:19 - $author: Message index $i');
      }

      final export = parser.parse(buffer.toString());
      expect(export.totalMessages, equals(100));
      expect(export.messages.length, equals(100));
      expect(export.participants, equals({'Alice', 'Bob'}));
      expect(export.startDate, equals(DateTime(2025, 6, 5, 10, 19)));
      expect(export.endDate, equals(DateTime(2025, 6, 5, 10, 19)));

      for (int i = 0; i < 100; i++) {
        final expectedAuthor = i.isEven ? 'Alice' : 'Bob';
        expect(export.messages[i].author, equals(expectedAuthor));
        expect(export.messages[i].content, equals('Message index $i'));
        expect(export.messages[i].timestamp, equals(DateTime(2025, 6, 5, 10, 19)));
      }
    });

    test('preserves order for multiple consecutive messages from same author in same second', () {
      const input = '''
[05/06/2025, 10:19:30] Alice: First thought
[05/06/2025, 10:19:30] Alice: Second thought
[05/06/2025, 10:19:30] Alice: Third thought
[05/06/2025, 10:19:30] Bob: Quick reply
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(4));
      expect(export.messages.map((m) => m.content).toList(), equals([
        'First thought',
        'Second thought',
        'Third thought',
        'Quick reply',
      ]));
      expect(export.messages.map((m) => m.author).toList(), equals([
        'Alice',
        'Alice',
        'Alice',
        'Bob',
      ]));
    });

    test('handles date boundaries across midnight in rapid succession', () {
      const input = '''
31/12/2024 23:59:59 - Alice: Happy New Year!
01/01/2025 00:00:00 - Bob: Happy New Year to you too!
01/01/2025 00:00:01 - Alice: Cheers!
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(3));
      expect(export.startDate, equals(DateTime(2024, 12, 31, 23, 59, 59)));
      expect(export.endDate, equals(DateTime(2025, 1, 1, 0, 0, 1)));
    });

    test('correctly derives start/end dates when messages appear out-of-order in export', () {
      const input = '''
05/06/2025 10:25 - Alice: Late message arrived first
05/06/2025 10:15 - Bob: Earlier message logged second
05/06/2025 10:20 - Alice: Middle message
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(3));
      expect(export.startDate, equals(DateTime(2025, 6, 5, 10, 15)));
      expect(export.endDate, equals(DateTime(2025, 6, 5, 10, 25)));
    });
  });

  group('Adversarial 2: Complex Author Names', () {
    test('handles hyphenated names, space-padded hyphens, and multi-word names', () {
      const input = '''
05/06/2025 10:19 - Jean-Luc: Bonjour
05/06/2025 10:20 - Maria - Clara: Olá Jean-Luc
05/06/2025 10:21 - Pedro de Alcântara João Carlos Leopoldo: Olá a todos
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(3));
      expect(export.participants, equals({
        'Jean-Luc',
        'Maria - Clara',
        'Pedro de Alcântara João Carlos Leopoldo',
      }));
      expect(export.messages[0].author, equals('Jean-Luc'));
      expect(export.messages[0].content, equals('Bonjour'));
      expect(export.messages[1].author, equals('Maria - Clara'));
      expect(export.messages[1].content, equals('Olá Jean-Luc'));
    });

    test('handles brackets, parentheses, quotes, and tildes in author names', () {
      const input = '''
05/06/2025 10:19 - [Admin] John: Notice to all
05/06/2025 10:20 - {Support} Mary: How can I help?
05/06/2025 10:21 - Carlos "The Rock" O'Connor: Let's do this!
05/06/2025 10:22 - ~Wesley Rios: Leading tilde cleaned
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(4));
      expect(export.participants, equals({
        '[Admin] John',
        '{Support} Mary',
        'Carlos "The Rock" O\'Connor',
        'Wesley Rios',
      }));
      expect(export.messages[3].author, equals('Wesley Rios'));
    });

    test('handles phone numbers with international prefixes, spaces, and hyphens', () {
      const input = '''
05/06/2025 10:19 - +55 11 99999-8888: Olá Brasil
05/06/2025 10:20 - +1 (555) 234-5678: Hello USA
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(2));
      expect(export.participants, contains('+55 11 99999-8888'));
      expect(export.participants, contains('+1 (555) 234-5678'));
    });

    test('handles emojis and symbols in author names', () {
      const input = '''
05/06/2025 10:19 - 🇧🇷 Carlos Silva 🚀: Mensagem com emoji no nome
05/06/2025 10:20 - ⚡ Thunder ⚡: Mais um teste
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(2));
      expect(export.participants, equals({'🇧🇷 Carlos Silva 🚀', '⚡ Thunder ⚡'}));
      expect(export.messages[0].content, equals('Mensagem com emoji no nome'));
    });

    test('tolerates colons inside author names by splitting at first colon delimiter', () {
      const input = '''
05/06/2025 10:19 - Dr: House: Olá paciente
05/06/2025 10:20 - Paciente: Doutor, estou com dor
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(2));
      expect(export.messages[0].author, equals('Dr'));
      expect(export.messages[0].content, equals('House: Olá paciente'));
      expect(export.messages[1].author, equals('Paciente'));
    });
  });

  group('Adversarial 3: Fake Timestamps in Message Body', () {
    test('does not break on timestamps located within the message text on the same line', () {
      const input = '''
05/06/2025 10:19 - Alice: Reunião marcada para 05/06/2025 14:00 - Sala 3. Não se atrase!
05/06/2025 10:20 - Bob: Certo, às 14:00 estarei lá.
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(2));
      expect(export.messages[0].author, equals('Alice'));
      expect(
        export.messages[0].content,
        equals('Reunião marcada para 05/06/2025 14:00 - Sala 3. Não se atrase!'),
      );
      expect(export.messages[1].author, equals('Bob'));
    });

    test('accumulates multiline text with bulleted times and schedules', () {
      const input = '''
05/06/2025 10:19 - Alice: Cronograma do evento:
- 09:00: Credenciamento
- 10:00: Palestra de Abertura
- 12:00: Almoço
- 14:00: Workshops
Até amanhã pessoal!
05/06/2025 10:25 - Bob: Perfeito, anotado!
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(2));
      expect(export.messages[0].author, equals('Alice'));
      expect(
        export.messages[0].content,
        equals('Cronograma do evento:\n- 09:00: Credenciamento\n- 10:00: Palestra de Abertura\n- 12:00: Almoço\n- 14:00: Workshops\nAté amanhã pessoal!'),
      );
      expect(export.messages[1].author, equals('Bob'));
    });

    test('preserves quoted messages containing timestamps', () {
      const input = '''
05/06/2025 10:19 - Alice: Veja o que você me disse:
"04/06/2025 08:00 - Bob: Eu confirmo minha presença"
E agora você diz que não vai?
05/06/2025 10:20 - Bob: Mudei de ideia.
''';
      final export = parser.parse(input);
      expect(export.totalMessages, equals(2));
      expect(export.messages[0].author, equals('Alice'));
      expect(export.messages[0].content, contains('"04/06/2025 08:00 - Bob: Eu confirmo minha presença"'));
      expect(export.messages[1].author, equals('Bob'));
    });
  });

  group('Adversarial 4: Empty input, 0-byte files, and corrupt archives', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('chat_wrapped_adv_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('throws WhatsAppParseException on 0-byte text input string and whitespace', () {
      expect(() => parser.parse(''), throwsA(isA<WhatsAppParseException>()));
      expect(() => parser.parse('   \r\n\t   \n'), throwsA(isA<WhatsAppParseException>()));
    });

    test('throws WhatsAppParseException on 0-byte text file on disk', () async {
      final emptyFile = File('${tempDir.path}/empty.txt');
      await emptyFile.writeAsBytes([]);

      expect(
        () => ingestionService.ingestPath(emptyFile.path),
        throwsA(isA<WhatsAppParseException>()),
      );
    });

    test('throws ZipExtractorException on 0-byte ZIP file on disk', () async {
      final emptyZip = File('${tempDir.path}/empty.zip');
      await emptyZip.writeAsBytes([]);

      expect(
        () => ingestionService.ingestPath(emptyZip.path),
        throwsA(isA<ZipExtractorException>()),
      );
    });

    test('throws ZipExtractorException on 0-byte bytes to extractChatTextFromBytes', () {
      expect(
        () => zipExtractor.extractChatTextFromBytes([]),
        throwsA(isA<ZipExtractorException>()),
      );
    });

    test('throws ZipExtractorException when non-ZIP file has .zip extension', () async {
      final fakeZip = File('${tempDir.path}/fake.zip');
      await fakeZip.writeAsString('I am just a plain text file pretending to be a zip.');

      expect(
        () => ingestionService.ingestPath(fakeZip.path),
        throwsA(isA<ZipExtractorException>()),
      );
    });

    test('throws ZipExtractorException when file has ZIP magic header PK but corrupted payload', () async {
      final corruptMagic = File('${tempDir.path}/corrupt_magic.dat');
      // PK\x03\x04 followed by corrupted garbage
      await corruptMagic.writeAsBytes([0x50, 0x4B, 0x03, 0x04, 0xAA, 0xBB, 0xCC, 0xDD]);

      expect(
        () => ingestionService.ingestPath(corruptMagic.path),
        throwsA(isA<ZipExtractorException>()),
      );
    });

    test('throws ZipExtractorException when ZIP contains only non-txt files (e.g. photos)', () async {
      final archive = Archive();
      archive.addFile(ArchiveFile('photo.jpg', 10, Uint8List(10)));
      archive.addFile(ArchiveFile('audio.opus', 10, Uint8List(10)));
      final zipBytes = ZipEncoder().encode(archive);

      final zipFile = File('${tempDir.path}/no_text.zip');
      await zipFile.writeAsBytes(zipBytes);

      expect(
        () => ingestionService.ingestPath(zipFile.path),
        throwsA(isA<ZipExtractorException>()),
      );
    });

    test('throws WhatsAppParseException when ZIP contains an empty _chat.txt', () async {
      final archive = Archive();
      archive.addFile(ArchiveFile('_chat.txt', 0, Uint8List(0)));
      final zipBytes = ZipEncoder().encode(archive);

      final zipFile = File('${tempDir.path}/empty_chat_in_zip.zip');
      await zipFile.writeAsBytes(zipBytes);

      expect(
        () => ingestionService.ingestPath(zipFile.path),
        throwsA(isA<WhatsAppParseException>()),
      );
    });

    test('successfully extracts chat from nested directory inside ZIP archive', () async {
      final archive = Archive();
      const content = '05/06/2025 10:19 - Wesley: Olá da pasta aninhada!';
      final contentBytes = Uint8List.fromList(utf8.encode(content));
      archive.addFile(ArchiveFile('subfolder/export_dir/_chat.txt', contentBytes.length, contentBytes));
      final zipBytes = ZipEncoder().encode(archive);

      final zipFile = File('${tempDir.path}/nested.zip');
      await zipFile.writeAsBytes(zipBytes);

      final export = await ingestionService.ingestPath(zipFile.path);
      expect(export.totalMessages, equals(1));
      expect(export.messages.first.content, equals('Olá da pasta aninhada!'));
      expect(export.participants, equals({'Wesley'}));
    });
  });

  group('Adversarial 5: Silent Message Deletion & Multiline Truncation Flaws', () {
    test('does NOT drop normal user messages containing words like adicionou, removeu, added, etc.', () {
      const input = '''
05/06/2025 10:19 - Alice: Quem adicionou açúcar no café?
05/06/2025 10:20 - Bob: Eu adicionei um pouco.
05/06/2025 10:21 - Alice: O garçom removeu os pratos da mesa.
05/06/2025 10:22 - Bob: I added the new feature yesterday.
05/06/2025 10:23 - Alice: He removed the old file from git.
05/06/2025 10:24 - Bob: Você sabe qual é o código de segurança do cartão?
05/06/2025 10:25 - Alice: Quem foi que saiu do grupo da faculdade?
''';
      final export = parser.parse(input);
      expect(
        export.totalMessages,
        equals(7),
        reason: 'Legitimate user messages containing common words must not be dropped as system messages',
      );
      expect(export.participants, equals({'Alice', 'Bob'}));
    });

    test('does NOT truncate multiline messages when continuation line contains system keywords', () {
      const input = '''
05/06/2025 10:19 - Alice: Olá pessoal!
O cliente adicionou novos requisitos no projeto ontem.
Amanhã faremos o refinamento.
05/06/2025 10:20 - Bob: Certo, combinado.
''';
      final export = parser.parse(input);
      expect(
        export.messages.first.content,
        equals(
          'Olá pessoal!\nO cliente adicionou novos requisitos no projeto ontem.\nAmanhã faremos o refinamento.',
        ),
        reason: 'Multiline continuation lines without timestamps should not trigger system message truncation',
      );
      expect(export.totalMessages, equals(2));
    });
  });
}
