// lib/core/payment/presentation/screens/payment_method_screen.dart

import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../domain/entities/payment_method.dart';
import '../widgets/payment_method_tile.dart';

class PaymentMethodScreen extends StatefulWidget {
  final List<PaymentMethodType> availableMethods;
  final PaymentMethodType? selectedMethod;

  const PaymentMethodScreen({
    super.key,
    required this.availableMethods,
    this.selectedMethod,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentMethodType? _selectedMethod;
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedMethod;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Payment Method',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            _buildPaymentMethodsList(),
            if (_selectedMethod != null) ...[
              const SizedBox(height: 24),
              _buildPaymentDetails(),
            ],
          ],
        ),
      ),
      bottomNavigationBar:
          _selectedMethod != null ? _buildBottomBar(context) : null,
    );
  }

  Widget _buildPaymentMethodsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Choose Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...widget.availableMethods.map(
            (method) => PaymentMethodTile(
              method: method,
              isSelected: _selectedMethod == method,
              onTap: () {
                setState(() {
                  _selectedMethod = method;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentDetailsForm(),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsForm() {
    switch (_selectedMethod!) {
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        return _buildCardForm();
      case PaymentMethodType.paypal:
        return _buildPayPalForm();
      case PaymentMethodType.applePay:
      case PaymentMethodType.googlePay:
        return _buildDigitalWalletInfo();
      case PaymentMethodType.bankTransfer:
        return _buildBankTransferInfo();
      case PaymentMethodType.cashOnDelivery:
        return _buildCashOnDeliveryInfo();
    }
  }

  Widget _buildCardForm() {
    return Column(
      children: [
        TextField(
          controller: _cardNumberController,
          decoration: InputDecoration(
            labelText: 'Card Number',
            hintText: '1234 5678 9012 3456',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.credit_card),
          ),
          keyboardType: TextInputType.number,
          maxLength: 19,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cardHolderController,
          decoration: InputDecoration(
            labelText: 'Card Holder Name',
            hintText: 'John Doe',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _expiryController,
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  hintText: 'MM/YY',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.datetime,
                maxLength: 5,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _cvvController,
                decoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: '123',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPayPalForm() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'PayPal Email',
        hintText: 'your@email.com',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildDigitalWalletInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _selectedMethod == PaymentMethodType.applePay
                ? Icons.apple
                : Icons.android,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _selectedMethod == PaymentMethodType.applePay
                  ? 'You will be redirected to Apple Pay to complete the payment'
                  : 'You will be redirected to Google Pay to complete the payment',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankTransferInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bank transfer instructions will be provided after checkout',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Bank details and payment reference will be sent to your email',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashOnDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.money, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pay with cash when your service is delivered or completed',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canProceed() ? () => _confirmPaymentMethod() : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: AppColors.border,
            ),
            child: const Text(
              'Confirm Payment Method',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  bool _canProceed() {
    if (_selectedMethod == null) return false;

    switch (_selectedMethod!) {
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        return _cardNumberController.text.isNotEmpty &&
            _cardHolderController.text.isNotEmpty &&
            _expiryController.text.isNotEmpty &&
            _cvvController.text.isNotEmpty;
      case PaymentMethodType.paypal:
        return _emailController.text.isNotEmpty &&
            _emailController.text.contains('@');
      case PaymentMethodType.applePay:
      case PaymentMethodType.googlePay:
      case PaymentMethodType.bankTransfer:
      case PaymentMethodType.cashOnDelivery:
        return true;
    }
  }

  void _confirmPaymentMethod() {
    PaymentMethod paymentMethod;

    switch (_selectedMethod!) {
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        // Get last 4 digits
        final cardNumber = _cardNumberController.text.replaceAll(' ', '');
        final lastFour = cardNumber.length >= 4
            ? cardNumber.substring(cardNumber.length - 4)
            : cardNumber;

        paymentMethod = PaymentMethod(
          type: _selectedMethod!,
          cardNumber: lastFour,
          cardHolderName: _cardHolderController.text,
          additionalData: {
            'expiry': _expiryController.text,
          },
        );
        break;

      case PaymentMethodType.paypal:
        paymentMethod = PaymentMethod(
          type: _selectedMethod!,
          email: _emailController.text,
        );
        break;

      default:
        paymentMethod = PaymentMethod(type: _selectedMethod!);
    }

    Navigator.pop(context, {
      'type': _selectedMethod,
      'details': paymentMethod,
    });
  }
}
