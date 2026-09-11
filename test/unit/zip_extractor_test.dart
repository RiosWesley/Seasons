import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/services/file_ingestion_service.dart';
import 'package:chat_wrapped/core/services/zip_extractor_service.dart';

void main() {
  const zipExtractor = ZipExtractorService();
  final ingestionService = FileIngestionService(zipExtractor: zipExtractor);

  group('ZipExtractorService - In-Memory Decompression', () {
    test('extracts _chat.txt from a ZIP archive', () {
      final archive = Archive();
      const sampleContent = '05/06/2025 10:19 - Wesley: Olá do arquivo zip!';
      final fileData = utf8.encode(sampleContent);
      archive.addFile(ArchiveFile('_chat.txt', fileData.length, fileData));

      final zipBytes = ZipEncoder().encode(archive);
      expect(zipBytes, isNotNull);

      final extracted = zipExtractor.extractChatTextFromBytes(zipBytes);
      expect(extracted, equals(sampleContent));
    });

    test('extracts WhatsApp named .txt when _chat.txt is absent', () {
      final archive = Archive();
      const sampleContent = '05/06/2025 10:19 - Wesley: Mensagem em Conversa do WhatsApp.txt';
      final fileData = utf8.encode(sampleContent);
      archive.addFile(
        ArchiveFile('Conversa do WhatsApp com João.txt', fileData.length, fileData),
      );

      final zipBytes = ZipEncoder().encode(archive);
      expect(zipBytes, isNotNull);

      final extracted = zipExtractor.extractChatTextFromBytes(zipBytes);
      expect(extracted, equals(sampleContent));
    });

    test('extracts text file while ignoring heavy media files', () {
      final archive = Archive();
      const chatContent = '05/06/2025 10:19 - Wesley: Mensagem principal';
      final chatData = utf8.encode(chatContent);
      archive.addFile(ArchiveFile('_chat.txt', chatData.length, chatData));

      // Add dummy media files
      final dummyMedia = Uint8List(1024 * 10); // 10KB dummy media
      archive.addFile(ArchiveFile('foto1.jpg', dummyMedia.length, dummyMedia));
      archive.addFile(ArchiveFile('audio1.opus', dummyMedia.length, dummyMedia));
      archive.addFile(ArchiveFile('video1.mp4', dummyMedia.length, dummyMedia));

      final zipBytes = ZipEncoder().encode(archive);
      expect(zipBytes, isNotNull);

      final extracted = zipExtractor.extractChatTextFromBytes(zipBytes);
      expect(extracted, equals(chatContent));
    });

    test('throws ZipExtractorException when no .txt file is present in ZIP', () {
      final archive = Archive();
      final dummyMedia = Uint8List(100);
      archive.addFile(ArchiveFile('foto.jpg', dummyMedia.length, dummyMedia));

      final zipBytes = ZipEncoder().encode(archive);
      expect(zipBytes, isNotNull);

      expect(
        () => zipExtractor.extractChatTextFromBytes(zipBytes),
        throwsA(isA<ZipExtractorException>()),
      );
    });

    test('throws ZipExtractorException on empty or invalid zip bytes', () {
      expect(
        () => zipExtractor.extractChatTextFromBytes([]),
        throwsA(isA<ZipExtractorException>()),
      );
      expect(
        () => zipExtractor.extractChatTextFromBytes([1, 2, 3, 4]),
        throwsA(isA<ZipExtractorException>()),
      );
    });
  });

  group('ZipExtractorService - File Path Streaming', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('chat_wrapped_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('extracts chat text from file path on disk', () async {
      final archive = Archive();
      const chatContent = '05/06/2025 10:19 - João: Olá do disco!';
      final chatData = utf8.encode(chatContent);
      archive.addFile(ArchiveFile('_chat.txt', chatData.length, chatData));

      final zipBytes = ZipEncoder().encode(archive);
      final zipFilePath = '${tempDir.path}/export.zip';
      await File(zipFilePath).writeAsBytes(zipBytes);

      final extracted = await zipExtractor.extractChatTextFromPath(zipFilePath);
      expect(extracted, equals(chatContent));
    });

    test('throws ZipExtractorException when file does not exist', () async {
      expect(
        () => zipExtractor.extractChatTextFromPath('${tempDir.path}/non_existent.zip'),
        throwsA(isA<ZipExtractorException>()),
      );
    });
  });

  group('FileIngestionService Integration', () {
    const samplePath = '/home/wesley/Documents/chat-wrapped-mobile/Conversa do WhatsApp com João Arthur Britto.txt';

    test('isZipBytes identifies zip magic header correctly', () {
      expect(FileIngestionService.isZipBytes([0x50, 0x4B, 0x03, 0x04, 0x00]), isTrue);
      expect(FileIngestionService.isZipBytes([0x50, 0x4B, 0x05, 0x06]), isTrue);
      expect(FileIngestionService.isZipBytes([0x30, 0x35, 0x2F, 0x30]), isFalse); // '05/0'
      expect(FileIngestionService.isZipBytes([]), isFalse);
    });

    test('ingests plain text file directly from path', () async {
      final export = await ingestionService.ingestPath(samplePath);
      expect(export.totalMessages, equals(15));
      expect(export.participants, equals({'João Arthur Britto', 'wesley rios'}));
    });

    test('ingests packaged zip file containing real chat export', () async {
      final sampleFile = File(samplePath);
      final rawChatBytes = await sampleFile.readAsBytes();

      final archive = Archive();
      archive.addFile(
        ArchiveFile('Conversa do WhatsApp com João Arthur Britto.txt', rawChatBytes.length, rawChatBytes),
      );
      archive.addFile(ArchiveFile('dummy_image.jpg', 50, Uint8List(50)));

      final zipBytes = ZipEncoder().encode(archive);

      // Ingest via bytes
      final export = await ingestionService.ingestBytes(zipBytes, fileName: 'export.zip');
      expect(export.totalMessages, equals(15));
      expect(export.participants, equals({'João Arthur Britto', 'wesley rios'}));
      expect(export.startDate, equals(DateTime(2025, 6, 5, 10, 19)));
      expect(export.endDate, equals(DateTime(2025, 10, 17, 9, 5)));
    });

    test('ingests content string directly', () {
      const chatContent = '''
05/06/2025 10:19 - João: Oi
05/06/2025 10:20 - Maria: Olá
''';
      final export = ingestionService.ingestContent(chatContent);
      expect(export.totalMessages, equals(2));
      expect(export.participants, equals({'João', 'Maria'}));
    });
  });
}
