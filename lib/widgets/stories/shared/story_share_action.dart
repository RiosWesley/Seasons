import 'package:flutter/material.dart';

/// Tactile editorial share button for concluding story cards.
/// Integrates [Icon(Icons.share_rounded)] to ensure full compatibility with existing
/// automated test suites while offering luxury tactile physical styling.
class StoryShareAction extends StatefulWidget {
  final VoidCallback onShare;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double height;
  final double borderRadius;

  const StoryShareAction({
    super.key,
    required this.onShare,
    this.label = 'COMPARTILHAR RETROSPECTIVA',
    this.backgroundColor = const Color(0xFF1E1B4B),
    this.foregroundColor = Colors.white,
    this.borderColor,
    this.height = 52.0,
    this.borderRadius = 16.0,
  });

  @override
  State<StoryShareAction> createState() => _StoryShareActionState();
}

class _StoryShareActionState extends State<StoryShareAction> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutQuad,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onShare,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: widget.borderColor != null
                  ? Border.all(color: widget.borderColor!, width: 1.0)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: widget.backgroundColor.withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.share_rounded,
                  color: widget.foregroundColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.foregroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
