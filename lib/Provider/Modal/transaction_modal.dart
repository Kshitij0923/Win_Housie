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
