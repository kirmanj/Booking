// lib/features/tours/presentation/screens/tour_operator_dashboard.dart
import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TourOperatorDashboard extends StatefulWidget {
  final String operatorId;

  const TourOperatorDashboard({super.key, required this.operatorId});

  @override
  State<TourOperatorDashboard> createState() => _TourOperatorDashboardState();
}

class _TourOperatorDashboardState extends State<TourOperatorDashboard> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tour Operator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const TourCreateScreen(),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Overview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Tours', '24', Iconsax.box),
                _buildStatItem('Bookings', '156', Iconsax.book),
                _buildStatItem('Revenue', '\$12,450', Iconsax.wallet),
                _buildStatItem('Rating', '4.8', Iconsax.star),
              ],
            ),
          ),

          // Tabs
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildDashboardTab('Tours', 0),
                ),
                Expanded(
                  child: _buildDashboardTab('Bookings', 1),
                ),
                Expanded(
                  child: _buildDashboardTab('Calendar', 2),
                ),
                Expanded(
                  child: _buildDashboardTab('Guides', 3),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildToursTab();
      case 1:
        return _buildBookingsTab();
      case 2:
        return _buildCalendarTab();
      case 3:
        return _buildGuidesTab();
      default:
        return Container();
    }
  }

  Widget _buildToursTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTourManagementCard(),
        const SizedBox(height: 16),
        _buildTourManagementCard(),
        const SizedBox(height: 16),
        _buildTourManagementCard(),
      ],
    );
  }

  Widget _buildTourManagementCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Iconsax.image, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dubai Desert Safari',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Dubai, UAE',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Adventure'),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('\$299'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTourStat('Capacity', '50'),
              _buildTourStat('Booked', '35'),
              _buildTourStat('Available', '15'),
              _buildTourStat('Rating', '4.9'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.edit, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.calendar, size: 16),
                  label: const Text('Calendar'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.chart, size: 16),
                  label: const Text('Analytics'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTourStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookingCard(),
        const SizedBox(height: 16),
        _buildBookingCard(),
        const SizedBox(height: 16),
        _buildBookingCard(),
      ],
    );
  }

  Widget _buildBookingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOUR-123456',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Confirmed',
                  style: TextStyle(
                    color: AppColors.accentGreen,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'John Smith',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Iconsax.calendar, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              const Text('Dec 15, 2024'),
              const SizedBox(width: 16),
              Icon(Iconsax.people, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              const Text('4 Persons'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '\$1,196.00',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.message, size: 20),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.more, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    return const Center(
      child: Text('Calendar View'),
    );
  }

  Widget _buildGuidesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildGuideCard(),
        const SizedBox(height: 16),
        _buildGuideCard(),
        const SizedBox(height: 16),
        _buildGuideCard(),
      ],
    );
  }

  Widget _buildGuideCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.profile_circle, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ahmed Al Mansoori',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Iconsax.star, size: 14, color: AppColors.accentYellow),
                    const SizedBox(width: 4),
                    const Text('4.9'),
                    const SizedBox(width: 16),
                    Icon(Iconsax.briefcase,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    const Text('8 years'),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('English'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Arabic'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Hindi'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.more),
          ),
        ],
      ),
    );
  }
}
