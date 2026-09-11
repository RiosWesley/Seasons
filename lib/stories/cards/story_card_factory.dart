import 'package:flutter/material.dart';
import '../../core/models/amigos_stats.dart';
import '../../core/models/casal_stats.dart';
import '../../core/models/general_stats.dart';
import '../../core/models/grupo_stats.dart';
import '../story_slide.dart';
import 'amigos_story_cards.dart';
import 'casal_story_cards.dart';
import 'grupo_story_cards.dart';

/// Factory resolving the appropriate 9:16 Story Card widget
/// for a given [StorySlide] and [ChatAnalysisResult].
class StoryCardFactory {
  StoryCardFactory._();

  static Widget buildCard({
    required StorySlide slide,
    required ChatAnalysisResult analysis,
    VoidCallback? onShare,
  }) {
    switch (slide.mode) {
      case ChatMode.casal:
        if (analysis is CasalAnalysisResult) {
          return CasalStoryCards.buildSlide(
            slideId: slide.id,
            analysis: analysis,
            onShare: onShare,
          );
        }
        break;
      case ChatMode.amigos:
        if (analysis is AmigosAnalysisResult) {
          return AmigosStoryCards.buildSlide(
            slideId: slide.id,
            analysis: analysis,
            onShare: onShare,
          );
        }
        break;
      case ChatMode.grupo:
        if (analysis is GrupoAnalysisResult) {
          return GrupoStoryCards.buildSlide(
            slideId: slide.id,
            analysis: analysis,
            onShare: onShare,
          );
        }
        break;
    }

    // Fallback: build with default mode handler
    if (analysis is CasalAnalysisResult) {
      return CasalStoryCards.buildSlide(
        slideId: slide.id,
        analysis: analysis,
        onShare: onShare,
      );
    } else if (analysis is AmigosAnalysisResult) {
      return AmigosStoryCards.buildSlide(
        slideId: slide.id,
        analysis: analysis,
        onShare: onShare,
      );
    } else if (analysis is GrupoAnalysisResult) {
      return GrupoStoryCards.buildSlide(
        slideId: slide.id,
        analysis: analysis,
        onShare: onShare,
      );
    }

    return const Center(
      child: Text('Slide não disponível'),
    );
  }
}
