import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';

/// Exception thrown when ZIP decompression or chat extraction fails.
class ZipExtractorException implements Exception {
  final String message;
  const ZipExtractorException(this.message);

  @override
  String toString() => 'ZipExtractorException: $message';
}

/// Service for extracting WhatsApp chat exports from ZIP archives.
///
/// Implemented using pure-Dart [archive] package to ensure 100% offline execution.
/// Only locates and extracts text files (_chat.txt or *.txt) while skipping heavy
/// media files (images, audio, videos) to prevent Out-Of-Memory (OOM) errors.
class ZipExtractorService {
  const ZipExtractorService();

  /// Extracts chat text content from ZIP bytes.
  String extractChatTextFromBytes(List<int> zipBytes) {
    if (zipBytes.isEmpty) {
      throw const ZipExtractorException('O arquivo ZIP está vazio.');
    }

    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } catch (e) {
      throw ZipExtractorException('Falha ao descompactar arquivo ZIP: $e');
    }

    return _findAndExtractChatText(archive);
  }

  /// Extracts chat text content from a file path using streaming to minimize memory usage.
  Future<String> extractChatTextFromPath(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw ZipExtractorException('Arquivo não encontrado: $filePath');
    }

    InputFileStream? inputStream;
    try {
      inputStream = InputFileStream(filePath);
      final archive = ZipDecoder().decodeStream(inputStream);
      return _findAndExtractChatText(archive);
    } catch (e) {
      if (e is ZipExtractorException) rethrow;
      throw ZipExtractorException('Falha ao descompactar arquivo ZIP: $e');
    } finally {
      await inputStream?.close();
    }
  }

  /// Extracts chat text content from a [File].
  Future<String> extractChatTextFromFile(File file) {
    return extractChatTextFromPath(file.path);
  }

  String _findAndExtractChatText(Archive archive) {
    ArchiveFile? chatFile;

    // 1. First priority: exactly '_chat.txt' (standard WhatsApp iOS export)
    for (final file in archive.files) {
      if (file.isFile && file.name.toLowerCase().endsWith('_chat.txt')) {
        chatFile = file;
        break;
      }
    }

    // 2. Second priority: any *.txt file containing 'whatsapp' or 'conversa'
    if (chatFile == null) {
      for (final file in archive.files) {
        if (file.isFile && file.name.toLowerCase().endsWith('.txt')) {
          final lower = file.name.toLowerCase();
          if (lower.contains('conversa') || lower.contains('whatsapp')) {
            chatFile = file;
            break;
          }
        }
      }
    }

    // 3. Third priority: any *.txt file (take the largest)
    if (chatFile == null) {
      ArchiveFile? largestTxt;
      for (final file in archive.files) {
        if (file.isFile && file.name.toLowerCase().endsWith('.txt')) {
          if (largestTxt == null || file.size > largestTxt.size) {
            largestTxt = file;
          }
        }
      }
      chatFile = largestTxt;
    }

    if (chatFile == null) {
      throw const ZipExtractorException(
        'Nenhum arquivo de conversa (.txt) foi encontrado dentro do arquivo ZIP.',
      );
    }

    // Only decompress the selected .txt file content
    final rawBytes = chatFile.content;
    chatFile.clear();

    // Decode with strict UTF-8 first, fallback to Latin-1 on FormatException
    try {
      return utf8.decode(rawBytes);
    } on FormatException {
      return latin1.decode(rawBytes);
    } catch (_) {
      return latin1.decode(rawBytes);
    }
  }
}
