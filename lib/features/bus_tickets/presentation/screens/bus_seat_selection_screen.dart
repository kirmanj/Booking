import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_bloc.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_event.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Payment Hub Imports
import 'package:aman_booking/core/payment/domain/entities/service_type.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_request.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_item.dart';
import 'package:aman_booking/core/payment/domain/entities/tax_item.dart';
import 'package:aman_booking/core/payment/presentation/screens/checkout_screen.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class BusSeatSelectionScreen extends StatelessWidget {
  const BusSeatSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusBloc, BusState>(
      listener: (context, state) {
        if (state is BusError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is! BusSeatSelectionLoaded) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        final s = state;
        final requiredSeats = s.query.passengers;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Select seats',
                  subtitle:
                      '${s.trip.from} → ${s.trip.to} • ${requiredSeats} passenger${requiredSeats > 1 ? 's' : ''}',
                  onBack: () => Navigator.pop(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _Legend(
                            color: AppColors.surfaceDark, label: 'Available'),
                        _Legend(
                            color: AppColors.accentGreen, label: 'Selected'),
                        _Legend(color: AppColors.error, label: 'Booked'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primary.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.drive_eta_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Driver',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              _BusSeatGrid(seats: s.seats),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Selected: ${s.selectedSeats.length}/$requiredSeats',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${(s.trip.pricePerPassenger * requiredSeats).toStringAsFixed(0)} total',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: s.selectedSeats.length == requiredSeats
                          ? () => _confirmBooking(context, s)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.border,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Confirm seats & book',
                        style: TextStyle(
                          fontSize: 15,
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
      },
    );
  }

  void _confirmBooking(BuildContext context, BusSeatSelectionLoaded s) {
    // Calculate pricing
    final seatsCount = s.selectedSeats.length;
    final pricePerSeat = s.trip.pricePerPassenger;
    final subtotal = pricePerSeat * seatsCount;
    final vat = subtotal * 0.05;
    const convenienceFee = 2.00;
    final total = subtotal + vat + convenienceFee;

    // Build payment items
    final List<PaymentItem> items = [
      PaymentItem(
        id: 'bus_ticket',
        title: '${s.trip.companyName} - ${s.trip.from} to ${s.trip.to}',
        description: 'Seats: ${s.selectedSeats.join(', ')}',
        basePrice: pricePerSeat,
        quantity: seatsCount,
        serviceType: ServiceType.busTicket,
        metadata: {
          'company': s.trip.companyName,
          'from': s.trip.from,
          'to': s.trip.to,
          'departure_time': s.trip.departAt,
          'arrival_time': s.trip.arriveAt,
          'seats': s.selectedSeats,
          'bus_type': s.trip.busType,
        },
      ),
    ];

    // Build tax items
    final List<TaxItem> taxes = [
      TaxItem(
        id: 'vat',
        name: 'VAT',
        amount: vat,
        percentage: 0.05,
        isInclusive: false,
      ),
    ];

    // Create payment request
    final paymentRequest = PaymentRequest(
      id: 'BUS${DateTime.now().millisecondsSinceEpoch}',
      serviceType: ServiceType.busTicket,
      serviceName: '${s.trip.from} to ${s.trip.to}',
      serviceIcon: ServiceType.busTicket.icon,
      items: items,
      subtotal: subtotal,
      taxes: taxes,
      discountAmount: 0.0,
      convenienceFee: convenienceFee,
      total: total,
      currency: 'USD',
      serviceMetadata: {
        'booking_reference': 'BUS${DateTime.now().millisecondsSinceEpoch}',
        'trip_data': {
          'company': s.trip.companyName,
          'from': s.trip.from,
          'to': s.trip.to,
          'departure': s.trip.departAt,
          'arrival': s.trip.arriveAt,
          'seats': s.selectedSeats,
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
            // Payment successful
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Bus tickets booked! Invoice: ${invoice.invoiceNumber}'),
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

  void _confirmBookingOld(BuildContext context, BusSeatSelectionLoaded s) {
    final ref = 'BUS${DateTime.now().millisecondsSinceEpoch % 1000000}';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Booking Confirmed',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${s.trip.from} → ${s.trip.to}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Seats: ${s.selectedSeats.join(', ')}',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              'Reference: $ref',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // seat screen
              Navigator.pop(context); // trip details
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Done',
              style:
                  TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _BusSeatGrid extends StatelessWidget {
  final List<BusSeat> seats;
  const _BusSeatGrid({required this.seats});

  @override
  Widget build(BuildContext context) {
    final maxRow = seats.map((s) => s.row).reduce((a, b) => a > b ? a : b);
    final maxCol = seats.map((s) => s.col).reduce((a, b) => a > b ? a : b);

    return Column(
      children: List.generate(maxRow + 1, (rowIndex) {
        final rowSeats = seats.where((s) => s.row == rowIndex).toList()
          ..sort((a, b) => a.col.compareTo(b.col));

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(maxCol + 1, (colIndex) {
              final seat = rowSeats.firstWhere(
                (s) => s.col == colIndex,
                orElse: () => BusSeat(
                  code: '',
                  row: rowIndex,
                  col: colIndex,
                  isAisle: true,
                  status: SeatStatus.blocked,
                ),
              );

              if (seat.isAisle || seat.code.isEmpty) {
                return Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: const Center(
                    child: Icon(
                      Icons.more_horiz,
                      color: AppColors.border,
                      size: 16,
                    ),
                  ),
                );
              }

              Color bgColor;
              Color borderColor;
              Color textColor;
              IconData? icon;

              switch (seat.status) {
                case SeatStatus.available:
                  bgColor = AppColors.surfaceDark;
                  borderColor = AppColors.primary.withOpacity(0.3);
                  textColor = AppColors.textPrimary;
                  icon = Icons.event_seat_outlined;
                  break;
                case SeatStatus.selected:
                  bgColor = AppColors.accentGreen;
                  borderColor = AppColors.accentGreen;
                  textColor = Colors.white;
                  icon = Icons.check_circle;
                  break;
                case SeatStatus.booked:
                case SeatStatus.blocked:
                  bgColor = AppColors.error.withOpacity(0.15);
                  borderColor = AppColors.error.withOpacity(0.4);
                  textColor = AppColors.error;
                  icon = Icons.cancel;
                  break;
              }

              return GestureDetector(
                onTap: () => context.read<BusBloc>().add(ToggleSeat(seat.code)),
                child: Container(
                  width: 48,
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 2),
                    boxShadow: seat.status == SeatStatus.selected
                        ? [
                            BoxShadow(
                              color: AppColors.accentGreen.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: textColor,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        seat.code,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: color == AppColors.surfaceDark ? AppColors.border : color,
              width: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const _TopBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.10),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SupportButton(
            category: SupportCategory.busTickets,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
