import 'package:flutter/material.dart';
import '../../theme/squircle_border.dart';
import '../../theme/swiss_typography.dart';
import '../../widgets/stories/shared/seasons_story_footer.dart';
import '../../widgets/stories/shared/story_paper_background.dart';

/// Base layout container for all 9:16 Story Cards.
/// Uses the tactile physical paper engine (Warm Ivory #FBF9F5, creased texture,
/// hairline framing) and renders the refined "seasons" footer.
class StoryCardBase extends StatelessWidget {
  final String category;
  final IconData categoryIcon;
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;
  final Color? backgroundColor;

  const StoryCardBase({
    super.key,
    required this.category,
    required this.categoryIcon,
    required this.title,
    this.subtitle,
    required this.child,
    this.footer,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? const Color(0xFFFBF9F5);

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: StoryPaperBackground(
        baseColor: effectiveBg,
        hairlineBorderColor: const Color(0x261E1B4B),
        textureOpacity: 0.40,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36), // Clearance for progress bars and top chrome

                // Category Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: ShapeDecoration(
                    color: const Color(0x121E1B4B),
                    shape: SquircleBorder.radius(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(categoryIcon, size: 12, color: const Color(0xFF1E1B4B)),
                      const SizedBox(width: 6),
                      Text(
                        category.toUpperCase(),
                        style: SwissTypography.labelSmall.copyWith(
                          color: const Color(0xFF1E1B4B),
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  title,
                  style: SwissTypography.displayMedium.copyWith(
                    color: const Color(0xFF1E1B4B),
                    fontFamily: 'serif',
                    fontSize: 28,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: SwissTypography.bodyMedium.copyWith(
                      color: const Color(0xFF475569),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Central Content Area
                Expanded(
                  child: Center(
                    child: child,
                  ),
                ),

                const SizedBox(height: 12),

                // Footer / Branding
                footer ?? _defaultFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _defaultFooter() {
    return const SeasonsStoryFooter(
      editionTag: 'seasons archive',
    );
  }
}
