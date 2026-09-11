import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../../screens/mode_selection_screen.dart';
import '../../theme/swiss_colors.dart';
import '../analytics/chat_analyzer.dart';
import '../models/general_stats.dart';
import '../models/raw_chat_export.dart';
import 'file_ingestion_service.dart';

/// Callback signatures for ShareIntentService.
typedef ChatParsedCallback = void Function(
  RawChatExport export,
  ChatAnalysisResult analysis,
);
typedef ShareIntentErrorCallback = void Function(
  Object error,
  StackTrace? stackTrace,
);

/// Service for listening to incoming WhatsApp chat export files (.txt / .zip)
/// shared via Android Send/Share Intent (`ACTION_SEND` and `ACTION_SEND_MULTIPLE`).
///
/// Handles cold-start intents via [ReceiveSharingIntent.getInitialMedia] and
/// background/resumed intents via [ReceiveSharingIntent.getMediaStream].
class ShareIntentService {
  final FileIngestionService _ingestionService;
  final ReceiveSharingIntent? intentPlugin;
  final GlobalKey<NavigatorState>? navigatorKey;
  final ChatParsedCallback? onChatParsed;
  final ShareIntentErrorCallback? onError;

  StreamSubscription<List<SharedMediaFile>>? _mediaSubscription;
  bool _isProcessing = false;
  bool _isInitialized = false;

  ShareIntentService({
    FileIngestionService? ingestionService,
    this.intentPlugin,
    this.navigatorKey,
    this.onChatParsed,
    this.onError,
  }) : _ingestionService = ingestionService ?? FileIngestionService();

  /// The active plugin instance (injected or default singleton).
  ReceiveSharingIntent get activePlugin =>
      intentPlugin ?? ReceiveSharingIntent.instance;

  /// Whether the service is currently processing a shared chat export.
  bool get isProcessing => _isProcessing;

  /// Whether the service has been initialized.
  bool get isInitialized => _isInitialized;

  /// Normalizes a file path, removing any `file://` scheme prefix.
  static String normalizeFilePath(String path) {
    if (path.startsWith('file://')) {
      try {
        return Uri.parse(path).toFilePath();
      } catch (_) {
        return path.replaceFirst('file://', '');
      }
    }
    return path;
  }

  /// Identifies the first candidate WhatsApp export file (.zip or .txt) from
  /// a list of shared media files.
  static SharedMediaFile? findTargetChatFile(List<SharedMediaFile> files) {
    if (files.isEmpty) return null;

    // 1. Explicit file extension match (.zip or .txt)
    for (final file in files) {
      final pathLower = file.path.toLowerCase();
      if (pathLower.endsWith('.zip') || pathLower.endsWith('.txt')) {
        return file;
      }
    }

    // 2. MIME type inspection
    for (final file in files) {
      final mime = file.mimeType?.toLowerCase();
      if (mime != null) {
        if (mime.contains('zip') ||
            mime.contains('text/plain') ||
            mime.contains('octet-stream')) {
          return file;
        }
      }
    }

    // 3. Fallback: single file with non-empty path
    if (files.length == 1 && files.first.path.trim().isNotEmpty) {
      return files.first;
    }

    return null;
  }

  /// Initializes the intent listeners for both background resumption and cold start.
  void initialize() {
    if (_isInitialized) return;
    _isInitialized = true;

    // 1. Listen for files shared while app is running in memory / background
    try {
      _mediaSubscription = activePlugin.getMediaStream().listen(
        (List<SharedMediaFile> files) {
          handleSharedFiles(files);
        },
        onError: (Object err, StackTrace? stack) {
          debugPrint('ShareIntentService media stream error: $err');
          onError?.call(err, stack);
        },
      );
    } catch (e, stack) {
      debugPrint('ShareIntentService getMediaStream setup error: $e');
      onError?.call(e, stack);
    }

    // 2. Catch files shared when app is opened cold from closed state
    try {
      activePlugin.getInitialMedia().then(
        (List<SharedMediaFile> files) {
          handleSharedFiles(files);
        },
        onError: (Object err, StackTrace? stack) {
          debugPrint('ShareIntentService initial media error: $err');
          onError?.call(err, stack);
        },
      );
    } catch (e, stack) {
      debugPrint('ShareIntentService getInitialMedia setup error: $e');
      onError?.call(e, stack);
    }
  }

  /// Handles incoming list of shared media files.
  Future<ChatAnalysisResult?> handleSharedFiles(
    List<SharedMediaFile> files,
  ) async {
    if (files.isEmpty || _isProcessing) return null;

    final targetFile = findTargetChatFile(files);
    if (targetFile == null) return null;

    final normalizedPath = normalizeFilePath(targetFile.path);
    if (normalizedPath.trim().isEmpty) return null;

    _isProcessing = true;
    try {
      final result = await processSharedFilePath(normalizedPath);
      try {
        await activePlugin.reset();
      } catch (resetErr) {
        debugPrint('ShareIntentService reset error: $resetErr');
      }
      return result;
    } catch (e, stack) {
      debugPrint('ShareIntentService processing failed: $e');
      onError?.call(e, stack);
      _showErrorNotice(e.toString());
      return null;
    } finally {
      _isProcessing = false;
    }
  }

  /// Ingests, parses, analyzes, and navigates to [ModeSelectionScreen] for a given [filePath].
  Future<ChatAnalysisResult> processSharedFilePath(String filePath) async {
    final normalized = normalizeFilePath(filePath);

    // 1. Ingest via FileIngestionService (handles both .txt and .zip)
    final rawExport = await _ingestionService.ingestPath(normalized);

    // 2. Local deterministic analysis via ChatAnalyzer
    final analysis = ChatAnalyzer.analyzeRawExport(rawExport);

    // 3. Optional callback notification
    onChatParsed?.call(rawExport, analysis);

    // 4. Auto-route to ModeSelectionScreen
    _navigateToModeSelection(rawExport, analysis);

    return analysis;
  }

  /// Pushes [ModeSelectionScreen] onto the active navigator.
  void _navigateToModeSelection(
    RawChatExport rawExport,
    ChatAnalysisResult analysis,
  ) {
    final nav = navigatorKey?.currentState;
    if (nav == null) {
      // If navigator state is not yet ready (e.g. cold start first frame), schedule for next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey?.currentState?.push(
          MaterialPageRoute<void>(
            builder: (_) => ModeSelectionScreen(
              rawExport: rawExport,
              initialAnalysis: analysis,
            ),
          ),
        );
      });
      return;
    }

    nav.push(
      MaterialPageRoute<void>(
        builder: (_) => ModeSelectionScreen(
          rawExport: rawExport,
          initialAnalysis: analysis,
        ),
      ),
    );
  }

  /// Displays user-facing notice if shared file ingestion fails.
  void _showErrorNotice(String message) {
    final context = navigatorKey?.currentContext;
    if (context != null && context.mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao processar conversa compartilhada: $message',
          ),
          backgroundColor: SwissColors.danger,
        ),
      );
    }
  }

  /// Disposes active subscriptions.
  void dispose() {
    _mediaSubscription?.cancel();
    _mediaSubscription = null;
    _isInitialized = false;
  }
}
