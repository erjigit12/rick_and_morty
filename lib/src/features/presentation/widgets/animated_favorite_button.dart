// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedFavoriteButton extends StatefulWidget {
  const AnimatedFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.tooltip,
  });

  final bool isFavorite;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationProgress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      value: widget.isFavorite ? 1 : 0,
    );

    _scaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 60),
          TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0), weight: 40),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        );

    _rotationProgress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      if (widget.isFavorite) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final inactive = theme.colorScheme.onSurfaceVariant;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final color = Color.lerp(inactive, primary, progress) ?? primary;
        final curveValue = _rotationProgress.value;
        final glowOpacity = (curveValue * 0.6).clamp(0.0, 1.0);
        final angle = math.sin(curveValue * math.pi) * (math.pi / 8);

        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: glowOpacity * 0.4,
              child: Transform.scale(
                scale: 0.9 + glowOpacity * 0.5,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary.withOpacity(0.35),
                  ),
                ),
              ),
            ),
            Transform.rotate(
              angle: angle,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: IconButton(
                  onPressed: widget.onPressed,
                  tooltip: widget.tooltip,
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 1 - progress,
                        child: Icon(Icons.star_border, color: inactive, size: 22),
                      ),
                      Opacity(
                        opacity: progress,
                        child: Icon(Icons.star, color: color, size: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
