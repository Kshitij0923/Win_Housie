import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tambola/Theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';

// Define GameSession class and GameStatus enum
enum GameStatus { active, completed, cancelled }

class GameSession {
  final String id;
  final DateTime date;
  final int playerCount;
  final double revenue;
  final GameStatus status;

  GameSession({
    required this.id,
    required this.date,
    required this.playerCount,
    required this.revenue,
    required this.status,
  });
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  bool _isGameActive = false;
  int _currentNumber = 0;
  List<int> _calledNumbers = [];
  final List<int> _allNumbers = List.generate(90, (index) => index + 1);

  // Sample data for statistics
  final Map<String, double> _revenueData = {
    'Mon': 2500,
    'Tue': 3200,
    'Wed': 4100,
    'Thu': 3800,
    'Fri': 5200,
    'Sat': 6100,
    'Sun': 5800,
  };

  final Map<String, int> _playerStats = {
    'Total Players': 1250,
    'Active Players': 780,
    'New Today': 45,
    'Premium Users': 320,
  };

  final List<GameSession> _recentGames = [
    GameSession(
      id: 'G001',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      playerCount: 78,
      revenue: 7800,
      status: GameStatus.completed,
    ),
    GameSession(
      id: 'G002',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      playerCount: 65,
      revenue: 6500,
      status: GameStatus.completed,
    ),
    GameSession(
      id: 'G003',
      date: DateTime.now().subtract(const Duration(days: 1)),
      playerCount: 92,
      revenue: 9200,
      status: GameStatus.completed,
    ),
  ];

  void _startNewGame() {
    setState(() {
      _isGameActive = true;
      _currentNumber = 0;
      _calledNumbers = [];
    });
  }

  void _generateNextNumber() {
    if (_calledNumbers.length >= 90) {
      // All numbers have been called
      setState(() {
        _isGameActive = false;
      });
      return;
    }
    // Generate a random number that hasn't been called yet
    List<int> remainingNumbers =
        _allNumbers.where((num) => !_calledNumbers.contains(num)).toList();
    remainingNumbers.shuffle();

    setState(() {
      _currentNumber = remainingNumbers.first;
      _calledNumbers.add(_currentNumber);
    });
  }

