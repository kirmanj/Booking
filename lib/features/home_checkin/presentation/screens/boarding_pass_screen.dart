// lib/features/home_checkin/presentation/screens/boarding_pass_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/home_checkin/domain/entities/home_checkin_entity.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class BoardingPassScreen extends StatelessWidget {
  final BoardingPass boardingPass;
  final HomeCheckInBooking booking;

  const BoardingPassScreen({
    super.key,
    required this.boardingPass,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.accentGreen,
            actions: const [
              SupportButton(
                category: SupportCategory.homeCheckin,
                color: Colors.white,
              ),
              SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentGreen,
                      AppColors.accentGreen.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Boarding Pass Ready!',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Iconsax.tick_circle,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
                children: [
                  // Success Message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accentGreen.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          color: AppColors.accentGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'All Set!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.accentGreen,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your ${booking.numberOfBags} bag${booking.numberOfBags > 1 ? 's have' : ' has'} been checked in. Proceed directly to passport control.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Boarding Pass
                  _buildBoardingPass(context),
                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButtons(context),
                  const SizedBox(height: 24),

                  // Important Instructions
                  _buildImportantInstructions(),
                  const SizedBox(height: 24),

                  // Bag Details
                  _buildBagDetails(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardingPass(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with airline branding
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
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
                          boardingPass.airline,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          boardingPass.flightNumber,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        boardingPass.passengerName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white.withOpacity(0.2),
                    //     borderRadius: BorderRadius.circular(16),
                    //   ),
                    //   child: Image.network(
                    //     boardingPass.airlineLogo,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),

          // Flight Route
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCityInfo(
                      boardingPass.departureCode,
                      boardingPass.departureCity,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Iconsax.airplane,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 2,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.3),
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildCityInfo(
                      boardingPass.arrivalCode,
                      boardingPass.arrivalCity,
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Flight Details Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Date',
                        DateFormat('dd MMM').format(boardingPass.flightDate),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        'Boarding',
                        boardingPass.boardingTime,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        'Departure',
                        boardingPass.departureTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Terminal',
                        boardingPass.terminal,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        'Gate',
                        boardingPass.gate,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        'Seat',
                        boardingPass.seat,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Barcode Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Simulated Barcode
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: List.generate(
                            25,
                            (i) => Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: i % 2 == 0
                                      ? Colors.black
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        boardingPass.barcode,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Booking Ref: ${boardingPass.bookingReference}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityInfo(String code, String city) {
    return Column(
      children: [
        Text(
          code,
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          city,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            'Download',
            Iconsax.document_download,
            AppColors.primary,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Boarding pass downloaded'),
                  backgroundColor: AppColors.accentGreen,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context,
            'Share',
            Iconsax.share,
            AppColors.secondary,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share options opened'),
                  backgroundColor: AppColors.accentGreen,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context,
            'Wallet',
            Iconsax.wallet_3,
            AppColors.accentOrange,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to wallet'),
                  backgroundColor: AppColors.accentGreen,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantInstructions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Iconsax.info_circle,
                  color: AppColors.accentOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Important Instructions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.accentOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...[
            'Arrive at airport at least 2 hours before departure',
            'Your bags are already checked in - proceed directly to security',
            'Keep this boarding pass accessible at all times',
            'Check your gate assignment before boarding',
            'Board the aircraft when your group is called',
          ].map((instruction) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 12),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      instruction,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBagDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
                  Iconsax.box,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Checked Baggage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBagDetailRow('Number of Bags', '${booking.numberOfBags}'),
          _buildBagDetailRow(
            'Total Weight',
            '${booking.totalWeight.toStringAsFixed(1)} kg',
          ),
          _buildBagDetailRow('Bag Tags', boardingPass.bagTagNumbers),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.tick_circle,
                  color: AppColors.accentGreen,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'All bags successfully checked in',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBagDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
