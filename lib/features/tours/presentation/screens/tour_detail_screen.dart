// lib/features/tours/presentation/screens/tour_detail_screen.dart
import 'package:aman_booking/features/tours/bloc/tour_bloc.dart';
import 'package:aman_booking/features/tours/presentation/screens/tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/tours/presentation/screens/tour_booking_screen.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TourDetailScreen extends StatefulWidget {
  final String tourId;

  const TourDetailScreen({super.key, required this.tourId});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  int _selectedImageIndex = 0;
  int _selectedTabIndex = 0;
  final PageController _imageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<TourBloc>().add(LoadTourById(widget.tourId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TourBloc, TourState>(
      // ← moved outside
      builder: (context, state) {
        // ← state is now visible
        if (state is TourLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is TourError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }

        if (state is TourDetailLoaded) {
          final tour = state.tour;
          return SafeArea(
            child: WillPopScope(
              onWillPop: _handleBackNavigation,
              child: Scaffold(
                backgroundColor: AppColors.background,
                body: CustomScrollView(
                  slivers: [
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
                            onPressed: () => _handleBackNavigation(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                            ),
                            color: AppColors.textPrimary,
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Tour Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Iconsax.heart, size: 20),
                            onPressed: () {},
                            color: AppColors.secondary,
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Iconsax.share, size: 20),
                            onPressed: () {},
                            color: AppColors.secondary,
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImageSlider(tour),
                            const SizedBox(height: 16),
                            // Title & Rating
                            Text(
                              tour.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.location,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${tour.city}, ${tour.country}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceDark,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: AppColors.accentYellow,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        tour.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        ' (${tour.reviews} reviews)',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceDark,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.clock,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(tour.duration),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Tabs
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceDark,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _selectedTabIndex = 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _selectedTabIndex == 0
                                              ? AppColors.surface
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Overview',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: _selectedTabIndex == 0
                                                  ? AppColors.primary
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _selectedTabIndex = 1),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _selectedTabIndex == 1
                                              ? AppColors.surface
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Itinerary',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: _selectedTabIndex == 1
                                                  ? AppColors.primary
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _selectedTabIndex = 2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _selectedTabIndex == 2
                                              ? AppColors.surface
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Inclusions',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: _selectedTabIndex == 2
                                                  ? AppColors.primary
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Tab Content
                            _buildTabContent(tour),

                            // Similar Tours
                            if (state.similarTours.isNotEmpty) ...[
                              const SizedBox(height: 32),
                              const Text(
                                'Similar Tours',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.similarTours.length,
                                  itemBuilder: (context, index) {
                                    final similarTour =
                                        state.similarTours[index];
                                    return Container(
                                      width: 160,
                                      margin: EdgeInsets.only(
                                        right: index ==
                                                state.similarTours.length - 1
                                            ? 0
                                            : 12,
                                      ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                              color: AppColors.primary
                                                  .withOpacity(0.1),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  similarTour.title,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '\$${similarTour.basePrice}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                bottomSheet: _buildBottomSheet(state),
              ),
            ),
          );
        }

        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }

  Widget _buildTabContent(Tour tour) {
    switch (_selectedTabIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tour.description,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Highlights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...tour.inclusions.take(5).map(
                  (inclusion) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: AppColors.accentGreen,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            inclusion,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...tour.itinerary.map((day) => _buildItineraryDay(day)),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s Included',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...tour.inclusions.map(
              (inclusion) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: AppColors.accentGreen,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        inclusion,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (tour.exclusions.isNotEmpty) ...[
              const Text(
                'What\'s Not Included',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...tour.exclusions.map(
                (exclusion) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          exclusion,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildItineraryDay(TourItinerary day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  day.day,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  day.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            day.description,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          if (day.activities.isNotEmpty) ...[
            const Text(
              'Activities:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...day.activities.map(
              (activity) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        activity,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (day.mealIncluded != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.restaurant,
                  size: 16,
                  color: AppColors.accentGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  'Meal: ${day.mealIncluded}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomSheet(TourState state) {
    if (state is! TourDetailLoaded) return Container();

    final tour = state.tour;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'From',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '\$${tour.basePrice}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'per person',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TourBookingScreen(tourId: tour.id),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: const Text(
              'Book Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(Tour tour) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            PageView.builder(
              controller: _imageController,
              itemCount: tour.images.length,
              onPageChanged: (index) {
                setState(() {
                  _selectedImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  color: AppColors.primary.withOpacity(0.05),
                  child: Image.network(
                    tour.images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  tour.images.length,
                  (index) => Container(
                    width: _selectedImageIndex == index ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _selectedImageIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _handleBackNavigation() async {
    context.read<TourBloc>().add(const LoadTours());
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    return false;
  }
}
