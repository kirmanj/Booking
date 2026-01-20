// lib/core/payment/domain/entities/invoice.dart

import 'package:equatable/equatable.dart';
import 'payment_request.dart';
import 'payment_method.dart';

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
  cancelled;

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get icon {
    switch (this) {
      case PaymentStatus.pending:
        return '⏳';
      case PaymentStatus.processing:
        return '⚙️';
      case PaymentStatus.completed:
        return '✅';
      case PaymentStatus.failed:
        return '❌';
      case PaymentStatus.refunded:
        return '↩️';
      case PaymentStatus.cancelled:
        return '🚫';
    }
  }
}

class Invoice extends Equatable {
  final String invoiceNumber;
  final DateTime issueDate;
  final PaymentRequest paymentRequest;
  final PaymentMethod paymentMethod;
  final String transactionId;
  final PaymentStatus status;
  final String customerName;
  final String customerEmail;
  final String? customerPhone;
  final Map<String, dynamic> additionalInfo;

  const Invoice({
    required this.invoiceNumber,
    required this.issueDate,
    required this.paymentRequest,
    required this.paymentMethod,
    required this.transactionId,
    required this.status,
    required this.customerName,
    required this.customerEmail,
    this.customerPhone,
    this.additionalInfo = const {},
  });

  String get formattedInvoiceNumber => 'INV-${invoiceNumber.toUpperCase()}';

  String get formattedDate {
    final day = issueDate.day.toString().padLeft(2, '0');
    final month = issueDate.month.toString().padLeft(2, '0');
    final year = issueDate.year;
    return '$day/$month/$year';
  }

  String get formattedTime {
    final hour = issueDate.hour.toString().padLeft(2, '0');
    final minute = issueDate.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Invoice copyWith({
    String? invoiceNumber,
    DateTime? issueDate,
    PaymentRequest? paymentRequest,
    PaymentMethod? paymentMethod,
    String? transactionId,
    PaymentStatus? status,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    Map<String, dynamic>? additionalInfo,
  }) {
    return Invoice(
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      issueDate: issueDate ?? this.issueDate,
      paymentRequest: paymentRequest ?? this.paymentRequest,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  List<Object?> get props => [
        invoiceNumber,
        issueDate,
        paymentRequest,
        paymentMethod,
        transactionId,
        status,
        customerName,
        customerEmail,
        customerPhone,
        additionalInfo,
      ];
}
