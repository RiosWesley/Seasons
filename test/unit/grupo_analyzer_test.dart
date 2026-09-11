import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/core/analytics/grupo_analyzer.dart';
import 'package:chat_wrapped/core/models/chat_message.dart';

void main() {
  group('GrupoAnalyzer Unit Tests', () {
    test('Leaderboard computes percentage contributions and awards podium medals', () {
      final messages = [
        ChatMessage(timestamp: DateTime.now(), author: 'Membro1', content: '1'),
        ChatMessage(timestamp: DateTime.now(), author: 'Membro1', content: '2'),
        ChatMessage(timestamp: DateTime.now(), author: 'Membro1', content: '3'),
        ChatMessage(timestamp: DateTime.now(), author: 'Membro1', content: '4'),
        ChatMessage(timestamp: DateTime.now(), author: 'Membro2', content: '5'),
        ChatMessage(timestamp: DateTime.now(), author: 'Membro2', content: '6'),
        ChatMessage(timestamp: DateTime.now(), author: 'Membro3', content: '7'),
        ChatMessage(timestamp: DateTime.now(), author: 'Membro4', content: '8'),
      ];

      final grupo = GrupoAnalyzer.analyze(messages);
      expect(grupo.memberRanking.length, equals(4));

      // Membro1: 4/8 = 50%
      expect(grupo.memberRanking[0].name, equals('Membro1'));
      expect(grupo.memberRanking[0].percentage, equals(50));
      expect(grupo.memberRanking[0].medal, equals('🥇'));

      // Membro2: 2/8 = 25%
      expect(grupo.memberRanking[1].name, equals('Membro2'));
      expect(grupo.memberRanking[1].percentage, equals(25));
      expect(grupo.memberRanking[1].medal, equals('🥈'));

      // Membro3: 1/8 = 13%
      expect(grupo.memberRanking[2].medal, equals('🥉'));

      // Membro4: 1/8 = 13%
      expect(grupo.memberRanking[3].medal, isNull);
    });

    test('Interaction Triad identifies reaction champion, reply champion, and topic starter', () {
      final messages = [
        // Topic starter
        ChatMessage(timestamp: DateTime(2025, 1, 1, 9, 0), author: 'Iniciador', content: 'Bom dia grupo'),
        // Reply turn by Reagente with reaction emojis
        ChatMessage(timestamp: DateTime(2025, 1, 1, 9, 2), author: 'Reagente', content: 'Excelente dia! 👍🔥💯'),
        // Reply turn by Respondedor
        ChatMessage(timestamp: DateTime(2025, 1, 1, 9, 5), author: 'Respondedor', content: 'Opa tudo bem?'),
        // Another reply by Respondedor to another author
        ChatMessage(timestamp: DateTime(2025, 1, 1, 9, 6), author: 'Outro', content: 'Sim!'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 9, 7), author: 'Respondedor', content: 'Maravilha'),
      ];

      final grupo = GrupoAnalyzer.analyze(messages);
      expect(grupo.memberInteraction.reactionChampionName, equals('Reagente'));
      expect(grupo.memberInteraction.reactionCount, equals(3));
      expect(grupo.memberInteraction.replyChampionName, equals('Respondedor'));
      expect(grupo.memberInteraction.replyCount, equals(2));
      expect(grupo.memberInteraction.topicsStartedCount, greaterThanOrEqualTo(1));
    });

    test('Group Dynamics detects night owl, consistent member, most active, and silent', () {
      final messages = [
        // Coruja: messages between 22h and 06h
        ChatMessage(timestamp: DateTime(2025, 1, 1, 23, 30), author: 'Coruja', content: 'Madrugada 1'),
        ChatMessage(timestamp: DateTime(2025, 1, 2, 2, 0), author: 'Coruja', content: 'Madrugada 2'),

        // Constante: messages on 3 distinct calendar days
        ChatMessage(timestamp: DateTime(2025, 1, 1, 12, 0), author: 'Constante', content: 'Dia 1'),
        ChatMessage(timestamp: DateTime(2025, 1, 2, 12, 0), author: 'Constante', content: 'Dia 2'),
        ChatMessage(timestamp: DateTime(2025, 1, 3, 12, 0), author: 'Constante', content: 'Dia 3'),

        // Tagarela: highest message count on 1 day
        ChatMessage(timestamp: DateTime(2025, 1, 1, 14, 0), author: 'Tagarela', content: 'M1'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 14, 1), author: 'Tagarela', content: 'M2'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 14, 2), author: 'Tagarela', content: 'M3'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 14, 3), author: 'Tagarela', content: 'M4'),

        // Fantasma: only 1 message
        ChatMessage(timestamp: DateTime(2025, 1, 1, 15, 0), author: 'Fantasma', content: 'Oi'),
      ];

      final grupo = GrupoAnalyzer.analyze(messages);
      expect(grupo.groupDynamics.nightOwl, equals('Coruja'));
      expect(grupo.groupDynamics.mostConsistent, equals('Constante'));
      expect(grupo.groupDynamics.mostActive, equals('Tagarela'));
      expect(grupo.groupDynamics.silent, equals('Fantasma'));
    });

    test('Computes 4 Vibes ranking correctly', () {
      final messages = [
        ChatMessage(timestamp: DateTime.now(), author: 'Risonho', content: 'hahaha 😂🤣'),
        ChatMessage(timestamp: DateTime.now(), author: 'Trabalhador', content: 'precisamos entregar o projeto e a reunião'),
        ChatMessage(timestamp: DateTime.now(), author: 'Romantico', content: 'meu amor lindo te amo 💕❤️'),
        ChatMessage(timestamp: DateTime.now(), author: 'Tedioso', content: 'que sono 😴😑'),
      ];

      final grupo = GrupoAnalyzer.analyze(messages);
      expect(grupo.vibeRanking.length, equals(4));

      final engracado = grupo.vibeRanking.firstWhere((v) => v.vibe == 'Engraçado');
      expect(engracado.winner, equals('Risonho'));

      final hardworker = grupo.vibeRanking.firstWhere((v) => v.vibe == 'Hardworker');
      expect(hardworker.winner, equals('Trabalhador'));

      final romantico = grupo.vibeRanking.firstWhere((v) => v.vibe == 'Romântico');
      expect(romantico.winner, equals('Romantico'));

      final entediado = grupo.vibeRanking.firstWhere((v) => v.vibe == 'Entediado');
      expect(entediado.winner, equals('Tedioso'));
    });

    test('Topic keyword clusters categorize and rank thematic words', () {
      final messages = [
        ChatMessage(timestamp: DateTime.now(), author: 'A', content: 'bora jogar games online jogo'),
        ChatMessage(timestamp: DateTime.now(), author: 'B', content: 'trabalho difícil projeto'),
        ChatMessage(timestamp: DateTime.now(), author: 'C', content: 'futebol hoje no fut'),
      ];

      final grupo = GrupoAnalyzer.analyze(messages);
      expect(grupo.topics.any((t) => t.topic == 'Games' && t.mentions > 0), isTrue);
      expect(grupo.topics.any((t) => t.topic == 'Trabalho' && t.mentions > 0), isTrue);
      expect(grupo.topics.any((t) => t.topic == 'Futebol' && t.mentions > 0), isTrue);
    });

    test('Group ignoring leaderboard tracks >2h turnaround delays', () {
      final messages = [
        ChatMessage(timestamp: DateTime(2025, 1, 1, 10, 0), author: 'A', content: 'Pergunta'),
        ChatMessage(timestamp: DateTime(2025, 1, 1, 13, 30), author: 'Atrasado', content: 'Resposta 3.5h depois'),
      ];

      final grupo = GrupoAnalyzer.analyze(messages);
      expect(grupo.groupIgnoringStats.mostIgnoringName, equals('Atrasado'));
      expect(grupo.groupIgnoringStats.mostIgnoringCount, equals(1));
      expect(grupo.groupIgnoringStats.mostIgnoredName, equals('A'));
      expect(grupo.groupIgnoringStats.mostIgnoredCount, equals(1));
    });
  });
}
