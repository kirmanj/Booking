// lib/core/payment/domain/entities/payment_result.dart

import 'package:equatable/equatable.dart';
import 'invoice.dart';

enum PaymentResultType {
  success,
  failure,
  cancelled;

  bool get isSuccess => this == PaymentResultType.success;
  bool get isFailure => this == PaymentResultType.failure;
  bool get isCancelled => this == PaymentResultType.cancelled;
}

class PaymentResult extends Equatable {
  final PaymentResultType type;
  final Invoice? invoice;
  final String? errorMessage;
  final String? errorCode;
  final DateTime timestamp;

  const PaymentResult({
    required this.type,
    this.invoice,
    this.errorMessage,
    this.errorCode,
    required this.timestamp,
  });

  factory PaymentResult.success(Invoice invoice) {
    return PaymentResult(
      type: PaymentResultType.success,
      invoice: invoice,
      timestamp: DateTime.now(),
    );
  }

  factory PaymentResult.failure({
    required String errorMessage,
    String? errorCode,
  }) {
    return PaymentResult(
      type: PaymentResultType.failure,
      errorMessage: errorMessage,
      errorCode: errorCode,
      timestamp: DateTime.now(),
    );
  }

  factory PaymentResult.cancelled() {
    return PaymentResult(
      type: PaymentResultType.cancelled,
      timestamp: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        type,
        invoice,
        errorMessage,
        errorCode,
        timestamp,
      ];
}
