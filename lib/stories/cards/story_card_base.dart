import 'package:flutter/material.dart';
import '../../theme/squircle_border.dart';
import '../../theme/swiss_typography.dart';
import '../../widgets/stories/shared/seasons_story_footer.dart';
import '../../widgets/stories/shared/story_paper_background.dart';

/// Base layout container for all 9:16 Story Cards.
/// Uses the tactile physical paper engine or an injected custom background,
/// renders category badges, title, subtitle, central content, and the "seasons" footer.
class StoryCardBase extends StatelessWidget {
  final String category;
  final IconData categoryIcon;
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;
  final Color? backgroundColor;
  final Widget? background;
  final bool isDarkTheme;
  final Color? categoryColor;
  final Color? titleColor;
  final Color? subtitleColor;

  const StoryCardBase({
    super.key,
    required this.category,
    required this.categoryIcon,
    required this.title,
    this.subtitle,
    required this.child,
    this.footer,
    this.backgroundColor,
    this.background,
    this.isDarkTheme = false,
    this.categoryColor,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? (isDarkTheme ? const Color(0xFF1B0B1E) : const Color(0xFFFBF9F5));

    final effectiveCategoryColor = categoryColor ?? (isDarkTheme ? Colors.white : const Color(0xFF1E1B4B));
    final effectiveTitleColor = titleColor ?? (isDarkTheme ? const Color(0xFFFFF9F2) : const Color(0xFF1E1B4B));
    final effectiveSubtitleColor = subtitleColor ?? (isDarkTheme ? const Color(0xFFE2E8F0) : const Color(0xFF475569));

    final backgroundWidget = background ??
        StoryPaperBackground(
          baseColor: effectiveBg,
          hairlineBorderColor: isDarkTheme ? const Color(0x33FFFFFF) : const Color(0x261E1B4B),
          textureOpacity: isDarkTheme ? 0.25 : 0.40,
        );

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background canvas
          Positioned.fill(child: backgroundWidget),

          // Foreground layout
          SafeArea(
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
                      color: isDarkTheme
                          ? Colors.white.withValues(alpha: 0.15)
                          : const Color(0x121E1B4B),
                      shape: SquircleBorder.radius(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(categoryIcon, size: 12, color: effectiveCategoryColor),
                        const SizedBox(width: 6),
                        Text(
                          category.toUpperCase(),
                          style: SwissTypography.labelSmall.copyWith(
                            color: effectiveCategoryColor,
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
                      color: effectiveTitleColor,
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
                        color: effectiveSubtitleColor,
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
        ],
      ),
    );
  }

  Widget _defaultFooter() {
    return SeasonsStoryFooter(
      editionTag: 'seasons archive',
      inkPrimary: isDarkTheme ? Colors.white : const Color(0xFF1E1B4B),
      inkSecondary: isDarkTheme ? const Color(0xFFFB7185) : const Color(0xFF475569),
    );
  }
}
