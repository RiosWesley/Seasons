import 'package:flutter/material.dart';
import '../../core/models/grupo_stats.dart';
import '../../widgets/stories/grupo/grupo_g1_cover_slide.dart';
import '../../widgets/stories/grupo/grupo_g2_literary_total_slide.dart';
import '../../widgets/stories/grupo/grupo_g3_top3_podium_slide.dart';
import '../../widgets/stories/grupo/grupo_g4_dynamics_slide.dart';
import '../../widgets/stories/grupo/grupo_g5_timeline_slide.dart';
import '../../widgets/stories/grupo/grupo_g6_topics_cloud_slide.dart';
import '../../widgets/stories/grupo/grupo_g7_heatmap_slide.dart';
import '../../widgets/stories/grupo/grupo_g8_collective_emojis_slide.dart';
import '../../widgets/stories/grupo/grupo_g9_chaotic_flood_slide.dart';
import '../../widgets/stories/grupo/grupo_g10_network_matrix_slide.dart';
import '../../widgets/stories/grupo/grupo_g11_culture_insight_slide.dart';
import '../../widgets/stories/grupo/grupo_g12_ghosting_trophy_slide.dart';
import '../../widgets/stories/grupo/grupo_g13_reporter_prints_slide.dart';
import '../../widgets/stories/grupo/grupo_g14_news_forwarder_slide.dart';
import '../../widgets/stories/grupo/grupo_g15_unsend_deleter_slide.dart';
import '../../widgets/stories/grupo/grupo_g16_certificate_slide.dart';
import '../adapters/grupo_story_adapter.dart';

/// Facade routing all 16 bespoke slides for Grupo Mode (g1..g16).
/// Each slide is encapsulated in its own widget in [lib/widgets/stories/grupo/],
/// adhering to the Periodical Magazine Editorial & Community Broadsheet aesthetic.
class GrupoStoryCards {
  GrupoStoryCards._();

  static Widget buildSlide({
    required String slideId,
    required GrupoAnalysisResult analysis,
    VoidCallback? onShare,
  }) {
    final adapter = GrupoStoryAdapter(analysis);

    switch (slideId) {
      case 'g1':
        return GrupoG1CoverSlide(adapter: adapter);
      case 'g2':
        return GrupoG2LiteraryTotalSlide(adapter: adapter);
      case 'g3':
        return GrupoG3Top3PodiumSlide(adapter: adapter);
      case 'g4':
        return GrupoG4DynamicsSlide(adapter: adapter);
      case 'g5':
        return GrupoG5TimelineSlide(adapter: adapter);
      case 'g6':
        return GrupoG6TopicsCloudSlide(adapter: adapter);
      case 'g7':
        return GrupoG7HeatmapSlide(adapter: adapter);
      case 'g8':
        return GrupoG8CollectiveEmojisSlide(adapter: adapter);
      case 'g9':
        return GrupoG9ChaoticFloodSlide(adapter: adapter);
      case 'g10':
        return GrupoG10NetworkMatrixSlide(adapter: adapter);
      case 'g11':
        return GrupoG11CultureInsightSlide(adapter: adapter);
      case 'g12':
        return GrupoG12GhostingTrophySlide(adapter: adapter);
      case 'g13':
        return GrupoG13ReporterPrintsSlide(adapter: adapter);
      case 'g14':
        return GrupoG14NewsForwarderSlide(adapter: adapter);
      case 'g15':
        return GrupoG15UnsendDeleterSlide(adapter: adapter);
      case 'g16':
        return GrupoG16CertificateSlide(adapter: adapter, onShare: onShare);
      default:
        return GrupoG1CoverSlide(adapter: adapter);
    }
  }
}
