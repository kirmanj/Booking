// lib/core/payment/presentation/widgets/tax_breakdown_widget.dart

import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../domain/entities/tax_item.dart';

class TaxBreakdownWidget extends StatelessWidget {
  final List<TaxItem> taxes;

  const TaxBreakdownWidget({
    super.key,
    required this.taxes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Tax & Fees Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...taxes.map((tax) => _buildTaxRow(tax)),
        ],
      ),
    );
  }

  Widget _buildTaxRow(TaxItem tax) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  tax.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (tax.percentage != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    '(${(tax.percentage! * 100).toStringAsFixed(1)}%)',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (tax.isInclusive) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Included',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            tax.amount.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 14,
              fontWeight: tax.isInclusive ? FontWeight.normal : FontWeight.w600,
              color: tax.isInclusive ? AppColors.textSecondary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
