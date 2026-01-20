// lib/features/tours/presentation/screens/tour_booking_screen.dart
import 'package:aman_booking/features/tours/bloc/tour_bloc.dart';
import 'package:aman_booking/features/tours/presentation/screens/tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/core/payment/domain/entities/service_type.dart' as payment;
import 'package:aman_booking/core/payment/domain/entities/payment_request.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_item.dart';
import 'package:aman_booking/core/payment/domain/entities/tax_item.dart';
import 'package:aman_booking/core/payment/presentation/screens/checkout_screen.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class TourBookingScreen extends StatefulWidget {
  final String tourId;

  const TourBookingScreen({super.key, required this.tourId});

  @override
  State<TourBookingScreen> createState() => _TourBookingScreenState();
}

class _TourBookingScreenState extends State<TourBookingScreen> {
  DateTime? _selectedDate;
  int _groupSize = 2;
  bool _isPrivateTour = false;
  List<TextEditingController> _travelerControllers = [];
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    context.read<TourBloc>().add(LoadTourById(widget.tourId));
  }

  void _initializeControllers() {
    _travelerControllers = List.generate(
      _groupSize,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var controller in _travelerControllers) {
      controller.dispose();
    }
    _emailController.dispose();
    _phoneController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  void _updateGroupSize(int newSize, int min, int max) {
    if (newSize < min || newSize > max || newSize == _groupSize) return;

    setState(() {
      if (newSize > _groupSize) {
        // Add new controllers
        for (int i = _groupSize; i < newSize; i++) {
          _travelerControllers.add(TextEditingController());
        }
      } else {
        // Dispose and remove excess controllers
        for (int i = _groupSize - 1; i >= newSize; i--) {
          _travelerControllers[i].dispose();
          _travelerControllers.removeAt(i);
        }
      }
      _groupSize = newSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<TourBloc, TourState>(
        listener: (context, state) {
          if (state is TourBookingCreated) {
            _showSuccessDialog(context, state.confirmationNumber);
          }
          if (state is TourError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TourLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: height * 0.02),
                  const Text(
                    'Loading tour details...',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          if (state is TourError) {
            return _buildErrorView(context, state.message);
          }

          if (state is TourDetailLoaded) {
            return _buildBookingContent(context, state.tour, width, height);
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Iconsax.warning_2, size: 64, color: AppColors.error),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<TourBloc>().add(LoadTourById(widget.tourId));
              },
              icon: const Icon(Iconsax.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingContent(
    BuildContext context,
    Tour tour,
    double width,
    double height,
  ) {
    return CustomScrollView(
      slivers: [
        // Modern App Bar (aligned with other modules)
        SliverAppBar(
          pinned: true,
          floating: false,
          backgroundColor: AppColors.surface,
          elevation: 0,
          toolbarHeight: 64,
          automaticallyImplyLeading: false,
          titleSpacing: 8,
          shape: Border(
            bottom: BorderSide(
              color: AppColors.primary.withOpacity(0.26),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                color: AppColors.textPrimary,
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Complete Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              const SupportButton(
                category: SupportCategory.tours,
                color: AppColors.textPrimary,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.search_normal, size: 18),
                color: AppColors.secondary,
                style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.filter, size: 18),
                color: AppColors.secondary,
                style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.map, size: 18),
                color: AppColors.secondary,
                style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
              ),
            ],
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tour Summary Card
                _buildModernTourSummary(tour, width),
                SizedBox(height: height * 0.03),

                // Tour Type Selection
                _buildModernTourTypeSelection(tour, width),
                SizedBox(height: height * 0.03),

                // Date Selection
                _buildModernDateSelection(tour, width, height),
                SizedBox(height: height * 0.03),

                // Group Size
                _buildModernGroupSize(tour, width),
                SizedBox(height: height * 0.03),

                // Traveler Information
                _buildModernTravelerInfo(width),
                SizedBox(height: height * 0.03),

                // Contact Information
                _buildModernContactInfo(width),
                SizedBox(height: height * 0.03),

                // Special Requirements
                _buildModernSpecialRequirements(width),
                SizedBox(height: height * 0.03),

                // Price Summary
                _buildModernPriceSummary(tour, width),
                SizedBox(height: height * 0.03),

                // Book Button
                _buildModernBookButton(tour, width),
                SizedBox(height: height * 0.05),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTourSummary(Tour tour, double width) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Iconsax.ticket, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tour Summary',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tour.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  Iconsax.location,
                  '${tour.city}, ${tour.country}',
                  AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoChip(
                  Iconsax.clock,
                  tour.duration,
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${tour.rating} (${tour.reviews} reviews)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.people,
                        size: 14, color: AppColors.accentGreen),
                    const SizedBox(width: 4),
                    Text(
                      'Max ${tour.maxCapacity}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentGreen,
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

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTourTypeSelection(Tour tour, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Iconsax.tag, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Select Tour Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTourTypeCard(
                icon: Iconsax.people,
                title: 'Group Tour',
                price: '\$${tour.basePrice.toInt()}',
                description: 'Join others',
                isSelected: !_isPrivateTour,
                isAvailable: tour.isGroupAvailable,
                onTap: () => setState(() => _isPrivateTour = false),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTourTypeCard(
                icon: Iconsax.user,
                title: 'Private Tour',
                price:
                    '\$${(tour.privateTourPrice ?? tour.basePrice * 2).toInt()}',
                description: 'Exclusive',
                isSelected: _isPrivateTour,
                isAvailable: tour.isPrivateAvailable,
                onTap: tour.isPrivateAvailable
                    ? () => setState(() => _isPrivateTour = true)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTourTypeCard({
    required IconData icon,
    required String title,
    required String price,
    required String description,
    required bool isSelected,
    required bool isAvailable,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isAvailable ? AppColors.border : AppColors.textTertiary),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.surfaceDark,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isAvailable
                        ? AppColors.primary
                        : AppColors.textTertiary),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: isSelected
                    ? Colors.white
                    : (isAvailable
                        ? AppColors.textPrimary
                        : AppColors.textTertiary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white.withOpacity(0.8)
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$price pp',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
            if (!isAvailable) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Not Available',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModernDateSelection(Tour tour, double width, double height) {
    // ✅ FIX: Generate available dates with proper slots
    final availableDates = List.generate(
      30,
      (index) => DateTime.now().add(Duration(days: index + 1)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Iconsax.calendar_1, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: height * 0.14,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            itemBuilder: (context, index) {
              final date = availableDates[index];
              final isSelected = _selectedDate != null &&
                  DateFormat('yyyy-MM-dd').format(_selectedDate!) ==
                      DateFormat('yyyy-MM-dd').format(date);

              // ✅ FIX: Generate random available slots (demo data)
              final remainingSlots = 15 + (index % 20); // Demo: 15-35 slots

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                  context.read<TourBloc>().add(
                        CheckTourAvailability(
                          tourId: tour.id,
                          date: date,
                          groupSize: _groupSize,
                          isPrivate: _isPrivateTour,
                        ),
                      );
                },
                child: Container(
                  width: width * 0.24,
                  margin: EdgeInsets.only(right: width * 0.03),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: AppColors.primaryGradient)
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd').format(date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEE').format(date),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white.withOpacity(0.8)
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.2)
                              : (remainingSlots < 10
                                  ? AppColors.error.withOpacity(0.15)
                                  : AppColors.accentGreen.withOpacity(0.15)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$remainingSlots left',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: isSelected
                                ? Colors.white
                                : (remainingSlots < 10
                                    ? AppColors.error
                                    : AppColors.accentGreen),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernGroupSize(Tour tour, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Iconsax.people, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Group Size',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, AppColors.surfaceDark.withOpacity(0.2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _updateGroupSize(
                  _groupSize - 1,
                  tour.minGroupSize,
                  tour.maxCapacity,
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: _groupSize > tour.minGroupSize
                        ? LinearGradient(colors: AppColors.primaryGradient)
                        : null,
                    color: _groupSize > tour.minGroupSize
                        ? null
                        : AppColors.surfaceDark,
                    shape: BoxShape.circle,
                    boxShadow: _groupSize > tour.minGroupSize
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: _groupSize > tour.minGroupSize
                        ? Colors.white
                        : AppColors.textTertiary,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$_groupSize',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Person${_groupSize > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Min: ${tour.minGroupSize} • Max: ${tour.maxCapacity}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _updateGroupSize(
                  _groupSize + 1,
                  tour.minGroupSize,
                  tour.maxCapacity,
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: _groupSize < tour.maxCapacity
                        ? LinearGradient(colors: AppColors.primaryGradient)
                        : null,
                    color: _groupSize < tour.maxCapacity
                        ? null
                        : AppColors.surfaceDark,
                    shape: BoxShape.circle,
                    boxShadow: _groupSize < tour.maxCapacity
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    Icons.add,
                    color: _groupSize < tour.maxCapacity
                        ? Colors.white
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernTravelerInfo(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Iconsax.profile_2user,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Traveler Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...List.generate(_groupSize, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
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
                        gradient:
                            LinearGradient(colors: AppColors.primaryGradient),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Traveler ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _travelerControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Iconsax.user, size: 20),
                    filled: true,
                    fillColor: AppColors.surfaceDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildModernContactInfo(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Iconsax.call, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: const Icon(Iconsax.sms, size: 20),
                  filled: true,
                  fillColor: AppColors.surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Iconsax.call, size: 20),
                  filled: true,
                  fillColor: AppColors.surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernSpecialRequirements(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Iconsax.note_text, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Special Requirements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _requirementsController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText:
                'Dietary restrictions, accessibility needs, special requests...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

// UPDATED SECTION FOR tour_booking_screen.dart
// Replace the _buildModernPriceSummary method with this:

  Widget _buildModernPriceSummary(Tour tour, double width) {
    return BlocBuilder<TourBloc, TourState>(
      builder: (context, state) {
        double pricePerPerson = _isPrivateTour
            ? (tour.privateTourPrice ?? tour.basePrice * 2)
            : tour.getPriceForGroup(_groupSize);

        double totalPrice = pricePerPerson * _groupSize;
        String priceMessage = '';

        // ✅ FIXED: Check for availability info in TourDetailLoaded state
        if (state is TourDetailLoaded && state.availabilityInfo != null) {
          pricePerPerson = state.availabilityInfo!.price;
          totalPrice = state.availabilityInfo!.price * _groupSize;
          priceMessage = state.availabilityInfo!.message;
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.secondary.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price per Person',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '\$${pricePerPerson.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '× $_groupSize person${_groupSize > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              // ✅ Show availability message if exists
              if (priceMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.info_circle,
                          color: AppColors.primary, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          priceMessage,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernBookButton(Tour tour, double width) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color:
            _selectedDate == null ? AppColors.surfaceDark : AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _selectedDate != null
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: _selectedDate == null ? null : () => _handleBooking(tour),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.tick_circle, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Complete Booking',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBooking(Tour tour) {
    // Validation
    final travelerNames = _travelerControllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    if (travelerNames.length != _groupSize) {
      _showErrorSnackBar('Please enter names for all travelers');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your email address');
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your phone number');
      return;
    }

    // Calculate pricing
    final pricePerPerson = _isPrivateTour
        ? (tour.privateTourPrice ?? tour.basePrice * 2)
        : tour.getPriceForGroup(_groupSize);
    final subtotal = pricePerPerson * _groupSize;
    final tourismTax = subtotal * 0.10;
    const guideFee = 15.0;
    const convenienceFee = 5.0;
    final total = subtotal + tourismTax + guideFee + convenienceFee;

    // Build payment request
    final paymentRequest = PaymentRequest(
      id: 'TOUR${DateTime.now().millisecondsSinceEpoch}',
      serviceType: payment.ServiceType.tour,
      serviceName: tour.title,
      serviceIcon: payment.ServiceType.tour.icon,
      items: [
        PaymentItem(
          id: 'tour_booking',
          title: tour.title,
          description:
              '$_groupSize participant(s), ${tour.duration} - ${_isPrivateTour ? 'Private Tour' : 'Group Tour'}',
          basePrice: pricePerPerson,
          quantity: _groupSize,
          serviceType: payment.ServiceType.tour,
          metadata: {
            'tour_id': tour.id,
            'tour_title': tour.title,
            'tour_location': '${tour.city}, ${tour.country}',
            'tour_duration': tour.duration,
            'tour_date': _selectedDate!.toIso8601String(),
            'is_private': _isPrivateTour,
            'group_size': _groupSize,
            'traveler_names': travelerNames,
            'contact_email': _emailController.text.trim(),
            'contact_phone': _phoneController.text.trim(),
            'special_requirements': _requirementsController.text.trim(),
          },
        ),
      ],
      subtotal: subtotal,
      taxes: [
        TaxItem(
          id: 'tourism_tax',
          name: 'Tourism Tax',
          amount: tourismTax,
          percentage: 0.10,
          isInclusive: false,
        ),
        const TaxItem(
          id: 'guide_fee',
          name: 'Guide Fee',
          amount: guideFee,
          isInclusive: false,
        ),
      ],
      discountAmount: 0.0,
      convenienceFee: convenienceFee,
      total: total,
      currency: 'USD',
      serviceMetadata: {
        'booking_reference': 'TOUR${DateTime.now().millisecondsSinceEpoch}',
        'service_type': 'tour',
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
            // Create booking after successful payment
            context.read<TourBloc>().add(
                  CreateTourBooking(
                    tourId: tour.id,
                    date: _selectedDate!,
                    groupSize: _groupSize,
                    isPrivate: _isPrivateTour,
                    travelerNames: travelerNames,
                    contactEmail: _emailController.text.trim(),
                    contactPhone: _phoneController.text.trim(),
                    specialRequirements: _requirementsController.text.trim(),
                  ),
                );

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Tour booked successfully! Invoice: ${invoice.invoiceNumber}'),
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.info_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String confirmationNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.tick_circle,
                    size: 48, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your tour has been successfully booked',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Confirmation Number',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      confirmationNumber,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
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
}
