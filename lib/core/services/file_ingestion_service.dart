import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../models/raw_chat_export.dart';
import '../parser/chat_parser.dart';
import 'zip_extractor_service.dart';

/// Unified service for ingesting WhatsApp chat exports (.txt or .zip).
class FileIngestionService {
  final ChatParser _parser;
  final ZipExtractorService _zipExtractor;

  FileIngestionService({
    ChatParser? parser,
    ZipExtractorService? zipExtractor,
  })  : _parser = parser ?? const ChatParser(),
        _zipExtractor = zipExtractor ?? const ZipExtractorService();

  /// Checks if given bytes begin with ZIP magic bytes ('PK').
  static bool isZipBytes(List<int> bytes) {
    if (bytes.length < 4) return false;
    return bytes[0] == 0x50 &&
        bytes[1] == 0x4B &&
        (bytes[2] == 0x03 || bytes[2] == 0x05 || bytes[2] == 0x07);
  }

  /// Ingests a file by its system [filePath] (.txt or .zip).
  Future<RawChatExport> ingestPath(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('Arquivo não encontrado', filePath);
    }

    final isZipByName = filePath.toLowerCase().endsWith('.zip');
    if (isZipByName) {
      final textContent = await _zipExtractor.extractChatTextFromPath(filePath);
      return _parser.parse(textContent);
    }

    // Check first 4 bytes for magic number
    bool isZipByHeader = false;
    final raf = await file.open(mode: FileMode.read);
    try {
      final headerBytes = await raf.read(4);
      isZipByHeader = isZipBytes(headerBytes);
    } finally {
      await raf.close();
    }

    if (isZipByHeader) {
      final textContent = await _zipExtractor.extractChatTextFromPath(filePath);
      return _parser.parse(textContent);
    }

    // Otherwise read as text
    final bytes = await file.readAsBytes();
    final textContent = _decodeBytesToText(bytes);
    return _parser.parse(textContent);
  }

  /// Ingests a [File] object.
  Future<RawChatExport> ingestFile(File file) {
    return ingestPath(file.path);
  }

  /// Ingests in-memory [bytes] with an optional [fileName].
  Future<RawChatExport> ingestBytes(
    List<int> bytes, {
    String? fileName,
  }) async {
    final isZip = (fileName != null && fileName.toLowerCase().endsWith('.zip')) ||
        isZipBytes(bytes);

    final String textContent;
    if (isZip) {
      textContent = _zipExtractor.extractChatTextFromBytes(bytes);
    } else {
      textContent = _decodeBytesToText(bytes);
    }

    return _parser.parse(textContent);
  }

  /// Ingests already decoded [textContent].
  RawChatExport ingestContent(String textContent) {
    return _parser.parse(textContent);
  }

  /// Triggers native system file picker to select a WhatsApp chat export (.txt or .zip).
  ///
  /// Returns `null` if user cancels the picker.
  Future<RawChatExport?> pickAndIngestChatFile() async {
    final selectedFile = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['txt', 'zip'],
    );

    if (selectedFile == null) {
      return null;
    }

    final path = selectedFile.path;
    if (path != null && path.isNotEmpty) {
      return ingestPath(path);
    }

    // Fallback using readAsBytes (e.g. Web or URI-only providers)
    final bytes = await selectedFile.readAsBytes();
    if (bytes.isNotEmpty) {
      return ingestBytes(bytes, fileName: selectedFile.name);
    }

    throw const ZipExtractorException(
      'Não foi possível ler o arquivo selecionado.',
    );
  }

  String _decodeBytesToText(List<int> bytes) {
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return latin1.decode(bytes);
    } catch (_) {
      return latin1.decode(bytes);
    }
  }
}
