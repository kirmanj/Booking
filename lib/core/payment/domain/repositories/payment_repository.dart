// lib/core/payment/domain/repositories/payment_repository.dart

import '../entities/payment_request.dart';
import '../entities/payment_method.dart';
import '../entities/invoice.dart';
import '../entities/payment_result.dart';

abstract class PaymentRepository {
  /// Process a payment request with the selected payment method
  Future<PaymentResult> processPayment({
    required PaymentRequest paymentRequest,
    required PaymentMethod paymentMethod,
    required String customerName,
    required String customerEmail,
    String? customerPhone,
    Map<String, dynamic>? additionalInfo,
  });

  /// Get available payment methods for a service type
  Future<List<PaymentMethodType>> getAvailablePaymentMethods(
    String serviceType,
  );

  /// Get invoice by invoice number
  Future<Invoice?> getInvoice(String invoiceNumber);

  /// Get invoices by customer email
  Future<List<Invoice>> getInvoicesByCustomer(String customerEmail);

  /// Verify a payment transaction
  Future<bool> verifyTransaction(String transactionId);

  /// Request refund for an invoice
  Future<bool> requestRefund(String invoiceNumber, String reason);

  /// Cancel a pending payment
  Future<bool> cancelPayment(String transactionId);

  /// Validate payment method details
  Future<bool> validatePaymentMethod(PaymentMethod paymentMethod);

  /// Calculate processing fee for payment method
  double calculateProcessingFee(
    PaymentMethodType paymentMethod,
    double amount,
  );
}
