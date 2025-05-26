import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tambola/Custom%20Widgets/button_style.dart';
import 'dart:math';
import 'package:tambola/Login_Register%20Screens/register_screen.dart';
import 'package:tambola/Theme/app_theme.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    theme.init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme().backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned.fill(child: AnimatedBackground()),
              // Main content
              Column(
                children: [
                  SizedBox(height: theme.sp(20)),
                  const LogoWithAnimation(),
                  SizedBox(height: theme.sp(1)),
                  // Stack with ticket and play button
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: theme.sp(20),
                          child: const EnhancedHousieTicket(),
                        ),
                        Positioned(
                          bottom: theme.sp(1),
                          child: ButtonWidget(
                            label: 'Play Now',
                            icon: Icons.casino_rounded,
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // How to play button
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => const HowToPlaySheet(),
                        );
                      },
                      icon: const Icon(
                        Icons.help_outline_rounded,
                        color: Colors.white70,
                      ),
                      label: Text('How to Play', style: theme.captionStyle),
                    ),
                  ),
                  // Bottom buttons
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: theme.sp(20),
                      top: theme.sp(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimatedIconButton(
                          icon: Icons.settings_rounded,
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            showDialog(
                              context: context,
                              builder: (_) => const SettingsDialog(),
                            );
                          },
                        ),
                        AnimatedIconButton(
                          icon: Icons.leaderboard_rounded,
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                        ),
                        AnimatedIconButton(
                          icon: Icons.info_outline_rounded,
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            showAboutDialog(
                              context: context,
                              applicationName: 'Win Housie',
                              applicationLegalese: '©️ 2023 Win Housie',
                              applicationVersion: '1.0.0',
                              applicationIcon: const Icon(
                                Icons.home_rounded,
                                color: Color(0xFF9D4EDD),
                              ),
                              children: [
                                const Text(
                                  'A property trading game inspired by classic board games.',
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Enhanced Logo with Animation
class LogoWithAnimation extends StatefulWidget {
  const LogoWithAnimation({super.key});

  @override
  State<LogoWithAnimation> createState() => _LogoWithAnimationState();
}

class _LogoWithAnimationState extends State<LogoWithAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _rotateAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    return Column(
      children: [
        // Animated logo
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotateAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding: EdgeInsets.all(theme.sp(5)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF9D4EDD).withValues(alpha: 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9D4EDD).withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.casino_rounded,
                    size: theme.sp(10),
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: theme.sp(3)),
        // Title with shimmer effect
        ShimmerText(
          text: 'Win Housie',
          style: theme.headingStyle.copyWith(
            fontSize: theme.sp(8.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: theme.sp(1)),
        Text('The Ultimate Housie Game', style: theme.captionStyle),
      ],
    );
  }
}

// Shimmer Text Effect for Title
class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle style;
  const ShimmerText({super.key, required this.text, required this.style});

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Color(0xFFFFFFFF),
                Color(0xFFB19CD9),
                Color(0xFF9D4EDD),
                Color(0xFFB19CD9),
                Color(0xFFFFFFFF),
              ],
              stops: [
                0.0,
                _controller.value - 0.2 < 0 ? 0.0 : _controller.value - 0.2,
                _controller.value,
                _controller.value + 0.2 > 1 ? 1.0 : _controller.value + 0.2,
                1.0,
              ],
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
          },
          child: Text(
            widget.text,
            style: widget.style.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}

// Animated background with particles
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    // Generate random particles
    for (int i = 0; i < 50; i++) {
      _particles.add(
        Particle(
          position: Offset(random.nextDouble(), random.nextDouble()),
          size: 1.0 + random.nextDouble() * 3.0,
          speed: 0.001 + random.nextDouble() * 0.002,
          opacity: 0.1 + random.nextDouble() * 0.6,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Grid lines
        CustomPaint(painter: GridPainter(), size: Size.infinite),
        // Animated particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlesPainter(
                progress: _controller.value,
                particles: _particles,
              ),
              size: Size.infinite,
            );
          },
        ),
      ],
    );
  }
}

