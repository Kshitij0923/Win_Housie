import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  MyTicketsScreenState createState() => MyTicketsScreenState();
}

class MyTicketsScreenState extends State<MyTicketsScreen>
    with SingleTickerProviderStateMixin {
  // Tab controller
  late TabController _tabController;
  // Sample upcoming games
  final List<Map<String, dynamic>> _upcomingGames = [
    {
      'id': '1001',
      'name': 'Weekend Special',
      'time': DateTime.now().add(const Duration(hours: 3)),
      'status': 'upcoming',
      'tickets': 2,
      'ticketTypes': ['Basic', 'Premium'],
      'ticketNumbers': ['#1234', '#5678'],
      'prizePool': '₹50,000',
      'players': 128,
      'color': Colors.purple,
    },
    {
      'id': '1002',
      'name': 'Sunday Mega',
      'time': DateTime.now().add(const Duration(days: 2, hours: 4)),
      'status': 'upcoming',
      'tickets': 1,
      'ticketTypes': ['VIP'],
      'ticketNumbers': ['#9012'],
      'prizePool': '₹100,000',
      'players': 245,
      'color': Colors.amber,
    },
  ];

  // Sample previous games
  final List<Map<String, dynamic>> _previousGames = [
    {
      'id': '998',
      'name': 'Friday Night Special',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'completed',
      'tickets': 3,
      'ticketTypes': ['Basic', 'Basic', 'Premium'],
      'ticketNumbers': ['#7712', '#7713', '#8801'],
      'winAmount': '₹1,000',
      'positions': ['Full Row', 'No Win', 'No Win'],
      'color': Colors.teal,
    },
    {
      'id': '997',
      'name': 'Midweek Madness',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'completed',
      'tickets': 1,
      'ticketTypes': ['Premium'],
      'ticketNumbers': ['#6543'],
      'winAmount': '₹500',
      'positions': ['Early Five'],
      'color': Colors.deepOrange,
    },
    {
      'id': '996',
      'name': 'Tuesday Tournament',
      'time': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'completed',
      'tickets': 2,
      'ticketTypes': ['Basic', 'Basic'],
      'ticketNumbers': ['#3421', '#3422'],
      'winAmount': '₹0',
      'positions': ['No Win', 'No Win'],
      'color': Colors.blueGrey,
    },
  ];

  // Sample ticket data
  List<List<List<int?>>> _sampleTickets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _generateSampleTickets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Generate sample tickets for demo
  void _generateSampleTickets() {
    _sampleTickets = [];

    // For each upcoming game, generate tickets
    for (var game in _upcomingGames) {
      List<List<List<int?>>> gameTickets = [];
      for (int i = 0; i < (game['tickets'] as int); i++) {
        gameTickets.add(_generateSampleTicket());
      }
      _sampleTickets.add(gameTickets.first);
    }

    // For each previous game, generate tickets
    for (var game in _previousGames) {
      List<List<List<int?>>> gameTickets = [];
      for (int i = 0; i < (game['tickets'] as int); i++) {
        gameTickets.add(_generateSampleTicket());
      }
      _sampleTickets.add(gameTickets.first);
    }
  }

  // Generate a sample ticket with random numbers
  List<List<int?>> _generateSampleTicket() {
    List<List<int?>> ticket = List.generate(3, (_) => List.filled(9, null));

    // Generate columns
    for (int col = 0; col < 9; col++) {
      // Each column has a specific range of numbers
      int min = col * 10 + 1;
      int max = col == 8 ? 90 : (col + 1) * 10;
      if (col == 0) {
        min = 1;
      }

      // Generate a list of potential numbers for this column
      List<int> numbers = List.generate(max - min + 1, (i) => min + i);
      numbers.shuffle();

      // Decide how many numbers in this column (1 or 2, rarely 0)
      int count = (col == 0 || col == 8) ? 1 : 2;

      // Assign numbers to rows in this column
      List<int> rowIndices = [0, 1, 2];
      rowIndices.shuffle();

      for (int i = 0; i < count; i++) {
        if (i < rowIndices.length) {
          ticket[rowIndices[i]][col] = numbers[i];
        }
      }
    }

    return ticket;
  }

  // View ticket details
  void _viewTicketDetails(int index, bool isUpcoming) {
    setState(() {});

    // Get the correct ticket data based on whether it's upcoming or previous
    List<List<int?>> ticketData;
    if (isUpcoming) {
      ticketData = _sampleTickets[index];
    } else {
      ticketData = _sampleTickets[_upcomingGames.length + index];
    }

    // Show ticket details in bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => _buildTicketDetailsSheet(
            context,
            isUpcoming ? _upcomingGames[index] : _previousGames[index],
            isUpcoming,
            ticketData,
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
              // App Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        iconSize: 20,
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Tickets',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Manage your game tickets',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.purple,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  tabs: const [Tab(text: 'UPCOMING'), Tab(text: 'PREVIOUS')],
                ),
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Upcoming Games Tab
                    _upcomingGames.isEmpty
                        ? _buildEmptyState(
                          'No upcoming games',
                          'Buy tickets to join the fun!',
                        )
                        : _buildTicketList(_upcomingGames, true),

                    // Previous Games Tab
                    _previousGames.isEmpty
                        ? _buildEmptyState(
                          'No previous games',
                          'Play a game to see your history here',
                        )
                        : _buildTicketList(_previousGames, false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate back to buy tickets screen
          Navigator.of(context).pop();
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build empty state widget
  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets7.lottiefiles.com/private_files/lf30_GjhcdO.json',
            width: 180,
            height: 180,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // Build ticket list
  Widget _buildTicketList(List<Map<String, dynamic>> games, bool isUpcoming) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        final formattedDate = DateFormat(
          'MMM d, yyyy',
        ).format(game['time'] as DateTime);
        final formattedTime = DateFormat(
          'h:mm a',
        ).format(game['time'] as DateTime);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (game['color'] as Color).withValues(alpha: 0.3),
            ),
          ),
          child: InkWell(
            onTap: () => _viewTicketDetails(index, isUpcoming),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Game header
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (game['color'] as Color).withValues(alpha: 0.8),
                        (game['color'] as Color).withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game['name'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$formattedDate · $formattedTime',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Game status
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isUpcoming
                                  ? Colors.green.withValues(alpha: 0.8)
                                  : Colors.grey.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isUpcoming ? 'UPCOMING' : 'COMPLETED',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Game details
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ticket count and info
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_number,
                            color: game['color'] as Color,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${game['tickets']} ${game['tickets'] == 1 ? 'Ticket' : 'Tickets'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          if (isUpcoming)
                            Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${game['players']} players',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Icon(
                                  Icons.emoji_events,
                                  color:
                                      (double.tryParse(
                                                    (game['winAmount']
                                                            as String)
                                                        .replaceAll('₹', '')
                                                        .replaceAll(',', ''),
                                                  ) ??
                                                  0) >
                                              0
                                          ? Colors.amber
                                          : Colors.grey[400],
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  game['winAmount'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        (double.tryParse(
                                                      (game['winAmount']
                                                              as String)
                                                          .replaceAll('₹', '')
                                                          .replaceAll(',', ''),
                                                    ) ??
                                                    0) >
                                                0
                                            ? Colors.amber
                                            : Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Ticket type chips
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: game['ticketTypes'].length,
                          separatorBuilder:
                              (context, index) => const SizedBox(width: 6),
                          itemBuilder: (context, i) {
                            final ticketType = game['ticketTypes'][i] as String;
                            final ticketNumber =
                                game['ticketNumbers'][i] as String;

                            Color chipColor;
                            switch (ticketType) {
                              case 'Basic':
                                chipColor = const Color.fromARGB(
                                  255,
                                  245,
                                  166,
                                  48,
                                );
                                break;
                              case 'Premium':
                                chipColor = Colors.purple;
                                break;
                              case 'VIP':
                                chipColor = Colors.amber;
                                break;
                              default:
                                chipColor = Colors.blueGrey;
                            }

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: chipColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: chipColor.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$ticketType $ticketNumber',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: chipColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (!isUpcoming &&
                                      (game['positions'] as List)[i] !=
                                          'No Win')
                                    Row(
                                      children: [
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          (game['positions'] as List)[i]
                                              as String,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Prize pool or action based on game status
                      isUpcoming
                          ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.purple.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.monetization_on,
                                  color: Colors.purple[300],
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Prize Pool:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  game['prizePool'] as String,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[300],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.purple[300],
                                  size: 16,
                                ),
                              ],
                            ),
                          )
                          : OutlinedButton.icon(
                            onPressed: () {
                              // View game results
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.purple.withValues(alpha: 0.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(
                              Icons.analytics_outlined,
                              size: 16,
                            ),
                            label: const Text('VIEW RESULTS'),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build ticket details bottom sheet
  Widget _buildTicketDetailsSheet(
    BuildContext context,
    Map<String, dynamic> game,
    bool isUpcoming,
    List<List<int?>> ticketData,
  ) {
    final formattedDateTime = DateFormat(
      'MMM d, yyyy · h:mm a',
    ).format(game['time'] as DateTime);
    final winAmount = game['winAmount']?.toString() ?? '₹0';
    final positions = (game['positions'] as List<dynamic>?) ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game['name'] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formattedDateTime,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isUpcoming
                                  ? Colors.green.withValues(alpha: 0.8)
                                  : Colors.grey.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isUpcoming ? 'UPCOMING' : 'COMPLETED',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Game statistics
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.withValues(alpha: 0.2),
                          Colors.indigo.withValues(alpha: 0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        // First row of stats
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildStatCard(
                              icon: Icons.confirmation_number,
                              label: 'Tickets',
                              value: '${game['tickets']}',
                              color: game['color'] as Color,
                            ),
                            _buildStatCard(
                              icon:
                                  isUpcoming
                                      ? Icons.people
                                      : Icons.emoji_events,
                              label: isUpcoming ? 'Players' : 'Won',
                              value:
                                  isUpcoming ? '${game['players']}' : winAmount,
                              color:
                                  isUpcoming
                                      ? Colors.blue
                                      : (double.tryParse(
                                                winAmount
                                                    .replaceAll('₹', '')
                                                    .replaceAll(',', ''),
                                              ) ??
                                              0) >
                                          0
                                      ? Colors.amber
                                      : Colors.grey,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Second row of stats
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildStatCard(
                              icon: Icons.calendar_today,
                              label: 'Date',
                              value: DateFormat(
                                'MMM d, yyyy',
                              ).format(game['time'] as DateTime),
                              color: Colors.teal,
                            ),
                            _buildStatCard(
                              icon: Icons.access_time,
                              label: 'Time',
                              value: DateFormat(
                                'h:mm a',
                              ).format(game['time'] as DateTime),
                              color: Colors.purple,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Your tickets section
                  const Row(
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        color: Colors.purple,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'YOUR TICKETS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // List of tickets
                  ...List.generate(game['tickets'] as int, (i) {
                    final ticketType =
                        (game['ticketTypes'] as List)[i] as String;
                    final ticketNumber =
                        (game['ticketNumbers'] as List)[i] as String;

                    Color chipColor;
                    switch (ticketType) {
                      case 'Basic':
                        chipColor = const Color.fromARGB(255, 245, 166, 48);
                        break;
                      case 'Premium':
                        chipColor = Colors.purple;
                        break;
                      case 'VIP':
                        chipColor = Colors.amber;
                        break;
                      default:
                        chipColor = Colors.blueGrey;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: chipColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Ticket header
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: chipColor.withValues(alpha: 0.1),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(11),
                              ),
                              border: Border(
                                bottom: BorderSide(
                                  color: chipColor.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.confirmation_number_outlined,
                                      color: chipColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$ticketType Ticket $ticketNumber',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: chipColor,
                                      ),
                                    ),
                                  ],
                                ),
                                if (!isUpcoming &&
                                    positions.length > i &&
                                    positions[i] != 'No Win')
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          positions[i],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Ticket grid
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: _buildTicketGrid(ticketData),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Actions
                  if (isUpcoming)
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to game screen
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('JOIN GAME'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            // Share ticket
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.purple.withValues(alpha: 0.5),
                            ),
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.share),
                          label: const Text('SHARE TICKETS'),
                        ),
                      ],
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        // View game results
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.analytics_outlined),
                      label: const Text('VIEW GAME RESULTS'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build stat card widget
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build ticket grid
  Widget _buildTicketGrid(List<List<int?>> ticketData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        border: TableBorder.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 0.5,
        ),
        defaultColumnWidth: const FlexColumnWidth(1),
        children: List.generate(3, (row) {
          return TableRow(
            children: List.generate(9, (col) {
              final number = ticketData[row][col];
              return Container(
                height: 36,
                alignment: Alignment.center,
                decoration:
                    number != null
                        ? BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.withValues(alpha: 0.3),
                              Colors.indigo.withValues(alpha: 0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        )
                        : null,
                child:
                    number != null
                        ? Text(
                          number.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : null,
              );
            }),
          );
        }),
      ),
    );
  }
}
