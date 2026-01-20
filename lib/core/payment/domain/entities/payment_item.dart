// lib/core/payment/domain/entities/payment_item.dart

import 'package:equatable/equatable.dart';
import 'service_type.dart';

class PaymentItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final double basePrice;
  final int quantity;
  final ServiceType serviceType;
  final Map<String, dynamic> metadata;

  const PaymentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.basePrice,
    this.quantity = 1,
    required this.serviceType,
    this.metadata = const {},
  });

  double get total => basePrice * quantity;

  PaymentItem copyWith({
    String? id,
    String? title,
    String? description,
    double? basePrice,
    int? quantity,
    ServiceType? serviceType,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      quantity: quantity ?? this.quantity,
      serviceType: serviceType ?? this.serviceType,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        basePrice,
        quantity,
        serviceType,
        metadata,
      ];
}
