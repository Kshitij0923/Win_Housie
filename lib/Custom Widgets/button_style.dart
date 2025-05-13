import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tambola/Theme/app_theme.dart';

class ButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final String? label; // Nullable
  final IconData? icon; // Nullable
  final Color? backgroundColor;
  final double? borderRadius;

  const ButtonWidget({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  State<ButtonWidget> createState() => _PlayNowButtonState();
}

class _PlayNowButtonState extends State<ButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme()..init(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.wp(20)),
              boxShadow: [
                BoxShadow(
                  color: theme.animationBgColor.withAlpha(
                    (0.3 + 0.3 * _glowAnimation.value) * 255 ~/ 1,
                  ),
                  blurRadius: 20,
                  spreadRadius: 4 * _glowAnimation.value,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.heavyImpact();
                widget.onPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.buttonbackgroundColor,
                padding: EdgeInsets.symmetric(
                  horizontal: theme.wp(7),
                  vertical: theme.hp(1.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(theme.wp(20)),
                ),
                elevation: 5 + 5 * _glowAnimation.value,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.label != null && widget.label!.isNotEmpty)
                    Text(widget.label!, style: theme.buttonTextStyle),
                  if (widget.label != null &&
                      widget.label!.isNotEmpty &&
                      widget.icon != null)
                    SizedBox(width: theme.sp(2)),
                  if (widget.icon != null)
                    Transform.rotate(
                      angle: _controller.value * 0.5 * pi,
                      child: Icon(widget.icon, color: theme.textPrimaryColor),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
