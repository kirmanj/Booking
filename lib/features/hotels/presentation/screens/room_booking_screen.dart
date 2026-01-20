import 'package:aman_booking/features/hotels/presentation/screens/hotel_detail.dart';
import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

// Payment Hub Imports
import 'package:aman_booking/core/payment/domain/entities/service_type.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_request.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_item.dart';
import 'package:aman_booking/core/payment/domain/entities/tax_item.dart';
import 'package:aman_booking/core/payment/presentation/screens/checkout_screen.dart';

// Support Imports
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class RoomBookingScreen extends StatefulWidget {
  final Hotel hotel;
  final RoomOffer room;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;

  const RoomBookingScreen({
    super.key,
    required this.hotel,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
  });

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  // Secondary only for borders/icons
  Color get _accent => AppColors.secondary;
  Color get _border => AppColors.primary.withOpacity(0.26);
  Color get _chipBg => AppColors.primary.withOpacity(0.08);

  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _request = TextEditingController();

  int get _nights =>
      widget.checkOut.difference(widget.checkIn).inDays.clamp(1, 365);

  String _payment = 'Pay at hotel'; // demo

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _email.dispose();
    _request.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMM dd, EEE');
    final total = widget.room.totalPrice(nights: _nights, rooms: widget.rooms);
    final base = widget.room.pricePerNight * _nights * widget.rooms;
    final taxes = widget.room.taxesPerNight * _nights * widget.rooms;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Confirm booking',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: const [
          SupportButton(
            category: SupportCategory.hotels,
            color: AppColors.textPrimary,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 110),
        child: Column(
          children: [
            // summary card
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hotel.name,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Iconsax.location, size: 14, color: _accent),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.hotel.location,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _rowInfo('Room', widget.room.name),
                  _rowInfo('Dates',
                      '${dateFmt.format(widget.checkIn)} → ${dateFmt.format(widget.checkOut)}'),
                  _rowInfo('Guests', '${widget.guests}'),
                  _rowInfo('Rooms', '${widget.rooms}'),
                  _rowInfo('Nights', '$_nights'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // price breakdown
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price details',
                    style: TextStyle(
                      fontSize: 13.2,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _moneyRow('Base rate', base),
                  _moneyRow('Taxes & fees', taxes),
                  const Divider(height: 18),
                  _moneyRow('Total', total, bold: true),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.room.refundable
                          ? AppColors.accentGreen.withOpacity(0.10)
                          : AppColors.accentOrange.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.room.refundable
                            ? AppColors.accentGreen.withOpacity(0.25)
                            : AppColors.accentOrange.withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.room.refundable
                              ? Iconsax.tick_circle
                              : Iconsax.warning_2,
                          size: 16,
                          color: widget.room.refundable
                              ? AppColors.accentGreen
                              : AppColors.accentOrange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.room.refundable
                                ? 'Free cancellation (${widget.room.freeCancelHours}h)'
                                : 'Non-refundable',
                            style: TextStyle(
                              fontSize: 11.2,
                              fontWeight: FontWeight.w800,
                              color: widget.room.refundable
                                  ? AppColors.accentGreen
                                  : AppColors.accentOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // payment
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment method',
                    style: TextStyle(
                      fontSize: 13.2,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _payOption('Pay at hotel', Icons.payments_outlined),
                  const SizedBox(height: 8),
                  _payOption('Credit / Debit card', Icons.credit_card),
                  const SizedBox(height: 8),
                  _payOption('Wallet / Balance', Icons.account_balance_wallet),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // guest details
            _card(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Guest details',
                      style: TextStyle(
                        fontSize: 13.2,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            controller: _firstName,
                            label: 'First name',
                            icon: Iconsax.user,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _textField(
                            controller: _lastName,
                            label: 'Last name',
                            icon: Iconsax.user,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _textField(
                      controller: _phone,
                      label: 'Phone',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          (v == null || v.trim().length < 7) ? 'Invalid' : null,
                    ),
                    const SizedBox(height: 10),
                    _textField(
                      controller: _email,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? 'Invalid' : null,
                    ),
                    const SizedBox(height: 10),
                    _textField(
                      controller: _request,
                      label: 'Special request (optional)',
                      icon: Iconsax.note_2,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // final note
            _card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _chipBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                    ),
                    child:
                        Icon(Iconsax.security_safe, size: 18, color: _accent),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'By confirming, you agree to the hotel rules and cancellation policy. This is a demo booking flow.',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // bottom confirm bar
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: _border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total: \$${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 12.8,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmBooking() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Calculate pricing
    final nightsCount = _nights;
    final roomsCount = widget.rooms;
    final baseRate = widget.room.pricePerNight * nightsCount * roomsCount;
    final tourismTax = baseRate * 0.10;
    final serviceCharge = baseRate * 0.05;
    final convenienceFee = 3.00;
    final subtotal = baseRate;
    final totalTaxes = tourismTax + serviceCharge;
    final total = subtotal + totalTaxes + convenienceFee;

    // Build payment items
    final List<PaymentItem> items = [
      PaymentItem(
        id: 'hotel_room',
        title: widget.room.name,
        description: '$nightsCount night(s), ${widget.guests} guest(s), $roomsCount room(s)',
        basePrice: widget.room.pricePerNight,
        quantity: nightsCount * roomsCount,
        serviceType: ServiceType.hotel,
        metadata: {
          'hotel_name': widget.hotel.name,
          'hotel_location': widget.hotel.location,
          'room_type': widget.room.name,
          'check_in': widget.checkIn.toIso8601String(),
          'check_out': widget.checkOut.toIso8601String(),
          'nights': nightsCount,
          'guests': widget.guests,
          'rooms': roomsCount,
        },
      ),
    ];

    // Build tax items
    final List<TaxItem> taxes = [
      TaxItem(
        id: 'tourism_tax',
        name: 'Tourism Tax',
        amount: tourismTax,
        percentage: 0.10,
        isInclusive: false,
      ),
      TaxItem(
        id: 'service_charge',
        name: 'Service Charge',
        amount: serviceCharge,
        percentage: 0.05,
        isInclusive: false,
      ),
    ];

    // Create payment request
    final paymentRequest = PaymentRequest(
      id: 'HT${DateTime.now().millisecondsSinceEpoch}',
      serviceType: ServiceType.hotel,
      serviceName: widget.hotel.name,
      serviceIcon: ServiceType.hotel.icon,
      items: items,
      subtotal: subtotal,
      taxes: taxes,
      discountAmount: 0.0,
      convenienceFee: convenienceFee,
      total: total,
      currency: 'USD',
      serviceMetadata: {
        'booking_reference': 'HT${DateTime.now().millisecondsSinceEpoch}',
        'hotel_data': {
          'name': widget.hotel.name,
          'location': widget.hotel.location,
          'rating': widget.hotel.rating,
          'room_type': widget.room.name,
          'check_in': widget.checkIn.toIso8601String(),
          'check_out': widget.checkOut.toIso8601String(),
        },
      },
      createdAt: DateTime.now(),
    );

    // Navigate to payment hub checkout
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          paymentRequest: paymentRequest,
          onPaymentComplete: (invoice) {
            // Payment successful - show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Hotel booked successfully! Invoice: ${invoice.invoiceNumber}'),
                backgroundColor: AppColors.accentGreen,
              ),
            );

            // Navigate back to home
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _rowInfo(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              k,
              style: const TextStyle(
                fontSize: 11.2,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              v,
              style: const TextStyle(
                fontSize: 11.6,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _moneyRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.6,
                fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
                color: bold ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 11.8,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w800,
              color: bold ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _payOption(String title, IconData icon) {
    final selected = _payment == title;
    return InkWell(
      onTap: () => setState(() => _payment = title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _chipBg : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? _border : _border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: _accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (selected) Icon(Iconsax.tick_circle, size: 18, color: _accent),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(icon, size: 18, color: _accent),
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _accent.withOpacity(0.7), width: 2),
        ),
      ),
    );
  }
}
