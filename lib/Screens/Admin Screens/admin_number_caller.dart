import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tambola/Theme/app_theme.dart';

class NumberCallerScreen extends StatefulWidget {
  final String? contestId;
  final String? contestTitle;
  const NumberCallerScreen({super.key, this.contestId, this.contestTitle});

  @override
  State<NumberCallerScreen> createState() => _NumberCallerScreenState();
}

class _NumberCallerScreenState extends State<NumberCallerScreen> {
  final List<int> _allNumbers = List.generate(90, (index) => index + 1);
  final List<int> _calledNumbers = [];
  int? _currentNumber;
  bool _isAutoCallingActive = false;
  Timer? _autoCallTimer;
  final int _autoCallIntervalSeconds = 15;
  int _remainingSeconds = 0;
  bool _isManualSelectionMode = false;

  @override
  void dispose() {
    _autoCallTimer?.cancel();
    super.dispose();
  }

  void _callNextNumber() {
    if (_calledNumbers.length >= 90) {
      setState(() {
        _currentNumber = null;
      });
      _stopAutoCalling();
      _showGameCompleteDialog();
      return;
    }

    final availableNumbers =
        _allNumbers
            .where((number) => !_calledNumbers.contains(number))
            .toList();
    if (availableNumbers.isEmpty) return;

    final random = Random();
    final nextNumber =
        availableNumbers[random.nextInt(availableNumbers.length)];

    _setCurrentNumber(nextNumber);
  }

  void _setCurrentNumber(int number) {
    if (!_calledNumbers.contains(number)) {
      setState(() {
        _currentNumber = number;
        _calledNumbers.add(number);
        _remainingSeconds = _autoCallIntervalSeconds;
      });
    }
  }

