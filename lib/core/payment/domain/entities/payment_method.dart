// lib/core/payment/domain/entities/payment_method.dart

enum PaymentMethodType {
  creditCard,
  debitCard,
  applePay,
  googlePay,
  paypal,
  bankTransfer,
  cashOnDelivery;

  String get displayName {
    switch (this) {
      case PaymentMethodType.creditCard:
        return 'Credit Card';
      case PaymentMethodType.debitCard:
        return 'Debit Card';
      case PaymentMethodType.applePay:
        return 'Apple Pay';
      case PaymentMethodType.googlePay:
        return 'Google Pay';
      case PaymentMethodType.paypal:
        return 'PayPal';
      case PaymentMethodType.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethodType.cashOnDelivery:
        return 'Cash on Delivery';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethodType.creditCard:
        return '💳';
      case PaymentMethodType.debitCard:
        return '💳';
      case PaymentMethodType.applePay:
        return '';
      case PaymentMethodType.googlePay:
        return 'G';
      case PaymentMethodType.paypal:
        return 'P';
      case PaymentMethodType.bankTransfer:
        return '🏦';
      case PaymentMethodType.cashOnDelivery:
        return '💵';
    }
  }
}

class PaymentMethod {
  final PaymentMethodType type;
  final String? cardNumber; // Last 4 digits for cards
  final String? cardHolderName;
  final String? email; // For PayPal
  final Map<String, dynamic> additionalData;

  const PaymentMethod({
    required this.type,
    this.cardNumber,
    this.cardHolderName,
    this.email,
    this.additionalData = const {},
  });

  String get displayInfo {
    switch (type) {
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        return cardNumber != null ? '•••• $cardNumber' : type.displayName;
      case PaymentMethodType.paypal:
        return email ?? type.displayName;
      default:
        return type.displayName;
    }
  }
}
