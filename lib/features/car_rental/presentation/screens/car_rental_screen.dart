import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/car_rental/bloc/car_rental_bloc.dart';
import 'package:aman_booking/features/car_rental/bloc/car_rental_event.dart';
import 'package:aman_booking/features/car_rental/bloc/car_rental_state.dart';
import 'package:aman_booking/features/car_rental/presentation/screens/company_profile_screen.dart';
import 'package:aman_booking/features/car_rental/presentation/screens/car_booking_screen.dart';

class CarRentalScreen extends StatelessWidget {
  const CarRentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarRentalBloc()..add(const LoadCarRentalHome()),
      child: const _CarRentalView(),
    );
  }
}

class _CarRentalView extends StatelessWidget {
  const _CarRentalView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<CarRentalBloc, CarRentalState>(
          builder: (context, state) {
            if (state is CarRentalInitial || state is CarRentalLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is CarRentalError) {
              return _ErrorView(message: state.message);
            }

            final s = state as CarRentalLoaded;
            final size = MediaQuery.of(context).size;
            final width = size.width;
            final height = size.height;

            // Responsive sizing using MediaQuery
            final companyListHeight = height * 0.25;
            final carHorizontalListHeight = height * 0.5;
            final cardWidth = width * 0.75;
            final cardHeight = height * 0.75;

            final carImageHeight = height * 0.22;
            final tileThumbWidth = width * 0.27;
            final tileThumbHeight = height * 0.1;

            return CustomScrollView(
              slivers: [
                _ModernHeader(location: s.location),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      width * 0.04,
                      height * 0.02,
                      width * 0.04,
                      0,
                    ),
                    child: _SearchCard(
                      location: s.location,
                      pickupDate: s.pickupDate,
                      dropoffDate: s.dropoffDate,
                      onPickLocation: () =>
                          _showLocationSheet(context, s.location),
                      onPickPickupDate: () => _pickDate(
                        context,
                        initial: s.pickupDate,
                        onSelected: (d) => context
                            .read<CarRentalBloc>()
                            .add(UpdatePickupDate(d)),
                      ),
                      onPickDropoffDate: () => _pickDate(
                        context,
                        initial: s.dropoffDate,
                        firstDate: s.pickupDate.add(const Duration(days: 1)),
                        onSelected: (d) => context
                            .read<CarRentalBloc>()
                            .add(UpdateDropoffDate(d)),
                      ),
                      onSearch: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Searching cars...')),
                        );
                      },
                    ),
                  ),
                ),

                // Companies Section
                SliverToBoxAdapter(
                  child: _ModernSectionHeader(
                    title: 'Car Rental Companies',
                    subtitle: 'Trusted providers • Compare prices',
                    icon: Iconsax.building_3,
                    onSeeAll: () {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: companyListHeight,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      scrollDirection: Axis.horizontal,
                      itemCount: s.companies.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: width * 0.03),
                      itemBuilder: (_, i) => _ModernCompanyCard(
                        company: s.companies[i],
                        cardWidth: cardWidth,
                        cardHeight: cardHeight,
                        onTap: () => _navigateToCompanyProfile(
                          context,
                          s.companies[i],
                          s,
                        ),
                      ),
                    ),
                  ),
                ),

                // Luxury Cars
                SliverToBoxAdapter(
                  child: _ModernSectionHeader(
                    title: 'Luxury Collection',
                    subtitle: 'Premium comfort • Elite experience',
                    icon: Iconsax.car,
                    onSeeAll: () {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: carHorizontalListHeight,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      scrollDirection: Axis.horizontal,
                      itemCount: s.luxuryCars.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: width * 0.035),
                      itemBuilder: (_, i) => _ModernCarCard(
                        car: s.luxuryCars[i],
                        cardWidth: cardWidth,
                        imageHeight: carImageHeight,
                        onBook: () => _navigateToBooking(
                          context,
                          s.luxuryCars[i],
                          s,
                        ),
                      ),
                    ),
                  ),
                ),

                // Budget Cars
                SliverToBoxAdapter(
                  child: _ModernSectionHeader(
                    title: 'Budget Friendly',
                    subtitle: 'Save more • Great value',
                    icon: Iconsax.money_3,
                    onSeeAll: () {},
                  ),
                ),
                SliverList.separated(
                  itemCount: s.lowPriceCars.length,
                  separatorBuilder: (_, __) => SizedBox(height: height * 0.015),
                  itemBuilder: (_, i) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: _ModernCarTile(
                      car: s.lowPriceCars[i],
                      thumbWidth: tileThumbWidth,
                      thumbHeight: tileThumbHeight,
                      onTap: () => _navigateToBooking(
                        context,
                        s.lowPriceCars[i],
                        s,
                      ),
                    ),
                  ),
                ),

                // Family Cars
                SliverToBoxAdapter(
                  child: _ModernSectionHeader(
                    title: 'Family SUVs',
                    subtitle: '7 seats • Perfect for trips',
                    icon: Iconsax.people,
                    onSeeAll: () {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: carHorizontalListHeight,
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        width * 0.04,
                        0,
                        width * 0.04,
                        height * 0.025,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: s.familyCars.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: width * 0.035),
                      itemBuilder: (_, i) => _ModernCarCard(
                        car: s.familyCars[i],
                        cardWidth: cardWidth,
                        imageHeight: carImageHeight,
                        onBook: () => _navigateToBooking(
                          context,
                          s.familyCars[i],
                          s,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Navigation to Company Profile
  void _navigateToCompanyProfile(
    BuildContext context,
    CarRentalCompany company,
    CarRentalLoaded state,
  ) {
    // Get all cars for this company
    final companyCars = <CarModel>[
      ...state.luxuryCars.where((c) => c.companyId == company.id),
      ...state.lowPriceCars.where((c) => c.companyId == company.id),
      ...state.familyCars.where((c) => c.companyId == company.id),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyProfileScreen(
          company: company,
          companyCars: companyCars,
        ),
      ),
    );
  }

  // Navigation to Car Booking
  void _navigateToBooking(
    BuildContext context,
    CarModel car,
    CarRentalLoaded state,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarBookingScreen(
          car: car,
          pickupDate: state.pickupDate,
          dropoffDate: state.dropoffDate,
          location: state.location,
        ),
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime initial,
    DateTime? firstDate,
    required void Function(DateTime) onSelected,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate ?? now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onSelected(picked);
  }

  Future<void> _showLocationSheet(BuildContext context, String current) async {
    final controller = TextEditingController(text: current);
    final suggestions = <String>[
      'Erbil Airport (EBL)',
      'Erbil Downtown',
      'Dubai Airport (DXB)',
      'Istanbul Airport (IST)',
      'Baghdad Airport (BGW)',
      'Najaf Airport (NJF)',
    ];

    final res = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Pickup Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                  )
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon:
                      const Icon(Iconsax.location, color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.surfaceDark,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Popular Locations',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...suggestions.map((s) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Iconsax.location,
                        color: AppColors.secondary, size: 20),
                  ),
                  title: Text(
                    s,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, s),
                );
              }),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, controller.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Use this location',
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
        );
      },
    );

    if (res != null && res.trim().isNotEmpty && context.mounted) {
      context.read<CarRentalBloc>().add(UpdateSearchLocation(res.trim()));
    }
  }
}

