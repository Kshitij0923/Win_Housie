import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tambola/Provider/Controller/payment_service.dart';
import 'package:tambola/Provider/Controller/user_provider.dart';
import 'package:tambola/Theme/app_theme.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // Updated quick amounts to start from 100
  final List<double> _quickAmounts = [100, 200, 500, 1000, 2000];
  double _selectedAmount = 0;
  bool _isProcessing = false;
  final _formKey = GlobalKey<FormState>();
  late PaymentService _paymentService;
  double? amountToAdd;
  String? userWalletId;
  // For payment method selection
  int _selectedPaymentMethodIndex = 0;

  // Minimum deposit amount constant
  final double _minimumDepositAmount = 100;

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService();
    _setupPaymentCallbacks();
  }

  void _setupPaymentCallbacks() {
    _paymentService.onPaymentSuccess = _handlePaymentSuccess;
    _paymentService.onPaymentError = _handlePaymentError;
    _paymentService.onExternalWallet = _handleExternalWallet;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    _paymentService.dispose();
    super.dispose();
  }

  void _selectQuickAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toString();
    });
  }

  Future<void> _processDeposit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isProcessing = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final phone = _phoneController.text;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.authToken;
      final userName = userProvider.username ?? 'User';

      if (token == null) {
        throw Exception('User not authenticated. Please log in again.');
      }

      amountToAdd = amount;
      await _paymentService.processDeposit(
        authToken: token,
        amount: amount,
        phone: phone,
        userName: userName,
      );
    } catch (e) {
      debugPrint("Payment processing error: $e");
      final theme = AppTheme();
      ScaffoldMessenger.of(context).showSnackBar(
        theme.createSnackBar(
          message: 'Payment failed: $e',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final theme = AppTheme();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.authToken;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        theme.createSnackBar(
          message: 'Authentication error. Please log in again.',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    if (amountToAdd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        theme.createSnackBar(
          message: 'Missing wallet information. Please try again.',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final verified = await _paymentService.addMoneyToWallet(
      authToken: token,
      paymentId: response.paymentId ?? '',
      orderId: response.orderId ?? '',
      signature: response.signature ?? '',
      amount: amountToAdd!, // Non-null asserted
    );

    if (verified) {
      ScaffoldMessenger.of(context).showSnackBar(
        theme.createSnackBar(
          message: 'Amount ₹${_amountController.text} deposited successfully!',
          backgroundColor: theme.successColor,
          duration: const Duration(seconds: 3),
        ),
      );
      _amountController.clear();
      setState(() {
        _selectedAmount = 0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        theme.createSnackBar(
          message: 'Payment verification failed. Please contact support.',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("❌ Payment Failed");
    debugPrint("Code: ${response.code}");
    debugPrint("Message: ${response.message}");

    final theme = AppTheme();
    ScaffoldMessenger.of(context).showSnackBar(
      theme.createSnackBar(
        message: "Payment failed: ${response.message}",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("💼 External Wallet: ${response.walletName}");
    final theme = AppTheme();
    ScaffoldMessenger.of(context).showSnackBar(
      theme.createSnackBar(
        message: "External Wallet selected: ${response.walletName}",
        backgroundColor: theme.infoColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildPaymentMethodList() {
    final theme = AppTheme();
    theme.init(context);

    final paymentMethods = [
      {'icon': Icons.credit_card, 'title': 'Debit / Credit Card'},
      {'icon': Icons.account_balance_wallet, 'title': 'Wallet'},
      {'icon': Icons.money, 'title': 'UPI / NetBanking'},
      {'icon': Icons.mobile_friendly, 'title': 'Mobile Wallets'},
    ];

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: paymentMethods.length,
      itemBuilder: (context, index) {
        final method = paymentMethods[index];
        return Card(
          color:
              _selectedPaymentMethodIndex == index
                  ? theme.primaryColor.withOpacity(0.1)
                  : theme.cardColor,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: Icon(
              method['icon'] as IconData,
              color: theme.primaryColor,
              size: theme.hp(3),
            ),
            title: Text(method['title'] as String, style: theme.bodyStyle),
            trailing: Radio<int>(
              value: index,
              groupValue: _selectedPaymentMethodIndex,
              activeColor: theme.primaryColor,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethodIndex = value!;
                });
              },
            ),
            onTap: () {
              setState(() {
                _selectedPaymentMethodIndex = index;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    theme.init(context);

    return Scaffold(
      appBar: theme.createAppBar(
        title: 'Deposit',
        titleStyle: theme.appBarTitleStyle.copyWith(fontSize: theme.sp(6)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: theme.defaultPadding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: theme.hp(20),
                    alignment: Alignment.center,
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return theme.primaryGradient.createShader(bounds);
                      },
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: theme.hp(15),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: theme.hp(3)),
                  Text(
                    'Enter Deposit Amount',
                    style: theme.subheadingStyle,
                    textAlign: TextAlign.center,
                  ),
                  // Add minimum amount notice
                  Text(
                    'Minimum deposit amount: ₹$_minimumDepositAmount',
                    style: TextStyle(
                      color: theme.textSecondaryColor,
                      fontSize: theme.sp(3.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: theme.hp(2)),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: theme.headingStyle,
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      hintStyle: theme.bodyStyle.copyWith(
                        color: theme.textSecondaryColor.withOpacity(0.6),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                          left: theme.wp(5),
                          right: theme.wp(2),
                        ),
                        child: Text(
                          '₹',
                          style: theme.headingStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: theme.wp(10),
                        minHeight: theme.hp(6),
                      ),
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: theme.cardBorderRadius,
                        borderSide: BorderSide(
                          color: theme.textSecondaryColor.withOpacity(0.1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: theme.cardBorderRadius,
                        borderSide: BorderSide(
                          color: theme.primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: theme.hp(2),
                        horizontal: theme.wp(4),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null) {
                        return 'Please enter a valid amount';
                      }
                      if (amount < _minimumDepositAmount) {
                        return 'Amount must be at least ₹$_minimumDepositAmount';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final amount = double.tryParse(value);
                      if (amount != null) {
                        setState(() {
                          _selectedAmount = amount;
                        });
                      } else {
                        setState(() {
                          _selectedAmount = 0;
                        });
                      }
                    },
                  ),
                  SizedBox(height: theme.hp(3)),
                  Text(
                    'Enter Phone Number',
                    style: theme.subheadingStyle.copyWith(
                      fontSize: theme.sp(4.5),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: theme.hp(1)),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: '10-digit phone number',
                      counterText: '',
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: theme.cardBorderRadius,
                        borderSide: BorderSide(
                          color: theme.textSecondaryColor.withOpacity(0.1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: theme.cardBorderRadius,
                        borderSide: BorderSide(
                          color: theme.primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: theme.hp(1.5),
                        horizontal: theme.wp(4),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: theme.hp(3)),
                  Text('Quick Select Amount', style: theme.subheadingStyle),
                  SizedBox(height: theme.hp(1)),
                  Wrap(
                    spacing: theme.wp(4),
                    runSpacing: theme.hp(2),
                    children:
                        _quickAmounts.map((amount) {
                          final isSelected = _selectedAmount == amount;
                          return GestureDetector(
                            onTap:
                                _isProcessing
                                    ? null
                                    : () => _selectQuickAmount(amount),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: theme.hp(1.5),
                                horizontal: theme.wp(5),
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? theme.primaryColor
                                        : theme.cardColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? theme.primaryColor
                                          : theme.textSecondaryColor
                                              .withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                '₹$amount',
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: theme.sp(4),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: theme.hp(4)),
                  Text('Select Payment Method', style: theme.subheadingStyle),
                  SizedBox(height: theme.hp(1)),
                  _buildPaymentMethodList(),
                  SizedBox(height: theme.hp(4)),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _processDeposit,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: theme.hp(2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor:
                          _isProcessing ? Colors.grey : theme.primaryColor,
                    ),
                    child:
                        _isProcessing
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              'Deposit',
                              style: TextStyle(
                                fontSize: theme.sp(5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
