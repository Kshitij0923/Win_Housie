import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tambola/Provider/Controller/wallet_service.dart';

class PaymentService {
  late Razorpay _razorpay;
  final WalletService _walletService = WalletService();
  final String baseUrl = 'https://ae12-103-175-140-106.ngrok-free.app/api';

  // Callback functions
  Function(PaymentSuccessResponse)? onPaymentSuccess;
  Function(PaymentFailureResponse)? onPaymentError;
  Function(ExternalWalletResponse)? onExternalWallet;

  PaymentService() {
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("✅ Payment Successful");
    debugPrint("Payment ID: ${response.paymentId}");
    debugPrint("Order ID: ${response.orderId}");
    debugPrint("Signature: ${response.signature}");

    if (onPaymentSuccess != null) {
      onPaymentSuccess!(response);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("❌ Payment Failed");
    debugPrint("Code: ${response.code}");
    debugPrint("Message: ${response.message}");

    if (onPaymentError != null) {
      onPaymentError!(response);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("💼 External Wallet: ${response.walletName}");

    if (onExternalWallet != null) {
      onExternalWallet!(response);
    }
  }

  // Modified to directly hit create_order API
  Future<void> processDeposit({
    required String authToken,
    required double amount,
    required String phone,
    required String userName,
  }) async {
    try {
      final orderData = await _createOrder(authToken, amount.toInt(), phone);

      final orderId = orderData['data']?['id'];
      if (orderId == null) {
        throw Exception(
          'Failed to create payment order: Order ID not found in response',
        );
      }

      debugPrint('Order created successfully with ID: $orderId');
      // Start Razorpay payment
      var options = {
        'key':
            'rzp_test_qowkqRrk2lGWzJ', // Replace with your actual Razorpay key
        'amount': (amount * 100).toInt(), // Razorpay expects amount in paise
        'name': 'Tambola',
        'order_id': orderId,
        'description': 'Add money to wallet',
        'prefill': {'contact': phone, 'name': userName},
        'theme': {'color': '#3399cc'},
      };
      debugPrint('Payment options: $options');

      _razorpay.open(options);
      debugPrint('Razorpay opened with options: $options');
    } catch (e) {
      debugPrint("Payment processing error: $e");
      throw Exception('Payment processing error: $e');
    }
  }

  Future<Map<String, dynamic>> _createOrder(
    String authToken,
    int amount,
    String phone,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/wallet/make_request');

      debugPrint('Creating order with amount: $amount, phone: $phone');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({'amount': amount, 'phone': phone}),
      );

      debugPrint('Create order response status: ${response.statusCode}');
      debugPrint('Create order response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      debugPrint('Exception in _createOrder: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  Future<bool> addMoneyToWallet({
    required String authToken,
    required double amount,
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    try {
      final url = Uri.parse(
        'https://ae12-103-175-140-106.ngrok-free.app/api/wallet/add_money',
      );

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': amount,
          'payment_id': paymentId,
          'order_id': orderId,
          'signature': signature,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        debugPrint('Failed to add money: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Add money API error: $e');
      return false;
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
