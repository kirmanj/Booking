// lib/core/payment/presentation/bloc/payment_state.dart

part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

// Initial state
class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

// Loading state
class PaymentLoading extends PaymentState {
  final String? message;

  const PaymentLoading({this.message});

  @override
  List<Object?> get props => [message];
}

// Payment initialized with request
class PaymentReady extends PaymentState {
  final PaymentRequest paymentRequest;
  final List<PaymentMethodType> availablePaymentMethods;
  final PaymentMethodType? selectedPaymentMethod;
  final PaymentMethod? paymentMethodDetails;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? promoCode;
  final double? discountAmount;

  const PaymentReady({
    required this.paymentRequest,
    required this.availablePaymentMethods,
    this.selectedPaymentMethod,
    this.paymentMethodDetails,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.promoCode,
    this.discountAmount,
  });

  double get finalTotal {
    return paymentRequest.total - (discountAmount ?? 0.0);
  }

  bool get canProceed {
    return selectedPaymentMethod != null &&
        paymentMethodDetails != null &&
        customerName != null &&
        customerName!.isNotEmpty &&
        customerEmail != null &&
        customerEmail!.isNotEmpty;
  }

  PaymentReady copyWith({
    PaymentRequest? paymentRequest,
    List<PaymentMethodType>? availablePaymentMethods,
    PaymentMethodType? selectedPaymentMethod,
    PaymentMethod? paymentMethodDetails,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? promoCode,
    double? discountAmount,
    bool clearPromoCode = false,
  }) {
    return PaymentReady(
      paymentRequest: paymentRequest ?? this.paymentRequest,
      availablePaymentMethods:
          availablePaymentMethods ?? this.availablePaymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      paymentMethodDetails: paymentMethodDetails ?? this.paymentMethodDetails,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      promoCode: clearPromoCode ? null : (promoCode ?? this.promoCode),
      discountAmount:
          clearPromoCode ? null : (discountAmount ?? this.discountAmount),
    );
  }

  @override
  List<Object?> get props => [
        paymentRequest,
        availablePaymentMethods,
        selectedPaymentMethod,
        paymentMethodDetails,
        customerName,
        customerEmail,
        customerPhone,
        promoCode,
        discountAmount,
      ];
}

// Payment processing
class PaymentProcessing extends PaymentState {
  final PaymentRequest paymentRequest;
  final PaymentMethod paymentMethod;

  const PaymentProcessing({
    required this.paymentRequest,
    required this.paymentMethod,
  });

  @override
  List<Object> get props => [paymentRequest, paymentMethod];
}

// Payment completed successfully
class PaymentSuccess extends PaymentState {
  final Invoice invoice;

  const PaymentSuccess(this.invoice);

  @override
  List<Object> get props => [invoice];
}

// Payment failed
class PaymentFailure extends PaymentState {
  final String errorMessage;
  final String? errorCode;
  final PaymentRequest? paymentRequest;

  const PaymentFailure({
    required this.errorMessage,
    this.errorCode,
    this.paymentRequest,
  });

  @override
  List<Object?> get props => [errorMessage, errorCode, paymentRequest];
}

// Payment cancelled
class PaymentCancelled extends PaymentState {
  final PaymentRequest? paymentRequest;

  const PaymentCancelled({this.paymentRequest});

  @override
  List<Object?> get props => [paymentRequest];
}

// Invoice loaded
class InvoiceLoaded extends PaymentState {
  final Invoice invoice;

  const InvoiceLoaded(this.invoice);

  @override
  List<Object> get props => [invoice];
}

// Refund requested
class RefundRequested extends PaymentState {
  final String invoiceNumber;
  final bool success;
  final String? message;

  const RefundRequested({
    required this.invoiceNumber,
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [invoiceNumber, success, message];
}

// Error state
class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object> get props => [message];
}
