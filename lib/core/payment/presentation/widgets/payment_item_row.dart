// lib/core/payment/presentation/widgets/payment_item_row.dart

import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../domain/entities/payment_item.dart';

class PaymentItemRow extends StatelessWidget {
  final PaymentItem item;

  const PaymentItemRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (item.quantity > 1) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${item.quantity} × ${item.basePrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            item.total.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
