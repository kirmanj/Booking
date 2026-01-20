import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/car_rental/bloc/car_rental_state.dart';

// Payment Hub Imports
import 'package:aman_booking/core/payment/domain/entities/service_type.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_request.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_item.dart';
import 'package:aman_booking/core/payment/domain/entities/tax_item.dart';
import 'package:aman_booking/core/payment/presentation/screens/checkout_screen.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class CarBookingScreen extends StatefulWidget {
  final CarModel car;
  final DateTime pickupDate;
  final DateTime dropoffDate;
  final String location;

  const CarBookingScreen({
    super.key,
    required this.car,
    required this.pickupDate,
    required this.dropoffDate,
    required this.location,
  });

  @override
  State<CarBookingScreen> createState() => _CarBookingScreenState();
}

class _CarBookingScreenState extends State<CarBookingScreen> {
  bool _withDriver = false;
  DriverProfile? _selectedDriver;
  final List<ExtraOption> _selectedExtras = [];

  // Available extras
  final List<ExtraOption> _availableExtras = const [
    ExtraOption(
      id: 'gps',
      name: 'GPS Navigation',
      description: 'Never get lost with built-in GPS',
      pricePerDay: 5.0,
      icon: 'gps',
    ),
    ExtraOption(
      id: 'child_seat',
      name: 'Child Seat',
      description: 'Safety first for your little ones',
      pricePerDay: 8.0,
      icon: 'child_seat',
    ),
    ExtraOption(
      id: 'insurance',
      name: 'Full Insurance',
      description: 'Complete peace of mind coverage',
      pricePerDay: 15.0,
      icon: 'insurance',
    ),
    ExtraOption(
      id: 'wifi',
      name: 'WiFi Hotspot',
      description: 'Stay connected on the go',
      pricePerDay: 7.0,
      icon: 'wifi',
    ),
    ExtraOption(
      id: 'pickup',
      name: 'Airport Pickup',
      description: 'We\'ll meet you at arrivals',
      pricePerDay: 0.0, // One-time fee
      icon: 'pickup',
    ),
  ];

  // Demo drivers to pick from when booking with driver
  final List<DriverProfile> _drivers = const [
    DriverProfile(
      id: 'drv1',
      name: 'Zara Rahman',
      age: 32,
      habit: 'Informative',
      language: 'Arabic, English',
      bio: 'Knows shortcuts around the city, calm driving style.',
    ),
    DriverProfile(
      id: 'drv2',
      name: 'Omar Ali',
      age: 28,
      habit: 'Talkative',
      language: 'Kurdish, English',
      bio: 'Friendly guide who shares local tips and food spots.',
    ),
    DriverProfile(
      id: 'drv3',
      name: 'Lina Karim',
      age: 35,
      habit: 'Quiet',
      language: 'Arabic, Turkish',
      bio: 'Discreet driver focused on a smooth, peaceful ride.',
    ),
  ];

  int get totalDays {
    return widget.dropoffDate.difference(widget.pickupDate).inDays;
  }

  double get carCost => widget.car.pricePerDay * totalDays;

  double get driverCost => _withDriver ? (35.0 * totalDays) : 0.0;

  double get extrasCost {
    return _selectedExtras.fold(
      0.0,
      (sum, extra) => sum + (extra.pricePerDay * totalDays),
    );
  }

