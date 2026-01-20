// lib/core/payment/data/repositories/payment_repository_impl.dart

import 'dart:math';
import '../../domain/entities/payment_request.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/payment_result.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  // In-memory storage for demo purposes
  final List<Invoice> _invoices = [];
  final Random _random = Random();

  @override
  Future<PaymentResult> processPayment({
    required PaymentRequest paymentRequest,
    required PaymentMethod paymentMethod,
    required String customerName,
    required String customerEmail,
    String? customerPhone,
    Map<String, dynamic>? additionalInfo,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate 95% success rate
    if (_random.nextDouble() > 0.05) {
      // Generate invoice
      final invoice = Invoice(
        invoiceNumber: _generateInvoiceNumber(),
        issueDate: DateTime.now(),
        paymentRequest: paymentRequest,
        paymentMethod: paymentMethod,
        transactionId: _generateTransactionId(),
        status: PaymentStatus.completed,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        additionalInfo: additionalInfo ?? {},
      );

      // Store invoice
      _invoices.add(invoice);

      return PaymentResult.success(invoice);
    } else {
      // Simulate payment failure
      return PaymentResult.failure(
        errorMessage: 'Payment declined. Please try another payment method.',
        errorCode: 'PAYMENT_DECLINED',
      );
    }
  }

  @override
  Future<List<PaymentMethodType>> getAvailablePaymentMethods(
    String serviceType,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // All payment methods are available for all services in demo
    return PaymentMethodType.values;
  }

  @override
  Future<Invoice?> getInvoice(String invoiceNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _invoices.firstWhere(
        (invoice) => invoice.invoiceNumber == invoiceNumber,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Invoice>> getInvoicesByCustomer(String customerEmail) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _invoices
        .where((invoice) => invoice.customerEmail == customerEmail)
        .toList();
  }

  @override
  Future<bool> verifyTransaction(String transactionId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // In demo, all transactions are valid if they exist
    return _invoices.any((invoice) => invoice.transactionId == transactionId);
  }

  @override
  Future<bool> requestRefund(String invoiceNumber, String reason) async {
    await Future.delayed(const Duration(seconds: 1));

    final invoiceIndex = _invoices.indexWhere(
      (invoice) => invoice.invoiceNumber == invoiceNumber,
    );

    if (invoiceIndex != -1) {
      final invoice = _invoices[invoiceIndex];
      if (invoice.status == PaymentStatus.completed) {
        // Update invoice status to refunded
        _invoices[invoiceIndex] = invoice.copyWith(
          status: PaymentStatus.refunded,
        );
        return true;
      }
    }

    return false;
  }

  @override
  Future<bool> cancelPayment(String transactionId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final invoiceIndex = _invoices.indexWhere(
      (invoice) => invoice.transactionId == transactionId,
    );

    if (invoiceIndex != -1) {
      final invoice = _invoices[invoiceIndex];
      if (invoice.status == PaymentStatus.pending ||
          invoice.status == PaymentStatus.processing) {
        _invoices[invoiceIndex] = invoice.copyWith(
          status: PaymentStatus.cancelled,
        );
        return true;
      }
    }

    return false;
  }

  @override
  Future<bool> validatePaymentMethod(PaymentMethod paymentMethod) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Basic validation for demo
    switch (paymentMethod.type) {
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        return paymentMethod.cardNumber != null &&
            paymentMethod.cardNumber!.length == 4 &&
            paymentMethod.cardHolderName != null &&
            paymentMethod.cardHolderName!.isNotEmpty;

      case PaymentMethodType.paypal:
        return paymentMethod.email != null &&
            paymentMethod.email!.contains('@');

      case PaymentMethodType.applePay:
      case PaymentMethodType.googlePay:
      case PaymentMethodType.bankTransfer:
      case PaymentMethodType.cashOnDelivery:
        return true;
    }
  }

  @override
  double calculateProcessingFee(
    PaymentMethodType paymentMethod,
    double amount,
  ) {
    // Demo processing fees
    switch (paymentMethod) {
      case PaymentMethodType.creditCard:
        return amount * 0.029; // 2.9%
      case PaymentMethodType.debitCard:
        return amount * 0.015; // 1.5%
      case PaymentMethodType.applePay:
      case PaymentMethodType.googlePay:
        return amount * 0.025; // 2.5%
      case PaymentMethodType.paypal:
        return amount * 0.034; // 3.4%
      case PaymentMethodType.bankTransfer:
        return 5.0; // Fixed fee
      case PaymentMethodType.cashOnDelivery:
        return 10.0; // Fixed fee
    }
  }

  // Helper methods
  String _generateInvoiceNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _random.nextInt(9999).toString().padLeft(4, '0');
    return 'AB${timestamp}$random';
  }

  String _generateTransactionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _random.nextInt(999999).toString().padLeft(6, '0');
    return 'TXN${timestamp}$random';
  }
}