  void _endGame() {
    setState(() {
      _isGameActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();

    // Base colors for neumorphic design
    final Color baseColor = Colors.grey[900]!;
    final Color shadowDark = Colors.black;
    final Color shadowLight = theme.primaryColor.withOpacity(0.3);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Admin Dashboard', style: theme.headingStyle),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Show settings
            },
          ),
        ],
      ),
      drawer: _buildAdminDrawer(theme),
      body: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child:
            _selectedIndex == 0
                ? _buildDashboardContent(
                  theme,
                  baseColor,
                  shadowDark,
                  shadowLight,
                )
                : _selectedIndex == 1
                ? _buildGameManagement(
                  theme,
                  baseColor,
                  shadowDark,
                  shadowLight,
                )
                : _buildPlayerManagement(
                  theme,
                  baseColor,
                  shadowDark,
                  shadowLight,
                ),
      ),
      bottomNavigationBar: _buildBottomNavBar(theme),
    );
  }

  Widget _buildAdminDrawer(AppTheme theme) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme.primaryColor, theme.accentColor],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Admin Panel',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Manage your Housie games',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
              isSelected: _selectedIndex == 0,
              theme: theme,
            ),
            _buildDrawerItem(
              icon: Icons.casino_outlined,
              title: 'Game Management',
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
              isSelected: _selectedIndex == 1,
              theme: theme,
            ),
            _buildDrawerItem(
              icon: Icons.people_outline,
              title: 'Player Management',
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
              isSelected: _selectedIndex == 2,
              theme: theme,
            ),
            const Divider(color: Colors.grey),
            _buildDrawerItem(
              icon: Icons.analytics_outlined,
              title: 'Analytics',
              onTap: () {},
              theme: theme,
            ),
            _buildDrawerItem(
              icon: Icons.payments_outlined,
              title: 'Payments',
              onTap: () {},
              theme: theme,
            ),
            _buildDrawerItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {},
              theme: theme,
            ),
            const Divider(color: Colors.grey),
            _buildDrawerItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {},
              theme: theme,
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {},
              theme: theme,
              textColor: theme.errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    required AppTheme theme,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.primaryColor : (textColor ?? Colors.white70),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color:
              isSelected ? theme.primaryColor : (textColor ?? Colors.white70),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: theme.primaryColor.withOpacity(0.15),
    );
  }

  Widget _buildBottomNavBar(AppTheme theme) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      backgroundColor: Colors.black,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
          activeIcon: Icon(Icons.dashboard),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.casino_outlined),
          label: 'Games',
          activeIcon: Icon(Icons.casino),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Players',
          activeIcon: Icon(Icons.people),
        ),
      ],
    );
  }

  Widget _buildDashboardContent(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, Admin!',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Here\'s what\'s happening with your games today',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Quick stats cards
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                theme,
                baseColor,
                shadowDark,
                shadowLight,
                title: 'Total Revenue',
                value: '₹32,450',
                icon: Icons.monetization_on_outlined,
                iconColor: theme.successColor,
              ),
              _buildStatCard(
                theme,
                baseColor,
                shadowDark,
                shadowLight,
                title: 'Active Players',
                value: '780',
                icon: Icons.people_outline,
                iconColor: theme.primaryColor,
              ),
              _buildStatCard(
                theme,
                baseColor,
                shadowDark,
                shadowLight,
                title: 'Games Today',
                value: '12',
                icon: Icons.casino_outlined,
                iconColor: theme.accentColor,
              ),
              _buildStatCard(
                theme,
                baseColor,
                shadowDark,
                shadowLight,
                title: 'Tickets Sold',
                value: '1,245',
                icon: Icons.confirmation_number_outlined,
                iconColor: theme.warningColor,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Revenue chart
          _buildNeumorphicContainer(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Weekly Revenue',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 7000,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipPadding: const EdgeInsets.all(8),
                            tooltipMargin: 8,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String weekDay = '';
                              switch (group.x.toInt()) {
                                case 0:
                                  weekDay = 'Mon';
                                  break;
                                case 1:
                                  weekDay = 'Tue';
                                  break;
                                case 2:
                                  weekDay = 'Wed';
                                  break;
                                case 3:
                                  weekDay = 'Thu';
                                  break;
                                case 4:
                                  weekDay = 'Fri';
                                  break;
                                case 5:
                                  weekDay = 'Sat';
                                  break;
                                case 6:
                                  weekDay = 'Sun';
                                  break;
                              }
                              return BarTooltipItem(
                                '$weekDay\n₹${rod.toY.round()}',
                                GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                String text = '';
                                switch (value.toInt()) {
                                  case 0:
                                    text = 'M';
                                    break;
                                  case 1:
                                  case 2:
                                    text = 'W';
                                    break;
                                  case 3:
                                    text = 'T';
                                    break;
                                  case 4:
                                    text = 'F';
                                    break;
                                  case 5:
                                    text = 'S';
                                    break;
                                  case 6:
                                    text = 'S';
                                    break;
                                }
                                return Text(
                                  text,
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '₹${value.toInt()}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                );
                              },
                              reservedSize: 40,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 1000,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups:
                            _revenueData.entries.map((entry) {
                              final int index = _revenueData.keys
                                  .toList()
                                  .indexOf(entry.key);
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: entry.value,
                                    color: theme.primaryColor,
                                    width: 16,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                    backDrawRodData: BackgroundBarChartRodData(
                                      show: true,
                                      toY: 7000,
                                      color: Colors.grey.withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recent games
          _buildNeumorphicContainer(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Recent Games',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentGames.length,
                  separatorBuilder:
                      (context, index) => Divider(
                        color: Colors.grey.withOpacity(0.2),
                        height: 1,
                      ),
                  itemBuilder: (context, index) {
                    final game = _recentGames[index];
                    return ListTile(
                      title: Text(
                        'Game #${game.id}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${game.playerCount} players • ₹${game.revenue}',
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  game.status == GameStatus.completed
                                      ? theme.successColor.withOpacity(0.2)
                                      : game.status == GameStatus.active
                                      ? theme.warningColor.withOpacity(0.2)
                                      : theme.errorColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              game.status.toString().split('.').last,
                              style: GoogleFonts.poppins(
                                color:
                                    game.status == GameStatus.completed
                                        ? theme.successColor
                                        : game.status == GameStatus.active
                                        ? theme.warningColor
                                        : theme.errorColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(game.date),
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to game details
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      // View all games
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: theme.primaryColor,
                      elevation: 0,
                      side: BorderSide(color: theme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('View All Games', style: GoogleFonts.poppins()),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Player stats
          _buildNeumorphicContainer(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Player Statistics',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2,
                  children:
                      _playerStats.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.value.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameManagement(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Game Management',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Create and manage your Tambola games',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Current game status
          _buildNeumorphicContainer(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Game',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _isGameActive
                                  ? theme.successColor.withOpacity(0.2)
                                  : theme.errorColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _isGameActive ? 'Active' : 'Inactive',
                          style: GoogleFonts.poppins(
                            color:
                                _isGameActive
                                    ? theme.successColor
                                    : theme.errorColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_isGameActive) ...[
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _currentNumber.toString(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Called Numbers: ${_calledNumbers.length}/90',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(90, (index) {
                        final number = index + 1;
                        final isCalled = _calledNumbers.contains(number);
                        return Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color:
                                isCalled
                                    ? theme.primaryColor
                                    : Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              number.toString(),
                              style: GoogleFonts.poppins(
                                color: isCalled ? Colors.white : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _generateNextNumber,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Next Number',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _endGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.errorColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'End Game',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.casino_outlined,
                            size: 80,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No active game',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _startNewGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Start New Game',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Game history
          _buildNeumorphicContainer(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Game History',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentGames.length,
                  separatorBuilder:
                      (context, index) => Divider(
                        color: Colors.grey.withOpacity(0.2),
                        height: 1,
                      ),
                  itemBuilder: (context, index) {
                    final game = _recentGames[index];
                    return ListTile(
                      title: Text(
                        'Game #${game.id}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${game.playerCount} players • ₹${game.revenue}',
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  game.status == GameStatus.completed
                                      ? theme.successColor.withOpacity(0.2)
                                      : game.status == GameStatus.active
                                      ? theme.warningColor.withOpacity(0.2)
                                      : theme.errorColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              game.status.toString().split('.').last,
                              style: GoogleFonts.poppins(
                                color:
                                    game.status == GameStatus.completed
                                        ? theme.successColor
                                        : game.status == GameStatus.active
                                        ? theme.warningColor
                                        : theme.errorColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(game.date),
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to game details
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Game settings
          _buildNeumorphicContainer(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Game Settings',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.timer_outlined,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    'Number Call Interval',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  subtitle: Text(
                    '15 seconds',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    // Open interval settings
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.attach_money_outlined,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    'Ticket Price',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  subtitle: Text(
                    '₹100 per ticket',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    // Open price settings
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.emoji_events_outlined,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    'Prize Configuration',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Early 5, Top Line, Middle Line, Bottom Line, Full House',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    // Open prize settings
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerManagement(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    // Sample player data
    final List<Map<String, dynamic>> players = [
      {
        'name': 'Rahul Sharma',
        'email': 'rahul.s@example.com',
        'tickets': 12,
        'spent': 1200,
        'wins': 3,
        'status': 'active',
      },
      {
        'name': 'Priya Patel',
        'email': 'priya.p@example.com',
        'tickets': 8,
        'spent': 800,
        'wins': 1,
        'status': 'active',
      },
      {
        'name': 'Amit Kumar',
        'email': 'amit.k@example.com',
        'tickets': 20,
        'spent': 2000,
        'wins': 5,
        'status': 'active',
      },
      {
        'name': 'Sneha Gupta',
        'email': 'sneha.g@example.com',
        'tickets': 5,
        'spent': 500,
        'wins': 0,
        'status': 'inactive',
      },
      {
        'name': 'Vikram Singh',
        'email': 'vikram.s@example.com',
        'tickets': 15,
        'spent': 1500,
        'wins': 2,
        'status': 'active',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Player Management',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Manage your player base',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Search and filter
          _buildNeumorphicContainer(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search players...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Status',
                            labelStyle: GoogleFonts.poppins(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                          style: GoogleFonts.poppins(color: Colors.white),
                          dropdownColor: Colors.grey[900],
                          value: 'All',
                          items:
                              ['All', 'Active', 'Inactive']
                                  .map(
                                    (status) => DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Sort By',
                            labelStyle: GoogleFonts.poppins(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                          style: GoogleFonts.poppins(color: Colors.white),
                          dropdownColor: Colors.grey[900],
                          value: 'Name',
                          items:
                              ['Name', 'Tickets', 'Spent', 'Wins']
                                  .map(
                                    (sort) => DropdownMenuItem<String>(
                                      value: sort,
                                      child: Text(sort),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Player list
          _buildNeumorphicContainer(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Players (${players.length})',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: theme.primaryColor,
                        ),
                        onPressed: () {
                          // Add new player
                        },
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: players.length,
                  separatorBuilder:
                      (context, index) => Divider(
                        color: Colors.grey.withOpacity(0.2),
                        height: 1,
                      ),
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.primaryColor.withOpacity(0.2),
                        child: Text(
                          player['name'].substring(0, 1),
                          style: GoogleFonts.poppins(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        player['name'],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        player['email'],
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              player['status'] == 'active'
                                  ? theme.successColor.withOpacity(0.2)
                                  : theme.errorColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          player['status'],
                          style: GoogleFonts.poppins(
                            color:
                                player['status'] == 'active'
                                    ? theme.successColor
                                    : theme.errorColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // Navigate to player details
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        // View all players
                      },
                      child: Text(
                        'View All Players',
                        style: GoogleFonts.poppins(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Player statistics
          _buildNeumorphicContainer(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Player Statistics',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Total Players',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '1,250',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Active Players',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '780',
                              style: GoogleFonts.poppins(
                                color: theme.successColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Premium Players',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '320',
                              style: GoogleFonts.poppins(
                                color: theme.primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      // View detailed analytics
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'View Detailed Analytics',
                      style: GoogleFonts.poppins(),
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

  Widget _buildStatCard(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight, {
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowDark,
            offset: const Offset(5, 5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: shadowLight,
            offset: const Offset(-5, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeumorphicContainer(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight, {
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowDark,
            offset: const Offset(5, 5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: shadowLight,
            offset: const Offset(-5, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
