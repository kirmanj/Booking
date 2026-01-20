// lib/core/payment/presentation/bloc/payment_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/payment_request.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/payment_result.dart';
import '../../domain/repositories/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc({required this.repository}) : super(const PaymentInitial()) {
    on<InitializePayment>(_onInitializePayment);
    on<LoadPaymentMethods>(_onLoadPaymentMethods);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<UpdatePaymentMethodDetails>(_onUpdatePaymentMethodDetails);
    on<UpdateCustomerInfo>(_onUpdateCustomerInfo);
    on<ApplyPromoCode>(_onApplyPromoCode);
    on<RemovePromoCode>(_onRemovePromoCode);
    on<ProcessPayment>(_onProcessPayment);
    on<CancelPayment>(_onCancelPayment);
    on<ResetPayment>(_onResetPayment);
    on<GetInvoice>(_onGetInvoice);
    on<RequestRefund>(_onRequestRefund);
  }

  Future<void> _onInitializePayment(
    InitializePayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading(message: 'Initializing payment...'));

    try {
      // Load available payment methods for this service
      final paymentMethods = await repository.getAvailablePaymentMethods(
        event.paymentRequest.serviceType.name,
      );

      emit(PaymentReady(
        paymentRequest: event.paymentRequest,
        availablePaymentMethods: paymentMethods,
      ));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onLoadPaymentMethods(
    LoadPaymentMethods event,
    Emitter<PaymentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PaymentReady) return;

    emit(const PaymentLoading(message: 'Loading payment methods...'));

    try {
      final paymentMethods = await repository.getAvailablePaymentMethods(
        currentState.paymentRequest.serviceType.name,
      );

      emit(currentState.copyWith(
        availablePaymentMethods: paymentMethods,
      ));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onSelectPaymentMethod(
    SelectPaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PaymentReady) return;

    emit(currentState.copyWith(
      selectedPaymentMethod: event.paymentMethodType,
      paymentMethodDetails: PaymentMethod(type: event.paymentMethodType),
    ));
  }

  Future<void> _onUpdatePaymentMethodDetails(
    UpdatePaymentMethodDetails event,
    Emitter<PaymentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PaymentReady) return;

    emit(currentState.copyWith(
      paymentMethodDetails: event.paymentMethod,
    ));
  }

  Future<void> _onUpdateCustomerInfo(
    UpdateCustomerInfo event,
    Emitter<PaymentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PaymentReady) return;

    emit(currentState.copyWith(
      customerName: event.name,
      customerEmail: event.email,
      customerPhone: event.phone,
    ));
  }

  Future<void> _onApplyPromoCode(
    ApplyPromoCode event,
    Emitter<PaymentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PaymentReady) return;

    emit(const PaymentLoading(message: 'Applying promo code...'));

    try {
      // Simulate promo code validation
      await Future.delayed(const Duration(seconds: 1));

      // Demo: Apply 10% discount for code "AMAN10"
      if (event.promoCode.toUpperCase() == 'AMAN10') {
        final discount = currentState.paymentRequest.total * 0.1;
        emit(currentState.copyWith(
          promoCode: event.promoCode,
          discountAmount: discount,
        ));
      } else {
        emit(currentState);
        emit(const PaymentError('Invalid promo code'));
        // Return to ready state after showing error
        await Future.delayed(const Duration(seconds: 2));
        emit(currentState);
      }
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onRemovePromoCode(
    RemovePromoCode event,
    Emitter<PaymentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PaymentReady) return;

    emit(currentState.copyWith(clearPromoCode: true));
  }

  Future<void> _onProcessPayment(
    ProcessPayment event,
    Emitter<PaymentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PaymentReady) return;

    if (!currentState.canProceed) {
      emit(const PaymentError('Please complete all required fields'));
      return;
    }

    emit(PaymentProcessing(
      paymentRequest: currentState.paymentRequest,
      paymentMethod: currentState.paymentMethodDetails!,
    ));

    try {
      final result = await repository.processPayment(
        paymentRequest: currentState.paymentRequest,
        paymentMethod: currentState.paymentMethodDetails!,
        customerName: currentState.customerName!,
        customerEmail: currentState.customerEmail!,
        customerPhone: currentState.customerPhone,
        additionalInfo: event.additionalInfo,
      );

      if (result.type == PaymentResultType.success && result.invoice != null) {
        emit(PaymentSuccess(result.invoice!));
      } else if (result.type == PaymentResultType.failure) {
        emit(PaymentFailure(
          errorMessage: result.errorMessage ?? 'Payment failed',
          errorCode: result.errorCode,
          paymentRequest: currentState.paymentRequest,
        ));
      } else if (result.type == PaymentResultType.cancelled) {
        emit(PaymentCancelled(paymentRequest: currentState.paymentRequest));
      }
    } catch (e) {
      emit(PaymentFailure(
        errorMessage: e.toString(),
        paymentRequest: currentState.paymentRequest,
      ));
    }
  }

  Future<void> _onCancelPayment(
    CancelPayment event,
    Emitter<PaymentState> emit,
  ) async {
    final currentState = state;

    if (currentState is PaymentReady) {
      emit(PaymentCancelled(paymentRequest: currentState.paymentRequest));
    } else if (currentState is PaymentProcessing) {
      emit(PaymentCancelled(paymentRequest: currentState.paymentRequest));
    }
  }

  Future<void> _onResetPayment(
    ResetPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentInitial());
  }

  Future<void> _onGetInvoice(
    GetInvoice event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading(message: 'Loading invoice...'));

    try {
      final invoice = await repository.getInvoice(event.invoiceNumber);

      if (invoice != null) {
        emit(InvoiceLoaded(invoice));
      } else {
        emit(const PaymentError('Invoice not found'));
      }
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onRequestRefund(
    RequestRefund event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading(message: 'Requesting refund...'));

    try {
      final success = await repository.requestRefund(
        event.invoiceNumber,
        event.reason,
      );

      emit(RefundRequested(
        invoiceNumber: event.invoiceNumber,
        success: success,
        message: success
            ? 'Refund request submitted successfully'
            : 'Refund request failed',
      ));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
