import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:aman_booking/features/bookings/data/models/booking_models.dart';
import 'package:aman_booking/features/bookings/data/sample_bookings.dart';
import 'package:aman_booking/features/bookings/presentation/screens/booking_detail_screen.dart';

class RedesignedBookingsScreen extends StatefulWidget {
  const RedesignedBookingsScreen({super.key});

  @override
  State<RedesignedBookingsScreen> createState() =>
      _RedesignedBookingsScreenState();
}

class _RedesignedBookingsScreenState extends State<RedesignedBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Booking> _allBookings = SampleBookings.getAllBookings();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Booking> get _filteredBookings {
    return _allBookings.where((booking) {
      switch (_tabController.index) {
        case 0: // All
          return true;
        case 1: // Upcoming
          return booking.status == BookingStatus.upcoming ||
              booking.status == BookingStatus.confirmed;
        case 2: // Completed
          return booking.status == BookingStatus.completed;
        case 3: // Cancelled
          return booking.status == BookingStatus.cancelled;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildStatsCards(),
                _buildTabBar(),
                const SizedBox(height: 8),
              ],
            ),
          ),
          _buildBookingsList(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final upcoming = _allBookings
        .where((b) =>
            b.status == BookingStatus.upcoming ||
            b.status == BookingStatus.confirmed)
        .length;
    final total = _allBookings.length;
    final totalSpent = _allBookings
        .where((b) => b.status != BookingStatus.cancelled)
        .fold<double>(0, (sum, booking) => sum + booking.totalAmount);

    return SliverAppBar(
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
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'My Bookings',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$upcoming upcoming • $total total trips',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total spent: \$${totalSpent.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.search_normal_1, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Iconsax.filter, color: Colors.white),
          onPressed: _showFilterSheet,
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    final upcoming = _allBookings
        .where((b) =>
            b.status == BookingStatus.upcoming ||
            b.status == BookingStatus.confirmed)
        .length;
    final completed =
        _allBookings.where((b) => b.status == BookingStatus.completed).length;
    final cancelled =
        _allBookings.where((b) => b.status == BookingStatus.cancelled).length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Upcoming',
              upcoming.toString(),
              AppColors.accentOrange,
              Iconsax.clock,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Completed',
              completed.toString(),
              AppColors.accentGreen,
              Iconsax.tick_circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Cancelled',
              cancelled.toString(),
              AppColors.error,
              Iconsax.close_circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false, // keep equal widths
        labelPadding: EdgeInsets.zero, // ✅ removes spacing between tabs
        indicatorPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,

        indicator: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(12),
        ),

        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,

        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        unselectedLabelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),

        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Tab(text: 'All'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Tab(text: 'Upcoming'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Tab(text: 'Completed'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Tab(text: 'Cancelled'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    final bookings = _filteredBookings;

    if (bookings.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.note_remove,
                size: 80,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No bookings found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your bookings will appear here',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildBookingCard(bookings[index]);
          },
          childCount: bookings.length,
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailScreen(booking: booking),
          ),
        );
      },
      child: Container(
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
            // Header
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
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(booking.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getTypeColor(booking.type).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTypeIcon(booking.type),
                          size: 14,
                          color: _getTypeColor(booking.type),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          booking.getTypeDisplayName(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _getTypeColor(booking.type),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
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
                      booking.getStatusDisplayName(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
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
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getTypeColor(booking.type),
                              _getTypeColor(booking.type).withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _getTypeIcon(booking.type),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getBookingTitle(booking),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.calendar,
                                  size: 14,
                                  color: AppColors.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM dd, yyyy')
                                      .format(booking.serviceDate),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Booking ID: ${booking.id}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textTertiary,
                              ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${booking.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookingDetailScreen(booking: booking),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBookingTitle(Booking booking) {
    if (booking is FlightBooking) {
      return '${booking.from} → ${booking.to}';
    } else if (booking is HotelBooking) {
      return booking.hotelName;
    } else if (booking is CarRentalBooking) {
      return '${booking.carBrand} ${booking.carModel}';
    } else if (booking is TourBooking) {
      return booking.tourName;
    } else if (booking is BusTicketBooking) {
      return '${booking.from} → ${booking.to}';
    } else if (booking is ESimBooking) {
      return booking.packageName;
    } else if (booking is AirportTaxiBooking) {
      return 'Airport Transfer';
    } else if (booking is HomeCheckinBooking) {
      return 'Home Check-In Service';
    }
    return 'Booking';
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return AppColors.accentOrange;
      case BookingStatus.confirmed:
        return AppColors.accentGreen;
      case BookingStatus.completed:
        return AppColors.primary;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.inProgress:
        return AppColors.accentPurple;
      case BookingStatus.pending:
        return AppColors.accentYellow;
    }
  }

  Color _getTypeColor(BookingType type) {
    switch (type) {
      case BookingType.flight:
        return AppColors.primary;
      case BookingType.hotel:
        return AppColors.accentPurple;
      case BookingType.carRental:
        return AppColors.accentOrange;
      case BookingType.tour:
        return AppColors.accentGreen;
      case BookingType.busTicket:
        return AppColors.accentGreen;
      case BookingType.eSim:
        return AppColors.primary;
      case BookingType.airportTaxi:
        return AppColors.accentOrange;
      case BookingType.homeCheckin:
        return AppColors.accentPurple;
    }
  }

  IconData _getTypeIcon(BookingType type) {
    switch (type) {
      case BookingType.flight:
        return Iconsax.airplane;
      case BookingType.hotel:
        return Iconsax.building_4;
      case BookingType.carRental:
        return Iconsax.car;
      case BookingType.tour:
        return Iconsax.map_1;
      case BookingType.busTicket:
        return Iconsax.bus;
      case BookingType.eSim:
        return Iconsax.simcard;
      case BookingType.airportTaxi:
        return Iconsax.car;
      case BookingType.homeCheckin:
        return Iconsax.home_2;
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Bookings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Filter options will be implemented here'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
