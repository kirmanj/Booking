// lib/core/payment/presentation/bloc/payment_event.dart

part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

// Initialize payment with request
class InitializePayment extends PaymentEvent {
  final PaymentRequest paymentRequest;

  const InitializePayment(this.paymentRequest);

  @override
  List<Object> get props => [paymentRequest];
}

// Load available payment methods
class LoadPaymentMethods extends PaymentEvent {
  const LoadPaymentMethods();
}

// Select a payment method
class SelectPaymentMethod extends PaymentEvent {
  final PaymentMethodType paymentMethodType;

  const SelectPaymentMethod(this.paymentMethodType);

  @override
  List<Object> get props => [paymentMethodType];
}

// Update payment method details
class UpdatePaymentMethodDetails extends PaymentEvent {
  final PaymentMethod paymentMethod;

  const UpdatePaymentMethodDetails(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

// Update customer information
class UpdateCustomerInfo extends PaymentEvent {
  final String name;
  final String email;
  final String? phone;

  const UpdateCustomerInfo({
    required this.name,
    required this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [name, email, phone];
}

// Apply promo code
class ApplyPromoCode extends PaymentEvent {
  final String promoCode;

  const ApplyPromoCode(this.promoCode);

  @override
  List<Object> get props => [promoCode];
}

// Remove promo code
class RemovePromoCode extends PaymentEvent {
  const RemovePromoCode();
}

// Process the payment
class ProcessPayment extends PaymentEvent {
  final Map<String, dynamic>? additionalInfo;

  const ProcessPayment({this.additionalInfo});

  @override
  List<Object?> get props => [additionalInfo];
}

// Cancel payment
class CancelPayment extends PaymentEvent {
  const CancelPayment();
}

// Reset payment state
class ResetPayment extends PaymentEvent {
  const ResetPayment();
}

// Get invoice by number
class GetInvoice extends PaymentEvent {
  final String invoiceNumber;

  const GetInvoice(this.invoiceNumber);

  @override
  List<Object> get props => [invoiceNumber];
}

// Request refund
class RequestRefund extends PaymentEvent {
  final String invoiceNumber;
  final String reason;

  const RequestRefund({
    required this.invoiceNumber,
    required this.reason,
  });

  @override
  List<Object> get props => [invoiceNumber, reason];
}
