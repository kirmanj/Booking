import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/bookings/data/models/booking_models.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class BookingDetailScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 16),
                  _buildInvoiceCard(),
                  const SizedBox(height: 16),
                  _buildBookingDetailsCard(),
                  const SizedBox(height: 16),
                  _buildCustomerInfoCard(),
                  const SizedBox(height: 16),
                  _buildPriceBreakdownCard(),
                  const SizedBox(height: 16),
                  _buildActionButtons(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getTypeColor().withOpacity(0.1),
                AppColors.surface,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStatusColor().withOpacity(0.1),
            _getStatusColor().withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getStatusIcon(),
              color: _getStatusColor(),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _getStatusColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusDescription(),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
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
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getTypeColor().withOpacity(0.1),
                  _getTypeColor().withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTypeColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(),
                    color: _getTypeColor(),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getBookingTitle(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Booking ID: ${booking.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Booking info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInfoRow(
                  'Booking Date',
                  DateFormat('MMM dd, yyyy • hh:mm a')
                      .format(booking.bookingDate),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Service Date',
                  DateFormat('MMM dd, yyyy').format(booking.serviceDate),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Booking Reference',
                  booking.id,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.document_text_1_copy,
                color: _getTypeColor(),
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._buildTypeSpecificDetails(),
        ],
      ),
    );
  }

  List<Widget> _buildTypeSpecificDetails() {
    final details = <Widget>[];

    switch (booking.type) {
      case BookingType.flight:
        final flight = booking as FlightBooking;
        details.addAll([
          _buildDetailRow('Airline', flight.airline),
          _buildDetailRow('Flight Number', flight.flightNumber),
          _buildDetailRow('PNR', flight.pnr),
          _buildDetailRow('Route', '${flight.from} → ${flight.to}'),
          _buildDetailRow('Departure', flight.departureTime.toString()),
          _buildDetailRow('Arrival', flight.arrivalTime.toString()),
          _buildDetailRow('Class', flight.classType),
          _buildDetailRow('Passengers', flight.passengers.toString()),
        ]);
        break;

      case BookingType.hotel:
        final hotel = booking as HotelBooking;
        details.addAll([
          _buildDetailRow('Hotel', hotel.hotelName),
          _buildDetailRow('Location', hotel.location),
          _buildDetailRow('Room Type', hotel.roomType),
          _buildDetailRow(
              'Guests', '${hotel.guests} Guest${hotel.guests > 1 ? 's' : ''}'),
          _buildDetailRow(
              'Check-in', DateFormat('MMM dd, yyyy').format(hotel.checkIn)),
          _buildDetailRow(
              'Check-out', DateFormat('MMM dd, yyyy').format(hotel.checkOut)),
          _buildDetailRow(
              'Nights', '${hotel.nights} Night${hotel.nights > 1 ? 's' : ''}'),
        ]);
        break;

      case BookingType.carRental:
        final car = booking as CarRentalBooking;
        details.addAll([
          _buildDetailRow('Car', '${car.carBrand} ${car.carModel}'),
          _buildDetailRow('Rental Company', car.customerName),
          _buildDetailRow('Pick-up', car.pickupLocation),
          _buildDetailRow('Drop-off', car.returnLocation),
          _buildDetailRow('Pick-up Date',
              DateFormat('MMM dd, yyyy • hh:mm a').format(car.pickupDate)),
          _buildDetailRow('Drop-off Date',
              DateFormat('MMM dd, yyyy • hh:mm a').format(car.returnDate)),
          _buildDetailRow(
              'Rental Days', '${car.days} Day${car.days > 1 ? 's' : ''}'),
        ]);
        break;

      case BookingType.tour:
        final tour = booking as TourBooking;
        details.addAll([
          _buildDetailRow('Tour', tour.tourName),
          _buildDetailRow('Location', tour.destination),
          _buildDetailRow('Duration', tour.duration),
          _buildDetailRow('Travelers',
              '${tour.participants} Traveler${tour.participants > 1 ? 's' : ''}'),
          _buildDetailRow(
              'Tour Date', DateFormat('MMM dd, yyyy').format(tour.tourDate)),
          _buildDetailRow('Guide', tour.tourName),
        ]);
        break;

      case BookingType.busTicket:
        final bus = booking as BusTicketBooking;
        details.addAll([
          _buildDetailRow('Bus Operator', bus.busCompany),
          _buildDetailRow('Route', '${bus.from} → ${bus.to}'),
          _buildDetailRow('Departure', bus.departureTime.toString()),
          _buildDetailRow('Arrival', bus.arrivalTime.toString()),
          _buildDetailRow('Bus Number', bus.busNumber),
          _buildDetailRow('Seats', bus.seatNumbers),
          _buildDetailRow('Passengers', bus.passengers.toString()),
        ]);
        break;

      case BookingType.eSim:
        final esim = booking as ESimBooking;
        details.addAll([
          _buildDetailRow('Provider', esim.packageName),
          _buildDetailRow('Plan', esim.packageName),
          _buildDetailRow('Country', esim.country),
          _buildDetailRow('Data', esim.dataAmount),
          _buildDetailRow('Validity', '${esim.validityDays} Days'),
          _buildDetailRow('ICCID', esim.simNumber),
          _buildDetailRow('Activation Date',
              DateFormat('MMM dd, yyyy').format(esim.activationDate)),
        ]);
        break;

      case BookingType.airportTaxi:
        final taxi = booking as AirportTaxiBooking;
        details.addAll([
          _buildDetailRow('Service', taxi.type.name),
          _buildDetailRow('Vehicle', taxi.vehicleModel),
          _buildDetailRow('Pick-up', taxi.pickupLocation),
          _buildDetailRow('Drop-off', taxi.dropoffLocation),
          _buildDetailRow('Pick-up Time',
              DateFormat('MMM dd, yyyy • hh:mm a').format(taxi.pickupTime)),
          _buildDetailRow('Driver', taxi.driverName),
          _buildDetailRow('Vehicle No.', taxi.vehiclePlate),
        ]);
        break;

      case BookingType.homeCheckin:
        final checkin = booking as HomeCheckinBooking;
        details.addAll([
          _buildDetailRow('Airline', checkin.airline),
          _buildDetailRow('Flight Number', checkin.flightNumber),
          _buildDetailRow('PNR', checkin.boardingPassNumber),
          _buildDetailRow(
              'Route', '${checkin.nationality} → ${checkin.nationality}'),
          _buildDetailRow('Flight Date',
              DateFormat('MMM dd, yyyy').format(checkin.flightTime)),
          _buildDetailRow('Departure', checkin.pickupTime.toString()),
          _buildDetailRow('Seat', checkin.seatNumber),
          _buildDetailRow('Boarding Pass', checkin.boardingPassNumber),
        ]);
        break;
    }

    return details;
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.user_copy,
                color: _getTypeColor(),
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Customer Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Name', booking.customerName),
          _buildDetailRow('Email', booking.customerEmail),
          _buildDetailRow('Phone', booking.customerPhone),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdownCard() {
    final subtotal = booking.totalAmount / 1.15; // Assuming 15% tax
    final tax = booking.totalAmount - subtotal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.wallet_money_copy,
                color: _getTypeColor(),
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Price Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPriceRow('Subtotal', subtotal),
          _buildPriceRow('Tax & Fees', tax),
          const Divider(height: 24),
          _buildPriceRow('Total Amount', booking.totalAmount, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.w700,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (booking.status == BookingStatus.upcoming) ...[
          _buildActionButton(
            icon: Iconsax.edit_2_copy,
            label: 'Modify Booking',
            color: AppColors.primary,
            onTap: () {
              // TODO: Navigate to modify booking screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Modify booking feature coming soon')),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
        _buildActionButton(
          icon: Iconsax.document_download_copy,
          label: 'Download Receipt',
          color: Colors.blue,
          onTap: () {
            // TODO: Implement download receipt
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Receipt downloaded successfully')),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          icon: Iconsax.message_question_copy,
          label: 'Contact Support',
          color: Colors.orange,
          onTap: () {
            // TODO: Navigate to support with pre-filled booking info
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening support chat...')),
            );
          },
        ),
        if (booking.status == BookingStatus.upcoming) ...[
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Iconsax.close_circle_copy,
            label: 'Cancel Booking',
            color: Colors.red,
            onTap: () => _showCancelDialog(context),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel Booking',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancelled successfully')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _getBookingTitle() {
    switch (booking.type) {
      case BookingType.flight:
        final flight = booking as FlightBooking;
        return '${flight.from} → ${flight.to}';
      case BookingType.hotel:
        return (booking as HotelBooking).hotelName;
      case BookingType.carRental:
        final car = booking as CarRentalBooking;
        return '${car.carBrand} ${car.carModel}';
      case BookingType.tour:
        return (booking as TourBooking).tourName;
      case BookingType.busTicket:
        final bus = booking as BusTicketBooking;
        return '${bus.from} → ${bus.to}';
      case BookingType.eSim:
        return (booking as ESimBooking).packageName;
      case BookingType.airportTaxi:
        return (booking as AirportTaxiBooking).type.name;
      case BookingType.homeCheckin:
        final checkin = booking as HomeCheckinBooking;
        return '${checkin.nationality} → ${checkin.nationality}';
    }
  }

  IconData _getTypeIcon() {
    switch (booking.type) {
      case BookingType.flight:
        return Iconsax.airplane_copy;
      case BookingType.hotel:
        return Iconsax.house_2_copy;
      case BookingType.carRental:
        return Iconsax.car_copy;
      case BookingType.tour:
        return Iconsax.map_1_copy;
      case BookingType.busTicket:
        return Iconsax.bus_copy;
      case BookingType.eSim:
        return Iconsax.simcard_copy;
      case BookingType.airportTaxi:
        return Iconsax.car_copy;
      case BookingType.homeCheckin:
        return Iconsax.home_wifi_copy;
    }
  }

  Color _getTypeColor() {
    switch (booking.type) {
      case BookingType.flight:
        return Colors.blue;
      case BookingType.hotel:
        return Colors.purple;
      case BookingType.carRental:
        return Colors.orange;
      case BookingType.tour:
        return Colors.green;
      case BookingType.busTicket:
        return Colors.teal;
      case BookingType.eSim:
        return Colors.indigo;
      case BookingType.airportTaxi:
        return Colors.amber;
      case BookingType.homeCheckin:
        return Colors.cyan;
    }
  }

  Color _getStatusColor() {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return Colors.blue;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.inProgress:
        return Colors.orange;
      case BookingStatus.pending:
        return Colors.grey;
      case BookingStatus.confirmed:
        return Colors.purpleAccent;
    }
  }

  IconData _getStatusIcon() {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return Iconsax.clock_copy;
      case BookingStatus.completed:
        return Iconsax.tick_circle_copy;
      case BookingStatus.cancelled:
        return Iconsax.close_circle_copy;
      case BookingStatus.inProgress:
        return Iconsax.refresh_copy;
      case BookingStatus.pending:
        return Iconsax.timer_1_copy;
      case BookingStatus.confirmed:
        return Iconsax.tick_square;
    }
  }

  String _getStatusText() {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
    }
  }

  String _getStatusDescription() {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return 'Your booking is confirmed and scheduled';
      case BookingStatus.completed:
        return 'This booking has been completed';
      case BookingStatus.cancelled:
        return 'This booking has been cancelled';
      case BookingStatus.inProgress:
        return 'This booking is currently in progress';
      case BookingStatus.pending:
        return 'This booking is pending confirmation';
      case BookingStatus.confirmed:
        return 'This booking is Confirmed';
    }
  }
}
