import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tambola/Theme/app_theme.dart';

class StandardFlexiblePoolScreen extends StatefulWidget {
  const StandardFlexiblePoolScreen({super.key});

  @override
  StandardFlexiblePoolScreenState createState() =>
      StandardFlexiblePoolScreenState();
}

class StandardFlexiblePoolScreenState extends State<StandardFlexiblePoolScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Map<String, dynamic>> _standardContests = [
    {
      'id': 'standard_contest_1',
      'name': '₹4000 Standard Flexible Pool',
      'entryFee': 50,
      'prizePool': 150000, // 1.5 Lakhs
      'startTime': '7:00 PM',
      'playersJoined': 45,
      'maxPlayers': 100,
      'color': const Color(0xFF4CAF50), // Green
      'iconColor': const Color(0xFF8BC34A), // Light Green
      'fontFamily': 'Poppins',
      'isPopular': false,
      'prizes': [
        {'name': 'Full Housie', 'amount': 75000, 'winners': 1, 'cap': 75000},
        {'name': 'First Line', 'amount': 10000, 'winners': 1, 'cap': 10000},
        {'name': 'Middle Line', 'amount': 10000, 'winners': 1, 'cap': 10000},
        {'name': 'Last Line', 'amount': 10000, 'winners': 1, 'cap': 10000},
        {
          'name': 'Twin Lines (1 & 2)',
          'amount': 3000,
          'winners': 1,
          'cap': 3000,
        },
        {
          'name': 'Twin Lines (2 & 3)',
          'amount': 3000,
          'winners': 1,
          'cap': 3000,
        },
        {
          'name': 'Twin Lines (3 & 1)',
          'amount': 3000,
          'winners': 1,
          'cap': 3000,
        },
        {'name': 'Early Five', 'amount': 1000, 'winners': 1, 'cap': 1000},
        {'name': 'Early Ten', 'amount': 2000, 'winners': 1, 'cap': 2000},
        {'name': 'Pyramid', 'amount': 2000, 'winners': 1, 'cap': 2000},
        {'name': 'Reverse Pyramid', 'amount': 2000, 'winners': 1, 'cap': 2000},
        {'name': 'Corner', 'amount': 1000, 'winners': 1, 'cap': 1000},
        {
          'name': '143 (I love You) First',
          'amount': 1000,
          'winners': 2,
          'cap': 2000,
        },
        {'name': 'Anda-Danda First', 'amount': 1000, 'winners': 2, 'cap': 2000},
        {'name': 'Odd Number First', 'amount': 1000, 'winners': 2, 'cap': 2000},
        {
          'name': 'Even Number First',
          'amount': 1000,
          'winners': 2,
          'cap': 2000,
        },
        {
          'name': '1 from Each Line First',
          'amount': 1000,
          'winners': 2,
          'cap': 2000,
        },
        {
          'name': 'Smallest Five First',
          'amount': 1000,
          'winners': 2,
          'cap': 2000,
        },
        {
          'name': 'Bigger Five First',
          'amount': 1000,
          'winners': 2,
          'cap': 2000,
        },
        {
          'name': '1 Balance in Full Housie',
          'amount': 14000,
          'winners': null,
          'specialRule':
              'All Players Time of Complete Full Housie (Distribute equally)',
        },
      ],
    },
    {
      'id': 'standard_contest_2',
      'name': '₹100000 Standard Flexible Pool',
      'entryFee': 49,
      'prizePool': 3400000, // 34 Lakhs
      'startTime': '8:30 PM',
      'playersJoined': 3200,
      'maxPlayers': 5000,
      'color': const Color(0xFF2196F3), // Blue
      'iconColor': const Color(0xFF03A9F4), // Light Blue
      'fontFamily': 'Montserrat',
      'isPopular': true,
      'prizes': [
        {
          'name': 'Full Housie',
          'amount': 2500000,
          'winners': 1,
          'cap': 2500000,
        },
        {'name': 'First Line', 'amount': 50000, 'winners': 1, 'cap': 50000},
        {'name': 'Middle Line', 'amount': 50000, 'winners': 1, 'cap': 50000},
        {'name': 'Last Line', 'amount': 50000, 'winners': 1, 'cap': 50000},
        {
          'name': 'Twin Lines (1 & 2)',
          'amount': 25000,
          'winners': 1,
          'cap': 25000,
        },
        {
          'name': 'Twin Lines (2 & 3)',
          'amount': 25000,
          'winners': 1,
          'cap': 25000,
        },
        {
          'name': 'Twin Lines (3 & 1)',
          'amount': 25000,
          'winners': 1,
          'cap': 25000,
        },
        {'name': 'Early Five', 'amount': 10000, 'winners': 1, 'cap': 10000},
        {'name': 'Early Ten', 'amount': 15000, 'winners': 1, 'cap': 15000},
        {
          'name': '143 (I love You) First',
          'amount': 2500,
          'winners': 3,
          'cap': 7500,
        },
        {'name': 'Anda-Danda First', 'amount': 2500, 'winners': 3, 'cap': 7500},
        {'name': 'Odd Number First', 'amount': 2500, 'winners': 3, 'cap': 7500},
        {
          'name': 'Even Number First',
          'amount': 2500,
          'winners': 3,
          'cap': 7500,
        },
        {
          'name': '1 from Each Line First',
          'amount': 2500,
          'winners': 3,
          'cap': 7500,
        },
        {
          'name': 'Smallest Five First',
          'amount': 2500,
          'winners': 3,
          'cap': 7500,
        },
        {
          'name': 'Bigger Five First',
          'amount': 2500,
          'winners': 3,
          'cap': 7500,
        },
        {
          'name': 'Unlucky 1 (in First 10 number) First',
          'amount': 2500,
          'winners': 3,
          'cap': 7500,
        },
        {'name': 'Above 50 First', 'amount': 2500, 'winners': 3, 'cap': 7500},
        {'name': 'Below 50 First', 'amount': 2500, 'winners': 3, 'cap': 7500},
        {'name': 'T First', 'amount': 2500, 'winners': 3, 'cap': 7500},
        {'name': 'H First', 'amount': 2500, 'winners': 3, 'cap': 7500},
        {
          'name': '1 Balance in Full Housie',
          'amount': 350000,
          'winners': null,
          'specialRule':
              'All Players Time of Complete Full Housie (Distribute equally)',
        },
        {
          'name': '2 Balance in Full Housie',
          'amount': 210000,
          'winners': null,
          'specialRule':
              'All Players Time of Complete Full Housie (Distribute equally)',
        },
      ],
    },
    {
      'id': 'standard_contest_3',
      'name': '₹2000 Standard Flexible Pool',
      'entryFee': 30,
      'prizePool': 38000, // 38 Thousand
      'startTime': '9:30 PM',
      'playersJoined': 850,
      'maxPlayers': 1500,
      'color': const Color(0xFFFF9800), // Orange
      'iconColor': const Color(0xFFFFB74D), // Light Orange
      'fontFamily': 'Raleway',
      'isPopular': false,
      'prizes': [
        {'name': 'Full Housie', 'amount': 15000, 'winners': 1, 'cap': 15000},
        {'name': 'First Line', 'amount': 3000, 'winners': 1, 'cap': 3000},
        {'name': 'Middle Line', 'amount': 3000, 'winners': 1, 'cap': 3000},
        {'name': 'Last Line', 'amount': 3000, 'winners': 1, 'cap': 3000},
        {
          'name': 'Twin Lines (1 & 2)',
          'amount': 1000,
          'winners': 1,
          'cap': 1000,
        },
        {
          'name': 'Twin Lines (2 & 3)',
          'amount': 1000,
          'winners': 1,
          'cap': 1000,
        },
        {
          'name': 'Twin Lines (3 & 1)',
          'amount': 1000,
          'winners': 1,
          'cap': 1000,
        },
        {'name': 'Early Five', 'amount': 500, 'winners': 1, 'cap': 500},
        {'name': 'Early Ten', 'amount': 1000, 'winners': 1, 'cap': 1000},
        {'name': 'Pyramid', 'amount': 500, 'winners': 1, 'cap': 500},
        {'name': 'Reverse Pyramid', 'amount': 500, 'winners': 1, 'cap': 500},
        {'name': '143 (I love You)', 'amount': 500, 'winners': 1, 'cap': 500},
        {'name': 'Anda-Danda', 'amount': 500, 'winners': 1, 'cap': 500},
        {'name': 'Odd Number', 'amount': 500, 'winners': 1, 'cap': 500},
        {'name': 'Even Number', 'amount': 500, 'winners': 1, 'cap': 500},
        {'name': '1 from Each Line', 'amount': 500, 'winners': 1, 'cap': 500},
        {'name': 'Smallest Five', 'amount': 500, 'winners': 1, 'cap': 500},
        {'name': 'Bigger Five', 'amount': 500, 'winners': 1, 'cap': 500},
        {
          'name': '1 Balance in Full Housie',
          'amount': 5000,
          'winners': null,
          'specialRule':
              'All Players Time of Complete Full Housie (Distribute equally)',
        },
      ],
    },
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

  void _viewContestDetails(Map<String, dynamic> contest, int index) {
    setState(() {
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) => _buildContestDetailsSheet(context, contest),
    );
  }

  void _joinContest(Map<String, dynamic> contest) {
    Navigator.of(context).pop(); // Close details sheet if open

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
                contest['fontFamily'],
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
                  'You are about to join ${contest['name']} contest for ₹${contest['entryFee']}.',
                  style: GoogleFonts.getFont(
                    contest['fontFamily'],
                    textStyle: TextStyle(color: Colors.grey[300]),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Proceed with payment?',
                  style: GoogleFonts.getFont(
                    contest['fontFamily'],
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.getFont(
                    contest['fontFamily'],
                    textStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Show payment success
                  _showPaymentSuccess(contest);
                },
                child: Text(
                  'PAY NOW',
                  style: GoogleFonts.getFont(
                    contest['fontFamily'],
                    textStyle: TextStyle(
                      color: contest['color'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme().createAppBar(
        title: 'Standard Flexible Pool',
        titleStyle: const TextStyle(fontSize: 22),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF111827), // gray-900
              Color(0xFF1F2937), // gray-800
              Color(0xFF1E293B), // slate-800
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main content - Wrapped in Expanded to take all available space
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Game Schedule Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigo.withValues(alpha: 0.8),
                              Colors.blueGrey.withValues(alpha: 0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                FontAwesomeIcons.trophy,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'STANDARD FLEXIBLE POOLS',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Prize pools up to ₹34 Lakhs!',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Multiple winning patterns. More chances to win!',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Available contests header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              FontAwesomeIcons.layerGroup,
                              color: Colors.deepPurple,
                              size: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AVAILABLE CONTESTS',
                            style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Contest cards
                      ...List.generate(_standardContests.length, (index) {
                        final contest = _standardContests[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                (contest['color'] as Color).withValues(
                                  alpha: 0.15,
                                ),
                                Colors.black.withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (contest['color'] as Color).withValues(
                                alpha: 0.5,
                              ),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Contest header with gradient
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      (contest['color'] as Color).withValues(
                                        alpha: 0.8,
                                      ),
                                      (contest['color'] as Color).withValues(
                                        alpha: 0.4,
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            contest['name'] as String,
                                            style: GoogleFonts.getFont(
                                              contest['fontFamily'],
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.clock,
                                                color: Colors.white.withValues(
                                                  alpha: 0.9,
                                                ),
                                                size: 10,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Today, ${contest['startTime']}',
                                                style: GoogleFonts.getFont(
                                                  contest['fontFamily'],
                                                  textStyle: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (contest['isPopular'])
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.local_fire_department,
                                              color: Colors.orange,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              'POPULAR',
                                              style: GoogleFonts.getFont(
                                                contest['fontFamily'],
                                                textStyle: const TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Contest details with shadow border
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Prize pool and entry fee
                                    Row(
                                      children: [
                                        // Prize pool card
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.black.withValues(
                                                    alpha: 0.5,
                                                  ),
                                                  Colors.black.withValues(
                                                    alpha: 0.3,
                                                  ),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: (contest['color']
                                                        as Color)
                                                    .withValues(alpha: 0.3),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'PRIZE POOL',
                                                  style: GoogleFonts.getFont(
                                                    contest['fontFamily'],
                                                    textStyle: TextStyle(
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[400],
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  _formatCurrency(
                                                    contest['prizePool'],
                                                  ),
                                                  style: GoogleFonts.getFont(
                                                    contest['fontFamily'],
                                                    textStyle: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          contest['color']
                                                              as Color,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Entry fee card
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.black.withValues(
                                                    alpha: 0.5,
                                                  ),
                                                  Colors.black.withValues(
                                                    alpha: 0.3,
                                                  ),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey[800]!,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ENTRY FEE',
                                                  style: GoogleFonts.getFont(
                                                    contest['fontFamily'],
                                                    textStyle: TextStyle(
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[400],
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '₹${contest['entryFee']}',
                                                  style: GoogleFonts.getFont(
                                                    contest['fontFamily'],
                                                    textStyle: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    // Players progress
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${contest['playersJoined']}/${contest['maxPlayers']} PLAYERS',
                                              style: GoogleFonts.getFont(
                                                contest['fontFamily'],
                                                textStyle: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.grey[400],
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${((contest['playersJoined'] as int) / (contest['maxPlayers'] as int) * 100).toInt()}% FULL',
                                              style: GoogleFonts.getFont(
                                                contest['fontFamily'],
                                                textStyle: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.grey[400],
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: LinearProgressIndicator(
                                            value:
                                                (contest['playersJoined']
                                                    as int) /
                                                (contest['maxPlayers'] as int),
                                            backgroundColor: Colors.grey[800],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  contest['color'] as Color,
                                                ),
                                            minHeight: 6,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    // Prize highlights
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            (contest['color'] as Color)
                                                .withValues(alpha: 0.15),
                                            (contest['color'] as Color)
                                                .withValues(alpha: 0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: (contest['color'] as Color)
                                              .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'PRIZE HIGHLIGHTS',
                                            style: GoogleFonts.getFont(
                                              contest['fontFamily'],
                                              textStyle: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[400],
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildPrizeItem(
                                                contest: contest,
                                                title: 'Full Housie',
                                                amount:
                                                    contest['prizes'][0]['amount'],
                                              ),
                                              _buildPrizeItem(
                                                contest: contest,
                                                title: 'First Line',
                                                amount:
                                                    contest['prizes'][1]['amount'],
                                              ),
                                              _buildPrizeItem(
                                                contest: contest,
                                                title: 'Middle Line',
                                                amount:
                                                    contest['prizes'][2]['amount'],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // Action buttons
                                    Row(
                                      children: [
                                        // View Details button
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed:
                                                () => _viewContestDetails(
                                                  contest,
                                                  index,
                                                ),
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              side: BorderSide(
                                                color:
                                                    contest['color'] as Color,
                                                width: 1.5,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              'VIEW DETAILS',
                                              style: GoogleFonts.getFont(
                                                contest['fontFamily'],
                                                textStyle: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      contest['color'] as Color,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Join Contest button
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed:
                                                () => _joinContest(contest),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  contest['color'] as Color,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              elevation: 3,
                                            ),
                                            child: Text(
                                              'JOIN NOW',
                                              style: GoogleFonts.getFont(
                                                contest['fontFamily'],
                                                textStyle: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
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
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrizeItem({
    required Map<String, dynamic> contest,
    required String title,
    required int amount,
  }) {
    return Column(
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.getFont(
            contest['fontFamily'],
            textStyle: TextStyle(
              fontSize: 8,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _formatCurrency(amount),
          style: GoogleFonts.getFont(
            contest['fontFamily'],
            textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: contest['color'] as Color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContestDetailsSheet(
    BuildContext context,
    Map<String, dynamic> contest,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1E1E2C), Color(0xFF2A2A3E)],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (contest['color'] as Color).withValues(alpha: 0.8),
                      (contest['color'] as Color).withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contest['name'] as String,
                            style: GoogleFonts.getFont(
                              contest['fontFamily'],
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.clock,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 12,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Today, ${contest['startTime']}',
                                style: GoogleFonts.getFont(
                                  contest['fontFamily'],
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contest stats
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              contest: contest,
                              title: 'Prize Pool',
                              value: _formatCurrency(contest['prizePool']),
                              icon: FontAwesomeIcons.trophy,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              contest: contest,
                              title: 'Entry Fee',
                              value: '₹${contest['entryFee']}',
                              icon: FontAwesomeIcons.ticket,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Players progress
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (contest['color'] as Color).withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'PLAYERS JOINED',
                                  style: GoogleFonts.getFont(
                                    contest['fontFamily'],
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400],
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${((contest['playersJoined'] as int) / (contest['maxPlayers'] as int) * 100).toInt()}% FULL',
                                  style: GoogleFonts.getFont(
                                    contest['fontFamily'],
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: contest['color'] as Color,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${contest['playersJoined']} / ${contest['maxPlayers']} players',
                              style: GoogleFonts.getFont(
                                contest['fontFamily'],
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value:
                                    (contest['playersJoined'] as int) /
                                    (contest['maxPlayers'] as int),
                                backgroundColor: Colors.grey[800],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  contest['color'] as Color,
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Prize breakdown
                      Text(
                        'PRIZE BREAKDOWN',
                        style: GoogleFonts.getFont(
                          contest['fontFamily'],
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Prize list
                      ...List.generate(contest['prizes'].length, (index) {
                        final prize = contest['prizes'][index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.black.withValues(alpha: 0.3),
                                Colors.black.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[800]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prize['name'] as String,
                                      style: GoogleFonts.getFont(
                                        contest['fontFamily'],
                                        textStyle: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (prize['specialRule'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          prize['specialRule'] as String,
                                          style: GoogleFonts.getFont(
                                            contest['fontFamily'],
                                            textStyle: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _formatCurrency(prize['amount']),
                                    style: GoogleFonts.getFont(
                                      contest['fontFamily'],
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: contest['color'] as Color,
                                      ),
                                    ),
                                  ),
                                  if (prize['winners'] != null)
                                    Text(
                                      '${prize['winners']} winner${prize['winners'] > 1 ? 's' : ''}',
                                      style: GoogleFonts.getFont(
                                        contest['fontFamily'],
                                        textStyle: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      // Join button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _joinContest(contest),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: contest['color'] as Color,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'JOIN CONTEST FOR ₹${contest['entryFee']}',
                            style: GoogleFonts.getFont(
                              contest['fontFamily'],
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required Map<String, dynamic> contest,
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withValues(alpha: 0.3),
            Colors.black.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (contest['color'] as Color).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (contest['color'] as Color).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: contest['color'] as Color, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.getFont(
                  contest['fontFamily'],
                  textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.getFont(
              contest['fontFamily'],
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccess(Map<String, dynamic> contest) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: const Color(0xFF1E1E2C),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Payment Successful!',
                  style: GoogleFonts.getFont(
                    contest['fontFamily'],
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have successfully joined ${contest['name']}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    contest['fontFamily'],
                    textStyle: TextStyle(color: Colors.grey[300]),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to game lobby or dashboard
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: contest['color'] as Color,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'GO TO LOBBY',
                      style: GoogleFonts.getFont(
                        contest['fontFamily'],
                        textStyle: const TextStyle(
                          fontSize: 14,
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
    );
  }

  String _formatCurrency(int amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)} L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹$amount';
    }
  }
}