/// ============ MODERN UI WIDGETS ============

class _ModernHeader extends StatelessWidget {
  final String location;
  const _ModernHeader({required this.location});

  @override
  Widget build(BuildContext context) {
    final border = AppColors.primary.withOpacity(0.26);
    final accent = AppColors.secondary;

    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      titleSpacing: 8,
      shape: Border(
        bottom: BorderSide(color: border, width: 1),
      ),
      title: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 6),
          const Text(
            'Car Rental',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 1),
          IconButton(
            onPressed: () {},
            icon: Icon(Iconsax.search_normal, size: 18, color: accent),
            style: IconButton.styleFrom(padding: const EdgeInsets.all(0)),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Iconsax.filter, size: 18, color: accent),
            style: IconButton.styleFrom(padding: const EdgeInsets.all(0)),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Iconsax.map, size: 18, color: accent),
            style: IconButton.styleFrom(padding: const EdgeInsets.all(0)),
          ),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  final String location;
  final DateTime pickupDate;
  final DateTime dropoffDate;
  final VoidCallback onPickLocation;
  final VoidCallback onPickPickupDate;
  final VoidCallback onPickDropoffDate;
  final VoidCallback onSearch;

  const _SearchCard({
    required this.location,
    required this.pickupDate,
    required this.dropoffDate,
    required this.onPickLocation,
    required this.onPickPickupDate,
    required this.onPickDropoffDate,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('EEE, MMM dd');
    final days = dropoffDate.difference(pickupDate).inDays.clamp(1, 365);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, AppColors.surfaceDark.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onPickLocation,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Iconsax.location,
                        size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: AppColors.secondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ModernDateField(
                  icon: Iconsax.calendar,
                  label: 'Pickup',
                  value: df.format(pickupDate),
                  onTap: onPickPickupDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ModernDateField(
                  icon: Iconsax.calendar,
                  label: 'Drop-off',
                  value: df.format(dropoffDate),
                  onTap: onPickDropoffDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.clock, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        '$days day${days > 1 ? 's' : ''} rental',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Iconsax.search_normal_1,
                          size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernDateField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ModernDateField({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onSeeAll;

  const _ModernSectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondary,
            ),
            child: const Text(
              'See all',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernCompanyCard extends StatelessWidget {
  final CarRentalCompany company;
  final double cardWidth;
  final VoidCallback onTap;
  final double cardHeight;

  const _ModernCompanyCard({
    required this.company,
    required this.cardWidth,
    required this.cardHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, AppColors.surfaceDark.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.secondary.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Image.network(
                    company.logoUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Iconsax.building_3,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${company.rating}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            ' (${company.reviews})',
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
                IconButton(
                  icon: Icon(
                    company.isFavorite ? Iconsax.heart : Iconsax.heart,
                    size: 20,
                    color: company.isFavorite
                        ? Colors.red
                        : AppColors.textSecondary,
                  ),
                  onPressed: () {
                    context
                        .read<CarRentalBloc>()
                        .add(ToggleCompanyFavorite(company.id));
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Iconsax.location,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    company.coverage,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: company.highlights.take(2).map((h) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.secondary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    h,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${company.fromPricePerDay.toInt()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '/day',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Fleet',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios,
                          size: 10, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernCarCard extends StatelessWidget {
  final CarModel car;
  final double cardWidth;
  final double imageHeight;
  final VoidCallback onBook;

  const _ModernCarCard({
    required this.car,
    required this.cardWidth,
    required this.imageHeight,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car image
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  height: imageHeight,
                  width: double.infinity,
                  child: Image.network(
                    car.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: AppColors.surfaceDark,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            value: progress.expectedTotalBytes == null
                                ? null
                                : progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceDark,
                      child: const Icon(Iconsax.car,
                          size: 48, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              // Favorite button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<CarRentalBloc>()
                        .add(ToggleCarFavorite(car.id));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      car.isFavorite ? Iconsax.heart : Iconsax.heart,
                      size: 20,
                      color:
                          car.isFavorite ? Colors.red : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              // Badges
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: car.freeCancellation
                          ? [
                              AppColors.accentGreen,
                              AppColors.accentGreen.withOpacity(0.8)
                            ]
                          : [
                              AppColors.accentOrange,
                              AppColors.accentOrange.withOpacity(0.8)
                            ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: (car.freeCancellation
                                ? AppColors.accentGreen
                                : AppColors.accentOrange)
                            .withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    car.freeCancellation ? 'Free Cancel' : 'Non-refundable',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Discount badge
              if (car.oldPricePerDay != null)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.error.withOpacity(0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      '-${(((car.oldPricePerDay! - car.pricePerDay) / car.oldPricePerDay!) * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Car details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    car.brand,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Name
                  Text(
                    car.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Rating & Insurance
                  Row(
                    children: [
                      const Icon(Icons.star, size: 15, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${car.rating}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ' (${car.reviews})',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      if (car.insuranceIncluded)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.shield_tick,
                                size: 12,
                                color: AppColors.accentGreen,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Insured',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.accentGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Specs
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SpecChip(
                          icon: Iconsax.profile_2user, text: '${car.seats}'),
                      _SpecChip(icon: Iconsax.bag, text: '${car.bags}'),
                      _SpecChip(
                          icon: Iconsax.setting_2, text: car.transmission[0]),
                      _SpecChip(icon: Iconsax.gas_station, text: car.fuel),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(height: 12),
                  // Price & Book button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (car.oldPricePerDay != null)
                            Text(
                              '\$${car.oldPricePerDay!.toInt()}',
                              style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          Row(
                            children: [
                              Text(
                                '\$${car.pricePerDay.toInt()}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '/day',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: onBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Book',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernCarTile extends StatelessWidget {
  final CarModel car;
  final double thumbWidth;
  final double thumbHeight;
  final VoidCallback onTap;

  const _ModernCarTile({
    required this.car,
    required this.thumbWidth,
    required this.thumbHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, AppColors.surfaceDark.withOpacity(0.2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // Car image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: thumbWidth,
                height: thumbHeight,
                child: Image.network(
                  car.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: AppColors.surfaceDark,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceDark,
                    child: const Icon(Iconsax.car,
                        size: 32, color: AppColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Car details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          car.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          car.isFavorite ? Iconsax.heart : Iconsax.heart,
                          size: 18,
                          color: car.isFavorite
                              ? Colors.red
                              : AppColors.textSecondary,
                        ),
                        onPressed: () {
                          context
                              .read<CarRentalBloc>()
                              .add(ToggleCarFavorite(car.id));
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${car.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '• ${car.brand}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _MiniSpec(
                          icon: Iconsax.profile_2user, text: '${car.seats}'),
                      const SizedBox(width: 8),
                      _MiniSpec(icon: Iconsax.bag, text: '${car.bags}'),
                      const SizedBox(width: 8),
                      _MiniSpec(
                          icon: Iconsax.setting_2, text: car.transmission[0]),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (car.oldPricePerDay != null)
                        Text(
                          '\$${car.oldPricePerDay!.toInt()}',
                          style: TextStyle(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      Row(
                        children: [
                          Text(
                            '\$${car.pricePerDay.toInt()}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '/day',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Book',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
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
}

class _SpecChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SpecChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.secondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniSpec extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MiniSpec({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.secondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.warning_2,
                  size: 48, color: AppColors.error),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  context.read<CarRentalBloc>().add(const LoadCarRentalHome()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