// Particle class for background animation
class Particle {
  Offset position;
  double size;
  double speed;
  double opacity;
  Particle({
    required this.position,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

// Particles painter
class ParticlesPainter extends CustomPainter {
  final double progress;
  final List<Particle> particles;
  ParticlesPainter({required this.progress, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Calculate position with movement
      final x =
          (particle.position.dx + progress * particle.speed * 10) %
          1.0 *
          size.width;
      final y =
          (particle.position.dy + progress * particle.speed * 5) %
          1.0 *
          size.height;
      // Pulse effect
      final pulseOpacity =
          particle.opacity *
          (0.6 + 0.4 * sin(progress * 2 * pi + particle.position.dx * 10));
      final paint =
          Paint()
            ..color = const Color(0xFFB19CD9).withValues(alpha: pulseOpacity)
            ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), particle.size, paint);
      // Add glow effect
      final glowPaint =
          Paint()
            ..color = const Color(
              0xFF9D4EDD,
            ).withValues(alpha: pulseOpacity * 0.3)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(x, y), particle.size * 1.5, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Enhanced Housie Ticket with better animations and modern design
class EnhancedHousieTicket extends StatefulWidget {
  const EnhancedHousieTicket({super.key});

  @override
  State<EnhancedHousieTicket> createState() => _EnhancedHousieTicketState();
}

class _EnhancedHousieTicketState extends State<EnhancedHousieTicket>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _markAnimController;
  final List<int> _markedCells = [];
  final Random random = Random();
  late final List<List<int?>> ticketNumbers;

  @override
  void initState() {
    super.initState();
    // Generate ticket data
    ticketNumbers = _generateTicket();
    // Setup animation controllers
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _markAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    // Schedule a random number to be marked every 2 seconds
    Future.delayed(const Duration(seconds: 1), _markRandomNumber);
  }

  void _markRandomNumber() {
    if (!mounted) return;

    if (_markedCells.length < 8) {
      // Find all available numbers
      List<int> availableIndices = [];
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 9; col++) {
          if (ticketNumbers[row][col] != null) {
            int index = row * 9 + col;
            if (!_markedCells.contains(index)) {
              availableIndices.add(index);
            }
          }
        }
      }
      if (availableIndices.isNotEmpty) {
        // Pick a random number to mark
        int randomIndex =
            availableIndices[random.nextInt(availableIndices.length)];
        setState(() {
          _markedCells.add(randomIndex);
        });
        // Animate the marking
        _markAnimController.reset();
        _markAnimController.forward();
        // Schedule next marking
        Future.delayed(const Duration(seconds: 2), _markRandomNumber);
      }
    }
  }

  // Generate ticket numbers similar to tambola/housie rules
  List<List<int?>> _generateTicket() {
    List<List<int?>> ticket = List.generate(3, (_) => List.filled(9, null));
    // Each row has 5 numbers and 4 empty spaces
    for (int row = 0; row < 3; row++) {
      List<int> indices = List.generate(9, (i) => i);
      indices.shuffle(random);
      List<int> selectedIndices = indices.sublist(0, 5);
      selectedIndices.sort();
      for (int idx in selectedIndices) {
        // Numbers in each column follow a pattern (1-9, 10-19, 20-29, etc.)
        int minVal = idx * 10 + 1;
        int maxVal = idx == 8 ? 90 : (idx + 1) * 10;
        ticket[row][idx] = minVal + random.nextInt(maxVal - minVal);
      }
    }
    return ticket;
  }

  @override
  void dispose() {
    // Cancel any pending futures or timers here if needed
    _pulseController.dispose();
    _rotateController.dispose();
    _markAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AnimatedBuilder(
        animation: _rotateController,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(0.02 * sin(_rotateController.value * 2 * pi))
                  ..rotateY(0.02 * cos(_rotateController.value * 2 * pi)),
            child: child,
          );
        },
        child: Container(
          width: screenWidth * 0.89,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Colors.deepPurple],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9D4EDD).withValues(alpha: 0.5),
                spreadRadius: 2,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                spreadRadius: -5,
                blurRadius: 20,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ticket header with modern design
              const SizedBox(height: 15),
              // Ticket grid with modern design
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      width: 0.5,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    children: List.generate(3, (row) {
                      return TableRow(
                        children: List.generate(9, (col) {
                          final number = ticketNumbers[row][col];
                          final cellIndex = row * 9 + col;
                          final isMarked = _markedCells.contains(cellIndex);
                          return AnimatedBuilder(
                            animation: _markAnimController,
                            builder: (context, child) {
                              // Calculate animation value for this specific cell
                              double animValue = 0.0;
                              if (isMarked && _markedCells.last == cellIndex) {
                                animValue = _markAnimController.value;
                              }
                              return Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      isMarked
                                          ? const Color(0xFF9D4EDD).withValues(
                                            alpha:
                                                isMarked &&
                                                        _markedCells.last ==
                                                            cellIndex
                                                    ? 0.2 + 0.3 * animValue
                                                    : 0.3,
                                          )
                                          : Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 0.5,
                                  ),
                                ),
                                child:
                                    number == null
                                        ? null
                                        : Transform.scale(
                                          scale:
                                              isMarked &&
                                                      _markedCells.last ==
                                                          cellIndex
                                                  ? 1.0 + 0.3 * animValue
                                                  : 1.0,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // Number text
                                              Text(
                                                number.toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      isMarked
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                  color:
                                                      isMarked
                                                          ? const Color(
                                                            0xFF7B2CBF,
                                                          )
                                                          : Colors.black87,
                                                ),
                                              ),
                                              // Animated circle overlay for newly marked numbers
                                              if (isMarked &&
                                                  _markedCells.last ==
                                                      cellIndex)
                                                Opacity(
                                                  opacity: 1.0 - animValue,
                                                  child: Container(
                                                    width: 40 * animValue,
                                                    height: 40 * animValue,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFF9D4EDD,
                                                        ),
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              // Stamp effect for marked numbers
                                              if (isMarked && animValue >= 0.7)
                                                Transform.rotate(
                                                  angle: -0.2,
                                                  child: Opacity(
                                                    opacity:
                                                        isMarked &&
                                                                _markedCells
                                                                        .last ==
                                                                    cellIndex
                                                            ? animValue
                                                            : 0.8,
                                                    child: Icon(
                                                      Icons
                                                          .check_circle_outline_rounded,
                                                      color: const Color(
                                                        0xFF7B2CBF,
                                                      ),
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                              );
                            },
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Ticket footer with pattern indicators
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPatternIndicator('Early 5', Icons.filter_5_rounded),
                    _buildPatternIndicator(
                      'Top Line',
                      Icons.horizontal_rule_rounded,
                    ),
                    _buildPatternIndicator(
                      'Full House',
                      Icons.grid_view_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatternIndicator(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Animated Play Now Button

// Animated Icon Button for bottom navigation
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) => _controller.reverse());
        widget.onPressed();
      },
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  _isHovered
                      ? const Color(0xFF9D4EDD).withValues(alpha: 0.3)
                      : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow:
                  _isHovered
                      ? [
                        BoxShadow(
                          color: const Color(0xFF9D4EDD).withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                      : null,
            ),
            child: Transform.scale(
              scale: 1.0 + 0.2 * _controller.value,
              child: Icon(
                widget.icon,
                color: Colors.white.withValues(alpha: 0.9),
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Grid Painter for background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.05)
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke;

    // Draw horizontal lines
    for (int i = 0; i <= 20; i++) {
      final y = size.height * i / 20;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    for (int i = 0; i <= 20; i++) {
      final x = size.width * i / 20;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// How to Play Bottom Sheet
class HowToPlaySheet extends StatelessWidget {
  const HowToPlaySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(color: Color(0xFF9D4EDD), blurRadius: 20, spreadRadius: -5),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.casino_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              const Text(
                'How to Play Housie',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const RuleItem(
            icon: Icons.confirmation_number_rounded,
            title: 'Get Your Ticket',
            description:
                'Each player gets a ticket with random numbers arranged in a grid.',
          ),
          const RuleItem(
            icon: Icons.campaign_rounded,
            title: 'Number Calling',
            description:
                'Numbers are called out randomly. Mark them on your ticket if present.',
          ),
          const RuleItem(
            icon: Icons.grid_view_rounded,
            title: 'Winning Patterns',
            description:
                'Complete patterns like Early Five, Top Line, Middle Line, Bottom Line, or Full House.',
          ),
          const RuleItem(
            icon: Icons.celebration_rounded,
            title: 'Call Out',
            description:
                'Shout "housie!" when you complete a winning pattern to claim your prize.',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9D4EDD),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Got it!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Rule Item for How to Play
class RuleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const RuleItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF9D4EDD).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF9D4EDD), size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Settings Dialog
class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = true;
  double _volume = 0.7;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black87, Color(0xFF3A0CA3)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9D4EDD).withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SettingsSwitchTile(
              icon: Icons.volume_up_rounded,
              title: 'Sound Effects',
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
              },
            ),
            if (_soundEnabled)
              Padding(
                padding: const EdgeInsets.only(
                  left: 50,
                  right: 20,
                  top: 0,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.volume_down_rounded,
                      color: Colors.white54,
                      size: 20,
                    ),
                    Expanded(
                      child: Slider(
                        value: _volume,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                          });
                        },
                        activeColor: const Color(0xFF9D4EDD),
                        inactiveColor: Colors.white24,
                      ),
                    ),
                    const Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ],
                ),
              ),
            SettingsSwitchTile(
              icon: Icons.vibration_rounded,
              title: 'Vibration',
              value: _vibrationEnabled,
              onChanged: (value) {
                setState(() {
                  _vibrationEnabled = value;
                });
              },
            ),
            SettingsSwitchTile(
              icon: Icons.notifications_rounded,
              title: 'Notifications',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Save settings logic would go here
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9D4EDD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Switch Tile
class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF9D4EDD).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF9D4EDD), size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF9D4EDD),
            activeTrackColor: const Color(0xFF9D4EDD).withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
