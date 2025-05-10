import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tambola/Screens/ticket_screen.dart';

class HousieTicketsScreen extends StatefulWidget {
  const HousieTicketsScreen({super.key});

  @override
  _HousieTicketsScreenState createState() => _HousieTicketsScreenState();
}

class _HousieTicketsScreenState extends State<HousieTicketsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Selected ticket quantity
  Map<String, int> _ticketQuantities = {'100': 0, '200': 0, '500': 0};

  // Available ticket types with their details
  final List<Map<String, dynamic>> _ticketTypes = [
    {
      'price': '100',
      'name': 'Basic Ticket',
      'color': const Color.fromARGB(255, 245, 166, 48),
      'prizes': ['Early Five: ₹500', 'Full Row: ₹1,000', 'Full House: ₹2,500'],
      //'image': 'assets/images/basic_ticket.png',
      'description':
          'Perfect for beginners. Get started with your Housie journey!',
      'popular': false,
    },
    {
      'price': '200',
      'name': 'Premium Ticket',
      'color': Colors.purple,
      'prizes': [
        'Early Five: ₹1,000',
        'Full Row: ₹2,000',
        'Full House: ₹5,000',
      ],
      //'image': 'assets/images/premium_ticket.png',
      'description': 'Higher prizes with better winning odds!',
      'popular': true,
    },
    {
      'price': '500',
      'name': 'VIP Ticket',
      'color': Colors.amber,
      'prizes': [
        'Early Five: ₹2,500',
        'Full Row: ₹5,000',
        'Full House: ₹10,000',
        'Special Jackpot: ₹25,000',
      ],
      // 'image': 'assets/images/vip_ticket.png',
      'description': 'Exclusive access to special prizes & jackpots!',
      'popular': false,
    },
  ];

  // Selected contest
  String _selectedContest = 'Weekend Special';

  // Available contests
  final List<String> _contests = [
    'Weekend Special',
    'Sunday Mega',
    'Premium League',
  ];

  // Selected ticket ID for preview
  // String? _previewTicketPrice;

  // Calculate total amount
  int get _totalAmount {
    int total = 0;
    _ticketQuantities.forEach((price, quantity) {
      total += int.parse(price) * quantity;
    });
    return total;
  }

  // Calculate total tickets
  int get _totalTickets {
    int total = 0;
    _ticketQuantities.forEach((price, quantity) {
      total += quantity;
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to update ticket quantity
  void _updateTicketQuantity(String price, int change) {
    setState(() {
      int newQuantity = (_ticketQuantities[price] ?? 0) + change;
      if (newQuantity >= 0 && newQuantity <= 10) {
        _ticketQuantities[price] = newQuantity;
      }
    });
  }

  // Show ticket preview
  void _showTicketPreview(String price) {
    setState(() {
      // _previewTicketPrice = price;
    });

    // Generate sample tickets
    Map<String, dynamic> selectedTicket = _ticketTypes.firstWhere(
      (ticket) => ticket['price'] == price,
    );

    // Show bottom sheet with ticket preview
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildTicketPreviewSheet(context, selectedTicket),
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
                        children: [
                          Text(
                            'Buy Tickets',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Select your tickets for the game',
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
                          Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '8:00 PM',
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

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contest selection
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.purple[800]!.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SELECT CONTEST',
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
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.purple[500]!.withValues(
                                    alpha: 0.5,
                                  ),
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
                                items:
                                    _contests.map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Text(value),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.purple.withValues(alpha: 0.2),
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
                                      'Game starts at 8:00 PM. Make sure to buy tickets before 7:45 PM.',
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.purple[800]!.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CONTEST DETAILS',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildContestDetailRow(
                              icon: Icons.calendar_today,
                              label: 'Date',
                              value: 'Today, 8:00 PM',
                            ),
                            _buildContestDetailRow(
                              icon: Icons.group,
                              label: 'Players',
                              value: '128 joined',
                            ),
                            _buildContestDetailRow(
                              icon: Icons.attach_money,
                              label: 'Prize Pool',
                              value: '₹50,000',
                            ),
                            _buildContestDetailRow(
                              icon: Icons.emoji_events,
                              label: 'Max Winners',
                              value: '15',
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Available tickets header
                      const Text(
                        'AVAILABLE TICKETS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Ticket cards
                      ...List.generate(_ticketTypes.length, (index) {
                        final ticket = _ticketTypes[index];
                        final price = ticket['price'] as String;
                        final quantity = _ticketQuantities[price] ?? 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (ticket['color'] as Color).withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Ticket header
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      (ticket['color'] as Color).withValues(
                                        alpha: 0.8,
                                      ),
                                      (ticket['color'] as Color).withValues(
                                        alpha: 0.6,
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
                                          ticket['name'] as String,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          ticket['description'] as String,
                                          style: TextStyle(
                                            fontSize: 10.2,
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (ticket['popular'] as bool)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 3,
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
                                            color: ticket['color'] as Color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Ticket content
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  children: [
                                    // Price section
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.confirmation_number,
                                              color: ticket['color'] as Color,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '₹${ticket['price']}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const Text(
                                              ' / ticket',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Quantity selector
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha: 0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // Minus button
                                              IconButton(
                                                onPressed:
                                                    () => _updateTicketQuantity(
                                                      price,
                                                      -1,
                                                    ),
                                                icon: Icon(
                                                  Icons.remove,
                                                  color:
                                                      quantity > 0
                                                          ? Colors.white
                                                          : Colors.grey,
                                                  size: 20,
                                                ),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                      minWidth: 32,
                                                      minHeight: 32,
                                                    ),
                                              ),
                                              // Quantity
                                              Container(
                                                width: 32,
                                                height: 32,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  quantity.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              // Plus button
                                              IconButton(
                                                onPressed:
                                                    () => _updateTicketQuantity(
                                                      price,
                                                      1,
                                                    ),
                                                icon: Icon(
                                                  Icons.add,
                                                  color:
                                                      quantity < 10
                                                          ? Colors.white
                                                          : Colors.grey,
                                                  size: 20,
                                                ),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                      minWidth: 36,
                                                      minHeight: 36,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    // Prize information
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'PRIZES',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children:
                                              (ticket['prizes'] as List<String>).map((
                                                prize,
                                              ) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: (ticket['color']
                                                            as Color)
                                                        .withValues(alpha: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    border: Border.all(
                                                      color: (ticket['color']
                                                              as Color)
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    prize,
                                                    style: TextStyle(
                                                      color: (ticket['color']
                                                              as Color)
                                                          .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    // Preview button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed:
                                            () => _showTicketPreview(price),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black
                                              .withValues(alpha: 0.4),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            side: BorderSide(
                                              color: (ticket['color'] as Color)
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'PREVIEW TICKET',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      // Contest details
                    ],
                  ),
                ),
              ),

              // Bottom action bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  border: Border(
                    top: BorderSide(
                      color: Colors.purple[900]!.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Total tickets and amount
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total: $_totalTickets tickets',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹$_totalAmount',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Pay button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            _totalTickets > 0
                                ? () {
                                  // Payment process
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          backgroundColor: const Color(
                                            0xFF1E1E2C,
                                          ),
                                          title: const Text(
                                            'Confirm Purchase',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'You are about to purchase $_totalTickets tickets for ₹$_totalAmount.',
                                                style: TextStyle(
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'Proceed with payment?',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () =>
                                                      Navigator.of(
                                                        context,
                                                      ).pop(),
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                  color: Colors.grey[400],
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
                                                style: TextStyle(
                                                  color: Colors.purple[300],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[600],
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.purple[900]!
                              .withValues(alpha: 0.3),
                          disabledForegroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'BUY TICKETS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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

  Widget _buildContestDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.purple[900]!.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.purple[300], size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketPreviewSheet(
    BuildContext context,
    Map<String, dynamic> ticket,
  ) {
    // Generate a sample ticket with random numbers
    List<List<int?>> sampleTicket = _generateSampleTicket();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${ticket['name']} (₹${ticket['price']})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Ticket preview
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (ticket['color'] as Color).withValues(alpha: 0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // Ticket header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (ticket['color'] as Color),
                        (ticket['color'] as Color).withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Weekend Housie',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Ticket #${1000 + (ticket['price'] as String).hashCode % 9000}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Ticket numbers
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: List.generate(3, (row) {
                      return Row(
                        children: List.generate(9, (col) {
                          final number = sampleTicket[row][col];

                          return Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child:
                                      number != null
                                          ? Text(
                                            number.toString(),
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          )
                                          : const SizedBox(),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),

                // Ticket footer
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today, 8:00 PM',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            size: 14,
                            color: (ticket['color'] as Color),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Prize: ₹${(ticket['prizes'] as List).last.toString().split('₹').last}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: (ticket['color'] as Color),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Instructions
          Padding(
            padding: const EdgeInsets.all(16),
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
                _buildInstructionItem(
                  icon: Icons.check_circle_outline,
                  text: 'Numbers will be called out randomly during the game.',
                ),
                _buildInstructionItem(
                  icon: Icons.check_circle_outline,
                  text: 'Mark the numbers on your ticket as they are called.',
                ),
                _buildInstructionItem(
                  icon: Icons.check_circle_outline,
                  text: 'Claim prizes for Early Five, Full Row, or Full House.',
                ),
                _buildInstructionItem(
                  icon: Icons.check_circle_outline,
                  text: 'Multiple tickets increase your chances of winning!',
                ),
              ],
            ),
          ),

          // Add to cart button
          Padding(
            padding: const EdgeInsets.all(
              16,
            ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Add ticket to cart
                  final price = ticket['price'] as String;
                  _updateTicketQuantity(price, 1);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ticket['color'] as Color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'ADD TO CART',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.purple[300], size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Generate a sample housie ticket with random numbers
  List<List<int?>> _generateSampleTicket() {
    // Create a 3x9 grid with null values
    List<List<int?>> ticket = List.generate(3, (_) => List.filled(9, null));

    // Each row should have exactly 5 numbers
    for (int row = 0; row < 3; row++) {
      // Randomly select 5 columns for this row
      List<int> selectedCols = List.generate(9, (i) => i)..shuffle();
      selectedCols = selectedCols.sublist(0, 5);

      // Fill selected columns with random numbers
      for (int col in selectedCols) {
        // Each column has a specific range
        int min = col * 10 + 1;
        int max = (col == 8) ? 90 : (col + 1) * 10;

        // Generate a random number in the column's range
        ticket[row][col] =
            min + (DateTime.now().millisecondsSinceEpoch % (max - min + 1));
      }
    }

    // Sort each column
    for (int col = 0; col < 9; col++) {
      List<int?> column = [ticket[0][col], ticket[1][col], ticket[2][col]];
      column.sort((a, b) {
        if (a == null) return 1;
        if (b == null) return -1;
        return a.compareTo(b);
      });

      for (int row = 0; row < 3; row++) {
        ticket[row][col] = column[row];
      }
    }

    return ticket;
  }

  // Show payment success dialog
  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xFF1E1E2C),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Lottie.asset(
                    'assets/Animation.json',
                    repeat: false,
                    controller: _animationController,
                    onLoaded: (composition) {
                      _animationController
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Purchase Successful!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'You have successfully purchased $_totalTickets tickets for the $_selectedContest contest.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyTicketsScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'VIEW MY TICKETS',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'BACK TO HOME',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
    );
  }
}
