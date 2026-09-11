import 'casal_stats.dart';
import 'general_stats.dart';

/// Communication archetype assigned to a squad friend.
class CommunicationStyle {
  final String name;
  final String style; // 'engraçado', 'expressivo', 'detalhista', 'objetivo', 'carinhoso'
  final String emoji; // '😂', '😊', '📝', '⚡', '💕'

  const CommunicationStyle({
    required this.name,
    required this.style,
    required this.emoji,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommunicationStyle &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          style == other.style &&
          emoji == other.emoji;

  @override
  int get hashCode => Object.hash(name, style, emoji);

  @override
  String toString() => 'CommunicationStyle($name: $style $emoji)';
}

/// Superlative friend benchmarks and achievements.
class FriendStat {
  final String mostMessagesName;
  final int mostMessagesCount;
  final String fastestReplyName;
  final String fastestReplyTimeFormatted;
  final String favoriteEmoji;
  final int favoriteEmojiCount;
  final String biggestFloodName;
  final int biggestFloodCount;
  final String activeHourFormatted;

  const FriendStat({
    required this.mostMessagesName,
    required this.mostMessagesCount,
    required this.fastestReplyName,
    required this.fastestReplyTimeFormatted,
    required this.favoriteEmoji,
    required this.favoriteEmojiCount,
    required this.biggestFloodName,
    required this.biggestFloodCount,
    required this.activeHourFormatted,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendStat &&
          runtimeType == other.runtimeType &&
          mostMessagesName == other.mostMessagesName &&
          mostMessagesCount == other.mostMessagesCount &&
          fastestReplyName == other.fastestReplyName &&
          fastestReplyTimeFormatted == other.fastestReplyTimeFormatted &&
          favoriteEmoji == other.favoriteEmoji &&
          favoriteEmojiCount == other.favoriteEmojiCount &&
          biggestFloodName == other.biggestFloodName &&
          biggestFloodCount == other.biggestFloodCount &&
          activeHourFormatted == other.activeHourFormatted;

  @override
  int get hashCode => Object.hash(
        mostMessagesName,
        mostMessagesCount,
        fastestReplyName,
        fastestReplyTimeFormatted,
        favoriteEmoji,
        favoriteEmojiCount,
        biggestFloodName,
        biggestFloodCount,
        activeHourFormatted,
      );

  @override
  String toString() =>
      'FriendStat(mostMsgs: $mostMessagesName ($mostMessagesCount), fastest: $fastestReplyName ($fastestReplyTimeFormatted), flood: $biggestFloodName ($biggestFloodCount))';
}

/// Dynamic conversational roles inside the squad.
class GroupDynamic {
  final String conversationStarter;
  final String mostInteractive;

  const GroupDynamic({
    required this.conversationStarter,
    required this.mostInteractive,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupDynamic &&
          runtimeType == other.runtimeType &&
          conversationStarter == other.conversationStarter &&
          mostInteractive == other.mostInteractive;

  @override
  int get hashCode => Object.hash(conversationStarter, mostInteractive);

  @override
  String toString() =>
      'GroupDynamic(starter: $conversationStarter, interactive: $mostInteractive)';
}

/// Aggregate statistical container for Amigos Mode.
class AmigosStats {
  final GeneralStats general;
  final List<CommunicationStyle> communicationStyles;
  final CompatibilityScore compatibility;
  final FriendStat friendStats;
  final GroupDynamic groupDynamics;
  final List<String> insights;
  final IgnoringStats ignoringStats;
  final AudioIgnoringStats audioIgnoringStats;
  final ResponseTimeStats responseTimeStats;

  const AmigosStats({
    required this.general,
    required this.communicationStyles,
    required this.compatibility,
    required this.friendStats,
    required this.groupDynamics,
    required this.insights,
    required this.ignoringStats,
    required this.audioIgnoringStats,
    required this.responseTimeStats,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmigosStats &&
          runtimeType == other.runtimeType &&
          general == other.general &&
          compatibility == other.compatibility &&
          friendStats == other.friendStats &&
          groupDynamics == other.groupDynamics &&
          ignoringStats == other.ignoringStats &&
          audioIgnoringStats == other.audioIgnoringStats &&
          responseTimeStats == other.responseTimeStats;

  @override
  int get hashCode => Object.hash(
        general,
        compatibility,
        friendStats,
        groupDynamics,
        ignoringStats,
        audioIgnoringStats,
        responseTimeStats,
      );

  @override
  String toString() =>
      'AmigosStats(compatibility: ${compatibility.score}%, friendStats: $friendStats)';
}

/// ChatAnalysisResult implementation for Amigos mode.
class AmigosAnalysisResult implements ChatAnalysisResult {
  final AmigosStats stats;

  const AmigosAnalysisResult(this.stats);

  @override
  GeneralStats get generalStats => stats.general;

  @override
  ChatMode get mode => ChatMode.amigos;

  List<CommunicationStyle> get communicationStyles => stats.communicationStyles;
  CompatibilityScore get compatibility => stats.compatibility;
  FriendStat get friendStats => stats.friendStats;
  GroupDynamic get groupDynamics => stats.groupDynamics;
  List<String> get insights => stats.insights;
  IgnoringStats get ignoringStats => stats.ignoringStats;
  AudioIgnoringStats get audioIgnoringStats => stats.audioIgnoringStats;
  ResponseTimeStats get responseTimeStats => stats.responseTimeStats;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmigosAnalysisResult &&
          runtimeType == other.runtimeType &&
          stats == other.stats;

  @override
  int get hashCode => stats.hashCode;

  @override
  String toString() => 'AmigosAnalysisResult($stats)';
}
