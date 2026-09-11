import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Service for capturing 9:16 story cards at 1080x1920 resolution
/// and sharing via the native Android share sheet.
class StoryExportService {
  StoryExportService._();

  /// Standard vertical 9:16 story dimensions
  static const int exportWidth = 1080;
  static const int exportHeight = 1920;
  static const double targetAspectRatio = 9 / 16;
  static const String exportFilePrefix = 'chat_wrapped_story_';
  static const String defaultShareText = 'Confira o nosso WhatsApp Wrapped! 📊';

  /// Captures a widget wrapped in a [RepaintBoundary] identified by [boundaryKey]
  /// into a lossless PNG image file saved in the application cache directory.
  ///
  /// Returns the absolute file path of the saved PNG, or null if capture failed.
  static Future<String?> captureStoryCardToPng(GlobalKey boundaryKey) async {
    try {
      final renderObject = boundaryKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        debugPrint('StoryExportService: RepaintBoundary render object not found.');
        return null;
      }
      final boundary = renderObject;

      // Calculate pixelRatio to achieve 1080 width from logical width (default 360 -> ratio 3.0)
      final logicalWidth = boundary.size.width;
      final double pixelRatio = logicalWidth > 0 ? (exportWidth / logicalWidth) : 3.0;

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        debugPrint('StoryExportService: Failed to convert image to byte data.');
        return null;
      }

      final buffer = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = '$exportFilePrefix$timestamp.png';
      final filePath = '${tempDir.path}/$filename';

      final file = File(filePath);
      await file.writeAsBytes(buffer);

      debugPrint('StoryExportService: Exported story card to $filePath');
      return filePath;
    } catch (e) {
      debugPrint('StoryExportService: Error during capture: $e');
      return null;
    }
  }

  /// Triggers the native Android share sheet with the exported PNG image.
  static Future<void> shareStoryImage(
    String imagePath, {
    String? text,
  }) async {
    if (imagePath.isEmpty) {
      debugPrint('StoryExportService: Cannot share empty image path.');
      return;
    }

    final file = File(imagePath);
    if (!await file.exists()) {
      debugPrint('StoryExportService: File does not exist at $imagePath');
      return;
    }

    try {
      final shareText = text ?? defaultShareText;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imagePath, mimeType: 'image/png')],
          text: shareText,
        ),
      );
    } catch (e) {
      debugPrint('StoryExportService: Error sharing story image: $e');
    }
  }

  /// Convenience pipeline: captures the boundary and immediately presents
  /// the native share sheet.
  static Future<bool> exportAndShare(
    GlobalKey boundaryKey, {
    BuildContext? context,
    String? text,
  }) async {
    try {
      final filePath = await captureStoryCardToPng(boundaryKey);
      if (filePath == null) {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao gerar imagem para compartilhamento.')),
          );
        }
        return false;
      }

      await shareStoryImage(filePath, text: text);
      return true;
    } catch (e) {
      debugPrint('StoryExportService: exportAndShare failed: $e');
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao compartilhar story: $e')),
        );
      }
      return false;
    }
  }
}
