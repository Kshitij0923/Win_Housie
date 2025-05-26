import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HousieContestScreen extends StatefulWidget {
  const HousieContestScreen({super.key});

  @override
  HousieContestScreenState createState() => HousieContestScreenState();
}

class HousieContestScreenState extends State<HousieContestScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Selected contest
  String _selectedContest = 'Standard Game';

  // Available contests
  final List<Map<String, dynamic>> _contests = [
    {
      'id': 'contest_free',
      'name': 'Free Flexible Pool',
      'entryFee': 50,
      'prizePool': 250,
      'startTime': '7:00 PM',
      'playersJoined': 32,
      'maxPlayers': 100,
      'color': Colors.teal,
      'isPopular': false,
      'prizes': [
        {'name': 'Full Housie', 'amount': 100},
        {'name': 'First Line', 'amount': 50},
        {'name': 'Middle Line', 'amount': 50},
        {'name': 'Last Line', 'amount': 50},
      ],
    },

    {
      'id': 'contest_premium',
      'name': 'Premium Flexible Pool',
      'entryFee': 4000,
      'prizePool': 150000, // 1.5 Lakhs
      'startTime': '9:00 PM',
      'playersJoined': 18,
      'maxPlayers': 50,
      'color': Colors.purple,
      'isPopular': true,
      'prizes': [
        {'name': 'Full Housie', 'amount': 75000},
        {'name': 'First Line', 'amount': 10000},
        {'name': 'Middle Line', 'amount': 10000},
        {'name': 'Last Line', 'amount': 10000},
        {'name': 'Twin Lines (1 & 2)', 'amount': 3000},
        {'name': 'Twin Lines (2 & 3)', 'amount': 3000},
        {'name': 'Twin Lines (3 & 1)', 'amount': 3000},
        {'name': 'Early Five', 'amount': 1000},
        {'name': 'Early Ten', 'amount': 2000},
        {'name': 'Pyramid', 'amount': 2000},
        {'name': 'Reverse Pyramid', 'amount': 2000},
        {'name': 'Corner', 'amount': 1000},
        {'name': '143 (I love You) First', 'amount': 2000, 'winners': 2},
        {'name': 'Anda-Danda First', 'amount': 2000, 'winners': 2},
        {'name': 'Odd Number First', 'amount': 2000, 'winners': 2},
        {'name': 'Even Number First', 'amount': 2000, 'winners': 2},
        {'name': '1 from Each Line First', 'amount': 2000, 'winners': 2},
        {'name': 'Smallest Five First', 'amount': 2000, 'winners': 2},
        {'name': 'Bigger Five First', 'amount': 2000, 'winners': 2},
        {
          'name': '1 Balance in Full Housie',
          'amount': 14000,
          'specialRule': 'All Players Time of Complete Full Housie',
        },
      ],
    },
  ];

  // Selected contest for details view
  Map<String, dynamic>? _selectedContestDetails;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Default selected contest
    _selectedContestDetails = _contests[0];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _viewContestDetails(Map<String, dynamic> contest) {
    if (!mounted) return;

    setState(() {
      _selectedContestDetails = contest;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      builder:
          (bottomSheetContext) =>
              _buildContestDetailsSheet(bottomSheetContext, contest),
    );
  }

  void _joinContest(Map<String, dynamic> contest) {
    if (!mounted) return;

    // Close details sheet if open
    Navigator.of(context).pop();

    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: const Color(0xFF1E1E2C),
            title: const Text(
              'Confirm Entry',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You are about to join ${contest['name']} contest for ₹${contest['entryFee']}.',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Proceed with payment?',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigator.of(dialogContext).pop();
                  if (mounted) {
                    _showPaymentSuccess(contest);
                  }
                },
                child: Text(
                  'PAY NOW',
                  style: TextStyle(
                    color: contest['color'],
                    fontWeight: FontWeight.bold,
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF111827), // gray-900
              Color(0xFF312E81), // indigo-900
              Color(0xFF581C87), // purple-900
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar with back button and title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Housie Contests',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Join a contest and play with others',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[600],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '₹10,000',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
                      // Contest type selection
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.purple[800]!.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SELECT GAME TYPE',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.purple[500]!.withOpacity(0.5),
                                ),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedContest,
                                isExpanded: true,
                                dropdownColor: const Color(0xFF1E1E2C),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.purple,
                                ),
                                underline: Container(),
                                style: const TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedContest = newValue;
                                    });
                                  }
                                },
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: 'Standard Game',
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text('Standard Game'),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'Quick Play',
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text('Quick Play'),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'Tournament',
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text('Tournament'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.purple[300],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Join a contest 5 minutes before it starts to secure your spot.',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
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

                      // Game Schedule Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigo.withOpacity(0.8),
                              Colors.blue.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.schedule,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'UPCOMING GAMES',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Games at 7:00 PM & 9:00 PM',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Join now to secure your spot!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
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
                      const Text(
                        'AVAILABLE CONTESTS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Contest cards
                      ...List.generate(_contests.length, (index) {
                        final contest = _contests[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (contest['color'] as Color).withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Contest header
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      (contest['color'] as Color).withOpacity(
                                        0.8,
                                      ),
                                      (contest['color'] as Color).withOpacity(
                                        0.6,
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          contest['name'] as String,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.white.withOpacity(
                                                0.8,
                                              ),
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Today, ${contest['startTime']}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white.withOpacity(
                                                  0.8,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (contest['isPopular'] as bool)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          'POPULAR',
                                          style: TextStyle(
                                            color: contest['color'] as Color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Contest content
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    // Prize pool section
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'PRIZE POOL',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '₹${contest['prizePool']}',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              'ENTRY FEE',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '₹${contest['entryFee']}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    // Progress bar for player count
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${contest['playersJoined']} / ${contest['maxPlayers']} Players',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            Text(
                                              '${((contest['playersJoined'] as int) / (contest['maxPlayers'] as int) * 100).toInt()}% Full',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Stack(
                                          children: [
                                            // Background
                                            Container(
                                              height: 8,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            // Progress
                                            Container(
                                              height: 8,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  ((contest['playersJoined']
                                                          as int) /
                                                      (contest['maxPlayers']
                                                          as int)) *
                                                  0.75,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    contest['color'] as Color,
                                                    (contest['color'] as Color)
                                                        .withOpacity(0.7),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    // Prize preview
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'TOP PRIZES',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            _buildPrizeItem(
                                              title: 'Full Housie',
                                              amount:
                                                  (contest['prizes'][0]['amount']
                                                          as int)
                                                      .toString(),
                                              color: contest['color'] as Color,
                                            ),
                                            const SizedBox(width: 8),
                                            _buildPrizeItem(
                                              title: 'First Line',
                                              amount:
                                                  (contest['prizes'][1]['amount']
                                                          as int)
                                                      .toString(),
                                              color: contest['color'] as Color,
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800]!
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '+${(contest['prizes'] as List).length - 2}',
                                                    style: TextStyle(
                                                      color:
                                                          contest['color']
                                                              as Color,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'more',
                                                    style: TextStyle(
                                                      color: Colors.grey[400],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    // Action buttons
                                    Row(
                                      children: [
                                        // View details button
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed:
                                                () => _viewContestDetails(
                                                  contest,
                                                ),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: (contest['color']
                                                        as Color)
                                                    .withOpacity(0.7),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                            ),
                                            child: const Text(
                                              'VIEW DETAILS',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Join contest button
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed:
                                                () => _joinContest(contest),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  contest['color'] as Color,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                            ),
                                            child: const Text(
                                              'JOIN CONTEST',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
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

                      const SizedBox(height: 20),

                      // How to play section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.blue[800]!.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'HOW TO PLAY',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildHowToPlayStep(
                              number: '1',
                              title: 'Join a Contest',
                              description:
                                  'Select a contest that suits your budget and preferences.',
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 16),
                            _buildHowToPlayStep(
                              number: '2',
                              title: 'Get Your Tickets',
                              description:
                                  'One ticket is automatically generated when you join a contest.',
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 16),
                            _buildHowToPlayStep(
                              number: '3',
                              title: 'Play the Game',
                              description:
                                  'Mark numbers on your ticket as they are called out during the game.',
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 16),
                            _buildHowToPlayStep(
                              number: '4',
                              title: 'Win Prizes',
                              description:
                                  'Claim your prize when you complete any winning pattern!',
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
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
    required String title,
    required String amount,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[400], fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '₹$amount',
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowToPlayStep({
    required String number,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
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
            color: Color(0xFF1E1E2C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Draggable handle
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),

              // Contest header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (contest['color'] as Color).withOpacity(0.8),
                      (contest['color'] as Color).withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
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
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.white.withOpacity(0.8),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Today, ${contest['startTime']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'ENTRY FEE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${contest['entryFee']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Contest details
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Prize pool and players info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(
                          icon: Icons.emoji_events,
                          title: 'PRIZE POOL',
                          value: '₹${contest['prizePool']}',
                          color: contest['color'] as Color,
                        ),
                        _buildInfoCard(
                          icon: Icons.people,
                          title: 'PLAYERS',
                          value:
                              '${contest['playersJoined']}/${contest['maxPlayers']}',
                          color: contest['color'] as Color,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Prize distribution
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PRIZE DISTRIBUTION',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Prize list
                        ...List.generate((contest['prizes'] as List).length, (
                          index,
                        ) {
                          final prize = contest['prizes'][index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: (contest['color'] as Color).withOpacity(
                                  0.3,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: (contest['color'] as Color)
                                            .withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: contest['color'] as Color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prize['name'] as String,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        if (prize.containsKey('specialRule'))
                                          Text(
                                            prize['specialRule'] as String,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        if (prize.containsKey('winners') &&
                                            (prize['winners'] as int) > 1)
                                          Text(
                                            '${prize['winners']} winners',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  '₹${prize['amount']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: contest['color'] as Color,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Rules
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RULES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildRuleItem(
                          icon: Icons.info_outline,
                          text:
                              'The game will start at exactly ${contest['startTime']}. Join 5 minutes before to secure your spot.',
                        ),
                        _buildRuleItem(
                          icon: Icons.confirmation_number_outlined,
                          text:
                              'One ticket will be automatically generated when you join the contest.',
                        ),
                        _buildRuleItem(
                          icon: Icons.payments_outlined,
                          text:
                              'Prizes will be credited to your wallet immediately after the game ends.',
                        ),
                        _buildRuleItem(
                          icon: Icons.verified_user_outlined,
                          text:
                              'Fair play is strictly enforced. Any form of cheating will result in disqualification.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Join button
                    ElevatedButton(
                      onPressed: () => _joinContest(contest),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: contest['color'] as Color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'JOIN CONTEST',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[400], size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[300]),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccess(Map<String, dynamic> contest) {
    if (!mounted) return; // Check if widget is still mounted before proceeding

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => Dialog(
            // Use dialogContext instead of context
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success animation
                  Lottie.network(
                    'https://assets10.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                    height: 150,
                    repeat: false,
                    controller: _animationController,
                    onLoaded: (composition) {
                      if (mounted) {
                        // Check if still mounted before updating controller
                        _animationController
                          ..duration = composition.duration
                          ..forward();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You have successfully joined ${contest['name']} contest.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Get ready for an exciting game at ${contest['startTime']}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        dialogContext,
                      ).pop(); // Use dialogContext here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