  double get totalCost =>
      carCost + driverCost + extrasCost + widget.car.deposit;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dateFormat = DateFormat('EEE, MMM d');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar with car image
          SliverAppBar(
            expandedHeight: size.height * 0.35,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: const [
              SupportButton(
                category: SupportCategory.carRental,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.car.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceDark,
                      child: const Icon(
                        Iconsax.car,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Car name at bottom
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.car.brand,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.car.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Booking details
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Iconsax.calendar,
                          color: AppColors.secondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Rental Period',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateCard(
                          label: 'Pickup',
                          date: dateFormat.format(widget.pickupDate),
                          icon: Iconsax.export_3,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: _buildDateCard(
                          label: 'Dropoff',
                          date: dateFormat.format(widget.dropoffDate),
                          icon: Iconsax.import_3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.clock,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$totalDays days rental',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Driver option
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _withDriver
                      ? AppColors.secondary.withOpacity(0.5)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Iconsax.profile_circle,
                          color: AppColors.accentGreen,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Book with Driver',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Professional driver • \$35/day',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _withDriver,
                        onChanged: (value) {
                          setState(() {
                            _withDriver = value;
                            if (!value) _selectedDriver = null;
                          });
                        },
                        activeColor: AppColors.secondary,
                      ),
                    ],
                  ),
                  if (_withDriver) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.tick_circle,
                                size: 16,
                                color: AppColors.accentGreen,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'What\'s included:',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildDriverBenefit('Professional licensed driver'),
                          _buildDriverBenefit('Local area knowledge'),
                          _buildDriverBenefit('Stress-free travel'),
                          _buildDriverBenefit('Flexible schedule'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choose your driver',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._drivers.map((driver) {
                      final isSelected = _selectedDriver?.id == driver.id;
                      return _buildDriverCard(driver, isSelected);
                    }),
                  ],
                ],
              ),
            ),
          ),

          // Extra options
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Iconsax.add_circle,
                          color: AppColors.accentOrange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Extra Options',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._availableExtras.map((extra) {
                    final isSelected = _selectedExtras.contains(extra);
                    return _buildExtraOption(extra, isSelected);
                  }).toList(),
                ],
              ),
            ),
          ),

          // Car specs reminder
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Iconsax.car,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Vehicle Specifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSpec(
                          Iconsax.profile_2user, '${widget.car.seats} Seats'),
                      _buildSpec(Iconsax.bag, '${widget.car.bags} Bags'),
                      _buildSpec(Iconsax.setting_2, widget.car.transmission),
                      _buildSpec(Iconsax.gas_station, widget.car.fuel),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // Bottom bar with price breakdown
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Price breakdown
                _buildPriceRow('Car rental', carCost),
                if (_withDriver) _buildPriceRow('Driver', driverCost),
                if (_selectedExtras.isNotEmpty)
                  _buildPriceRow('Extras', extrasCost),
                _buildPriceRow('Deposit (refundable)', widget.car.deposit,
                    isDeposit: true),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '\$${totalCost.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 16,
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
      ),
    );
  }

  Widget _buildDateCard({
    required String label,
    required String date,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.secondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date,
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

  Widget _buildDriverBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.accentGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(DriverProfile driver, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDriver = driver;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withOpacity(0.08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.user,
                color: AppColors.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        driver.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${driver.age} yrs',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTag(Iconsax.smileys, driver.habit),
                      const SizedBox(height: 6),
                      _buildTag(Iconsax.language_circle, driver.language),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    driver.bio,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Iconsax.tick_circle : Icons.circle,
              color: isSelected ? AppColors.secondary : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.secondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtraOption(ExtraOption extra, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedExtras.remove(extra);
          } else {
            _selectedExtras.add(extra);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withOpacity(0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondary
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getExtraIcon(extra.icon),
                size: 20,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    extra.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    extra.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  extra.pricePerDay == 0
                      ? 'Free'
                      : '\$${extra.pricePerDay.toInt()}/day',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppColors.secondary : AppColors.primary,
                  ),
                ),
                if (isSelected && extra.pricePerDay > 0)
                  Text(
                    '\$${(extra.pricePerDay * totalDays).toInt()} total',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpec(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(height: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDeposit = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color:
                  isDeposit ? AppColors.textTertiary : AppColors.textSecondary,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDeposit ? AppColors.textTertiary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getExtraIcon(String icon) {
    switch (icon) {
      case 'gps':
        return Iconsax.routing;
      case 'child_seat':
        return Iconsax.profile_circle;
      case 'insurance':
        return Iconsax.shield_tick;
      case 'wifi':
        return Iconsax.wifi;
      case 'pickup':
        return Iconsax.airplane;
      default:
        return Iconsax.tick_circle;
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Confirm Booking',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are booking:',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.car.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$totalDays days • \$${totalCost.toStringAsFixed(0)} total',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            if (_withDriver) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.profile_circle,
                      size: 14,
                      color: AppColors.accentGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _selectedDriver != null
                          ? 'Driver: ${_selectedDriver!.name}'
                          : 'With Driver',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _proceedToPayment(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment(BuildContext context) {
    // Calculate pricing
    final days = totalDays;
    final carRentalCost = widget.car.pricePerDay * days;
    final driverCost = _withDriver ? 50.0 * days : 0.0;
    final extrasCost = _selectedExtras.fold<double>(
      0.0,
      (sum, extra) => sum + (extra.pricePerDay * days),
    );

    final subtotal = carRentalCost + driverCost + extrasCost;
    final vat = subtotal * 0.15;
    final insuranceFee = 30.0 * days;
    const convenienceFee = 5.00;
    final total = subtotal + vat + insuranceFee + convenienceFee;

    // Build payment items
    final List<PaymentItem> items = [
      PaymentItem(
        id: 'car_rental',
        title: widget.car.name,
        description: '$days day(s) rental',
        basePrice: widget.car.pricePerDay,
        quantity: days,
        serviceType: ServiceType.carRental,
        metadata: {
          'car_brand': widget.car.brand,
          'location': widget.location,
          'pickup_date': widget.pickupDate.toIso8601String(),
          'dropoff_date': widget.dropoffDate.toIso8601String(),
          'days': days,
        },
      ),
      if (_withDriver && _selectedDriver != null)
        PaymentItem(
          id: 'driver_service',
          title: 'Professional Driver',
          description: '${_selectedDriver!.name} - $days day(s)',
          basePrice: 50.0,
          quantity: days,
          serviceType: ServiceType.carRental,
          metadata: {
            'driver_name': _selectedDriver!.name,
            'driver_habit': _selectedDriver!.habit,
            'driver_language': _selectedDriver!.language,
          },
        ),
      ..._selectedExtras.map((extra) => PaymentItem(
            id: 'extra_${extra.id}',
            title: extra.name,
            description: extra.description,
            basePrice: extra.pricePerDay,
            quantity: days,
            serviceType: ServiceType.carRental,
          )),
    ];

    // Build tax items
    final List<TaxItem> taxes = [
      TaxItem(
        id: 'vat',
        name: 'VAT',
        amount: vat,
        percentage: 0.15,
        isInclusive: false,
      ),
      TaxItem(
        id: 'insurance',
        name: 'Insurance Fee',
        amount: insuranceFee,
        isInclusive: false,
      ),
    ];

    // Create payment request
    final paymentRequest = PaymentRequest(
      id: 'CR${DateTime.now().millisecondsSinceEpoch}',
      serviceType: ServiceType.carRental,
      serviceName: '${widget.car.brand} ${widget.car.name}',
      serviceIcon: ServiceType.carRental.icon,
      items: items,
      subtotal: subtotal,
      taxes: taxes,
      discountAmount: 0.0,
      convenienceFee: convenienceFee,
      total: total,
      currency: 'USD',
      serviceMetadata: {
        'booking_reference': 'CR${DateTime.now().millisecondsSinceEpoch}',
        'car_data': {
          'brand': widget.car.brand,
          'name': widget.car.name,
          'location': widget.location,
          'pickup': widget.pickupDate.toIso8601String(),
          'dropoff': widget.dropoffDate.toIso8601String(),
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
                content: Text('Car rental booked! Invoice: ${invoice.invoiceNumber}'),
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
}

class DriverProfile {
  final String id;
  final String name;
  final int age;
  final String habit;
  final String language;
  final String bio;

  const DriverProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.habit,
    required this.language,
    required this.bio,
  });
}
