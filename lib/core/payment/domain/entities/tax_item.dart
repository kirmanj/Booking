// lib/core/payment/domain/entities/tax_item.dart

import 'package:equatable/equatable.dart';

class TaxItem extends Equatable {
  final String id;
  final String name;
  final double amount;
  final double? percentage;
  final bool isInclusive;

  const TaxItem({
    required this.id,
    required this.name,
    required this.amount,
    this.percentage,
    this.isInclusive = false,
  });

  @override
  List<Object?> get props => [id, name, amount, percentage, isInclusive];
}
