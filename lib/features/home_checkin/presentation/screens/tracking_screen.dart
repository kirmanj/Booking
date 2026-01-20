// lib/features/home_checkin/presentation/screens/tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/home_checkin/domain/entities/home_checkin_entity.dart';
import 'package:aman_booking/features/home_checkin/presentation/bloc/home_checkin_bloc.dart';
import 'package:aman_booking/features/home_checkin/presentation/screens/boarding_pass_screen.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TrackingScreen extends StatefulWidget {
  final String bookingId;

  const TrackingScreen({super.key, required this.bookingId});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCheckInBloc>().add(StartTracking(widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<HomeCheckInBloc, HomeCheckInState>(
        listener: (context, state) {
          if (state is BoardingPassReady) {
            // Navigate to boarding pass screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<HomeCheckInBloc>(),
                  child: BoardingPassScreen(
                    boardingPass: state.boardingPass,
                    booking: state.booking,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeCheckInLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TrackingActive) {
            return _buildTrackingView(state.booking, state.driverLocation);
          }

          return const Center(child: Text('Loading tracking...'));
        },
      ),
    );
  }

  Widget _buildTrackingView(
    HomeCheckInBooking booking,
    DriverLocation? driverLocation,
  ) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          booking.confirmationNumber ?? 'XXXXXX',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Flight ${booking.flightNumber}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Status Card
                _buildCurrentStatusCard(booking),
                const SizedBox(height: 20),

                // Driver Info (if assigned)
                if (booking.driverName != null) ...[
                  _buildDriverCard(booking, driverLocation),
                  const SizedBox(height: 20),
                ],

                // Progress Timeline
                _buildProgressTimeline(booking),
                const SizedBox(height: 20),

                // Booking Details
                _buildBookingDetailsCard(booking),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStatusCard(HomeCheckInBooking booking) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    String statusDescription;

    switch (booking.status) {
      case BookingStatus.confirmed:
        statusColor = AppColors.accentGreen;
        statusIcon = Iconsax.tick_circle;
        statusText = 'Booking Confirmed';
        statusDescription = 'Waiting for driver assignment';
        break;
      case BookingStatus.driverAssigned:
        statusColor = AppColors.primary;
        statusIcon = Iconsax.user;
        statusText = 'Driver Assigned';
        statusDescription = 'Driver is preparing to collect your bags';
        break;
      case BookingStatus.driverEnRoute:
        statusColor = AppColors.accentOrange;
        statusIcon = Iconsax.car;
        statusText = 'Driver En Route';
        statusDescription = 'Driver is on the way to your location';
        break;
      case BookingStatus.bagsCollected:
        statusColor = AppColors.secondary;
        statusIcon = Iconsax.box;
        statusText = 'Bags Collected';
        statusDescription = 'Heading to the airport';
        break;
      case BookingStatus.atAirport:
        statusColor = AppColors.primary;
        statusIcon = Iconsax.airplane;
        statusText = 'At Airport';
        statusDescription = 'Processing your check-in';
        break;
      case BookingStatus.checkedIn:
        statusColor = AppColors.accentGreen;
        statusIcon = Iconsax.tick_square;
        statusText = 'Bags Checked In';
        statusDescription = 'Generating your boarding pass';
        break;
      case BookingStatus.completed:
        statusColor = AppColors.accentGreen;
        statusIcon = Iconsax.verify;
        statusText = 'Completed';
        statusDescription = 'Boarding pass ready!';
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusIcon = Iconsax.info_circle;
        statusText = 'Pending';
        statusDescription = 'Processing your booking';
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              statusColor.withOpacity(0.15),
              statusColor.withOpacity(0.05)
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(statusIcon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              statusDescription,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textWhite,
              ),
              textAlign: TextAlign.left,
            ),
            if (booking.estimatedArrival != null) ...[
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.timer, color: statusColor, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'ETA: ${booking.estimatedArrival}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(
    HomeCheckInBooking booking,
    DriverLocation? location,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.primaryGradient),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.user,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.driverName ?? 'Driver',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < 4 ? Icons.star : Icons.star_half,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '4.9 (248 trips)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.call,
                  color: AppColors.accentGreen,
                  size: 20,
                ),
              ),
            ],
          ),
          if (booking.vehicleNumber != null) ...[
            const Divider(height: 32),
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    Iconsax.car,
                    'Vehicle',
                    booking.vehicleNumber!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoChip(
                    Iconsax.call_calling,
                    'Phone',
                    booking.driverPhone ?? 'N/A',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTimeline(HomeCheckInBooking booking) {
    final statuses = [
      BookingStatus.confirmed,
      BookingStatus.driverAssigned,
      BookingStatus.driverEnRoute,
      BookingStatus.bagsCollected,
      BookingStatus.atAirport,
      BookingStatus.checkedIn,
      BookingStatus.completed,
    ];

    final statusTitles = {
      BookingStatus.confirmed: 'Booking Confirmed',
      BookingStatus.driverAssigned: 'Driver Assigned',
      BookingStatus.driverEnRoute: 'Driver En Route',
      BookingStatus.bagsCollected: 'Bags Collected',
      BookingStatus.atAirport: 'At Airport',
      BookingStatus.checkedIn: 'Bags Checked In',
      BookingStatus.completed: 'Completed',
    };

    final currentIndex = statuses.indexOf(booking.status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.info_circle,
                  size: 14,
                  color: AppColors.accentOrange,
                ),
                const SizedBox(width: 6),
                Text(
                  'Demo: Click phases below to advance',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentOrange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...statuses.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            final isCompleted = index <= currentIndex;
            final isCurrent = index == currentIndex;
            final isLast = index == statuses.length - 1;
            final canAdvance = index == currentIndex + 1; // Next status

            return InkWell(
              onTap: canAdvance
                  ? () {
                      // Simulate advancing to next phase
                      context.read<HomeCheckInBloc>().add(
                            SimulateStatusUpdate(widget.bookingId, status),
                          );
                    }
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: canAdvance
                      ? AppColors.primary.withOpacity(0.05)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.primary
                                : canAdvance
                                    ? AppColors.primary.withOpacity(0.3)
                                    : AppColors.surfaceDark,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCurrent || canAdvance
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isCurrent || canAdvance
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Icon(
                              isCompleted
                                  ? Iconsax.tick_circle
                                  : canAdvance
                                      ? Iconsax.play
                                      : Iconsax.record_circle,
                              color: isCompleted || canAdvance
                                  ? Colors.white
                                  : AppColors.textTertiary,
                              size: 18,
                            ),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 3,
                            height: 40,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              gradient: isCompleted
                                  ? LinearGradient(
                                      colors: AppColors.primaryGradient,
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : null,
                              color: isCompleted ? null : AppColors.surfaceDark,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16, top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statusTitles[status] ?? '',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isCurrent
                                    ? FontWeight.w900
                                    : FontWeight.w600,
                                color: isCompleted || canAdvance
                                    ? AppColors.textPrimary
                                    : AppColors.textTertiary,
                              ),
                            ),
                            if (isCurrent)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'In progress...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            if (canAdvance)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Tap to advance →',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsCard(HomeCheckInBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.document_text,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Passenger', booking.passengerName),
          _buildDetailRow('Flight', booking.flightNumber),
          _buildDetailRow('From', booking.departureCity),
          _buildDetailRow('To', booking.arrivalCity),
          _buildDetailRow(
            'Flight Date',
            DateFormat('EEE, MMM dd, yyyy').format(booking.flightDate),
          ),
          _buildDetailRow('Departure Time', booking.flightTime),
          _buildDetailRow('Pickup Location', booking.pickupLocation),
          _buildDetailRow('Number of Bags', '${booking.numberOfBags}'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Weight',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${booking.totalWeight.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
