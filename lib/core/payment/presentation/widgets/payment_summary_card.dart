// lib/core/payment/presentation/widgets/payment_summary_card.dart

import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../domain/entities/payment_request.dart';

class PaymentSummaryCard extends StatelessWidget {
  final PaymentRequest paymentRequest;
  final double? discountAmount;

  const PaymentSummaryCard({
    super.key,
    required this.paymentRequest,
    this.discountAmount,
  });

  @override
  Widget build(BuildContext context) {
    final finalTotal = paymentRequest.total - (discountAmount ?? 0.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Subtotal',
            paymentRequest.subtotal,
            paymentRequest.currency,
          ),
          if (paymentRequest.taxAmount > 0)
            _buildSummaryRow(
              'Taxes & Fees',
              paymentRequest.taxAmount,
              paymentRequest.currency,
            ),
          if (paymentRequest.convenienceFee > 0)
            _buildSummaryRow(
              'Convenience Fee',
              paymentRequest.convenienceFee,
              paymentRequest.currency,
            ),
          if (discountAmount != null && discountAmount! > 0)
            _buildSummaryRow(
              'Discount',
              -discountAmount!,
              paymentRequest.currency,
              isDiscount: true,
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${paymentRequest.currency} ${finalTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount,
    String currency, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            isDiscount
                ? '- $currency ${amount.abs().toStringAsFixed(2)}'
                : '$currency ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDiscount ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
