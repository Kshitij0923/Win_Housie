import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tambola/Provider/Modal/transaction_modal.dart';

class WalletService {
  final String baseUrl = 'https://ae12-103-175-140-106.ngrok-free.app/api';

  Future<Map<String, dynamic>> fetchWalletData(String token) async {
    try {
      debugPrint(
        'Fetching wallet data with token: ${token.substring(0, 20)}...',
      );

      final response = await http.get(
        Uri.parse('$baseUrl/wallet/fetching_wallet'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('Response: ${response.body}');
        final data = json.decode(response.body);

        // Process the wallet data
        Map<String, dynamic> processedData = {
          'coins': 0,
          'tickets': 0,
          'transactions': [],
          'userTickets': [],
        };

        // Extract wallet data from the response
        if (data['data'] != null) {
          // The data structure has changed - wallet data is directly in data['data'], not in an array
          final walletData = data['data'];
          processedData['coins'] = walletData['Balance'] ?? 0;

          // Add debug logs
          debugPrint('Balance: ${walletData['Balance']}');

          // If there are transactions in the response, add them
          if (walletData['transaction_history'] != null &&
              walletData['transaction_history'] is List) {
            processedData['transactions'] = walletData['transaction_history'];
          }

          // If there are tickets in the response, add them
          if (walletData['ticket_history'] != null &&
              walletData['ticket_history'] is List) {
            processedData['userTickets'] = walletData['ticket_history'];
          }
        }

        return processedData;
      } else {
        debugPrint('Error fetching wallet data: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception('Failed to load wallet data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception in fetchWalletData: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Map<String, dynamic>> verifyPayment(
    String token,
    String paymentId,
    String orderId,
    String signature,
  ) async {
    final url = Uri.parse(
      "https://9869-103-175-140-106.ngrok-free.app/api/wallet/add_money",
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'payment_id': paymentId,
        'order_id': orderId,
        'signature': signature,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to verify payment");
    }
  }

  // Update the addMoney method to include wallet ID
  Future<Map<String, dynamic>> addMoney(
    String token,
    int amount,
    String phone,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wallet/add_money'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'amount': amount,
          'phone': phone,
          // wallet_id removed as it's no longer required
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        debugPrint('Error adding money: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception(data['message'] ?? 'Failed to add money to wallet');
      }
    } catch (e) {
      debugPrint('Exception in addMoney: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }

  List<Transaction> parseTransactions(List<dynamic> transactionsData) {
    return transactionsData.map((transaction) {
      return Transaction(
        id: transaction['id'] ?? '',
        type: _parseTransactionType(transaction['type'] ?? 'purchase'),
        amount: transaction['amount'] ?? 0,
        date:
            transaction['date'] != null
                ? DateTime.parse(transaction['date'])
                : DateTime.now(),
        status: _parseTransactionStatus(transaction['status'] ?? 'completed'),
        description: transaction['description'] ?? 'Transaction',
      );
    }).toList();
  }

  TransactionType _parseTransactionType(String type) {
    switch (type.toLowerCase()) {
      case 'deposit':
        return TransactionType.deposit;
      case 'withdrawal':
        return TransactionType.withdrawal;
      case 'gameplay':
        return TransactionType.gamePlay;
      case 'reward':
        return TransactionType.reward;
      case 'purchase':
      default:
        return TransactionType.purchase;
    }
  }

  TransactionStatus _parseTransactionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TransactionStatus.pending;
      case 'failed':
        return TransactionStatus.failed;
      case 'completed':
      default:
        return TransactionStatus.completed;
    }
  }

  List<Ticket> parseTickets(List<dynamic> ticketsData) {
    return ticketsData.map((ticket) {
      return Ticket(
        id: ticket['id'] ?? '',
        gameId: ticket['gameId'] ?? '',
        purchaseDate:
            ticket['purchaseDate'] != null
                ? DateTime.parse(ticket['purchaseDate'])
                : DateTime.now(),
        expiryDate:
            ticket['expiryDate'] != null
                ? DateTime.parse(ticket['expiryDate'])
                : DateTime.now().add(const Duration(days: 30)),
        isUsed: ticket['isUsed'] ?? false,
        gameName: ticket['gameName'] ?? 'Game',
      );
    }).toList();
  }
}
