import 'general_stats.dart';

/// Leaderboard ranking item for group members.
class MemberRanking {
  final String name;
  final int percentage; // 0..100
  final String? medal; // '🥇', '🥈', '🥉', or null

  const MemberRanking({
    required this.name,
    required this.percentage,
    this.medal,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberRanking &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          percentage == other.percentage &&
          medal == other.medal;

  @override
  int get hashCode => Object.hash(name, percentage, medal);

  @override
  String toString() => 'MemberRanking($name: $percentage% ${medal ?? ""})';
}

/// Triad interaction champions in large groups.
class MemberInteraction {
  final String reactionChampionName;
  final int reactionCount;
  final String replyChampionName;
  final int replyCount;
  final String topicsStartedChampionName;
  final int topicsStartedCount;

  const MemberInteraction({
    required this.reactionChampionName,
    required this.reactionCount,
    required this.replyChampionName,
    required this.replyCount,
    required this.topicsStartedChampionName,
    required this.topicsStartedCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberInteraction &&
          runtimeType == other.runtimeType &&
          reactionChampionName == other.reactionChampionName &&
          reactionCount == other.reactionCount &&
          replyChampionName == other.replyChampionName &&
          replyCount == other.replyCount &&
          topicsStartedChampionName == other.topicsStartedChampionName &&
          topicsStartedCount == other.topicsStartedCount;

  @override
  int get hashCode => Object.hash(
        reactionChampionName,
        reactionCount,
        replyChampionName,
        replyCount,
        topicsStartedChampionName,
        topicsStartedCount,
      );

  @override
  String toString() =>
      'MemberInteraction(reactions: $reactionChampionName ($reactionCount), replies: $replyChampionName ($replyCount), topics: $topicsStartedChampionName ($topicsStartedCount))';
}

/// Behavioral dynamics across large groups.
class GroupDynamicsStats {
  final String mostActive;
  final String silent;
  final String mostConsistent;
  final String nightOwl;

  const GroupDynamicsStats({
    required this.mostActive,
    required this.silent,
    required this.mostConsistent,
    required this.nightOwl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupDynamicsStats &&
          runtimeType == other.runtimeType &&
          mostActive == other.mostActive &&
          silent == other.silent &&
          mostConsistent == other.mostConsistent &&
          nightOwl == other.nightOwl;

  @override
  int get hashCode =>
      Object.hash(mostActive, silent, mostConsistent, nightOwl);

  @override
  String toString() =>
      'GroupDynamicsStats(mostActive: $mostActive, silent: $silent, consistent: $mostConsistent, nightOwl: $nightOwl)';
}

/// Category winner for distinct conversational vibes.
class VibeRanking {
  final String vibe; // 'Engraçado', 'Hardworker', 'Romântico', 'Entediado'
  final String winner;
  final String emoji;
  final int score;

  const VibeRanking({
    required this.vibe,
    required this.winner,
    required this.emoji,
    required this.score,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VibeRanking &&
          runtimeType == other.runtimeType &&
          vibe == other.vibe &&
          winner == other.winner &&
          emoji == other.emoji &&
          score == other.score;

  @override
  int get hashCode => Object.hash(vibe, winner, emoji, score);

  @override
  String toString() => 'VibeRanking($vibe: $winner $emoji, score: $score)';
}

/// Topic cluster mention frequency.
class TopicAnalysis {
  final String topic; // 'Trabalho', 'Games', 'Futebol', 'Filmes', 'Comida', 'Festa'
  final int mentions;

  const TopicAnalysis({
    required this.topic,
    required this.mentions,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicAnalysis &&
          runtimeType == other.runtimeType &&
          topic == other.topic &&
          mentions == other.mentions;

  @override
  int get hashCode => Object.hash(topic, mentions);

  @override
  String toString() => 'TopicAnalysis($topic: $mentions mentions)';
}

/// Entry in the group ignoring leaderboard.
class GroupIgnoringRankingEntry {
  final String name;
  final int count;

  const GroupIgnoringRankingEntry({
    required this.name,
    required this.count,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupIgnoringRankingEntry &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          count == other.count;

  @override
  int get hashCode => Object.hash(name, count);

  @override
  String toString() => 'GroupIgnoringRankingEntry($name: $count)';
}

/// Group-wide ghosting leaderboard statistics.
class GroupIgnoringStats {
  final String mostIgnoringName;
  final int mostIgnoringCount;
  final String mostIgnoredName;
  final int mostIgnoredCount;
  final List<GroupIgnoringRankingEntry> ignoringRanking;

  const GroupIgnoringStats({
    required this.mostIgnoringName,
    required this.mostIgnoringCount,
    required this.mostIgnoredName,
    required this.mostIgnoredCount,
    required this.ignoringRanking,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupIgnoringStats &&
          runtimeType == other.runtimeType &&
          mostIgnoringName == other.mostIgnoringName &&
          mostIgnoringCount == other.mostIgnoringCount &&
          mostIgnoredName == other.mostIgnoredName &&
          mostIgnoredCount == other.mostIgnoredCount;

  @override
  int get hashCode => Object.hash(
        mostIgnoringName,
        mostIgnoringCount,
        mostIgnoredName,
        mostIgnoredCount,
      );

  @override
  String toString() =>
      'GroupIgnoringStats(mostIgnoring: $mostIgnoringName ($mostIgnoringCount), mostIgnored: $mostIgnoredName ($mostIgnoredCount))';
}

/// Complete statistics container for Grupo Mode.
class GrupoStats {
  final GeneralStats general;
  final List<MemberRanking> memberRanking;
  final MemberInteraction memberInteraction;
  final GroupDynamicsStats groupDynamics;
  final List<VibeRanking> vibeRanking;
  final List<TopicAnalysis> topics;
  final List<String> topEmojis;
  final List<String> activeHours;
  final List<String> insights;
  final GroupIgnoringStats groupIgnoringStats;

  const GrupoStats({
    required this.general,
    required this.memberRanking,
    required this.memberInteraction,
    required this.groupDynamics,
    required this.vibeRanking,
    required this.topics,
    required this.topEmojis,
    required this.activeHours,
    required this.insights,
    required this.groupIgnoringStats,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrupoStats &&
          runtimeType == other.runtimeType &&
          general == other.general &&
          memberInteraction == other.memberInteraction &&
          groupDynamics == other.groupDynamics &&
          groupIgnoringStats == other.groupIgnoringStats;

  @override
  int get hashCode => Object.hash(
        general,
        memberInteraction,
        groupDynamics,
        groupIgnoringStats,
      );

  @override
  String toString() =>
      'GrupoStats(members: ${memberRanking.length}, topics: ${topics.length})';
}

/// ChatAnalysisResult implementation for Grupo mode.
class GrupoAnalysisResult implements ChatAnalysisResult {
  final GrupoStats stats;

  const GrupoAnalysisResult(this.stats);

  @override
  GeneralStats get generalStats => stats.general;

  @override
  ChatMode get mode => ChatMode.grupo;

  List<MemberRanking> get memberRanking => stats.memberRanking;
  MemberInteraction get memberInteraction => stats.memberInteraction;
  GroupDynamicsStats get groupDynamics => stats.groupDynamics;
  List<VibeRanking> get vibeRanking => stats.vibeRanking;
  List<TopicAnalysis> get topics => stats.topics;
  List<String> get topEmojis => stats.topEmojis;
  List<String> get activeHours => stats.activeHours;
  List<String> get insights => stats.insights;
  GroupIgnoringStats get groupIgnoringStats => stats.groupIgnoringStats;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrupoAnalysisResult &&
          runtimeType == other.runtimeType &&
          stats == other.stats;

  @override
  int get hashCode => stats.hashCode;

  @override
  String toString() => 'GrupoAnalysisResult($stats)';
}
