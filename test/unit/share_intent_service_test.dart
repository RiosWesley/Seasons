import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:chat_wrapped/core/models/general_stats.dart';
import 'package:chat_wrapped/core/models/raw_chat_export.dart';
import 'package:chat_wrapped/core/services/share_intent_service.dart';
import 'package:chat_wrapped/screens/dashboard_screen.dart';
import 'package:chat_wrapped/screens/mode_selection_screen.dart';

class TestSharingIntentPlugin extends ReceiveSharingIntent {
  List<SharedMediaFile> initialMedia;
  final StreamController<List<SharedMediaFile>> streamController;
  int resetCallCount = 0;

  TestSharingIntentPlugin({
    List<SharedMediaFile>? initialMedia,
    StreamController<List<SharedMediaFile>>? controller,
  })  : initialMedia = initialMedia ?? [],
        streamController =
            controller ?? StreamController<List<SharedMediaFile>>.broadcast();

  @override
  Future<List<SharedMediaFile>> getInitialMedia() => Future.value(initialMedia);

  @override
  Stream<List<SharedMediaFile>> getMediaStream() => streamController.stream;

  @override
  Future<dynamic> reset() async {
    resetCallCount++;
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final sampleTxtPath =
      File('test/fixtures/brazilian_24h.txt').absolute.path;
  final sampleTxtDuoPath =
      File('test/fixtures/brazilian_12h.txt').absolute.path;
  final sampleZipPath =
      File('test/fixtures/sample_chat.zip').absolute.path;

  group('ShareIntentService - Static Utilities', () {
    test('normalizeFilePath removes file:// scheme', () {
      expect(
        ShareIntentService.normalizeFilePath('file:///data/user/0/chat.zip'),
        equals('/data/user/0/chat.zip'),
      );
      expect(
        ShareIntentService.normalizeFilePath('/storage/emulated/0/chat.txt'),
        equals('/storage/emulated/0/chat.txt'),
      );
    });

    test('findTargetChatFile correctly identifies .zip files', () {
      final files = [
        SharedMediaFile(
          path: '/path/to/image.jpg',
          type: SharedMediaType.image,
          mimeType: 'image/jpeg',
        ),
        SharedMediaFile(
          path: '/path/to/chat_export.zip',
          type: SharedMediaType.file,
          mimeType: 'application/zip',
        ),
      ];

      final target = ShareIntentService.findTargetChatFile(files);
      expect(target, isNotNull);
      expect(target!.path, equals('/path/to/chat_export.zip'));
    });

    test('findTargetChatFile correctly identifies .txt files', () {
      final files = [
        SharedMediaFile(
          path: '/path/to/audio.opus',
          type: SharedMediaType.file,
        ),
        SharedMediaFile(
          path: '/path/to/conversa.txt',
          type: SharedMediaType.file,
        ),
      ];

      final target = ShareIntentService.findTargetChatFile(files);
      expect(target, isNotNull);
      expect(target!.path, equals('/path/to/conversa.txt'));
    });

    test('findTargetChatFile matches by mimeType when extension is absent', () {
      final files = [
        SharedMediaFile(
          path: '/path/to/stream_data',
          type: SharedMediaType.file,
          mimeType: 'application/zip',
        ),
      ];

      final target = ShareIntentService.findTargetChatFile(files);
      expect(target, isNotNull);
      expect(target!.path, equals('/path/to/stream_data'));
    });

    test('findTargetChatFile returns null on empty list', () {
      expect(ShareIntentService.findTargetChatFile([]), isNull);
    });
  });

  group('ShareIntentService - Chat Processing', () {
    test('processSharedFilePath ingests .txt export and generates analysis', () async {
      RawChatExport? capturedExport;
      ChatAnalysisResult? capturedAnalysis;

      final service = ShareIntentService(
        onChatParsed: (export, analysis) {
          capturedExport = export;
          capturedAnalysis = analysis;
        },
      );

      final result = await service.processSharedFilePath(sampleTxtPath);

      expect(result, isNotNull);
      expect(capturedExport, isNotNull);
      expect(capturedAnalysis, isNotNull);
      expect(capturedExport!.messages.isNotEmpty, isTrue);
      expect(capturedExport!.participants.length, equals(3));
      expect(capturedAnalysis!.mode, equals(ChatMode.grupo));
    });

    test('processSharedFilePath ingests .zip export and generates analysis', () async {
      final service = ShareIntentService();
      final result = await service.processSharedFilePath(sampleZipPath);

      expect(result, isNotNull);
      expect(result.generalStats.totalMessages, greaterThan(0));
    });

    test('handleSharedFiles triggers reset and completes processing', () async {
      final testPlugin = TestSharingIntentPlugin();
      final service = ShareIntentService(intentPlugin: testPlugin);

      final files = [
        SharedMediaFile(path: sampleTxtPath, type: SharedMediaType.file),
      ];

      final result = await service.handleSharedFiles(files);
      expect(result, isNotNull);
      expect(testPlugin.resetCallCount, equals(1));
      expect(service.isProcessing, isFalse);
    });

    test('handleSharedFiles catches missing file error and notifies onError callback', () async {
      Object? receivedError;
      final testPlugin = TestSharingIntentPlugin();
      final service = ShareIntentService(
        intentPlugin: testPlugin,
        onError: (err, stack) {
          receivedError = err;
        },
      );

      final files = [
        SharedMediaFile(
          path: '/non_existent/path/to/chat.txt',
          type: SharedMediaType.file,
        ),
      ];

      final result = await service.handleSharedFiles(files);
      expect(result, isNull);
      expect(receivedError, isNotNull);
      expect(service.isProcessing, isFalse);
    });
  });

  group('ShareIntentService - Lifecycle & Streams', () {
    test('cold start intent triggers automatic parsing and callbacks', () async {
      final completer = Completer<RawChatExport>();
      final testPlugin = TestSharingIntentPlugin(
        initialMedia: [
          SharedMediaFile(path: sampleTxtPath, type: SharedMediaType.file),
        ],
      );

      final service = ShareIntentService(
        intentPlugin: testPlugin,
        onChatParsed: (export, analysis) {
          if (!completer.isCompleted) {
            completer.complete(export);
          }
        },
      );

      service.initialize();
      expect(service.isInitialized, isTrue);

      final export = await completer.future.timeout(
        const Duration(seconds: 3),
      );
      expect(export.messages.isNotEmpty, isTrue);

      service.dispose();
      expect(service.isInitialized, isFalse);
    });

    test('warm start stream emits trigger ingestion flow', () async {
      final streamController = StreamController<List<SharedMediaFile>>.broadcast();
      final completer = Completer<ChatAnalysisResult>();
      final testPlugin = TestSharingIntentPlugin(
        controller: streamController,
      );

      final service = ShareIntentService(
        intentPlugin: testPlugin,
        onChatParsed: (export, analysis) {
          if (!completer.isCompleted) {
            completer.complete(analysis);
          }
        },
      );

      service.initialize();

      // Emit incoming share intent stream event
      streamController.add([
        SharedMediaFile(path: sampleZipPath, type: SharedMediaType.file),
      ]);

      final analysis = await completer.future.timeout(
        const Duration(seconds: 3),
      );
      expect(analysis.generalStats.totalMessages, greaterThan(0));

      service.dispose();
      await streamController.close();
    });

    test('ReceiveSharingIntent setMockValues works with default singleton', () async {
      final streamController = StreamController<List<SharedMediaFile>>.broadcast();
      ReceiveSharingIntent.setMockValues(
        initialMedia: [],
        mediaStream: streamController.stream,
      );

      final completer = Completer<RawChatExport>();
      final service = ShareIntentService(
        onChatParsed: (export, analysis) {
          if (!completer.isCompleted) {
            completer.complete(export);
          }
        },
      );

      service.initialize();
      expect(service.activePlugin, isA<ReceiveSharingIntent>());

      streamController.add([
        SharedMediaFile(path: sampleTxtPath, type: SharedMediaType.file),
      ]);

      final export = await completer.future.timeout(
        const Duration(seconds: 3),
      );
      expect(export.messages.isNotEmpty, isTrue);

      service.dispose();
      await streamController.close();
    });
  });

  group('ShareIntentService - Navigation Integration', () {
    testWidgets('handleSharedFiles with duo chat pushes ModeSelectionScreen onto navigator',
        (WidgetTester tester) async {
      final navKey = GlobalKey<NavigatorState>();
      final testPlugin = TestSharingIntentPlugin();
      final service = ShareIntentService(
        intentPlugin: testPlugin,
        navigatorKey: navKey,
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navKey,
          home: const Scaffold(body: Text('Home Base')),
        ),
      );

      expect(find.text('Home Base'), findsOneWidget);
      expect(find.byType(ModeSelectionScreen), findsNothing);

      // Process shared duo WhatsApp export file inside runAsync for real file I/O
      await tester.runAsync(() async {
        await service.handleSharedFiles([
          SharedMediaFile(path: sampleTxtDuoPath, type: SharedMediaType.file),
        ]);
      });

      await tester.pumpAndSettle();

      // ModeSelectionScreen should now be in the widget tree for duo
      expect(find.byType(ModeSelectionScreen), findsOneWidget);
      expect(find.text('Configurar Retrospectiva'), findsOneWidget);
    });

    testWidgets('handleSharedFiles with 3+ members routes directly to DashboardScreen as Grupo',
        (WidgetTester tester) async {
      final navKey = GlobalKey<NavigatorState>();
      final testPlugin = TestSharingIntentPlugin();
      final service = ShareIntentService(
        intentPlugin: testPlugin,
        navigatorKey: navKey,
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navKey,
          home: const Scaffold(body: Text('Home Base')),
        ),
      );

      expect(find.text('Home Base'), findsOneWidget);
      expect(find.byType(DashboardScreen), findsNothing);

      // Process shared 3-member WhatsApp export file inside runAsync
      await tester.runAsync(() async {
        await service.handleSharedFiles([
          SharedMediaFile(path: sampleTxtPath, type: SharedMediaType.file),
        ]);
      });

      await tester.pumpAndSettle();

      // DashboardScreen should now be opened directly for 3+ members
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(find.text('Relatório Completo'), findsOneWidget);
    });
  });
}
