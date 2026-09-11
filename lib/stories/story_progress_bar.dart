import 'package:flutter/material.dart';

/// Segmented progress bar for the 9:16 Stories Experience.
/// Renders horizontal segments corresponding to each slide, with completed
/// slides filled, the active slide interpolating progress from 0.0 to 1.0,
/// and upcoming slides in a subdued track.
class StoryProgressBar extends StatelessWidget {
  final int totalSegments;
  final int currentIndex;
  final double animationProgress;
  final double barHeight;
  final double gap;
  final Color activeColor;
  final Color completedColor;
  final Color unfilledColor;

  const StoryProgressBar({
    super.key,
    required this.totalSegments,
    required this.currentIndex,
    required this.animationProgress,
    this.barHeight = 3.5,
    this.gap = 4.0,
    this.activeColor = Colors.white,
    this.completedColor = Colors.white,
    this.unfilledColor = const Color(0x40FFFFFF), // 25% white
  });

  @override
  Widget build(BuildContext context) {
    if (totalSegments <= 0) return const SizedBox.shrink();

    return Row(
      children: List.generate(totalSegments, (index) {
        double progress = 0.0;
        if (index < currentIndex) {
          progress = 1.0;
        } else if (index == currentIndex) {
          progress = animationProgress.clamp(0.0, 1.0);
        } else {
          progress = 0.0;
        }

        final isLast = index == totalSegments - 1;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0.0 : gap),
            child: _StorySegment(
              progress: progress,
              height: barHeight,
              activeColor: index == currentIndex ? activeColor : completedColor,
              unfilledColor: unfilledColor,
            ),
          ),
        );
      }),
    );
  }
}

class _StorySegment extends StatelessWidget {
  final double progress;
  final double height;
  final Color activeColor;
  final Color unfilledColor;

  const _StorySegment({
    required this.progress,
    required this.height,
    required this.activeColor,
    required this.unfilledColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: unfilledColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fillWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: fillWidth,
              height: height,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          );
        },
      ),
    );
  }
}
