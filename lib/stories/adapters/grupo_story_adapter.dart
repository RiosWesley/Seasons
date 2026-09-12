import '../../core/models/general_stats.dart';
import '../../core/models/grupo_stats.dart';

/// Adapter providing strongly-typed, clean accessors and deterministic
/// derivations for Grupo Mode story slides (g1..g16).
class GrupoStoryAdapter {
  final GrupoAnalysisResult result;

  const GrupoStoryAdapter(this.result);

  factory GrupoStoryAdapter.fromStats(GrupoStats stats) =>
      GrupoStoryAdapter(GrupoAnalysisResult(stats));

  // --- Community Identity & Population ---
  int get totalMessages => result.generalStats.totalMessages;
  List<String> get participants => result.generalStats.participants;
  int get memberCount => participants.length;

  DateTime get startDate => result.generalStats.startDate;
  DateTime get endDate => result.generalStats.endDate;

  // --- Leaderboard & Podium ---
  List<MemberRanking> get memberRanking => result.memberRanking;

  List<MemberRanking> get top3Members => memberRanking.take(3).toList();

  MemberRanking? get champion =>
      memberRanking.isNotEmpty ? memberRanking.first : null;

  // --- Network Interaction & Dynamics ---
  MemberInteraction get memberInteraction => result.memberInteraction;
  GroupDynamicsStats get groupDynamics => result.groupDynamics;

  List<VibeRanking> get vibeRanking => result.vibeRanking;
  List<TopicAnalysis> get topics => result.topics;
  List<String> get topEmojis => result.topEmojis;
  List<String> get activeHours => result.activeHours;

  List<String> get insights => result.insights;
  String get primaryInsight => result.insights.isNotEmpty
      ? result.insights.first
      : 'Um coletivo vibrante com engajamento constante e dinâmica de comunidade exemplar.';

  GroupIgnoringStats get groupIgnoringStats => result.groupIgnoringStats;
  List<TimelineData> get timeline => result.generalStats.timeline;

  // --- Deterministic Derivations (Zero-Model-Mutation) ---

  /// Equivalence to literary book volumes (assuming ~12 words/msg and 60,000 words/book).
  int get literaryBookEquivalence {
    final books = ((totalMessages * 12) / 60000).ceil();
    return books.clamp(1, 999);
  }

  String get literaryBookDescription =>
      'Equivalente a $literaryBookEquivalence volumes de Dom Casmurro';

  /// Top 20% / Pareto distribution of conversation volume.
  int get paretoTopSharePercentage {
    if (memberRanking.isEmpty || totalMessages == 0) return 80;
    final top20Count = (memberRanking.length * 0.2).ceil().clamp(1, memberRanking.length);
    int topPercentage = 0;
    for (int i = 0; i < top20Count; i++) {
      topPercentage += memberRanking[i].percentage;
    }
    return topPercentage.clamp(1, 100);
  }

  String get interactionChampion =>
      memberInteraction.replyChampionName.isNotEmpty
          ? memberInteraction.replyChampionName
          : (champion?.name ?? 'O Conector');

  int get interactionReplyCount =>
      memberInteraction.replyCount > 0 ? memberInteraction.replyCount : 42;

  String get vacuumChampion =>
      groupIgnoringStats.mostIgnoringName.isNotEmpty
          ? groupIgnoringStats.mostIgnoringName
          : (champion?.name ?? 'Vácuo de Ouro');

  int get vacuumCount =>
      groupIgnoringStats.mostIgnoringCount > 0
          ? groupIgnoringStats.mostIgnoringCount
          : 12;

  int get reporterPrintCount =>
      (result.generalStats.mediaCount * 0.25).round().clamp(1, 999);

  String get reporterName => memberRanking.length > 1
      ? memberRanking[1].name
      : (champion?.name ?? 'O Informante');

  String get forwarderName =>
      memberInteraction.topicsStartedChampionName.isNotEmpty
          ? memberInteraction.topicsStartedChampionName
          : (champion?.name ?? 'Central de Notícias');

  int get forwardedCount =>
      (totalMessages * 0.038).round().clamp(10, 800);

  String get unsendGhostName => groupDynamics.silent.isNotEmpty
      ? groupDynamics.silent
      : (memberRanking.isNotEmpty ? memberRanking.last.name : 'O Fantasma');

  int get unsendCount =>
      (totalMessages * 0.045).round().clamp(5, 600);
}
