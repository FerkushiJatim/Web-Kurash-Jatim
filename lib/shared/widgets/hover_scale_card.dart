import 'package:flutter/material.dart';

class HoverScaleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;

  const HoverScaleCard({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 1.02,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<HoverScaleCard> createState() => _HoverScaleCardState();
}

class _HoverScaleCardState extends State<HoverScaleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          transform: Matrix4.diagonal3Values(
            _isHovered ? widget.scale : 1.0,
            _isHovered ? widget.scale : 1.0,
            1.0,
          ),
          transformAlignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}
