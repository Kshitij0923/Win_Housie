import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tambola/Theme/app_theme.dart';

class WalletScreen extends StatefulWidget {
  final int coins;
  final int tickets;
  final List<Transaction> recentTransactions;

  const WalletScreen({
    super.key,
    this.coins = 0,
    this.tickets = 0,
    this.recentTransactions = const [],
  });

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showBalance = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    theme.init(context);
    final Color baseColor = theme.cardColor;
    final Color shadowDark = Colors.black;
    final Color shadowLight = theme.primaryColor.withValues(alpha: 0.3);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(theme),
              SizedBox(height: theme.hp(2)),
              _buildWalletBalance(theme, baseColor, shadowDark, shadowLight),
              SizedBox(height: theme.hp(3)),
              _buildQuickActions(theme, baseColor, shadowDark, shadowLight),
              SizedBox(height: theme.hp(3)),
              _buildTabBar(theme),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTransactionsTab(
                      theme,
                      baseColor,
                      shadowDark,
                      shadowLight,
                    ),
                    _buildTicketsTab(theme, baseColor, shadowDark, shadowLight),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AppTheme theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.wp(4), // Adjust as needed
        vertical: theme.hp(1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(theme.wp(2)),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(theme.wp(2.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 5,
                  ),
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    offset: const Offset(-2, -2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: theme.textPrimaryColor,
                size: theme.wp(5),
              ),
            ),
          ),
          Text('My Wallet', style: theme.subheadingStyle),
          GestureDetector(
            onTap: () {
              // Show wallet settings or history
            },
            child: Container(
              padding: EdgeInsets.all(theme.wp(2)),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(theme.wp(2.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 5,
                  ),
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    offset: const Offset(-2, -2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color: theme.textPrimaryColor,
                size: theme.wp(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletBalance(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.wp(5)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(theme.wp(5)),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: theme.cardBorderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [baseColor, theme.primaryColor.withValues(alpha: 0.2)],
          ),
          boxShadow: [
            BoxShadow(
              color: shadowDark.withValues(alpha: 0.7),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Balance', style: theme.captionStyle),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showBalance = !_showBalance;
                    });
                  },
                  child: Icon(
                    _showBalance ? Icons.visibility_off : Icons.visibility,
                    color: theme.textSecondaryColor,
                    size: theme.wp(5),
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.hp(1)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _showBalance ? '${widget.coins}' : '•••••',
                  style: GoogleFonts.poppins(
                    fontSize: theme.sp(10),
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimaryColor,
                  ),
                ),
                SizedBox(width: theme.wp(2)),
                Padding(
                  padding: EdgeInsets.only(bottom: theme.hp(1)),
                  child: Text(
                    'Coins',
                    style: theme.bodyStyle.copyWith(
                      color: theme.textSecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.hp(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBalanceCard(
                  theme,
                  baseColor,
                  shadowDark,
                  shadowLight,
                  icon: Icons.confirmation_number_rounded,
                  title: 'Tickets',
                  value: widget.tickets.toString(),
                  iconColor: theme.accentColor,
                ),
                _buildBalanceCard(
                  theme,
                  baseColor,
                  shadowDark,
                  shadowLight,
                  icon: Icons.trending_up_rounded,
                  title: 'Winnings',
                  value: '${widget.coins ~/ 10}',
                  iconColor: theme.successColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight, {
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      width: theme.wp(40),
      padding: EdgeInsets.all(theme.wp(3)),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(theme.wp(3)),
        boxShadow: [
          BoxShadow(
            color: shadowDark.withValues(alpha: 0.5),
            offset: const Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: shadowLight.withValues(alpha: 0.5),
            offset: const Offset(-2, -2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(theme.wp(2)),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(theme.wp(2)),
            ),
            child: Icon(icon, color: iconColor, size: theme.wp(5)),
          ),
          SizedBox(width: theme.wp(2)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.captionStyle),
              SizedBox(height: theme.hp(0.5)),
              Text(
                _showBalance ? value : '•••',
                style: GoogleFonts.poppins(
                  fontSize: theme.sp(4.5),
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.wp(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            icon: Icons.add_rounded,
            label: 'Add Coins',
            color: theme.primaryColor,
            onTap: () {
              // Add coins action
            },
          ),
          _buildActionButton(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            icon: Icons.shopping_cart_rounded,
            label: 'Buy Tickets',
            color: theme.accentColor,
            onTap: () {
              // Buy tickets action
            },
          ),
          _buildActionButton(
            theme,
            baseColor,
            shadowDark,
            shadowLight,
            icon: Icons.account_balance_wallet_rounded,
            label: 'Withdraw',
            color: theme.infoColor,
            onTap: () {
              // Withdraw action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(theme.wp(4)),
            decoration: BoxDecoration(
              color: baseColor,
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [baseColor, color.withValues(alpha: 0.15)],
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowDark.withValues(alpha: 0.7),
                  offset: const Offset(3, 3),
                  blurRadius: 6,
                ),
                BoxShadow(
                  color: shadowLight,
                  offset: const Offset(-3, -3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: theme.wp(6)),
          ),
          SizedBox(height: theme.hp(1)),
          Text(label, style: theme.captionStyle),
        ],
      ),
    );
  }

  Widget _buildTabBar(AppTheme theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.wp(5)),
      child: Container(
        height: theme.hp(6),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(theme.wp(3)),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.wp(3)),
            color: theme.primaryColor,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: theme.textSecondaryColor,
          labelStyle: GoogleFonts.poppins(
            fontSize: theme.sp(3.8),
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: theme.sp(3.8),
            fontWeight: FontWeight.w500,
          ),
          tabs: const [Tab(text: 'Transactions'), Tab(text: 'Tickets')],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    final transactions =
        widget.recentTransactions.isEmpty
            ? [
              Transaction(
                id: '1',
                type: TransactionType.deposit,
                amount: 500,
                date: DateTime.now().subtract(const Duration(days: 1)),
                status: TransactionStatus.completed,
                description: 'Added coins',
              ),
              Transaction(
                id: '2',
                type: TransactionType.gamePlay,
                amount: -100,
                date: DateTime.now().subtract(const Duration(days: 2)),
                status: TransactionStatus.completed,
                description: 'Game entry fee',
              ),
              Transaction(
                id: '3',
                type: TransactionType.reward,
                amount: 250,
                date: DateTime.now().subtract(const Duration(days: 3)),
                status: TransactionStatus.completed,
                description: 'Game winnings',
              ),
              Transaction(
                id: '4',
                type: TransactionType.purchase,
                amount: -50,
                date: DateTime.now().subtract(const Duration(days: 5)),
                status: TransactionStatus.completed,
                description: 'Purchased 5 tickets',
              ),
              Transaction(
                id: '5',
                type: TransactionType.withdrawal,
                amount: -200,
                date: DateTime.now().subtract(const Duration(days: 7)),
                status: TransactionStatus.pending,
                description: 'Withdrawal to bank account',
              ),
            ]
            : widget.recentTransactions;

    return Padding(
      padding: EdgeInsets.only(top: theme.hp(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.wp(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: theme.bodyStyle.copyWith(fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    // View all transactions
                  },
                  child: Text(
                    'View All',
                    style: theme.linkStyle.copyWith(fontSize: theme.sp(3.5)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.hp(1)),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: theme.wp(5)),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionItem(
                  theme,
                  baseColor,
                  shadowDark,
                  shadowLight,
                  transaction,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
    Transaction transaction,
  ) {
    final isPositive = transaction.amount > 0;
    final iconData = _getTransactionIcon(transaction.type);
    final iconColor = _getTransactionColor(transaction.type, theme);
    final statusColor =
        transaction.status == TransactionStatus.completed
            ? theme.successColor
            : transaction.status == TransactionStatus.pending
            ? theme.warningColor
            : theme.errorColor;

    return Container(
      margin: EdgeInsets.only(bottom: theme.hp(1.5)),
      padding: EdgeInsets.all(theme.wp(3)),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: theme.cardBorderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowDark.withValues(alpha: 0.5),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: shadowLight.withValues(alpha: 0.3),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(theme.wp(2.5)),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(theme.wp(2)),
            ),
            child: Icon(iconData, color: iconColor, size: theme.wp(5)),
          ),
          SizedBox(width: theme.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: theme.bodyStyle.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: theme.hp(0.5)),
                Row(
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(transaction.date),
                      style: theme.captionStyle,
                    ),
                    SizedBox(width: theme.wp(2)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.wp(1.5),
                        vertical: theme.hp(0.3),
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(theme.wp(1)),
                      ),
                      child: Text(
                        transaction.status.name.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: theme.sp(2.5),
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${transaction.amount}',
            style: GoogleFonts.poppins(
              fontSize: theme.sp(4.5),
              fontWeight: FontWeight.bold,
              color: isPositive ? theme.successColor : theme.errorColor,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return Icons.add_circle_outline_rounded;
      case TransactionType.withdrawal:
        return Icons.money_off_csred_rounded;
      case TransactionType.gamePlay:
        return Icons.videogame_asset_rounded;
      case TransactionType.reward:
        return Icons.emoji_events_rounded;
      case TransactionType.purchase:
        return Icons.shopping_cart_rounded;
    }
  }

  Color _getTransactionColor(TransactionType type, AppTheme theme) {
    switch (type) {
      case TransactionType.deposit:
        return theme.successColor;
      case TransactionType.withdrawal:
        return theme.errorColor;
      case TransactionType.gamePlay:
        return theme.primaryColor;
      case TransactionType.reward:
        return theme.warningColor;
      case TransactionType.purchase:
        return theme.accentColor;
    }
  }

  Widget _buildTicketsTab(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    // Sample ticket data
    final tickets = [
      Ticket(
        id: '1',
        gameId: 'G001',
        purchaseDate: DateTime.now().subtract(const Duration(days: 1)),
        expiryDate: DateTime.now().add(const Duration(days: 30)),
        isUsed: false,
        gameName: 'Mega Jackpot',
      ),
      Ticket(
        id: '2',
        gameId: 'G002',
        purchaseDate: DateTime.now().subtract(const Duration(days: 3)),
        expiryDate: DateTime.now().add(const Duration(days: 27)),
        isUsed: false,
        gameName: 'Lucky Draw',
      ),
      Ticket(
        id: '3',
        gameId: 'G001',
        purchaseDate: DateTime.now().subtract(const Duration(days: 5)),
        expiryDate: DateTime.now().add(const Duration(days: 25)),
        isUsed: true,
        gameName: 'Mega Jackpot',
      ),
    ];

    return Padding(
      padding: EdgeInsets.only(top: theme.hp(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.wp(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Tickets',
                  style: theme.bodyStyle.copyWith(fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    // Buy more tickets
                  },
                  child: Text(
                    'Buy More',
                    style: theme.linkStyle.copyWith(fontSize: theme.sp(3.5)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.hp(1)),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: theme.wp(5)),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketItem(
                  theme,
                  baseColor,
                  shadowDark,
                  shadowLight,
                  ticket,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketItem(
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
    Ticket ticket,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: theme.hp(2)),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: theme.cardBorderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowDark.withValues(alpha: 0.5),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: shadowLight.withValues(alpha: 0.3),
            offset: const Offset(-3, -3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(theme.wp(4)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primaryColor.withValues(alpha: 0.8),
                  theme.accentColor.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(theme.wp(3)),
                topRight: Radius.circular(theme.wp(3)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.gameName,
                      style: GoogleFonts.poppins(
                        fontSize: theme.sp(4.5),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: theme.hp(0.5)),
                    Text(
                      'Ticket #${ticket.id}',
                      style: GoogleFonts.poppins(
                        fontSize: theme.sp(3.5),
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.wp(3),
                    vertical: theme.hp(0.7),
                  ),
                  decoration: BoxDecoration(
                    color:
                        ticket.isUsed
                            ? theme.errorColor.withValues(alpha: 0.2)
                            : theme.successColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(theme.wp(5)),
                    border: Border.all(
                      color:
                          ticket.isUsed ? theme.errorColor : theme.successColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    ticket.isUsed ? 'USED' : 'ACTIVE',
                    style: GoogleFonts.poppins(
                      fontSize: theme.sp(3),
                      fontWeight: FontWeight.bold,
                      color:
                          ticket.isUsed ? theme.errorColor : theme.successColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(theme.wp(4)),
            child: Column(
              children: [
                _buildTicketInfoRow(
                  theme,
                  'Game ID',
                  ticket.gameId,
                  Icons.games_rounded,
                ),
                SizedBox(height: theme.hp(1.5)),
                _buildTicketInfoRow(
                  theme,
                  'Purchase Date',
                  DateFormat('MMM dd, yyyy').format(ticket.purchaseDate),
                  Icons.calendar_today_rounded,
                ),
                SizedBox(height: theme.hp(1.5)),
                _buildTicketInfoRow(
                  theme,
                  'Expiry Date',
                  DateFormat('MMM dd, yyyy').format(ticket.expiryDate),
                  Icons.timer_rounded,
                ),
                SizedBox(height: theme.hp(2)),
                if (!ticket.isUsed)
                  ElevatedButton(
                    onPressed: () {
                      // Use ticket action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: theme.hp(1.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(theme.wp(2.5)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: theme.wp(5)),
                        SizedBox(width: theme.wp(2)),
                        Text(
                          'Play Now',
                          style: GoogleFonts.poppins(
                            fontSize: theme.sp(4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfoRow(
    AppTheme theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: theme.textSecondaryColor, size: theme.wp(4.5)),
        SizedBox(width: theme.wp(3)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.captionStyle),
            SizedBox(height: theme.hp(0.3)),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: theme.sp(4),
                fontWeight: FontWeight.w500,
                color: theme.textPrimaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Models for the wallet screen
enum TransactionType { deposit, withdrawal, gamePlay, reward, purchase }

enum TransactionStatus { completed, pending, failed }

class Transaction {
  final String id;
  final TransactionType type;
  final int amount;
  final DateTime date;
  final TransactionStatus status;
  final String description;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
    required this.description,
  });
}

class Ticket {
  final String id;
  final String gameId;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final bool isUsed;
  final String gameName;

  Ticket({
    required this.id,
    required this.gameId,
    required this.purchaseDate,
    required this.expiryDate,
    required this.isUsed,
    required this.gameName,
  });
}
