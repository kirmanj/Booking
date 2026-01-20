import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedSegment = 0;
  final List<BookingItem> _bookings = [
    BookingItem(
      id: 'BK-2024-001',
      title: 'Bali Paradise Resort',
      type: 'Hotel',
      status: 'Confirmed',
      date: DateTime.now().add(const Duration(days: 7)),
      price: 299.99,
      guests: 2,
      nights: 3,
      image: 'assets/images/hotel1.jpg',
    ),
    BookingItem(
      id: 'BK-2024-002',
      title: 'Tokyo to Seoul Flight',
      type: 'Flight',
      status: 'Upcoming',
      date: DateTime.now().add(const Duration(days: 14)),
      price: 420.50,
      guests: 1,
      nights: 0,
      image: 'assets/images/flight1.jpg',
    ),
    BookingItem(
      id: 'BK-2024-003',
      title: 'Premium SUV Rental',
      type: 'Car',
      status: 'Completed',
      date: DateTime.now().subtract(const Duration(days: 7)),
      price: 599.00,
      guests: 1,
      nights: 7,
      image: 'assets/images/car1.jpg',
    ),
    BookingItem(
      id: 'BK-2024-004',
      title: 'Santorini Sunset Tour',
      type: 'Tour',
      status: 'Cancelled',
      date: DateTime.now().subtract(const Duration(days: 3)),
      price: 189.99,
      guests: 4,
      nights: 0,
      image: 'assets/images/tour1.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Segmented Control
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildSegment('Upcoming', 0),
                  _buildSegment('Completed', 1),
                  _buildSegment('Cancelled', 2),
                ],
              ),
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatCard('Total Bookings', '12', AppColors.primary),
                const SizedBox(width: 12),
                _buildStatCard('Total Spent', '\$2,450', AppColors.accentGreen),
                const SizedBox(width: 12),
                _buildStatCard('Upcoming', '3', AppColors.accentOrange),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bookings List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                final booking = _bookings[index];
                return _buildBookingCard(booking);
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'My Bookings',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: false,
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.filter, size: 22),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSegment(String label, int index) {
    final isSelected = _selectedSegment == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSegment = index),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingItem booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.id,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('MMM dd, yyyy').format(booking.date),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon/Image
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _getTypeColor(booking.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getTypeIcon(booking.type),
                        color: _getTypeColor(booking.type),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 16,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${booking.guests} Guest${booking.guests > 1 ? 's' : ''}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (booking.nights > 0) ...[
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.nightlight_round_outlined,
                                  size: 16,
                                  color: AppColors.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${booking.nights} Night${booking.nights > 1 ? 's' : ''}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${booking.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        if (booking.status == 'Upcoming' ||
                            booking.status == 'Confirmed')
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.error),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.accentGreen;
      case 'upcoming':
        return AppColors.accentOrange;
      case 'completed':
        return AppColors.primary;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textTertiary;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'hotel':
        return AppColors.accentGreen;
      case 'flight':
        return AppColors.accentGreen;
      case 'car':
        return AppColors.accentOrange;
      case 'tour':
        return AppColors.accentRed;
      default:
        return AppColors.primary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'hotel':
        return Iconsax.house;
      case 'flight':
        return Iconsax.airplane;
      case 'car':
        return Iconsax.car;
      case 'tour':
        return Iconsax.location;
      default:
        return Iconsax.box;
    }
  }
}

class BookingItem {
  final String id;
  final String title;
  final String type;
  final String status;
  final DateTime date;
  final double price;
  final int guests;
  final int nights;
  final String image;

  BookingItem({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.date,
    required this.price,
    required this.guests,
    required this.nights,
    required this.image,
  });
}
