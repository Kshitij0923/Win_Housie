import 'dart:math' as math;

import 'package:flutter/material.dart';

class HouzieeLoader extends StatefulWidget {
  final double size;
  final Color color;

  const HouzieeLoader({
    super.key,
    this.size = 80.0,
    this.color = Colors.purple,
  });

  @override
  State<HouzieeLoader> createState() => _HouzieeLoaderState();
}

class _HouzieeLoaderState extends State<HouzieeLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer rotating circle
              Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        widget.color.withValues(alpha: 0.3),
                        widget.color,
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              // House icon animation
              Transform.scale(
                scale: 0.7 + (_controller.value * 0.3),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: widget.size * 0.5,
                ),
              ),
              // Diamond shapes around the circle
              ...List.generate(6, (index) {
                final angle = (index / 6) * 2 * math.pi;
                final offsetAngle = _controller.value * 2 * math.pi;
                final x = math.cos(angle + offsetAngle) * (widget.size / 2);
                final y = math.sin(angle + offsetAngle) * (widget.size / 2);
                return Transform.translate(
                  offset: Offset(x, y),
                  child: Transform.rotate(
                    angle: angle + offsetAngle,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
