import 'package:flutter/material.dart';
import '../../theme/squircle_border.dart';
import '../../theme/swiss_colors.dart';
import '../../theme/swiss_typography.dart';

/// Base layout container for all 9:16 Story Cards.
/// Enforces Swiss-minimalist typography, tabular numerals, continuous squircles,
/// and disciplined emerald accents.
class StoryCardBase extends StatelessWidget {
  final String category;
  final IconData categoryIcon;
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;

  const StoryCardBase({
    super.key,
    required this.category,
    required this.categoryIcon,
    required this.title,
    this.subtitle,
    required this.child,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF090A0F), // Deep Swiss graphite canvas
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
                  color: SwissColors.darkSurfaceSubdued,
                  shape: SquircleBorder.radius(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(categoryIcon, size: 12, color: SwissColors.emeraldPrimary),
                    const SizedBox(width: 6),
                    Text(
                      category.toUpperCase(),
                      style: SwissTypography.labelSmall.copyWith(
                        color: SwissColors.emeraldPrimary,
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
                  color: SwissColors.darkTextPrimary,
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
                    color: SwissColors.darkTextSecondary,
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
    );
  }

  Widget _defaultFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 13,
                color: SwissColors.darkTextMuted,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  '100% OFFLINE • PRIVACIDADE LOCAL',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: SwissTypography.labelSmall.copyWith(
                    color: SwissColors.darkTextMuted,
                    fontSize: 9,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'CHAT WRAPPED',
          style: SwissTypography.labelSmall.copyWith(
            color: SwissColors.emeraldPrimary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
