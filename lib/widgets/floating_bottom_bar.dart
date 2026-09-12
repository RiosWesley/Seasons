import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/swiss_colors.dart';

/// Item descriptor for [FloatingBottomNavBar].
class FloatingBottomBarItem {
  final IconData icon;
  final String label;

  const FloatingBottomBarItem({
    required this.icon,
    required this.label,
  });
}

/// Frosted-Glass Floating Bottom Navigation Bar (R2).
///
/// Features:
/// - Floating margins: EdgeInsets.fromLTRB(20, 0, 20, 16 + bottomInset)
/// - Continuous 26dp squircle curvature: ClipRRect(borderRadius: BorderRadius.circular(26))
/// - Glassmorphism: BackdropFilter(sigmaX: 12, sigmaY: 12), semi-translucent fill
///   (0.82 alpha), subtle luminous border (0.6 / 0.12 alpha), and diffuse elevation shadow
/// - Lucide iconography: house, trendingUp, layoutGrid, settings
/// - Tactile HapticFeedback.selectionClick() on tab press
/// - Fluid sliding active selection pill with 260ms Curves.easeOutCubic, 1.05x active icon scale,
///   animated text style, and active dot indicator
class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<FloatingBottomBarItem> items;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = defaultItems,
  });

  static const List<FloatingBottomBarItem> defaultItems = [
    FloatingBottomBarItem(icon: LucideIcons.house, label: 'Início'),
    FloatingBottomBarItem(icon: LucideIcons.trendingUp, label: 'Minhas Análises'),
    FloatingBottomBarItem(icon: LucideIcons.layoutGrid, label: 'Modelos'),
    FloatingBottomBarItem(icon: LucideIcons.settings, label: 'Configurações'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 16 + bottomInset),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            isDark
                ? BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                : const BoxShadow(
                    color: Color(0x1A0F172A),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? SwissColors.darkSurfaceCard.withValues(alpha: 0.82)
                    : Colors.white.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.6),
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final count = items.length;
                  if (count == 0) return const SizedBox.shrink();

                  final itemWidth = totalWidth / count;
                  const pillWidth = 52.0;
                  const pillHeight = 28.0;

                  final hasValidIndex = currentIndex >= 0 && currentIndex < count;
                  final activeIndex = hasValidIndex ? currentIndex : 0;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Fluid sliding active selection pill
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        left: (activeIndex * itemWidth) + (itemWidth - pillWidth) / 2,
                        top: 2,
                        width: pillWidth,
                        height: pillHeight,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: hasValidIndex ? 1.0 : 0.0,
                          child: Container(
                            decoration: ShapeDecoration(
                              color: isDark
                                  ? SwissColors.irisPrimary.withValues(alpha: 0.25)
                                  : const Color(0xFFEEF2FF),
                              shape: const StadiumBorder(),
                            ),
                          ),
                        ),
                      ),

                      // Nav items row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(count, (index) {
                          final item = items[index];
                          final isActive = index == currentIndex;

                          return Expanded(
                            child: _FloatingNavItem(
                              key: ValueKey('floating_nav_item_$index'),
                              item: item,
                              isActive: isActive,
                              isDark: isDark,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                onTap(index);
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  final FloatingBottomBarItem item;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _FloatingNavItem({
    super.key,
    required this.item,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = SwissColors.irisPrimary;
    final inactiveIconColor = isDark ? SwissColors.darkTextMuted : const Color(0xFF94A3B8);
    final activeTextColor = isDark ? SwissColors.irisPrimary : const Color(0xFF4F46E5);
    final inactiveTextColor = isDark ? SwissColors.darkTextSecondary : const Color(0xFF64748B);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Center(
                child: AnimatedScale(
                  scale: isActive ? 1.05 : 0.95,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: isActive ? activeColor : inactiveIconColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeTextColor : inactiveTextColor,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedOpacity(
              opacity: isActive ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
