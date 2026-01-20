// lib/core/payment/presentation/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../domain/entities/payment_request.dart';
import '../../domain/entities/invoice.dart';
import '../bloc/payment_bloc.dart';
import '../widgets/payment_summary_card.dart';
import '../widgets/payment_item_row.dart';
import '../widgets/tax_breakdown_widget.dart';
import 'payment_method_screen.dart';
import 'invoice_screen.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class CheckoutScreen extends StatefulWidget {
  final PaymentRequest paymentRequest;
  final Function(Invoice)? onPaymentComplete;

  const CheckoutScreen({
    super.key,
    required this.paymentRequest,
    this.onPaymentComplete,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _promoCodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(
        repository: context.read(),
      )..add(InitializePayment(widget.paymentRequest)),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            // Navigate to invoice screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => InvoiceScreen(invoice: state.invoice),
              ),
            ).then((_) {
              widget.onPaymentComplete?.call(state.invoice);
            });
          } else if (state is PaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return Scaffold(
              appBar: _buildAppBar(context),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      state.message ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PaymentProcessing) {
            return Scaffold(
              appBar: _buildAppBar(context),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 16),
                    const Text(
                      'Processing payment...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please wait while we process your payment',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! PaymentReady) {
            return Scaffold(
              appBar: _buildAppBar(context),
              body: const Center(
                child: Text('Error initializing payment'),
              ),
            );
          }

          return Scaffold(
            appBar: _buildAppBar(context),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildServiceHeader(state.paymentRequest),
                  const SizedBox(height: 16),
                  _buildItemsList(state.paymentRequest),
                  const SizedBox(height: 16),
                  _buildTaxBreakdown(state.paymentRequest),
                  const SizedBox(height: 16),
                  _buildPromoCodeSection(context, state),
                  const SizedBox(height: 16),
                  _buildPaymentSummary(state),
                  const SizedBox(height: 16),
                  _buildCustomerInfoSection(context, state),
                  const SizedBox(height: 16),
                  _buildPaymentMethodSection(context, state),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomBar(context, state),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Checkout',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: const [
        SupportButton(
          category: SupportCategory.payment,
          color: AppColors.textPrimary,
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildServiceHeader(PaymentRequest request) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.textPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                //  color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white)),
            child: Image.asset(
              request.serviceIcon,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AMAN BOOKING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  request.serviceType.displayName.toString().toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request.serviceName,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(PaymentRequest request) {
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
            'Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...request.items.map((item) => PaymentItemRow(item: item)),
        ],
      ),
    );
  }

  Widget _buildTaxBreakdown(PaymentRequest request) {
    if (request.taxes.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TaxBreakdownWidget(taxes: request.taxes),
    );
  }

  Widget _buildPromoCodeSection(BuildContext context, PaymentReady state) {
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
            'Promo Code',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (state.promoCode == null) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoCodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final code = _promoCodeController.text.trim();
                    if (code.isNotEmpty) {
                      context.read<PaymentBloc>().add(ApplyPromoCode(code));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textWhite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.promoCode!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        Text(
                          'Discount: ${state.paymentRequest.currency} ${state.discountAmount?.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<PaymentBloc>().add(const RemovePromoCode());
                      _promoCodeController.clear();
                    },
                    icon: const Icon(Icons.close),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(PaymentReady state) {
    return PaymentSummaryCard(
      paymentRequest: state.paymentRequest,
      discountAmount: state.discountAmount,
    );
  }

  Widget _buildCustomerInfoSection(BuildContext context, PaymentReady state) {
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
            'Customer Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name *',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            onChanged: (value) {
              context.read<PaymentBloc>().add(
                    UpdateCustomerInfo(
                      name: value,
                      email: _emailController.text,
                      phone: _phoneController.text,
                    ),
                  );
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email *',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              context.read<PaymentBloc>().add(
                    UpdateCustomerInfo(
                      name: _nameController.text,
                      email: value,
                      phone: _phoneController.text,
                    ),
                  );
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone (Optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              context.read<PaymentBloc>().add(
                    UpdateCustomerInfo(
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: value,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context, PaymentReady state) {
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
            'Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentMethodScreen(
                    availableMethods: state.availablePaymentMethods,
                    selectedMethod: state.selectedPaymentMethod,
                  ),
                ),
              );

              if (result != null && result is Map) {
                context.read<PaymentBloc>().add(
                      SelectPaymentMethod(result['type']),
                    );
                if (result['details'] != null) {
                  context.read<PaymentBloc>().add(
                        UpdatePaymentMethodDetails(result['details']),
                      );
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  if (state.selectedPaymentMethod != null) ...[
                    Text(
                      state.selectedPaymentMethod!.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.selectedPaymentMethod!.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ] else ...[
                    const Icon(Icons.payment, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Select payment method',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                  const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, PaymentReady state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${state.paymentRequest.currency} ${state.finalTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.canProceed
                    ? () {
                        context.read<PaymentBloc>().add(const ProcessPayment());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppColors.border,
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
