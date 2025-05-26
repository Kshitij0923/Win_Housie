import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tambola/Contest%20Screens/mega_contest_screen.dart';
import 'package:tambola/Contest%20Screens/standard_contest.dart';
import 'package:tambola/Provider/Controller/user_provider.dart';
import 'dart:convert';

import 'package:tambola/Theme/app_theme.dart';

class MegaScreen extends StatefulWidget {
  const MegaScreen({super.key, required Map contest});

  @override
  HousieContestScreenState createState() => HousieContestScreenState();
}

class HousieContestScreenState extends State<MegaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Contest data from API
  List<Map<String, dynamic>> _contests = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Selected contest
  String _selectedContest = 'Standard Game';
  Map<String, dynamic>? _selectedContestDetails;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fetchContests();

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

  String? _getAuthToken() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.authToken;

    // Add more detailed logging
    if (token == null || token.isEmpty) {
      debugPrint('WARNING: Auth token is null or empty');
      debugPrint('User provider state: ${userProvider.toString()}');
    } else {
      debugPrint('Auth token available: ${token.substring(0, 10)}...');
    }

    return token;
  }

  Map<String, String> _getAuthHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };

    final token = _getAuthToken();
    debugPrint('Auth token: $token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<void> _fetchContests() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final token = _getAuthToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Authentication required. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://ae12-103-175-140-106.ngrok-free.app/api/Contests/fetch_contest',
        ),
        headers: _getAuthHeaders(),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Map<String, dynamic>> transformedContests = [];

        // Handle the nested response structure
        if (jsonData is Map && jsonData.containsKey('data')) {
          final contestsData = jsonData['data'];
          if (contestsData is List) {
            for (var contest in contestsData) {
              if (contest is Map) {
                try {
                  final transformedContest = _transformContestData(
                    Map<String, dynamic>.from(contest),
                  );
                  transformedContests.add(transformedContest);
                  debugPrint(
                    'Transformed contest: ${transformedContest['name']} - Prize: ${transformedContest['prizePool']}',
                  );
                } catch (e) {
                  debugPrint('Error transforming contest: $e');
                  debugPrint('Contest data: $contest');
                }
              }
            }
          }
        } else if (jsonData is List) {
          for (var contest in jsonData) {
            if (contest is Map) {
              try {
                final transformedContest = _transformContestData(
                  Map<String, dynamic>.from(contest),
                );
                transformedContests.add(transformedContest);
              } catch (e) {
                debugPrint('Error transforming contest: $e');
                debugPrint('Contest data: $contest');
              }
            }
          }
        }

        // Sort contests by prize pool (highest first)
        transformedContests.sort(
          (a, b) => (b['prizePool'] as int).compareTo(a['prizePool'] as int),
        );

        setState(() {
          _contests = transformedContests;
          _isLoading = false;
          if (_contests.isNotEmpty) {
            _selectedContestDetails = _contests[0];
          }
        });

        debugPrint('Successfully loaded ${_contests.length} contests');
        for (var contest in _contests) {
          debugPrint(
            'Contest: ${contest['name']} - Prize: ₹${contest['prizePool']} - Entry: ₹${contest['entryFee']}',
          );
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Authentication failed. Please log in again.';
          _isLoading = false;
        });
      } else if (response.statusCode == 500) {
        setState(() {
          _errorMessage = 'Server error. Please try again later.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to fetch contests. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error in _fetchContests: $e');
      setState(() {
        _errorMessage = 'Error fetching contests: $e';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _transformContestData(Map<String, dynamic> apiContest) {
    // Extract values from the actual API response structure
    final contestId =
        apiContest['_id']?.toString() ??
        'contest_${DateTime.now().millisecondsSinceEpoch}';
    final numberOfContestants = apiContest['number_of_contestants'] ?? 100;
    final prize = apiContest['prize'] ?? 0;
    final ticketPrice = apiContest['ticket_prize'] ?? 0;
    final contestState = apiContest['contest_state'] ?? 'pending';
    final contestParticipants =
        apiContest['contest_participants'] as List? ?? [];
    final contestPatternClaim =
        apiContest['contest_pattern_claim'] as List? ?? [];

    // Generate contest name based on prize and participants
    String contestName = _generateContestName(
      prize,
      numberOfContestants,
      ticketPrice,
    );

    // Determine if it's a mega contest based on prize pool or ticket price
    bool isMega = prize > 50000 || ticketPrice > 1000;
    bool isPopular = numberOfContestants > 1000;

    // Color scheme based on contest type
    Color primaryColor;
    Color iconColor;
    String fontFamily;

    if (isMega) {
      if (prize > 200000) {
        primaryColor = const Color(
          0xFF9C27B0,
        ); // Purple for high-value contests
        iconColor = const Color(0xFFBA68C8);
        fontFamily = 'Quicksand';
      } else {
        primaryColor = const Color(0xFFFF9800); // Orange for mega contests
        iconColor = const Color(0xFFFFB74D);
        fontFamily = 'Raleway';
      }
    } else if (isPopular) {
      primaryColor = const Color(0xFF2196F3); // Blue for popular contests
      iconColor = const Color(0xFF03A9F4);
      fontFamily = 'Montserrat';
    } else {
      primaryColor = const Color(0xFF4CAF50); // Green for regular contests
      iconColor = const Color(0xFF8BC34A);
      fontFamily = 'Poppins';
    }

    // Use actual prizes from contest_pattern_claim or generate default ones
    List<Map<String, dynamic>> prizes = _generatePrizesFromPattern(
      contestPatternClaim,
      prize,
    );

    return {
      'id': contestId,
      'name': contestName,
      'entryFee': ticketPrice,
      'prizePool': prize,
      'startTime': _generateStartTime(),
      'playersJoined': contestParticipants.length,
      'maxPlayers': numberOfContestants,
      'color': primaryColor,
      'iconColor': iconColor,
      'fontFamily': fontFamily,
      'isPopular': isPopular,
      'isMega': isMega,
      'prizes': prizes,
      'status': contestState,
      'description': _generateDescription(
        contestName,
        prize,
        numberOfContestants,
      ),
      'contestPatternClaim': contestPatternClaim,
    };
  }

  // Helper method to generate prizes from contest_pattern_claim
  List<Map<String, dynamic>> _generatePrizesFromPattern(
    List contestPatternClaim,
    int totalPrize,
  ) {
    List<Map<String, dynamic>> prizes = [];

    if (contestPatternClaim.isNotEmpty) {
      for (var pattern in contestPatternClaim) {
        if (pattern is Map) {
          prizes.add({
            'name': pattern['pattern'] ?? 'Prize',
            'amount': pattern['prize'] ?? 0,
            'winners': 1,
          });
        }
      }
    }

    // If no patterns found, generate default prizes
    if (prizes.isEmpty) {
      prizes = [
        {
          'name': 'Full Housie',
          'amount': (totalPrize * 0.5).toInt(),
          'winners': 1,
        },
        {
          'name': 'First Line',
          'amount': (totalPrize * 0.2).toInt(),
          'winners': 1,
        },
        {
          'name': 'Middle Line',
          'amount': (totalPrize * 0.15).toInt(),
          'winners': 1,
        },
        {
          'name': 'Last Line',
          'amount': (totalPrize * 0.15).toInt(),
          'winners': 1,
        },
      ];
    }

    return prizes;
  }

  // Helper method to generate contest name
  String _generateContestName(int prize, int contestants, int ticketPrice) {
    if (prize > 1000000) {
      return 'Mega Million Contest';
    } else if (prize > 500000) {
      return 'Super Jackpot Contest';
    } else if (prize > 100000) {
      return 'Premium Contest';
    } else if (contestants > 5000) {
      return 'Massive Multiplayer Contest';
    } else if (ticketPrice == 0) {
      return 'Free Entry Contest';
    } else if (ticketPrice > 10000) {
      return 'High Stakes Contest';
    } else {
      return 'Standard Contest';
    }
  }

  // Helper method to generate prizes based on total prize pool
  List<Map<String, dynamic>> _generatePrizes(int totalPrize) {
    return [
      {
        'name': 'Full Housie',
        'amount': (totalPrize * 0.5).toInt(),
        'winners': 1,
      },
      {
        'name': 'First Line',
        'amount': (totalPrize * 0.2).toInt(),
        'winners': 1,
      },
      {
        'name': 'Middle Line',
        'amount': (totalPrize * 0.15).toInt(),
        'winners': 1,
      },
      {
        'name': 'Last Line',
        'amount': (totalPrize * 0.15).toInt(),
        'winners': 1,
      },
    ];
  }

  // Helper method to generate start time (since it's not in the API)
  String _generateStartTime() {
    final now = DateTime.now();
    final startTime = now.add(Duration(minutes: 15 + (now.minute % 30)));

    int hour = startTime.hour;
    int minute = startTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '${hour}:${minute.toString().padLeft(2, '0')} $period';
  }

  // Helper method to generate description
  String _generateDescription(String name, int prize, int contestants) {
    return 'Join $name with a prize pool of ₹$prize. Up to $contestants players can participate in this exciting game!';
  }

  // Format time from API response (updated to handle missing time data)
  String _formatTime(dynamic timeData) {
    if (timeData == null) {
      // Generate a time since the API doesn't provide start_time
      return _generateStartTime();
    }

    try {
      if (timeData is String) {
        // If it's already a formatted time string
        if (timeData.contains('PM') || timeData.contains('AM')) {
          return timeData;
        }
        // If it's a date-time string, parse and format
        DateTime dateTime = DateTime.parse(timeData);
        int hour = dateTime.hour;
        int minute = dateTime.minute;
        String period = hour >= 12 ? 'PM' : 'AM';
        hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '${hour}:${minute.toString().padLeft(2, '0')} $period';
      }
    } catch (e) {
      print('Error formatting time: $e');
    }

    return _generateStartTime();
  }

  void _viewContestDetails(Map<String, dynamic> contest) {
    setState(() {
      _selectedContestDetails = contest;
    });

    // Check if it's the Standard Flexible Pool contest
    if (contest['id'] == 'contest_standard' ||
        contest['name'].toLowerCase().contains('standard')) {
      // Navigate to StandardFlexiblePoolScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StandardFlexiblePoolScreen()),
      );
    } else {
      // Show modal bottom sheet for other contests
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) => _buildContestDetailsSheet(context, contest),
      );
    }
  }

  void _viewMegaContestDetails(Map<String, dynamic> contest) {
    // Navigate to mega contest details screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MegaContestScreen(contest: contest),
      ),
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
        title: 'Housie Contests',
        titleStyle: TextStyle(fontSize: 22),
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
                child:
                    _isLoading
                        ? _buildLoadingWidget()
                        : _errorMessage != null
                        ? _buildErrorWidget()
                        : _buildContestContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Loading widget
  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading Contests...',
            style: GoogleFonts.inter(
              textStyle: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Error widget
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            'Failed to Load Contests',
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                textStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchContests,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Main contest content
  Widget _buildContestContent() {
    if (_contests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, color: Colors.grey, size: 64),
            const SizedBox(height: 16),
            Text(
              'No Contests Available',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new contests',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
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
              border: Border.all(color: Colors.blueGrey[800]!.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.infoCircle,
                        color: Colors.blueGrey[300],
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Join a contest 5 minutes before it starts to secure your spot.',
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
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

          const SizedBox(height: 16),

          // Game Schedule Banner (only show if we have contests)
          if (_contests.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.withOpacity(0.8),
                    Colors.blueGrey.withOpacity(0.6),
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
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.calendarAlt,
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
                          'UPCOMING GAMES',
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
                          'Games starting soon - Join now!',
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
                          'Total ${_contests.length} contests available',
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
            const SizedBox(height: 16),
          ],

          // Mega Contests section
          if (_contests.where((c) => c['isMega'] == true).isNotEmpty) ...[
            Text(
              'MEGA CONTESTS',
              style: GoogleFonts.rubik(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _contests.where((c) => c['isMega'] == true).length,
                itemBuilder: (context, index) {
                  final megaContests =
                      _contests.where((c) => c['isMega'] == true).toList();
                  final contest = megaContests[index];
                  return _buildMegaContestCard(contest);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Available contests header
          if (_contests.where((c) => c['isMega'] == false).isNotEmpty) ...[
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
            const SizedBox(height: 12),
            // Regular Contest cards
            ...List.generate(
              _contests.where((c) => c['isMega'] == false).length,
              (index) {
                final regularContests =
                    _contests.where((c) => c['isMega'] == false).toList();
                final contest = regularContests[index];
                return _buildRegularContestCard(contest);
              },
            ),
          ],
        ],
      ),
    );
  }

  // Build mega contest card
  Widget _buildMegaContestCard(Map<String, dynamic> contest) {
    return Container(
      width: 270,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (contest['color'] as Color).withOpacity(0.8),
            (contest['color'] as Color).withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (contest['color'] as Color).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 90,
              height: 90,
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
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    'MEGA',
                    style: GoogleFonts.getFont(
                      contest['fontFamily'],
                      textStyle: TextStyle(
                        color: contest['color'] as Color,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
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
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.clock,
                      color: Colors.white.withOpacity(0.8),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Today, ${contest['startTime']}',
                      style: GoogleFonts.getFont(
                        contest['fontFamily'],
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${contest['prizePool'].toString()}',
                  style: GoogleFonts.getFont(
                    contest['fontFamily'],
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Entry Fee: ₹${contest['entryFee']}',
                      style: GoogleFonts.getFont(
                        contest['fontFamily'],
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _viewMegaContestDetails(contest),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'VIEW',
                          style: GoogleFonts.getFont(
                            contest['fontFamily'],
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: contest['color'] as Color,
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
  }

  // Build regular contest card
  Widget _buildRegularContestCard(Map<String, dynamic> contest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (contest['color'] as Color).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Contest header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (contest['color'] as Color).withOpacity(0.8),
                  (contest['color'] as Color).withOpacity(0.6),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            fontSize: 16,
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
                            color: Colors.white.withOpacity(0.8),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Today, ${contest['startTime']}',
                            style: GoogleFonts.getFont(
                              contest['fontFamily'],
                              textStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
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
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'POPULAR',
                          style: GoogleFonts.getFont(
                            contest['fontFamily'],
                            textStyle: const TextStyle(
                              fontSize: 10,
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
          // Contest details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRIZE POOL',
                          style: GoogleFonts.getFont(
                            contest['fontFamily'],
                            textStyle: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${contest['prizePool']}',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'ENTRY FEE',
                          style: GoogleFonts.getFont(
                            contest['fontFamily'],
                            textStyle: TextStyle(
                              fontSize: 10,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Players joined progress
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${contest['playersJoined']} / ${contest['maxPlayers']} Players',
                                style: GoogleFonts.getFont(
                                  contest['fontFamily'],
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ),
                              Text(
                                '${((contest['playersJoined'] / contest['maxPlayers']) * 100).toInt()}%',
                                style: GoogleFonts.getFont(
                                  contest['fontFamily'],
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    color: contest['color'] as Color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value:
                                contest['playersJoined'] /
                                contest['maxPlayers'],
                            backgroundColor: Colors.grey[800],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              contest['color'] as Color,
                            ),
                            minHeight: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Join/View button
                    GestureDetector(
                      onTap: () => _viewContestDetails(contest),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              contest['color'] as Color,
                              (contest['color'] as Color).withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (contest['color'] as Color).withOpacity(
                                0.3,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'JOIN',
                              style: GoogleFonts.getFont(
                                contest['fontFamily'],
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
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

  // Build contest details sheet
  Widget _buildContestDetailsSheet(
    BuildContext context,
    Map<String, dynamic> contest,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2C),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (contest['color'] as Color).withOpacity(0.8),
                  (contest['color'] as Color).withOpacity(0.6),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Today, ${contest['startTime']}',
                        style: GoogleFonts.getFont(
                          contest['fontFamily'],
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prize info
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Prize Pool',
                          '₹${contest['prizePool']}',
                          FontAwesomeIcons.trophy,
                          contest['color'] as Color,
                          contest['fontFamily'],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          'Entry Fee',
                          '₹${contest['entryFee']}',
                          FontAwesomeIcons.ticket,
                          contest['color'] as Color,
                          contest['fontFamily'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Players info
                  _buildInfoCard(
                    'Players Joined',
                    '${contest['playersJoined']} / ${contest['maxPlayers']}',
                    FontAwesomeIcons.users,
                    contest['color'] as Color,
                    contest['fontFamily'],
                    isFullWidth: true,
                    progress: contest['playersJoined'] / contest['maxPlayers'],
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
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate((contest['prizes'] as List).length, (index) {
                    final prize = contest['prizes'][index];
                    return _buildPrizeItem(
                      prize['name'],
                      '₹${prize['amount'].toInt()}',
                      '${prize['winners']} winner${prize['winners'] > 1 ? 's' : ''}',
                      contest['color'] as Color,
                      contest['fontFamily'],
                    );
                  }),
                  const SizedBox(height: 20),
                  // Game rules
                  Text(
                    'GAME RULES',
                    style: GoogleFonts.getFont(
                      contest['fontFamily'],
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRuleItem(
                    'Numbers will be called randomly',
                    contest['fontFamily'],
                  ),
                  _buildRuleItem(
                    'Mark numbers on your ticket as they are called',
                    contest['fontFamily'],
                  ),
                  _buildRuleItem(
                    'First to complete a line/pattern wins the prize',
                    contest['fontFamily'],
                  ),
                  _buildRuleItem(
                    'Multiple winners split the prize money',
                    contest['fontFamily'],
                  ),
                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),
          // Join button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _joinContest(contest),
                style: ElevatedButton.styleFrom(
                  backgroundColor: contest['color'] as Color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'JOIN CONTEST - ₹${contest['entryFee']}',
                  style: GoogleFonts.getFont(
                    contest['fontFamily'],
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build info cards
  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String fontFamily, {
    bool isFullWidth = false,
    double? progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
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
                title.toUpperCase(),
                style: GoogleFonts.getFont(
                  fontFamily,
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
          Text(
            value,
            style: GoogleFonts.getFont(
              fontFamily,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ],
        ],
      ),
    );
  }

  // Helper method to build prize items
  Widget _buildPrizeItem(
    String name,
    String amount,
    String winners,
    Color color,
    String fontFamily,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.getFont(
                  fontFamily,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                winners,
                style: GoogleFonts.getFont(
                  fontFamily,
                  textStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: GoogleFonts.getFont(
              fontFamily,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build rule items
  Widget _buildRuleItem(String rule, String fontFamily) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              rule,
              style: GoogleFonts.getFont(
                fontFamily,
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show payment success animation
  void _showPaymentSuccess(Map<String, dynamic> contest) {
    Navigator.of(context).pop(); // Close confirmation dialog

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
                // Success animation
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
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
                    textStyle: TextStyle(fontSize: 14, color: Colors.grey[300]),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Optionally navigate to game screen or refresh contests
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'CONTINUE',
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
}
