import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/parser/chat_parser.dart';
import 'package:chat_wrapped/core/parser/text_sanitizer.dart';
import 'package:chat_wrapped/core/parser/whatsapp_regex.dart';
import 'package:chat_wrapped/core/services/file_ingestion_service.dart';

void main() {
  const parser = ChatParser();

  group('TextSanitizer', () {
    test('strips zero-width and directional Unicode characters', () {
      const input = '\u200E\uFEFF[24/04/2023, 14:56]\u200F João:\u200B Olá mundo\u200C';
      final sanitized = TextSanitizer.sanitizeLine(input);
      expect(sanitized, equals('[24/04/2023, 14:56] João: Olá mundo'));
    });

    test('normalizes non-breaking and narrow spaces to standard spaces', () {
      const input = '24/04/2023,\u00A014:56\u202FAM - João: Olá\u2007mundo\u2009aqui';
      final sanitized = TextSanitizer.sanitizeLine(input);
      expect(sanitized, equals('24/04/2023, 14:56 AM - João: Olá mundo aqui'));
    });
  });

  group('WhatsAppRegex Header Matching', () {
    test('matches Brazilian 24h format without comma', () {
      const line = '05/06/2025 10:19 - João: Opa mano, tudo bem?';
      final header = WhatsAppRegex.parseHeader(line);
      expect(header, isNotNull);
      expect(header!.author, equals('João'));
      expect(header.content, equals('Opa mano, tudo bem?'));
      expect(header.timestamp, equals(DateTime(2025, 6, 5, 10, 19)));
    });

    test('matches Brazilian 24h format with comma', () {
      const line = '05/06/2025, 10:19 - João: Opa mano';
      final header = WhatsAppRegex.parseHeader(line);
      expect(header, isNotNull);
      expect(header!.author, equals('João'));
      expect(header.content, equals('Opa mano'));
      expect(header.timestamp, equals(DateTime(2025, 6, 5, 10, 19)));
    });

    test('matches Brazilian 12h format AM/PM with 2-digit and 4-digit years', () {
      const lineAm = '05/06/25, 10:19 AM - Maria: Bom dia';
      final headerAm = WhatsAppRegex.parseHeader(lineAm);
      expect(headerAm, isNotNull);
      expect(headerAm!.timestamp, equals(DateTime(2025, 6, 5, 10, 19)));
      expect(headerAm.author, equals('Maria'));
      expect(headerAm.content, equals('Bom dia'));

      const linePm = '05/06/2025, 10:19 PM - Maria: Boa noite';
      final headerPm = WhatsAppRegex.parseHeader(linePm);
      expect(headerPm, isNotNull);
      expect(headerPm!.timestamp, equals(DateTime(2025, 6, 5, 22, 19)));

      const line12Am = '05/06/2025, 12:15 AM - Maria: Meia noite e quinze';
      final header12Am = WhatsAppRegex.parseHeader(line12Am);
      expect(header12Am, isNotNull);
      expect(header12Am!.timestamp, equals(DateTime(2025, 6, 5, 0, 15)));

      const line12Pm = '05/06/2025, 12:15 PM - Maria: Meio dia e quinze';
      final header12Pm = WhatsAppRegex.parseHeader(line12Pm);
      expect(header12Pm, isNotNull);
      expect(header12Pm!.timestamp, equals(DateTime(2025, 6, 5, 12, 15)));
    });

    test('matches iOS bracketed 24h and 12h formats', () {
      const lineBracket24 = '[05/06/2025, 10:19:30] João Arthur: Tudo certo';
      final header24 = WhatsAppRegex.parseHeader(lineBracket24);
      expect(header24, isNotNull);
      expect(header24!.author, equals('João Arthur'));
      expect(header24.content, equals('Tudo certo'));
      expect(header24.timestamp, equals(DateTime(2025, 6, 5, 10, 19, 30)));

      const lineBracket12 = '[05/06/25, 10:19:30 PM] ~Wesley: Show';
      final header12 = WhatsAppRegex.parseHeader(lineBracket12);
      expect(header12, isNotNull);
      expect(header12!.author, equals('Wesley')); // leading ~ stripped
      expect(header12.content, equals('Show'));
      expect(header12.timestamp, equals(DateTime(2025, 6, 5, 22, 19, 30)));
    });

    test('tolerates colons inside message content', () {
      const line = '05/06/2025 10:19 - Wesley: Veja este link: https://example.com/item:123';
      final header = WhatsAppRegex.parseHeader(line);
      expect(header, isNotNull);
      expect(header!.author, equals('Wesley'));
      expect(header.content, equals('Veja este link: https://example.com/item:123'));
    });
  });

  group('WhatsAppRegex System Message & Media Detection', () {
    test('identifies encryption and group management system messages', () {
      expect(
        WhatsAppRegex.isSystemMessage(
          '24/04/2023 14:56 - As mensagens e ligações são protegidas com a criptografia de ponta a ponta. Saiba mais',
        ),
        isTrue,
      );
      expect(
        WhatsAppRegex.isSystemMessage('05/06/2025 10:19 - João adicionou Maria'),
        isTrue,
      );
      expect(
        WhatsAppRegex.isSystemMessage('05/06/2025 10:19 - Você removeu Pedro'),
        isTrue,
      );
      expect(
        WhatsAppRegex.isSystemMessage('05/06/2025 10:19 - Lucas saiu do grupo'),
        isTrue,
      );
      expect(
        WhatsAppRegex.isSystemMessage('05/06/2025 10:19 - Seu código de segurança mudou'),
        isTrue,
      );
      expect(
        WhatsAppRegex.isSystemMessage('Esta mensagem foi apagada.'),
        isTrue,
      );
    });

    test('does not misidentify normal chat messages as system messages', () {
      expect(
        WhatsAppRegex.isSystemMessage('05/06/2025 10:19 - João: Opa mano, tudo bem?'),
        isFalse,
      );
      expect(
        WhatsAppRegex.isSystemMessage('Tudo bem por aqui!'),
        isFalse,
      );
    });

    test('detects media markers and media types accurately', () {
      expect(WhatsAppRegex.isMedia('<Mídia oculta>'), isTrue);
      expect(WhatsAppRegex.detectMediaType('<Mídia oculta>'), equals('image'));

      expect(WhatsAppRegex.isMedia('<Media omitted>'), isTrue);
      expect(WhatsAppRegex.isMedia('(arquivo anexado)'), isTrue);

      expect(WhatsAppRegex.isMedia('audio omitted'), isTrue);
      expect(WhatsAppRegex.detectMediaType('audio omitted'), equals('audio'));
      expect(WhatsAppRegex.detectMediaType('PTT-20250605-WA0001.opus (arquivo anexado)'), equals('audio'));

      expect(WhatsAppRegex.isMedia('video omitted'), isTrue);
      expect(WhatsAppRegex.detectMediaType('VID-20250605-WA0001.mp4 (arquivo anexado)'), equals('video'));

      expect(WhatsAppRegex.isMedia('sticker omitted'), isTrue);
      expect(WhatsAppRegex.detectMediaType('STK-20250605-WA0001.webp (arquivo anexado)'), equals('sticker'));

      expect(WhatsAppRegex.isMedia('Oi, você viu o filme?'), isFalse);
      expect(WhatsAppRegex.detectMediaType('Oi, você viu o filme?'), isNull);
    });
  });

  group('ChatParser Multiline Accumulation & Edge Cases', () {
    test('accumulates multiline paragraphs into single message', () {
      const rawText = '''
05/06/2025 10:19 - João: Primeiro parágrafo
Continuação na segunda linha.

Terceiro parágrafo após linha em branco.
05/06/2025 10:20 - Maria: Resposta simples
''';
      final export = parser.parse(rawText);
      expect(export.totalMessages, equals(2));
      expect(
        export.messages[0].content,
        equals('Primeiro parágrafo\nContinuação na segunda linha.\n\nTerceiro parágrafo após linha em branco.'),
      );
      expect(export.messages[0].author, equals('João'));
      expect(export.messages[1].content, equals('Resposta simples'));
      expect(export.messages[1].author, equals('Maria'));
    });

    test('filters system messages by default', () {
      const rawText = '''
24/04/2023 14:56 - As mensagens e ligações são protegidas com a criptografia de ponta a ponta. Saiba mais
05/06/2025 10:19 - João adicionou Maria
05/06/2025 10:20 - João: Oi Maria!
05/06/2025 10:21 - Maria: Olá João!
05/06/2025 10:22 - João: Esta mensagem foi apagada.
''';
      final export = parser.parse(rawText);
      expect(export.totalMessages, equals(2));
      expect(export.messages.map((m) => m.content).toList(), equals(['Oi Maria!', 'Olá João!']));
      expect(export.participants, equals({'João', 'Maria'}));
    });

    test('preserves system messages when includeSystemMessages is true', () {
      const rawText = '''
24/04/2023 14:56 - As mensagens e ligações são protegidas com a criptografia de ponta a ponta. Saiba mais
05/06/2025 10:20 - João: Oi Maria!
''';
      final export = parser.parse(rawText, includeSystemMessages: true);
      expect(export.totalMessages, equals(2));
      expect(export.messages[0].isSystem, isTrue);
      expect(export.messages[1].isSystem, isFalse);
    });

    test('throws WhatsAppParseException on empty or unparseable input', () {
      expect(() => parser.parse(''), throwsA(isA<WhatsAppParseException>()));
      expect(() => parser.parse('   \n\n   '), throwsA(isA<WhatsAppParseException>()));
      expect(
        () => parser.parse('24/04/2023 14:56 - As mensagens e ligações são protegidas com a criptografia...'),
        throwsA(isA<WhatsAppParseException>()),
      );
    });
  });

  group('Sample WhatsApp Export Verification', () {
    test('correctly parses Conversa do WhatsApp com João Arthur Britto.txt', () {
      const samplePath = 'test/fixtures/benchmark_chat.txt';
      final file = File(samplePath);
      expect(file.existsSync(), isTrue, reason: 'Sample file should exist at fixture path');

      final rawContent = file.readAsStringSync();
      final export = parser.parse(rawContent);

      // Verify participant list
      expect(export.participants, equals({'João Arthur Britto', 'wesley rios'}));

      // Total messages: 7 from João + 8 from Wesley = 15 messages
      expect(export.totalMessages, equals(15));
      expect(export.messages.length, equals(15));

      final joaoMessages = export.messages.where((m) => m.author == 'João Arthur Britto').toList();
      final wesleyMessages = export.messages.where((m) => m.author == 'wesley rios').toList();
      expect(joaoMessages.length, equals(7));
      expect(wesleyMessages.length, equals(8));

      // Check date range
      expect(export.startDate, equals(DateTime(2025, 6, 5, 10, 19)));
      expect(export.endDate, equals(DateTime(2025, 10, 17, 9, 5)));

      // Check media messages (lines 20, 21, 22 are <Mídia oculta>)
      final mediaMessages = export.messages.where((m) => m.isMedia).toList();
      expect(mediaMessages.length, equals(3));
      for (final m in mediaMessages) {
        expect(m.content, equals('<Mídia oculta>'));
        expect(m.mediaType, equals('image'));
      }

      // Check first user message
      expect(export.messages.first.author, equals('João Arthur Britto'));
      expect(export.messages.first.content, equals('Opa mano, tudo bem?'));
      expect(export.messages.first.isMedia, isFalse);
      expect(export.messages.first.isSystem, isFalse);

      // Check last user message
      expect(export.messages.last.author, equals('João Arthur Britto'));
      expect(export.messages.last.content, equals('<Mídia oculta>'));
      expect(export.messages.last.isMedia, isTrue);
    });

    test('correctly parses Conversa do WhatsApp com wesley rios ☭⃠.txt', () {
      const userChatPath = 'test/Conversa do WhatsApp com wesley rios ☭⃠.txt';
      final file = File(userChatPath);
      expect(file.existsSync(), isTrue, reason: 'User chat export file should exist at relative path');

      final rawContent = file.readAsStringSync();
      // Validação explícita de Idempotência: invocações consecutivas retornam o mesmo resultado imutável
      final export1 = parser.parse(rawContent);
      final export2 = parser.parse(rawContent);

      expect(export1.totalMessages, equals(8822));
      expect(export2.totalMessages, equals(export1.totalMessages));
      expect(export1.participants, equals({'Rafael F.', 'wesley rios ☭⃠'}));
      expect(export2.participants, equals(export1.participants));

      final rafaelMsgs = export1.messages.where((m) => m.author == 'Rafael F.').toList();
      final wesleyMsgs = export1.messages.where((m) => m.author == 'wesley rios ☭⃠').toList();
      expect(rafaelMsgs.length, equals(4635));
      expect(wesleyMsgs.length, equals(4187));
    });
  });

  group('Milestone 1 Remediation Fixes', () {
    test('Fix 1 & Fix 3: isDeletedMessage correctly differentiates deleted messages from regular messages', () {
      expect(WhatsAppRegex.isDeletedMessage('Esta mensagem foi apagada.'), isTrue);
      expect(WhatsAppRegex.isDeletedMessage('Esta mensagem foi apagada'), isTrue);
      expect(WhatsAppRegex.isDeletedMessage('Você apagou esta mensagem'), isTrue);
      expect(WhatsAppRegex.isDeletedMessage('This message was deleted.'), isTrue);
      expect(WhatsAppRegex.isDeletedMessage('You deleted this message'), isTrue);
      expect(WhatsAppRegex.isDeletedMessage('Chamada de voz perdida'), isTrue);
      expect(WhatsAppRegex.isDeletedMessage('Missed voice call'), isTrue);
      expect(WhatsAppRegex.isDeletedMessage('Olá, tudo bem?'), isFalse);
      expect(WhatsAppRegex.isDeletedMessage('Quem removeu o arquivo?'), isFalse);
      expect(WhatsAppRegex.isDeletedMessage('Ela me adicionou no LinkedIn'), isFalse);
    });

    test('Fix 1: Authored messages with system keywords are never classified as system messages', () {
      expect(
        WhatsAppRegex.isSystemMessage('05/06/2025 10:20 - João: O chefe removeu o arquivo do servidor'),
        isFalse,
      );
      expect(
        WhatsAppRegex.isSystemMessage('05/06/2025 10:21 - Maria: Ela me adicionou no LinkedIn'),
        isFalse,
      );
      expect(
        WhatsAppRegex.isSystemMessage('05/06/2025 10:22 - Pedro: Quem criou o grupo de estudos?'),
        isFalse,
      );
    });

    test('Fix 3: System notifications with colons are recognized as system messages and not fake authors', () {
      const line = '24/04/2023 14:56 - As mensagens e ligações são protegidas com criptografia de ponta a ponta: saiba mais';
      expect(WhatsAppRegex.parseHeader(line), isNull);
      expect(WhatsAppRegex.isSystemMessage(line), isTrue);

      const raw = '''
$line
05/06/2025 10:19 - Wesley: Olá!
''';
      final export = parser.parse(raw);
      expect(export.totalMessages, equals(1));
      expect(export.participants, equals({'Wesley'}));
      expect(export.messages.first.author, equals('Wesley'));
    });

    test('Fix 4: Empty and whitespace-only authors are rejected in header matching', () {
      expect(WhatsAppRegex.parseHeader('05/06/2025 10:19 - : Sem autor'), isNull);
      expect(WhatsAppRegex.parseHeader('05/06/2025 10:19 - ~ : Sem autor'), isNull);
      expect(WhatsAppRegex.parseHeader('05/06/2025 10:19 -    : Sem autor'), isNull);
    });

    test('Fix 5 & Fix 6: Ingestion handles Latin-1 bytes with Portuguese accents cleanly', () async {
      final latin1Bytes = latin1.encode('''
05/06/2025 10:19 - Wesley: Olá, coração com acentuação!
05/06/2025 10:20 - João: Não esqueça do café com pão.
''');
      final ingestionService = FileIngestionService();
      final export = await ingestionService.ingestBytes(latin1Bytes);
      expect(export.totalMessages, equals(2));
      expect(export.messages[0].content, equals('Olá, coração com acentuação!'));
      expect(export.messages[1].content, equals('Não esqueça do café com pão.'));
      expect(export.participants, equals({'Wesley', 'João'}));
    });
  });
}
