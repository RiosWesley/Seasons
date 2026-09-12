import '../../core/models/amigos_stats.dart';
import '../../core/models/casal_stats.dart';
import '../../core/models/general_stats.dart';

/// Adapter providing strongly-typed, clean accessors and deterministic
/// derivations for Amigos/Squad Mode story slides (a1..a18).
class AmigosStoryAdapter {
  final AmigosAnalysisResult result;

  const AmigosStoryAdapter(this.result);

  factory AmigosStoryAdapter.fromStats(AmigosStats stats) =>
      AmigosStoryAdapter(AmigosAnalysisResult(stats));

  // --- Squad Members & Volumes ---
  List<String> get participants => result.generalStats.participants;

  int get memberCount => participants.length;

  String get squadRosterFormatted {
    if (participants.isEmpty) return 'Squad';
    if (participants.length <= 3) return participants.join(' • ');
    return '${participants.take(3).join(', ')} e +${participants.length - 3}';
  }

  int get totalMessages => result.generalStats.totalMessages;

  Map<String, int> get participantCounts => result.generalStats.participantCounts;

  List<MapEntry<String, int>> get sortedMemberVolumes {
    final entries = participantCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  DateTime get startDate => result.generalStats.startDate;
  DateTime get endDate => result.generalStats.endDate;

  // --- Squad Archetypes & Dynamics ---
  List<CommunicationStyle> get communicationStyles =>
      result.communicationStyles;

  CompatibilityScore get compatibility => result.compatibility;
  int get compatibilityScore => result.compatibility.score;
  String get compatibilityDescription => result.compatibility.description;

  FriendStat get friendStats => result.friendStats;
  GroupDynamic get groupDynamics => result.groupDynamics;

  // --- Temporal & Vocabulary Stats ---
  List<TimelineData> get timeline => result.generalStats.timeline;

  TimelineData? get peakTimelineMonth {
    if (timeline.isEmpty) return null;
    TimelineData peak = timeline.first;
    for (final entry in timeline) {
      if (entry.count > peak.count) {
        peak = entry;
      }
    }
    return peak;
  }

  List<WordCount> get topWords => result.generalStats.topWords;
  List<EmojiCount> get topEmojis => result.generalStats.topEmojis;

  List<HourActivity> get activeHours => result.generalStats.activeHours;
  int get peakHour => result.generalStats.mostActiveHour;
  String get peakHourFormatted => '${peakHour.toString().padLeft(2, '0')}:00';

  // --- Speed & Ignoring Metrics ---
  ResponseTimeStats get responseTimeStats => result.responseTimeStats;

  double get averageResponseTimeMinutes =>
      responseTimeStats.averageResponseTimeMs / 60000;

  String get averageResponseTimeFormatted {
    final mins = averageResponseTimeMinutes;
    if (mins < 1.0) {
      final secs = (responseTimeStats.averageResponseTimeMs / 1000).round();
      return '$secs seg';
    }
    return '${mins.toStringAsFixed(1)} min';
  }

  IgnoringStats get ignoringStats => result.ignoringStats;
  AudioIgnoringStats get audioIgnoringStats => result.audioIgnoringStats;

  List<String> get insights => result.insights;
  String get primaryInsight => result.insights.isNotEmpty
      ? result.insights.first
      : 'Um squad vibrante que transforma qualquer assunto em um evento inesquecível.';

  // --- Deterministic Derivations (Zero-Model-Mutation) ---
  String get biggestFloodAuthor => friendStats.biggestFloodName.isNotEmpty
      ? friendStats.biggestFloodName
      : (participants.isNotEmpty ? participants.first : 'O Monólogo');

  int get biggestFloodCount => friendStats.biggestFloodCount > 0
      ? friendStats.biggestFloodCount
      : 8;

  String get fastestReplier => friendStats.fastestReplyName.isNotEmpty
      ? friendStats.fastestReplyName
      : (participants.isNotEmpty ? participants.first : 'O Relâmpago');

  int get totalAudios => audioIgnoringStats.totalAudios;

  /// Estimated audio duration in minutes for the squad.
  int get estimatedAudioMinutes =>
      (totalAudios * 0.45).round().clamp(1, 9999);

  String get podcasterAuthor => audioIgnoringStats.ignoredAudios >= audioIgnoringStats.wasIgnoredAudios
      ? (participants.isNotEmpty ? participants.first : 'O Podcaster')
      : (participants.length > 1 ? participants[1] : 'O Podcaster');

  /// Estimated prints / screenshots taken by the squad.
  int get estimatedPrints =>
      (result.generalStats.mediaCount * 0.22).round().clamp(1, 999);

  String get printInvestigator => participants.length > 1
      ? participants[1]
      : (participants.isNotEmpty ? participants.first : 'Detetive do Squad');

  /// Circulating forwarded memes and external fuel.
  int get forwardedMemes =>
      (totalMessages * 0.042).round().clamp(5, 500);

  String get memeSupplier => groupDynamics.conversationStarter.isNotEmpty
      ? groupDynamics.conversationStarter
      : (participants.isNotEmpty ? participants.first : 'Central de Memes');

  /// Comic suspense unsent drafts within squad discussions.
  int get unsentDrafts =>
      (totalMessages * 0.052).round().clamp(3, 400);

  String get vacuumKing => ignoringStats.ignoredCount >= ignoringStats.wasIgnoredCount
      ? (participants.isNotEmpty ? participants.first : 'Fantasma')
      : (participants.length > 1 ? participants[1] : 'Fantasma');

  String get vacuumVictim => ignoringStats.wasIgnoredCount >= ignoringStats.ignoredCount
      ? (participants.isNotEmpty ? participants.first : 'O Paciente')
      : (participants.length > 1 ? participants[1] : 'O Paciente');
}
