import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

class WeekendHousieGameScreen extends StatefulWidget {
  const WeekendHousieGameScreen({super.key});
  @override
  _WeekendHousieGameScreenState createState() =>
      _WeekendHousieGameScreenState();
}

class _WeekendHousieGameScreenState extends State<WeekendHousieGameScreen>
    with SingleTickerProviderStateMixin {
  // Controller for animation
  late AnimationController _controller;
  late Animation<double> _animation;

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSpeaking = false;
  double _volume = 1.0; // Added volume control

  // Game variables
  final List<int> _allNumbers = List.generate(90, (index) => index + 1);
  final List<int> _calledNumbers = [];
  int? _currentNumber;
  int _remainingNumbers = 90;
  Timer? _timer;
  bool _isGameStarted = false;
  bool _isGamePaused = false;
  int _secondsToNextNumber = 10;

  // Player ticket data (3 rows × 9 columns)
  // The actual ticket will have some empty cells
  List<List<int?>> _playerTicket = [];
  List<List<bool>> _markedNumbers = [];
  bool _hasClaimed = false;

  // List of current winners
  final List<Map<String, dynamic>> _winners = [];
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    // Initialize audio
    _initializeTts();
    // Generate player ticket (Tambola ticket has 3 rows with 5 numbers each, arranged in 9 columns)
    _generatePlayerTicket();
    _markedNumbers = List.generate(3, (_) => List.generate(9, (_) => false));

    // Start with some numbers already called (game in progress)
    _simulateGameInProgress();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5); // Slower speech rate for clarity
    await _flutterTts.setVolume(_volume);

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  Future<void> _playNumberAudio(int number) async {
    if (_isSpeaking) return;
    setState(() {
      _isSpeaking = true;
    });

    try {
      await _flutterTts.setVolume(_volume);

      // Play a game sound first if you want
      //await _audioPlayer.play(AssetSource('game.mp3'));
      await Future.delayed(const Duration(milliseconds: 500));

      // Speak the number
      await _flutterTts.speak("Number $number");
    } catch (e) {
      debugPrint('TTS error: $e');
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  void _simulateGameInProgress() {
    // Simulate some numbers already called
    final random = Random();
    final preCalledCount =
        random.nextInt(15) + 10; // 10-25 numbers already called

    List<int> availableNumbers = List.from(_allNumbers);
    for (int i = 0; i < preCalledCount; i++) {
      if (availableNumbers.isEmpty) break;
      final idx = random.nextInt(availableNumbers.length);
      final number = availableNumbers[idx];
      availableNumbers.removeAt(idx);
      _calledNumbers.add(number);
    }

    // Set current number as the last called
    if (_calledNumbers.isNotEmpty) {
      _currentNumber = _calledNumbers.last;
    }

    _remainingNumbers = 90 - _calledNumbers.length;

    // Mark any called numbers on player's ticket
    _autoMarkCalledNumbers();
  }

  void _generatePlayerTicket() {
    // Initialize empty ticket
    _playerTicket = List.generate(3, (_) => List.generate(9, (_) => null));

    // In a real tambola ticket, each row has exactly 5 numbers and 4 empty cells
    // Numbers must be in ascending order in each column

    final random = Random();

    // For each column, decide which rows will have numbers
    for (int col = 0; col < 9; col++) {
      // Numbers for this column are in the range (col*10+1) to (col*10+10), except for the last column
      int min = col * 10 + 1;
      int max = col == 8 ? 90 : (col + 1) * 10;

      // Choose 1, 2 or 3 random positions for this column
      int numPositions = random.nextInt(3) + 1; // 1, 2, or 3
      List<int> positions = [];

      while (positions.length < numPositions) {
        int pos = random.nextInt(3); // 0, 1, or 2 (row index)
        if (!positions.contains(pos)) {
          positions.add(pos);
        }
      }

      // Sort positions to ensure numbers are in ascending order
      positions.sort();

      // Assign numbers to chosen positions
      List<int> columnNumbers = [];
      for (int i = 0; i < numPositions; i++) {
        int number = min + random.nextInt(max - min + 1);
        while (columnNumbers.contains(number)) {
          number = min + random.nextInt(max - min + 1);
        }
        columnNumbers.add(number);
      }

      // Sort numbers for this column
      columnNumbers.sort();

      // Assign sorted numbers to the positions
      for (int i = 0; i < numPositions; i++) {
        _playerTicket[positions[i]][col] = columnNumbers[i];
      }
    }

    // Ensure each row has exactly 5 numbers
    for (int row = 0; row < 3; row++) {
      int numbersInRow = _playerTicket[row].where((n) => n != null).length;

      if (numbersInRow > 5) {
        // Remove extra numbers
        while (_playerTicket[row].where((n) => n != null).length > 5) {
          List<int> nonEmptyIndices = [];
          for (int col = 0; col < 9; col++) {
            if (_playerTicket[row][col] != null) {
              nonEmptyIndices.add(col);
            }
          }

          // Choose a random non-empty cell to empty
          int indexToEmpty =
              nonEmptyIndices[random.nextInt(nonEmptyIndices.length)];
          _playerTicket[row][indexToEmpty] = null;
        }
      } else if (numbersInRow < 5) {
        // Add missing numbers
        while (_playerTicket[row].where((n) => n != null).length < 5) {
          List<int> emptyIndices = [];
          for (int col = 0; col < 9; col++) {
            if (_playerTicket[row][col] == null) {
              emptyIndices.add(col);
            }
          }

          // Choose a random empty cell to fill
          int indexToFill = emptyIndices[random.nextInt(emptyIndices.length)];
          int min = indexToFill * 10 + 1;
          int max = indexToFill == 8 ? 90 : (indexToFill + 1) * 10;

          // Find a number that doesn't conflict with other cells in same column
          int newNumber = min + random.nextInt(max - min + 1);
          bool isValid = true;

          for (int checkRow = 0; checkRow < 3; checkRow++) {
            if (_playerTicket[checkRow][indexToFill] == newNumber) {
              isValid = false;
              break;
            }
          }

          if (isValid) {
            _playerTicket[row][indexToFill] = newNumber;
          }
        }
      }
    }
    debugPrint('Generated Player Ticket: $_playerTicket');
    debugPrint('Marked Numbers: $_markedNumbers');
  }

  void _autoMarkCalledNumbers() {
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 9; col++) {
        if (_playerTicket[row][col] != null &&
            _calledNumbers.contains(_playerTicket[row][col])) {
          _markedNumbers[row][col] = true;
        }
      }
    }
  }

  Future<void> _startGame() async {
    setState(() {
      _isGameStarted = true;
      _isGamePaused = false;
    });

    // Play game start sound
    try {
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.play(AssetSource('game.mp3'));
      debugPrint('Playing game start sound');
    } catch (e) {
      debugPrint('Error playing game start sound: $e');
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsToNextNumber > 0) {
        setState(() {
          _secondsToNextNumber--;
        });
      } else {
        _callNextNumber();
        setState(() {
          _secondsToNextNumber = 10; // Reset timer
        });
      }
    });
  }

  void _pauseGame() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    setState(() {
      _isGamePaused = true;
    });
  }

  void _resumeGame() {
    _startGame();
  }

  Future<void> _callNextNumber() async {
    if (_remainingNumbers <= 0) return;

    final random = Random();
    List<int> uncalledNumbers =
        _allNumbers.where((n) => !_calledNumbers.contains(n)).toList();

    if (uncalledNumbers.isEmpty) return;

    int randomIndex = random.nextInt(uncalledNumbers.length);
    int nextNumber = uncalledNumbers[randomIndex];

    setState(() {
      _currentNumber = nextNumber;
      _calledNumbers.add(nextNumber);
      _remainingNumbers--;

      // Animate the number appearing
      _controller.reset();
      _controller.forward();
    });

    // Play audio for the called number
    await _playNumberAudio(nextNumber);

    // Auto-mark if on player's ticket
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 9; col++) {
        if (_playerTicket[row][col] == nextNumber) {
          _markedNumbers[row][col] = true;
        }
      }
    }

    // Check for winners every 5-10 numbers (simulated)
    if (_calledNumbers.length % (5 + random.nextInt(6)) == 0) {
      _addRandomWinner();
    }
  }

  void _toggleNumberMark(int row, int col) {
    if (_playerTicket[row][col] != null) {
      setState(() {
        _markedNumbers[row][col] = !_markedNumbers[row][col];
      });
    }
  }

  Future<void> _claimWin() async {
    // Check if win is valid
    bool hasFullRow = false;

    // Check for a full row
    for (int row = 0; row < 3; row++) {
      bool rowComplete = true;
      for (int col = 0; col < 9; col++) {
        // If there's a number and it's not marked, row is incomplete
        if (_playerTicket[row][col] != null && !_markedNumbers[row][col]) {
          rowComplete = false;
          break;
        }
      }
      if (rowComplete) {
        hasFullRow = true;
        break;
      }
    }

    setState(() {
      _hasClaimed = true;
    });

    // Play win sound if claim is valid
    if (hasFullRow) {
      try {
        await _audioPlayer.setVolume(_volume);
        await _audioPlayer.play(
          AssetSource('winner.mp3'),
        ); // Using game.mp3 as win sound
        debugPrint('Playing win sound');
      } catch (e) {
        debugPrint('Error playing win sound: $e');
      }
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: const Color(0xFF1E1E2C),
            title: Text(
              hasFullRow ? 'Winner!' : 'Claim Failed',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasFullRow)
                  Lottie.asset('assets/winner.json', height: 200, repeat: true),
                Text(
                  hasFullRow
                      ? 'Congratulations! Your claim is verified.\nYou have won ₹200!'
                      : 'Your claim could not be verified.\nMake sure you have a valid win pattern.',
                  style: TextStyle(color: Colors.grey[300], fontSize: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.purple[300],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );

    if (hasFullRow) {
      // Add player to winners list
      _winners.add({
        'name': 'You',
        'pattern': 'Full Row',
        'prize': '₹200',
        'isPlayer': true,
      });
    }
  }

  void _addRandomWinner() {
    final patterns = [
      'First Five',
      'Early Five',
      'Four Corners',
      'Middle Row',
      'Full House',
    ];
    final names = [
      'Alex S.',
      'Maria T.',
      'John D.',
      'Sarah K.',
      'Mike P.',
      'Emma L.',
    ];
    final prizes = ['₹100', '₹150', '₹200', '₹250', '₹500', '₹1000'];

    final random = Random();

    setState(() {
      _winners.add({
        'name': names[random.nextInt(names.length)],
        'pattern': patterns[random.nextInt(patterns.length)],
        'prize': prizes[random.nextInt(prizes.length)],
        'isPlayer': false,
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
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
              // App Bar with back button and game title
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
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Win Housie',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Game in progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
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
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
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

              // Game content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Audio speaker component
                      _buildAudioSpeakerComponent(),

                      // Game controls
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _gameControlButton(
                              icon:
                                  _isGamePaused
                                      ? Icons.play_arrow
                                      : Icons.pause,
                              label: _isGamePaused ? 'Resume' : 'Pause',
                              color:
                                  _isGamePaused
                                      ? Colors.green[600]!
                                      : Colors.amber[700]!,
                              onTap:
                                  _isGameStarted
                                      ? (_isGamePaused
                                          ? _resumeGame
                                          : _pauseGame)
                                      : _startGame,
                            ),
                            _gameControlButton(
                              icon: Icons.military_tech,
                              label: 'Claim Win',
                              color: Colors.purple[600]!,
                              onTap: _hasClaimed ? null : _claimWin,
                              disabled: _hasClaimed,
                            ),
                            _gameControlButton(
                              icon: Icons.history,
                              label: 'History',
                              color: Colors.blue[600]!,
                              onTap: () {
                                // Show called numbers history
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: const Color(0xFF1E1E2C),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder:
                                      (context) =>
                                          _buildNumbersHistorySheet(context),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Player ticket label
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'YOUR TICKET',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              'Tap numbers to mark',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Player ticket
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: List.generate(3, (row) {
                            return Row(
                              children: List.generate(9, (col) {
                                final number = _playerTicket[row][col];
                                final isMarked =
                                    number != null && _markedNumbers[row][col];

                                return Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: GestureDetector(
                                      onTap: () => _toggleNumberMark(row, col),
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color:
                                              isMarked
                                                  ? Colors.purple[100]
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            number != null
                                                ? Text(
                                                  number.toString(),
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        isMarked
                                                            ? FontWeight.bold
                                                            : FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                )
                                                : const SizedBox(),
                                            if (isMarked)
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.purple[600]!
                                                      .withValues(alpha: 0.7),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),
                        ),
                      ),

                      // Winners section
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'WINNERS',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              'Live updates',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400]!,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Winners list
                      _winners.isEmpty
                          ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 24),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.purple[800]!.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'No winners yet. Be the first one!',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _winners.length,
                            itemBuilder: (context, index) {
                              final winner = _winners[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      winner['isPlayer']
                                          ? Colors.purple[900]!.withValues(
                                            alpha: 0.5,
                                          )
                                          : Colors.black.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        winner['isPlayer']
                                            ? Colors.purple[400]!
                                            : Colors.purple[800]!.withValues(
                                              alpha: 0.3,
                                            ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Winner Avatar
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          colors:
                                              winner['isPlayer']
                                                  ? [
                                                    Colors.amber[400]!,
                                                    Colors.amber[700]!,
                                                  ]
                                                  : [
                                                    Colors.purple[400]!,
                                                    Colors.purple[800]!,
                                                  ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (winner['isPlayer']
                                                    ? Colors.amber[700]!
                                                    : Colors.purple[700]!)
                                                .withValues(alpha: 0.5),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child:
                                            winner['isPlayer']
                                                ? const Icon(
                                                  Icons.emoji_events,
                                                  color: Colors.white,
                                                  size: 24,
                                                )
                                                : Text(
                                                  winner['name']
                                                      .toString()
                                                      .split(' ')
                                                      .map((e) => e[0])
                                                      .join(''),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Winner Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                winner['name'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      winner['isPlayer']
                                                          ? Colors.amber[300]
                                                          : Colors.white,
                                                ),
                                              ),
                                              if (winner['isPlayer'])
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 8,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber[800],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'YOU',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Text(
                                            winner['pattern'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Winner Prize
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            winner['isPlayer']
                                                ? Colors.amber[800]
                                                : Colors.purple[800],
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (winner['isPlayer']
                                                    ? Colors.amber[900]!
                                                    : Colors.purple[900]!)
                                                .withValues(alpha: 0.5),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.attach_money,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          Text(
                                            winner['prize'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
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

  Widget _buildAudioSpeakerComponent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple[800]!.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    'Next Number',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 18),
                  Text(
                    '$_secondsToNextNumber s',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Current Number',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ScaleTransition(
                    scale: _animation,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.purple[600],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple[800]!.withValues(alpha: 0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _currentNumber?.toString() ?? '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'REMAINING',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _remainingNumbers.toString(),
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
          SizedBox(height: 20),
          // Audio controls
          Row(
            children: [
              // Speaker icon
              const SizedBox(width: 12),
              // Volume slider
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Speaker Volume',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.purple[400],
                        inactiveTrackColor: Colors.grey[800],
                        thumbColor: Colors.purple[200],
                        overlayColor: Colors.purple[200]!.withValues(
                          alpha: 0.2,
                        ),
                        trackHeight: 4.0,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8.0,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14.0,
                        ),
                      ),
                      child: Slider(
                        value: _volume,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                          });
                          _audioPlayer.setVolume(_volume);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Volume percentage
              SizedBox(
                width: 40,
                child: Text(
                  '${(_volume * 100).round()}%',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gameControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
    bool disabled = false,
  }) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumbersHistorySheet(BuildContext context) {
    // Group called numbers by tens (1-10, 11-20, etc.)
    Map<String, List<int>> groupedNumbers = {};

    for (int i = 0; i < 9; i++) {
      int start = i * 10 + 1;
      int end = (i + 1) * 10;
      if (i == 8) end = 90; // Last group is 81-90

      String groupName = '$start-$end';
      groupedNumbers[groupName] = [];

      for (int num = start; num <= end; num++) {
        if (_calledNumbers.contains(num)) {
          groupedNumbers[groupName]!.add(num);
        }
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Title
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Called Numbers History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Last called
        if (_currentNumber != null)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.purple[900]!.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.purple[500]!.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Last called: ',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _currentNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Total called
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Total numbers called: ${_calledNumbers.length} / 90',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ),

        // Grouped numbers
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children:
                  groupedNumbers.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Group header
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Numbers grid
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(10, (index) {
                            int number =
                                int.parse(entry.key.split('-')[0]) + index;
                            if (number > 90) return const SizedBox();

                            bool isCalled = entry.value.contains(number);

                            return Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color:
                                    isCalled
                                        ? Colors.purple[700]
                                        : Colors.grey[800]!.withValues(
                                          alpha: 0.5,
                                        ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color:
                                      isCalled
                                          ? Colors.purple[300]!
                                          : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  number.toString(),
                                  style: TextStyle(
                                    color:
                                        isCalled
                                            ? Colors.white
                                            : Colors.grey[500],
                                    fontWeight:
                                        isCalled
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 8),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),

        // Close button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[700],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Close',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
