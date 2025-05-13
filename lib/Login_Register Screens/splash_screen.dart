import 'package:flutter/material.dart';
import 'package:tambola/Custom%20Widgets/loading_animation.dart';
import 'package:tambola/Login_Register%20Screens/start_page.dart';
import 'dart:math' as math;

import 'package:tambola/Theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  double _loadingProgress = 0.0;
  bool _isNavigating = false;

  // Separate controller for ball animations
  late AnimationController _ballAnimationController;

  @override
  void initState() {
    super.initState();
    // Initialize animations
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create a much slower animation controller for the balls
    _ballAnimationController = AnimationController(
      duration: const Duration(
        seconds: 20,
      ), // Much slower animation (20 seconds per cycle)
      vsync: this,
    )..repeat(); // Make it repeat continuously

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Start animation
    _controller.forward();

    // Manually control the loading progress
    _startLoadingAnimation();
  }

  void _startLoadingAnimation() async {
    // Animate from 0% to 100% over 3 seconds
    const steps = 100;
    const stepDuration = Duration(milliseconds: 3000 ~/ steps);

    for (int i = 1; i <= steps; i++) {
      await Future.delayed(stepDuration);
      if (mounted) {
        setState(() {
          _loadingProgress = i / steps;
        });
      }
    }

    // After loading is complete, navigate
    if (mounted && !_isNavigating) {
      _isNavigating = true;
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder:
                (_, animation, secondaryAnimation) => const StartPage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.1, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _ballAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme().houzieeGradient),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(painter: TambolaPatternPainter()),
            ),
            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo container with glow
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade900.withValues(
                          alpha: 0.7,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF9D4EDD,
                            ).withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const HouzieeLoader(
                        size: 120,
                        color: Color(0xFF9D4EDD),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // App name
                    const Text(
                      'WIN HOUSIE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: Color(0xFF9D4EDD),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Tagline
                    Text(
                      'The Ultimate Tambola Experience',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Loading indicator
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: _loadingProgress,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF9D4EDD),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Loading text with percentage
                    Text(
                      'Loading your game... ${(_loadingProgress * 100).toInt()}%',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating tambola balls
            ..._buildFloatingBalls(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingBalls() {
    final List<Widget> balls = [];
    final random = math.Random();
    // Create 8 floating balls
    for (int i = 0; i < 8; i++) {
      final size = random.nextDouble() * 20 + 30;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final top = random.nextDouble() * MediaQuery.of(context).size.height;
      final number = random.nextInt(90) + 1;
      final opacity = random.nextDouble() * 0.4 + 0.2;

      // Create unique animation phase for each ball
      final phaseOffset = random.nextDouble() * math.pi * 2;

      // Much smaller amplitude for more subtle movement
      final amplitude = 2.0 + random.nextDouble() * 4.0;

      balls.add(
        Positioned(
          left: left,
          top: top,
          child: AnimatedBuilder(
            animation: _ballAnimationController,
            builder: (context, child) {
              // Use the slower ball animation controller
              final progress = _ballAnimationController.value;

              // Apply the phase offset for varied movement
              final angle = progress * 2 * math.pi + phaseOffset;

              return Opacity(
                opacity:
                    _controller.value * opacity, // Fade in with main controller
                child: Transform.translate(
                  offset: Offset(
                    math.sin(angle) * amplitude,
                    math.cos(angle) * amplitude,
                  ),
                  child: child,
                ),
              );
            },
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple.shade300, Colors.deepPurple.shade700],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size * 0.4,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return balls;
  }
}

class TambolaPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.05)
          ..strokeWidth = 1;
    const double spacing = 30;
    // Draw grid pattern
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some accent circles
    final accentPaint =
        Paint()
          ..color = Colors.purple.withValues(alpha: 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      80,
      accentPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      100,
      accentPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.9),
      60,
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