  void _startAutoCalling() {
    setState(() {
      _isAutoCallingActive = true;
      _isManualSelectionMode = false;
      _remainingSeconds = _autoCallIntervalSeconds;
    });

    _callNextNumber();

    _autoCallTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _callNextNumber();
        }
      });
    });
  }

  void _stopAutoCalling() {
    _autoCallTimer?.cancel();
    setState(() {
      _isAutoCallingActive = false;
    });
  }

  void _toggleManualSelectionMode() {
    if (_isAutoCallingActive) {
      _stopAutoCalling();
    }

    setState(() {
      _isManualSelectionMode = !_isManualSelectionMode;
    });
  }

  void _resetGame() {
    _stopAutoCalling();
    setState(() {
      _calledNumbers.clear();
      _currentNumber = null;
      _isManualSelectionMode = false;
    });
  }

  void _showGameCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Game Complete'),
            content: const Text('All numbers have been called!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetGame();
                },
                child: const Text('Start New Game'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Exit'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    theme.init(context);

    return Scaffold(
      appBar: theme.createAppBar(
        title: widget.contestTitle ?? 'Number Caller',
        titleStyle: theme.appBarTitleStyle.copyWith(fontSize: theme.sp(6)),
      ),
      body: Column(
        children: [
          _buildCurrentNumberDisplay(theme),
          _buildControlPanel(theme),
          _buildNumberGrid(theme),
        ],
      ),
    );
  }

  Widget _buildCurrentNumberDisplay(AppTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: theme.hp(3),
        horizontal: theme.wp(4),
      ),
      margin: EdgeInsets.all(theme.wp(4)),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Current Number',
            style: TextStyle(
              color: Colors.white,
              fontSize: theme.sp(5),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: theme.hp(1)),
          Text(
            _currentNumber?.toString() ?? '-',
            style: TextStyle(
              color: Colors.white,
              fontSize: theme.sp(12),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_isAutoCallingActive) ...[
            SizedBox(height: theme.hp(1)),
            Text(
              'Next number in: $_remainingSeconds seconds',
              style: TextStyle(color: Colors.white70, fontSize: theme.sp(4)),
            ),
          ],
          if (_isManualSelectionMode) ...[
            SizedBox(height: theme.hp(1)),
            Text(
              'Manual Selection Mode',
              style: TextStyle(
                color: Colors.white70,
                fontSize: theme.sp(4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControlPanel(AppTheme theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.wp(4)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout based on available width
          if (constraints.maxWidth > 600) {
            // For wider screens, show all buttons in a row
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildAutoButton(theme)),
                SizedBox(width: theme.wp(2)),
                Expanded(child: _buildManualModeButton(theme)),
                SizedBox(width: theme.wp(2)),
                Expanded(child: _buildNextNumberButton(theme)),
                SizedBox(width: theme.wp(2)),
                Expanded(child: _buildResetButton(theme)),
              ],
            );
          } else {
            // For narrower screens, show buttons in two rows
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildAutoButton(theme)),
                    SizedBox(width: theme.wp(2)),
                    Expanded(child: _buildManualModeButton(theme)),
                  ],
                ),
                SizedBox(height: theme.hp(1)),
                Row(
                  children: [
                    Expanded(child: _buildNextNumberButton(theme)),
                    SizedBox(width: theme.wp(2)),
                    Expanded(child: _buildResetButton(theme)),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildAutoButton(AppTheme theme) {
    return ElevatedButton.icon(
      onPressed: _isAutoCallingActive ? _stopAutoCalling : _startAutoCalling,
      icon: Icon(
        _isAutoCallingActive ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
      ),
      label: Text(
        _isAutoCallingActive ? 'Stop Auto' : 'Start Auto',
        style: TextStyle(color: Colors.white, fontSize: theme.sp(4)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _isAutoCallingActive ? Colors.orange : theme.primaryColor,
        padding: EdgeInsets.symmetric(vertical: theme.hp(1.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildManualModeButton(AppTheme theme) {
    return ElevatedButton.icon(
      onPressed: _toggleManualSelectionMode,
      icon: Icon(
        _isManualSelectionMode ? Icons.touch_app : Icons.pan_tool,
        color: Colors.white,
      ),
      label: Text(
        _isManualSelectionMode ? 'Exit Manual' : 'Manual Mode',
        style: TextStyle(color: Colors.white, fontSize: theme.sp(4)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isManualSelectionMode ? Colors.purple : Colors.blue,
        padding: EdgeInsets.symmetric(vertical: theme.hp(1.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildNextNumberButton(AppTheme theme) {
    return ElevatedButton.icon(
      onPressed: _isAutoCallingActive ? null : _callNextNumber,
      icon: const Icon(Icons.arrow_forward, color: Colors.white),
      label: Text(
        'Next Number',
        style: TextStyle(color: Colors.white, fontSize: theme.sp(4)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.textSecondaryColor,
        padding: EdgeInsets.symmetric(vertical: theme.hp(1.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildResetButton(AppTheme theme) {
    return ElevatedButton.icon(
      onPressed: _resetGame,
      icon: const Icon(Icons.refresh, color: Colors.white),
      label: Text(
        'Reset Game',
        style: TextStyle(color: Colors.white, fontSize: theme.sp(4)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(vertical: theme.hp(1.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildNumberGrid(AppTheme theme) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(theme.wp(4)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(theme.wp(2)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 10 : 9,
            childAspectRatio: 1,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: 90,
          itemBuilder: (context, index) {
            final number = index + 1;
            final isCalled = _calledNumbers.contains(number);
            final isCurrentNumber = _currentNumber == number;

            return GestureDetector(
              onTap:
                  _isManualSelectionMode && !isCalled
                      ? () => _setCurrentNumber(number)
                      : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color:
                      isCurrentNumber
                          ? theme.primaryColor
                          : isCalled
                          ? Colors.grey.shade300
                          : _isManualSelectionMode && !isCalled
                          ? Colors.white
                          : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        isCalled
                            ? Colors.grey.shade400
                            : _isManualSelectionMode && !isCalled
                            ? theme.primaryColor
                            : theme.primaryColor.withOpacity(0.5),
                    width:
                        isCurrentNumber || (_isManualSelectionMode && !isCalled)
                            ? 2
                            : 1,
                  ),
                  boxShadow:
                      isCurrentNumber
                          ? [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ]
                          : null,
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      color:
                          isCurrentNumber
                              ? Colors.white
                              : isCalled
                              ? Colors.grey.shade700
                              : _isManualSelectionMode && !isCalled
                              ? theme.primaryColor
                              : theme.textPrimaryColor,
                      fontWeight:
                          isCurrentNumber ||
                                  isCalled ||
                                  (_isManualSelectionMode && !isCalled)
                              ? FontWeight.bold
                              : FontWeight.normal,
                      fontSize: theme.sp(3.5),
                      decoration:
                          isCalled && !isCurrentNumber
                              ? TextDecoration.lineThrough
                              : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
