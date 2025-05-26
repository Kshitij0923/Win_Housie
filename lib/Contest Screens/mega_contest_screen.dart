import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tambola/Screens/gameScreen.dart';

class MegaContestScreen extends StatefulWidget {
  final Map<String, dynamic> contest;

  const MegaContestScreen({Key? key, required this.contest}) : super(key: key);

  @override
  _MegaContestScreenState createState() => _MegaContestScreenState();
}

class _MegaContestScreenState extends State<MegaContestScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isJoining = false;

  // Sample player avatars
  final List<String> _playerAvatars = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
    'assets/avatars/avatar5.png',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _joinMegaContest() {
    setState(() {
      _isJoining = true;
    });

    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: const Color(0xFF1E1E2C),
            title: Text(
              'Confirm Entry',
              style: GoogleFonts.getFont(
                widget.contest['fontFamily'],
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You are about to join ${widget.contest['name']} mega contest for ₹${widget.contest['entryFee']}.',
                  style: GoogleFonts.getFont(
                    widget.contest['fontFamily'],
                    textStyle: TextStyle(color: Colors.grey[300]),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Prize pool: ₹${widget.contest['prizePool']}',
                  style: GoogleFonts.getFont(
                    widget.contest['fontFamily'],
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Proceed with payment?',
                  style: GoogleFonts.getFont(
                    widget.contest['fontFamily'],
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isJoining = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.getFont(
                    widget.contest['fontFamily'],
                    textStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Show payment success
                  _showPaymentSuccess();
                },
                child: Text(
                  'PAY NOW',
                  style: GoogleFonts.getFont(
                    widget.contest['fontFamily'],
                    textStyle: TextStyle(
                      color: widget.contest['color'] as Color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/Animation.json',
                    width: 150,
                    height: 150,
                    repeat: false,
                    animate: true,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Payment Successful!',
                    style: GoogleFonts.getFont(
                      widget.contest['fontFamily'],
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You have successfully joined the ${widget.contest['name']} contest.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      widget.contest['fontFamily'],
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeekendHousieGameScreen(),
                        ),
                      );
                      setState(() {
                        _isJoining = false;
                      });
                      // Navigate to ticket view or game screen
                      // We can add navigation logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.contest['color'] as Color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'VIEW MY TICKET',
                      style: GoogleFonts.getFont(
                        widget.contest['fontFamily'],
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              (widget.contest['color'] as Color).withOpacity(0.8),
              const Color(0xFF111827),
              const Color(0xFF1F2937),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom app bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contest['name'],
                            style: GoogleFonts.getFont(
                              widget.contest['fontFamily'],
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'MEGA CONTEST',
                            style: GoogleFonts.getFont(
                              widget.contest['fontFamily'],
                              textStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'MEGA',
                        style: GoogleFonts.getFont(
                          widget.contest['fontFamily'],
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.contest['color'] as Color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mega Contest Banner
                      _buildMegaContestBanner(),

                      const SizedBox(height: 20),

                      // Contest Details Card
                      _buildContestDetailsCard(),

                      const SizedBox(height: 20),

                      // Prize Distribution
                      _buildPrizeDistribution(),

                      const SizedBox(height: 20),

                      // Joined Players
                      _buildJoinedPlayers(),

                      const SizedBox(height: 20),

                      // Rules and Details
                      _buildRulesAndDetails(),

                      const SizedBox(height: 20),

                      // Exclusive benefits
                      _buildExclusiveBenefits(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Bottom action bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ENTRY FEE',
                            style: GoogleFonts.getFont(
                              widget.contest['fontFamily'],
                              textStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${widget.contest['entryFee']}',
                            style: GoogleFonts.getFont(
                              widget.contest['fontFamily'],
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      child: ElevatedButton(
                        onPressed: _isJoining ? null : _joinMegaContest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.contest['color'] as Color,
                          disabledBackgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            _isJoining
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  'JOIN NOW',
                                  style: GoogleFonts.getFont(
                                    widget.contest['fontFamily'],
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                      ),
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

  Widget _buildMegaContestBanner() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (widget.contest['color'] as Color).withOpacity(0.7),
            (widget.contest['color'] as Color).withOpacity(0.3),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.contest['color'] as Color).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.trophy,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'EXCLUSIVE MEGA CONTEST',
                      style: GoogleFonts.getFont(
                        widget.contest['fontFamily'],
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '₹${widget.contest['prizePool']}',
                  style: GoogleFonts.getFont(
                    widget.contest['fontFamily'],
                    textStyle: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PRIZE POOL',
                  style: GoogleFonts.getFont(
                    widget.contest['fontFamily'],
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.clock,
                      color: Colors.white.withOpacity(0.8),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Today, ${widget.contest['startTime']}',
                      style: GoogleFonts.getFont(
                        widget.contest['fontFamily'],
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContestDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildDetailItem(
                'ENTRY FEE',
                '₹${widget.contest['entryFee']}',
                FontAwesomeIcons.ticket,
              ),
              const SizedBox(width: 20),
              _buildDetailItem(
                'MAX PLAYERS',
                '${widget.contest['maxPlayers']}',
                FontAwesomeIcons.users,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDetailItem(
                'JOINED',
                '${widget.contest['playersJoined']}',
                FontAwesomeIcons.userCheck,
              ),
              const SizedBox(width: 20),
              _buildDetailItem(
                'SLOTS LEFT',
                '${widget.contest['maxPlayers'] - widget.contest['playersJoined']}',
                FontAwesomeIcons.doorOpen,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Players progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.contest['playersJoined']}/${widget.contest['maxPlayers']} JOINED',
                    style: GoogleFonts.getFont(
                      widget.contest['fontFamily'],
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Text(
                    '${((widget.contest['playersJoined'] as int) / (widget.contest['maxPlayers'] as int) * 100).toInt()}%',
                    style: GoogleFonts.getFont(
                      widget.contest['fontFamily'],
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value:
                      (widget.contest['playersJoined'] as int) /
                      (widget.contest['maxPlayers'] as int),
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.contest['color'] as Color,
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: (widget.contest['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: widget.contest['color'] as Color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    widget.contest['fontFamily'],
                    textStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[400],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.getFont(
                    widget.contest['fontFamily'],
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizeDistribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRIZE DISTRIBUTION',
          style: GoogleFonts.getFont(
            widget.contest['fontFamily'],
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              ...List.generate(widget.contest['prizes'].length, (index) {
                final prize =
                    widget.contest['prizes'][index] as Map<String, dynamic>;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border:
                        index < widget.contest['prizes'].length - 1
                            ? Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                            )
                            : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getPrizeColor(index).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: _getPrizeIcon(index)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          prize['name'] as String,
                          style: GoogleFonts.getFont(
                            widget.contest['fontFamily'],
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${prize['amount']}',
                            style: GoogleFonts.getFont(
                              widget.contest['fontFamily'],
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getPrizeColor(index),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (prize.containsKey('winners') &&
                              prize['winners'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${prize['winners']} Winner${(prize['winners'] as int) > 1 ? 's' : ''}',
                                style: GoogleFonts.getFont(
                                  widget.contest['fontFamily'],
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Color _getPrizeColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.greenAccent;
      case 3:
        return Colors.purpleAccent;
      default:
        return widget.contest['color'] as Color;
    }
  }

  Widget _getPrizeIcon(int index) {
    switch (index) {
      case 0:
        return Icon(FontAwesomeIcons.trophy, color: Colors.amber, size: 18);
      case 1:
        return Icon(FontAwesomeIcons.medal, color: Colors.blueAccent, size: 18);
      case 2:
        return Icon(
          FontAwesomeIcons.award,
          color: Colors.greenAccent,
          size: 18,
        );
      case 3:
        return Icon(
          FontAwesomeIcons.certificate,
          color: Colors.purpleAccent,
          size: 18,
        );
      default:
        return Icon(
          FontAwesomeIcons.star,
          color: widget.contest['color'] as Color,
          size: 18,
        );
    }
  }

  Widget _buildJoinedPlayers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PLAYERS JOINED',
          style: GoogleFonts.getFont(
            widget.contest['fontFamily'],
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(5, (index) {
                    return Container(
                      margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[800],
                        child: Icon(
                          FontAwesomeIcons.user,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: (widget.contest['color'] as Color).withOpacity(
                        0.3,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '+${widget.contest['playersJoined'] - 5}',
                        style: GoogleFonts.getFont(
                          widget.contest['fontFamily'],
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.contest['color'] as Color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.users,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.contest['playersJoined']} players have already joined',
                    style: GoogleFonts.getFont(
                      widget.contest['fontFamily'],
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Only ${widget.contest['maxPlayers'] - widget.contest['playersJoined']} spots left!',
                style: GoogleFonts.getFont(
                  widget.contest['fontFamily'],
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.contest['color'] as Color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRulesAndDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONTEST RULES',
          style: GoogleFonts.getFont(
            widget.contest['fontFamily'],
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              _buildRuleItem(
                'Game Format',
                'Single elimination tournament format',
                FontAwesomeIcons.gamepad,
              ),
              const SizedBox(height: 16),
              _buildRuleItem(
                'Contest Duration',
                '${widget.contest['duration']} hours from start time',
                FontAwesomeIcons.hourglassHalf,
              ),
              const SizedBox(height: 16),
              _buildRuleItem(
                'Entry Restrictions',
                'Maximum of 3 entries per user',
                FontAwesomeIcons.ban,
              ),
              const SizedBox(height: 16),
              _buildRuleItem(
                'Prize Distribution',
                'Prizes credited within 24 hours of contest completion',
                FontAwesomeIcons.moneyBill,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Navigate to detailed rules
                  // Add navigation logic here
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'VIEW COMPLETE RULES',
                      style: GoogleFonts.getFont(
                        widget.contest['fontFamily'],
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.contest['color'] as Color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRuleItem(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.white.withOpacity(0.8)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.getFont(
                  widget.contest['fontFamily'],
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.getFont(
                  widget.contest['fontFamily'],
                  textStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExclusiveBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXCLUSIVE BENEFITS',
          style: GoogleFonts.getFont(
            widget.contest['fontFamily'],
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              _buildBenefitItem(
                'Premium Leaderboard',
                'Exclusive leaderboard with real-time rank tracking',
                FontAwesomeIcons.chartLine,
              ),
              const SizedBox(height: 16),
              _buildBenefitItem(
                'Expert Analysis',
                'Access to professional game analysis and insights',
                FontAwesomeIcons.lightbulb,
              ),
              const SizedBox(height: 16),
              _buildBenefitItem(
                'Social Media Recognition',
                'Top performers featured on our social media',
                FontAwesomeIcons.shareAlt,
              ),
              const SizedBox(height: 16),
              _buildBenefitItem(
                'Priority Support',
                'Dedicated customer support for mega contest participants',
                FontAwesomeIcons.headset,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: (widget.contest['color'] as Color).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: widget.contest['color'] as Color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.getFont(
                  widget.contest['fontFamily'],
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.getFont(
                  widget.contest['fontFamily'],
                  textStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// This is how you can use this screen with sample data
/* 
final Map<String, dynamic> sampleContest = {
  'name': 'Super League',
  'fontFamily': 'Poppins',
  'color': Colors.purple,
  'prizePool': '1,00,000',
  'entryFee': '49',
  'startTime': '7:30 PM',
  'maxPlayers': 10000,
  'playersJoined': 7356,
  'duration': '3',
  'prizes': [
    {
      'name': 'First Prize',
      'amount': '25,000',
      'winners': 1,
    },
    {
      'name': 'Second Prize',
      'amount': '15,000',
      'winners': 1,
    },
    {
      'name': 'Third Prize',
      'amount': '10,000',
      'winners': 1,
    },
    {
      'name': 'Top 10',
      'amount': '5,000',
      'winners': 7,
    },
    {
      'name': 'Top 100',
      'amount': '500',
      'winners': 90,
    },
  ],
};

// Usage
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => MegaContestScreen(
      contest: sampleContest,
    ),
  ),
);
*/
