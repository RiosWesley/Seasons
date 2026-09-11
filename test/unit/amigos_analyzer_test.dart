import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/analytics/amigos_analyzer.dart';
import 'package:chat_wrapped/core/models/chat_message.dart';

void main() {
  group('AmigosAnalyzer Unit Tests', () {
    test('Persona Decision Tree assigns all 5 communication archetypes correctly', () {
      final messages = [
        // 1. Engraçado: laugh ratio > 0.30
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 10, 0),
          author: 'Comediante',
          content: 'Kkkkkkk muito bom 😂',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 10, 1),
          author: 'Comediante',
          content: 'Quase morri de rir 🤣',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 10, 2),
          author: 'Comediante',
          content: 'Bom dia galera',
        ),

        // 2. Expressivo: emoji ratio > 0.40
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 10, 3),
          author: 'Expressivo',
          content: 'Bom dia ✨🎉',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 10, 4),
          author: 'Expressivo',
          content: 'Parabéns para todos 🥳',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 10, 5),
          author: 'Expressivo',
          content: 'Beleza então',
        ),

        // 3. Detalhista: avg length > 100
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 10, 6),
          author: 'Escritor',
          content: 'Caros colegas, gostaria de compartilhar uma análise detalhada sobre o tema que estamos discutindo nesta manhã de segunda-feira.',
        ),

        // 4. Objetivo: avg length < 20
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 10, 7),
          author: 'Objetivo',
          content: 'Ok',
        ),
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 10, 8),
          author: 'Objetivo',
          content: 'Sim',
        ),

        // 5. Carinhoso: fallback
        ChatMessage(
          timestamp: DateTime(2025, 1, 1, 10, 9),
          author: 'Carinhoso',
          content: 'Vamos nos encontrar para um café qualquer dia desses com calma',
        ),
      ];

      final amigos = AmigosAnalyzer.analyze(messages);
      final styles = {for (var s in amigos.communicationStyles) s.name: s.style};

      expect(styles['Comediante'], equals('engraçado'));
      expect(styles['Expressivo'], equals('expressivo'));
      expect(styles['Escritor'], equals('detalhista'));
      expect(styles['Objetivo'], equals('objetivo'));
      expect(styles['Carinhoso'], equals('carinhoso'));
    });

    test('Vibe Compatibility calculates squad diversity score and description', () {
      final messages = [
        ChatMessage(timestamp: DateTime.now(), author: 'P1', content: '😂🤣😂'), // engraçado
        ChatMessage(timestamp: DateTime.now(), author: 'P2', content: 'ok'), // objetivo
        ChatMessage(timestamp: DateTime.now(), author: 'P3', content: 'Um texto bem detalhado e explicativo ' * 4), // detalhista
      ];

      final amigos = AmigosAnalyzer.analyze(messages);
      expect(amigos.compatibility.score, inInclusiveRange(70, 100));
      expect(amigos.compatibility.description, isNotEmpty);
    });

    test('Monologue flood streak detects maximum consecutive run by single author', () {
      final messages = [
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'Alice', content: '1'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 1), author: 'Alice', content: '2'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 2), author: 'Bob', content: '3'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 3), author: 'Bob', content: '4'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 4), author: 'Bob', content: '5'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 5), author: 'Bob', content: '6'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 6), author: 'Carol', content: '7'),
      ];

      final amigos = AmigosAnalyzer.analyze(messages);
      expect(amigos.friendStats.biggestFloodName, equals('Bob'));
      expect(amigos.friendStats.biggestFloodCount, equals(4));
    });

    test('Fastest replier identifies speed champion and formats human readable time', () {
      final messages = [
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'Alice', content: 'Alguém online?'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0, 45), author: 'Bob', content: 'Opa estou!'), // 45s (<1 min)
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 8), author: 'Carol', content: 'Eu também'), // 7min
      ];

      final amigos = AmigosAnalyzer.analyze(messages);
      expect(amigos.friendStats.fastestReplyName, equals('Bob'));
      expect(amigos.friendStats.fastestReplyTimeFormatted, equals('1min'));
    });

    test('Group dynamics sets conversation starter from earliest message', () {
      final messages = [
        ChatMessage(timestamp: DateTime(2025, 1, 1, 8, 0), author: 'Iniciador', content: 'Bom dia squad'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 8, 30), author: 'Segundo', content: 'Bom dia'),
      ];

      final amigos = AmigosAnalyzer.analyze(messages);
      expect(amigos.groupDynamics.conversationStarter, equals('Iniciador'));
    });

    test('Handles empty and single-message chats gracefully', () {
      final amigosEmpty = AmigosAnalyzer.analyze([]);
      expect(amigosEmpty.general.totalMessages, equals(0));
      expect(amigosEmpty.compatibility.score, inInclusiveRange(0, 100));

      final amigosSingle = AmigosAnalyzer.analyze([
        ChatMessage(timestamp: DateTime.now(), author: 'Solo', content: 'Mensagem'),
      ]);
      expect(amigosSingle.communicationStyles.length, equals(1));
      expect(amigosSingle.friendStats.biggestFloodCount, equals(1));
    });
  });
}
