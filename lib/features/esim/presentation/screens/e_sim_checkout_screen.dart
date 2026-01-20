import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_bloc.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_event.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_state.dart';
import 'package:aman_booking/features/esim/data/models/e_sim_models.dart';
import 'package:aman_booking/features/esim/presentation/screens/e_sim_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

// Payment Hub Imports
import 'package:aman_booking/core/payment/domain/entities/service_type.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_request.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_item.dart';
import 'package:aman_booking/core/payment/domain/entities/tax_item.dart';
import 'package:aman_booking/core/payment/presentation/screens/checkout_screen.dart'
    as payment;
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class ESimCheckoutScreen extends StatefulWidget {
  final ESimPackage package;
  final ESimCountry country;

  const ESimCheckoutScreen({
    super.key,
    required this.package,
    required this.country,
  });

  @override
  State<ESimCheckoutScreen> createState() => _ESimCheckoutScreenState();
}

class _ESimCheckoutScreenState extends State<ESimCheckoutScreen> {
  // Demo user data - pre-filled
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '+1 555-0123');
  final _nameController = TextEditingController(text: 'John Doe');

  PaymentMethod _selectedPayment = PaymentMethod.creditCard;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<ESimBloc, ESimState>(
          listener: (context, state) {
            if (state is PurchaseSuccess && state.orders.isNotEmpty) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ESimBloc>(),
                    child: ESimQrScreen(order: state.orders.first),
                  ),
                ),
              );
            } else if (state is ESimError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isProcessing = state is PurchaseProcessing;

            return Column(
              children: [
                _AppBar(
                  onBack: () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PackageSummaryCard(
                          package: widget.package,
                          country: widget.country,
                        ),
                        const SizedBox(height: 16),
                        _SectionTitle(
                          icon: Iconsax.user,
                          title: 'Contact Information',
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          child: Column(
                            children: [
                              _TextField(
                                controller: _nameController,
                                label: 'Full Name',
                                icon: Iconsax.user,
                              ),
                              const SizedBox(height: 12),
                              _TextField(
                                controller: _emailController,
                                label: 'Email Address',
                                icon: Iconsax.sms,
                              ),
                              const SizedBox(height: 12),
                              _TextField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                icon: Iconsax.call,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SectionTitle(
                          icon: Iconsax.card,
                          title: 'Payment Method',
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          child: Column(
                            children: [
                              _PaymentOption(
                                method: PaymentMethod.creditCard,
                                icon: Iconsax.card,
                                label: 'Credit Card',
                                subtitle: 'Visa, Mastercard, Amex',
                                isSelected: _selectedPayment ==
                                    PaymentMethod.creditCard,
                                onTap: () => setState(() => _selectedPayment =
                                    PaymentMethod.creditCard),
                              ),
                              const SizedBox(height: 10),
                              _PaymentOption(
                                method: PaymentMethod.applePay,
                                icon: Icons.apple,
                                label: 'Apple Pay',
                                subtitle: 'Fast & secure',
                                isSelected:
                                    _selectedPayment == PaymentMethod.applePay,
                                onTap: () => setState(() =>
                                    _selectedPayment = PaymentMethod.applePay),
                              ),
                              const SizedBox(height: 10),
                              _PaymentOption(
                                method: PaymentMethod.googlePay,
                                icon: Iconsax.google,
                                label: 'Google Pay',
                                subtitle: 'Quick checkout',
                                isSelected:
                                    _selectedPayment == PaymentMethod.googlePay,
                                onTap: () => setState(() =>
                                    _selectedPayment = PaymentMethod.googlePay),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SectionTitle(
                          icon: Iconsax.receipt_2,
                          title: 'Order Summary',
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          child: Column(
                            children: [
                              _PriceRow(
                                label: 'Package Price',
                                value:
                                    '\$${widget.package.finalPrice.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 8),
                              _PriceRow(
                                label: 'Service Fee',
                                value: '\$0.99',
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(height: 1),
                              ),
                              _PriceRow(
                                label: 'Total',
                                value:
                                    '\$${(widget.package.finalPrice + 0.99).toStringAsFixed(2)}',
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<ESimBloc, ESimState>(
        builder: (context, state) {
          final isProcessing = state is PurchaseProcessing;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      isProcessing ? null : () => _proceedToPayment(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.border,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.shield_tick, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              'Complete Purchase • \$${(widget.package.finalPrice + 0.99).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _proceedToPayment(BuildContext context) {
    // Calculate pricing
    final packagePrice = widget.package.finalPrice;
    const quantity = 1;
    final subtotal = packagePrice * quantity;
    const convenienceFee = 0.0;
    final total = subtotal + convenienceFee;

    // Build payment items
    final List<PaymentItem> items = [
      PaymentItem(
        id: 'esim_package',
        title: widget.package.name,
        description:
            '${widget.package.dataAmount}, ${widget.package.validityText} days validity',
        basePrice: packagePrice,
        quantity: quantity,
        serviceType: ServiceType.eSim,
        metadata: {
          'country': widget.country.name,
          'country_code': widget.country.code,
          'data': widget.package.dataAmount,
          'validity': widget.package.validityText,
          'coverage': "Covereage",
          // widget.package,
        },
      ),
    ];

    // Create payment request (E-SIM typically has no additional taxes)
    final paymentRequest = PaymentRequest(
      id: 'ES${DateTime.now().millisecondsSinceEpoch}',
      serviceType: ServiceType.eSim,
      serviceName: widget.country.name,
      serviceIcon: ServiceType.eSim.icon,
      items: items,
      subtotal: subtotal,
      taxes: [],
      discountAmount: 0.0,
      convenienceFee: convenienceFee,
      total: total,
      currency: 'USD',
      serviceMetadata: {
        'booking_reference': 'ES${DateTime.now().millisecondsSinceEpoch}',
        'esim_data': {
          'country': widget.country.name,
          'package': widget.package.name,
          'data': widget.package.dataAmount,
          'validity': widget.package.validityText,
        },
      },
      createdAt: DateTime.now(),
    );

    // Navigate to payment hub checkout
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => payment.CheckoutScreen(
          paymentRequest: paymentRequest,
          onPaymentComplete: (invoice) {
            // Payment successful - trigger the purchase
            context.read<ESimBloc>().add(PurchaseEsim(
                  items: [
                    ESimCartItem(
                      package: widget.package,
                      quantity: 1,
                    )
                  ],
                  paymentMethod: _selectedPayment,
                ));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('E-SIM purchased! Invoice: ${invoice.invoiceNumber}'),
                backgroundColor: AppColors.accentGreen,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final VoidCallback onBack;

  const _AppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Review and complete your purchase',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SupportButton(
            category: SupportCategory.eSim,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _PackageSummaryCard extends StatelessWidget {
  final ESimPackage package;
  final ESimCountry country;

  const _PackageSummaryCard({
    required this.package,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                country.flagEmoji,
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${country.name} • ${package.validityText}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _WhiteChip(text: package.dataAmount),
                    const SizedBox(width: 8),
                    _WhiteChip(text: package.speed),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteChip extends StatelessWidget {
  final String text;

  const _WhiteChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _TextField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true, // Demo mode - read only
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final PaymentMethod method;
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.method,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Iconsax.tick_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: FontWeight.w900,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
