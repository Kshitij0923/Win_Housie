import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

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
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Compete with other players',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Leaderboard Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.purple[600],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Weekly',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Monthly',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'All Time',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Top 3 Players
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 2nd Place
                    _buildTopPlayer(
                      rank: 2,
                      name: 'Alex',
                      points: '2,450',
                      color: Colors.grey[400]!,
                      height: 100,
                    ),
                    
                    // 1st Place
                    _buildTopPlayer(
                      rank: 1,
                      name: 'Sarah',
                      points: '3,120',
                      color: Colors.amber[400]!,
                      height: 130,
                      isFirst: true,
                    ),
                    
                    // 3rd Place
                    _buildTopPlayer(
                      rank: 3,
                      name: 'Mike',
                      points: '1,890',
                      color: Colors.brown[400]!,
                      height: 80,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Leaderboard List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: [
                        _buildLeaderboardItem(4, 'David', '1,780', false),
                        _buildLeaderboardItem(5, 'Emma', '1,650', false),
                        _buildLeaderboardItem(6, 'John', '1,520', true),
                        _buildLeaderboardItem(7, 'Lisa', '1,340', false),
                        _buildLeaderboardItem(8, 'Kevin', '1,290', false),
                        _buildLeaderboardItem(9, 'Olivia', '1,150', false),
                        _buildLeaderboardItem(10, 'Ryan', '980', false),
                      ],
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

  Widget _buildTopPlayer({
    required int rank,
    required String name,
    required String points,
    required Color color,
    required double height,
    bool isFirst = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown for 1st place
        if (isFirst)
          Icon(
            Icons.emoji_events,
            color: Colors.amber[400],
            size: 24,
          ),
        const SizedBox(height: 8),
        
        // Avatar
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: isFirst ? 70 : 60,
              height: isFirst ? 70 : 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.7),
                  ],
                ),
                border: Border.all(
                  color: isFirst ? Colors.amber[300]! : color.withOpacity(0.5),
                  width: isFirst ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isFirst ? 20 : 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Name
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isFirst ? FontWeight.bold : FontWeight.w500,
            fontSize: isFirst ? 16 : 14,
          ),
        ),
        
        // Points
        Text(
          '$points pts',
          style: TextStyle(
            color: isFirst ? Colors.amber[300] : Colors.grey[400],
            fontWeight: FontWeight.w500,
            fontSize: isFirst ? 14 : 12,
          ),
        ),
        
        // Podium
        const SizedBox(height: 8),
        Container(
          width: isFirst ? 80 : 70,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.7),
                color.withOpacity(0.9),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(int rank, String name, String points, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.purple.withOpacity(0.2) : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: Colors.purple[400]!, width: 1)
            : null,
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.purple[600] : Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Avatar placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Name and points
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.grey[300],
                    fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$points points',
                  style: TextStyle(
                    color: isCurrentUser ? Colors.purple[300] : Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Badge for current user
          if (isCurrentUser)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'YOU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}