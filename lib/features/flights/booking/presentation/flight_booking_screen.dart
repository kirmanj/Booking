import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/flights/bloc/flights_state.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

// Payment Hub Imports
import 'package:aman_booking/core/payment/domain/entities/service_type.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_request.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_item.dart';
import 'package:aman_booking/core/payment/domain/entities/tax_item.dart';
import 'package:aman_booking/core/payment/presentation/screens/checkout_screen.dart';

// Support Imports
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class FlightBookingScreen extends StatefulWidget {
  final FlightModel flight;

  const FlightBookingScreen({
    super.key,
    required this.flight,
  });

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flightPathAnimation;

  final List<Traveler> _travelers = [];

  @override
  void initState() {
    super.initState();

    // Animation controller for airplane movement
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    // Slower movement that pauses briefly on stops
    _flightPathAnimation = _buildStopAnimation(
      controller: _animationController,
      stops: widget.flight.stops,
      moveWeight: 100,
      pauseWeight: 60,
    );

    // Start animation and loop it
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            _animationController.reverse();
          }
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            _animationController.forward();
          }
        });
      }
    });

    // Add one default traveler
    _travelers.add(Traveler(
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Animation<double> _buildStopAnimation({
    required AnimationController controller,
    required int stops,
    double moveWeight = 100,
    double pauseWeight = 20,
  }) {
    // progress points: 0 -> stop1 -> stop2 -> ... -> 1
    final points = <double>[0.0];
    for (int i = 1; i <= stops; i++) {
      points.add(i / (stops + 1));
    }
    points.add(1.0);

    final items = <TweenSequenceItem<double>>[];

    for (int i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];

      // move segment
      items.add(
        TweenSequenceItem(
          tween: Tween<double>(begin: a, end: b).chain(
            CurveTween(curve: Curves.easeInOut),
          ),
          weight: moveWeight,
        ),
      );

      // pause on stops (pause at every stop point, but not at final destination)
      final isFinal = (i + 1) == (points.length - 1);
      if (!isFinal) {
        items.add(
          TweenSequenceItem(
            tween: ConstantTween<double>(b),
            weight: pauseWeight,
          ),
        );
      }
    }

    return TweenSequence<double>(items).animate(controller);
  }

  Path _buildFlightPath(Size size) {
    final startPoint = Offset(40, size.height - 40);
    final endPoint = Offset(size.width - 40, 40);

    final path = Path()..moveTo(startPoint.dx, startPoint.dy);

    final controlPoint1 = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.3,
      startPoint.dy - 60,
    );
    final controlPoint2 = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.7,
      endPoint.dy - 20,
    );

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Animated Flight Path
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 20, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Flight Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            actions: const [
              SupportButton(
                category: SupportCategory.flights,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.9),
                      AppColors.primary.withOpacity(0.5),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 60, left: 20, right: 20, bottom: 20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = Size(constraints.maxWidth, 200);

                        final path = _buildFlightPath(size);
                        final metric = path.computeMetrics().first;

                        final originCode = widget.flight.origin
                            .split('(')[1]
                            .replaceAll(')', '');
                        final destCode = widget.flight.destination
                            .split('(')[1]
                            .replaceAll(')', '');

                        final timeFmt = DateFormat('HH:mm');

                        return Stack(
                          children: [
                            // ✅ Static paint (repaints once)
                            RepaintBoundary(
                              child: CustomPaint(
                                size: size,
                                painter: FlightPathStaticPainter(
                                    origin: originCode,
                                    destination: destCode,
                                    stops: widget.flight.stops,
                                    departureTime: timeFmt
                                        .format(widget.flight.departureTime),
                                    arrivalTime: timeFmt
                                        .format(widget.flight.arrivalTime),
                                    context: context),
                              ),
                            ),

                            // ✅ Moving airplane widget (cheap)
                            AnimatedBuilder(
                              animation: _flightPathAnimation,
                              child: Image.asset(
                                'assets/icons/airplane.png',
                                width: 50,
                                height: 50,
                              ),
                              builder: (context, airplaneChild) {
                                final p =
                                    _flightPathAnimation.value.clamp(0.0, 1.0);
                                final t = metric
                                    .getTangentForOffset(metric.length * p);
                                if (t == null) return const SizedBox.shrink();

                                final pos = t.position;
                                final angle = t.angle;

                                return Positioned(
                                  left: pos.dx - 28,
                                  top: pos.dy - 30,
                                  child: Transform.rotate(
                                    angle: angle -
                                        (math.pi /
                                            2.7), // adjust if your PNG faces another direction
                                    child: airplaneChild!,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flight Info Card
                  _buildFlightInfoCard(),

                  const SizedBox(height: 16),

                  // Flight Details
                  _buildFlightDetailsCard(),

                  const SizedBox(height: 16),

                  // Baggage & Amenities
                  _buildBaggageCard(),

                  const SizedBox(height: 16),

                  // Travelers Section
                  _buildTravelersSection(),

                  const SizedBox(height: 16),

                  // Price Breakdown
                  _buildPriceBreakdown(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildFlightInfoCard() {
    final dateFormat = DateFormat('HH:mm');
    final dayFormat = DateFormat('EEE, MMM dd');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Airline Header
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.flight.airlineCode,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.flight.airline,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      widget.flight.flightNumber,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.flight.stops == 0
                      ? AppColors.accentGreen.withOpacity(0.1)
                      : AppColors.accentOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.flight.stops == 0
                        ? AppColors.accentGreen.withOpacity(0.3)
                        : AppColors.accentOrange.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  widget.flight.stopsText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.flight.stops == 0
                        ? AppColors.accentGreen
                        : AppColors.accentOrange,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Route Timeline
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Departure
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormat.format(widget.flight.departureTime),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.flight.origin.split('(')[1].replaceAll(')', ''),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.flight.origin.split('(')[0].trim(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayFormat.format(widget.flight.departureTime),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Duration
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Iconsax.clock,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.flight.duration,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrival
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      dateFormat.format(widget.flight.arrivalTime),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.flight.destination
                          .split('(')[1]
                          .replaceAll(')', ''),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.flight.destination.split('(')[0].trim(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayFormat.format(widget.flight.arrivalTime),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Flight Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(Iconsax.airplane, 'Aircraft', 'Boeing 777-300ER'),
          _buildDetailRow(Icons.chair, 'Seat Class', 'Economy'),
          _buildDetailRow(Iconsax.ticket, 'Ticket Type', 'E-Ticket'),
          _buildDetailRow(Iconsax.calendar, 'Booking Date',
              DateFormat('MMM dd, yyyy').format(DateTime.now())),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaggageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Baggage & Amenities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAmenityChip(Iconsax.bag_tick, 'Cabin: 7kg'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAmenityChip(Iconsax.bag_2, 'Check-in: 23kg'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAmenityChip(Iconsax.wifi, 'Free WiFi'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAmenityChip(Iconsax.coffee, 'Meals Included'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelersSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Travelers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: _addTraveler,
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._travelers.asMap().entries.map((entry) {
            return _buildTravelerCard(entry.key, entry.value);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTravelerCard(int index, Traveler traveler) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  index == 0 ? 'Primary Traveler' : 'Traveler ${index + 1}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (index > 0)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: AppColors.textTertiary,
                  onPressed: () => _removeTraveler(index),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField('First Name', 'John'),
          const SizedBox(height: 8),
          _buildTextField('Last Name', 'Doe'),
          const SizedBox(height: 8),
          _buildTextField('Email', 'john.doe@example.com'),
          const SizedBox(height: 8),
          _buildTextField('Phone', '+964 770 123 4567'),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        hintStyle: TextStyle(fontSize: 13, color: AppColors.textTertiary),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    final baseFare = widget.flight.price * _travelers.length;
    final taxesAndFees = baseFare * 0.15;
    final totalPrice = baseFare + taxesAndFees;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            'Base Fare (${_travelers.length} traveler${_travelers.length > 1 ? 's' : ''})',
            '\$${baseFare.toStringAsFixed(2)}',
          ),
          _buildPriceRow(
              'Taxes & Fees (15%)', '\$${taxesAndFees.toStringAsFixed(2)}'),
          const Divider(height: 24),
          _buildPriceRow(
            'Total Amount',
            '\$${totalPrice.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 15,
              fontWeight: FontWeight.w700,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final totalPrice = (widget.flight.price * _travelers.length) +
        (widget.flight.price * _travelers.length * 0.15);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _proceedToPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue to Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTraveler() {
    setState(() {
      _travelers.add(Traveler(
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
      ));
    });
  }

  void _removeTraveler(int index) {
    if (_travelers.length > 1) {
      setState(() {
        _travelers.removeAt(index);
      });
    }
  }

  void _proceedToPayment() {
    // Validate travelers
    if (_travelers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one traveler'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Calculate pricing
    final baseFare = widget.flight.price * _travelers.length;
    final airportTax = baseFare * 0.05;
    final fuelSurcharge = 25.00 * _travelers.length;
    final convenienceFee = 5.00;
    final subtotal = baseFare;
    final totalTaxes = airportTax + fuelSurcharge;
    final total = subtotal + totalTaxes + convenienceFee;

    // Build payment items
    final List<PaymentItem> items = [
      PaymentItem(
        id: 'flight_ticket',
        title: '${widget.flight.airline} - ${widget.flight.flightNumber}',
        description: '${_travelers.length} Passenger(s), Economy Class',
        basePrice: widget.flight.price,
        quantity: _travelers.length,
        serviceType: ServiceType.flight,
        metadata: {
          'airline': widget.flight.airline,
          'airline_code': widget.flight.airlineCode,
          'flight_number': widget.flight.flightNumber,
          'origin': widget.flight.origin,
          'destination': widget.flight.destination,
          'departure_time': widget.flight.departureTime.toIso8601String(),
          'arrival_time': widget.flight.arrivalTime.toIso8601String(),
          'duration': widget.flight.duration,
          'stops': widget.flight.stops,
          'travelers': _travelers.length,
        },
      ),
    ];

    // Build tax items
    final List<TaxItem> taxes = [
      TaxItem(
        id: 'airport_tax',
        name: 'Airport Tax',
        amount: airportTax,
        percentage: 0.05,
        isInclusive: false,
      ),
      TaxItem(
        id: 'fuel_surcharge',
        name: 'Fuel Surcharge',
        amount: fuelSurcharge,
        isInclusive: false,
      ),
    ];

    // Create payment request
    final paymentRequest = PaymentRequest(
      id: 'FL${DateTime.now().millisecondsSinceEpoch}',
      serviceType: ServiceType.flight,
      serviceName: '${widget.flight.origin.split('(')[0].trim()} to ${widget.flight.destination.split('(')[0].trim()}',
      serviceIcon: ServiceType.flight.icon,
      items: items,
      subtotal: subtotal,
      taxes: taxes,
      discountAmount: 0.0,
      convenienceFee: convenienceFee,
      total: total,
      currency: 'USD',
      serviceMetadata: {
        'booking_reference': 'FL${DateTime.now().millisecondsSinceEpoch}',
        'flight_data': {
          'airline': widget.flight.airline,
          'flight_number': widget.flight.flightNumber,
          'origin': widget.flight.origin,
          'destination': widget.flight.destination,
          'departure': widget.flight.departureTime.toIso8601String(),
          'arrival': widget.flight.arrivalTime.toIso8601String(),
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
                content: Text('Flight booked successfully! Invoice: ${invoice.invoiceNumber}'),
                backgroundColor: AppColors.accentGreen,
              ),
            );

            // Navigate back to home or flights list
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }
}

// Flight Path Painter with Animated Airplane
class FlightPathStaticPainter extends CustomPainter {
  final String origin;
  final String destination;
  final int stops;
  final String departureTime;
  final String arrivalTime;
  final BuildContext context;

  FlightPathStaticPainter({
    required this.origin,
    required this.destination,
    required this.stops,
    required this.departureTime,
    required this.arrivalTime,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final startPoint = Offset(40, size.height - 40);
    final endPoint = Offset(size.width - 40, 40);

    // Path
    final path = Path()..moveTo(startPoint.dx, startPoint.dy);

    final controlPoint1 = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.3,
      startPoint.dy - 60,
    );
    final controlPoint2 = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.7,
      endPoint.dy - 20,
    );

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // dashed line (static so OK)
    final paintLine = Paint()
      ..color = AppColors.textWhite.withOpacity(0.30)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _drawDashedPath(canvas, path, paintLine);

    // markers
    _drawLocationMarker(canvas, startPoint,
        code: origin,
        time: departureTime,
        color: AppColors.secondary,
        isStart: true,
        context: context);

    _drawLocationMarker(canvas, endPoint,
        code: destination,
        time: arrivalTime,
        color: AppColors.primary,
        isStart: false,
        context: context);

    // stops
    if (stops > 0) {
      final metric = path.computeMetrics().first;
      for (int i = 1; i <= stops; i++) {
        final stopProgress = i / (stops + 1);
        final stopTangent =
            metric.getTangentForOffset(metric.length * stopProgress);
        if (stopTangent != null) {
          _drawStopMarker(canvas, stopTangent.position);
        }
      }
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final start = metric.getTangentForOffset(distance)?.position;
        distance += dashWidth;
        final end = metric.getTangentForOffset(distance)?.position;
        if (start != null && end != null) {
          canvas.drawLine(start, end, paint);
        }
        distance += dashSpace;
      }
    }
  }

  void _drawLocationMarker(Canvas canvas, Offset position,
      {required String code,
      required String time,
      required Color color,
      required bool isStart,
      required BuildContext context}) {
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, 10, borderPaint);
    canvas.drawCircle(position, 8, fillPaint);

    // Code
    final codePainter = TextPainter(
      text: TextSpan(
        text: code,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.textWhite,
        ),
      ),
      textDirection: Directionality.of(context),
    )..layout();

    // Time
    final timePainter = TextPainter(
      text: TextSpan(
        text: time,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textWhite,
        ),
      ),
      textDirection: Directionality.of(context),
    )..layout();

    final dy = isStart ? (position.dy + 14) : (position.dy - 38);

    codePainter.paint(
      canvas,
      Offset(position.dx - codePainter.width / 2, dy),
    );
    timePainter.paint(
      canvas,
      Offset(position.dx - timePainter.width / 2, dy + 16),
    );
  }

  void _drawStopMarker(Canvas canvas, Offset position) {
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppColors.accentOrange
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, 8, borderPaint);
    canvas.drawCircle(position, 6, fillPaint);
  }

  @override
  bool shouldRepaint(covariant FlightPathStaticPainter oldDelegate) => false;
}

// Traveler Model
class Traveler {
  String firstName;
  String lastName;
  String email;
  String phone;

  Traveler({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });
}
