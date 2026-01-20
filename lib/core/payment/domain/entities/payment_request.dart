// lib/core/payment/domain/entities/payment_request.dart

import 'package:equatable/equatable.dart';
import 'payment_item.dart';
import 'service_type.dart';
import 'tax_item.dart';

class PaymentRequest extends Equatable {
  final String id;
  final ServiceType serviceType;
  final String serviceName;
  final String serviceIcon;
  final List<PaymentItem> items;
  final double subtotal;
  final List<TaxItem> taxes;
  final double discountAmount;
  final double convenienceFee;
  final double total;
  final String currency;
  final Map<String, dynamic> serviceMetadata;
  final DateTime createdAt;

  const PaymentRequest({
    required this.id,
    required this.serviceType,
    required this.serviceName,
    required this.serviceIcon,
    required this.items,
    required this.subtotal,
    this.taxes = const [],
    this.discountAmount = 0.0,
    this.convenienceFee = 0.0,
    required this.total,
    this.currency = 'USD',
    this.serviceMetadata = const {},
    required this.createdAt,
  });

  double get taxAmount => taxes.fold(0.0, (sum, tax) => sum + tax.amount);

  PaymentRequest copyWith({
    String? id,
    ServiceType? serviceType,
    String? serviceName,
    String? serviceIcon,
    List<PaymentItem>? items,
    double? subtotal,
    List<TaxItem>? taxes,
    double? discountAmount,
    double? convenienceFee,
    double? total,
    String? currency,
    Map<String, dynamic>? serviceMetadata,
    DateTime? createdAt,
  }) {
    return PaymentRequest(
      id: id ?? this.id,
      serviceType: serviceType ?? this.serviceType,
      serviceName: serviceName ?? this.serviceName,
      serviceIcon: serviceIcon ?? this.serviceIcon,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxes: taxes ?? this.taxes,
      discountAmount: discountAmount ?? this.discountAmount,
      convenienceFee: convenienceFee ?? this.convenienceFee,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      serviceMetadata: serviceMetadata ?? this.serviceMetadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        serviceType,
        serviceName,
        serviceIcon,
        items,
        subtotal,
        taxes,
        discountAmount,
        convenienceFee,
        total,
        currency,
        serviceMetadata,
        createdAt,
      ];
}
