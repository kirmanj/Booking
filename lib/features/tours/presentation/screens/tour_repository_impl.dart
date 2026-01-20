// lib/features/tours/data/repositories/tour_repository_impl.dart
import 'dart:math';

import 'package:aman_booking/features/tours/presentation/screens/tour.dart';
import 'package:aman_booking/features/tours/presentation/screens/tour_repository.dart';

class TourRepositoryImpl implements TourRepository {
  final List<Tour> _demoTours = _createDemoTours();

  @override
  Future<List<Tour>> getTours() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _demoTours;
  }

  @override
  Future<Tour> getTourById(String tourId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoTours.firstWhere((tour) => tour.id == tourId);
  }

  @override
  Future<List<Tour>> getSimilarTours(Tour tour) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoTours
        .where((t) =>
            t.category == tour.category &&
            t.id != tour.id &&
            t.city == tour.city)
        .take(3)
        .toList();
  }

  @override
  Future<List<Tour>> searchTours({
    String query = '',
    String? location,
    TourCategory? category,
    TourDifficulty? difficulty,
    DateTime? startDate,
    DateTime? endDate,
    double? minPrice,
    double? maxPrice,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    var filteredTours = _demoTours;

    if (query.isNotEmpty) {
      filteredTours = filteredTours
          .where((tour) =>
              tour.title.toLowerCase().contains(query.toLowerCase()) ||
              tour.description.toLowerCase().contains(query.toLowerCase()) ||
              tour.tags.any(
                  (tag) => tag.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }

    if (location != null && location.isNotEmpty) {
      filteredTours = filteredTours
          .where((tour) =>
              tour.city.toLowerCase().contains(location.toLowerCase()) ||
              tour.country.toLowerCase().contains(location.toLowerCase()))
          .toList();
    }

    if (category != null) {
      filteredTours =
          filteredTours.where((tour) => tour.category == category).toList();
    }

    if (difficulty != null) {
      filteredTours =
          filteredTours.where((tour) => tour.difficulty == difficulty).toList();
    }

    if (minPrice != null) {
      filteredTours =
          filteredTours.where((tour) => tour.basePrice >= minPrice).toList();
    }

    if (maxPrice != null) {
      filteredTours =
          filteredTours.where((tour) => tour.basePrice <= maxPrice).toList();
    }

    return filteredTours;
  }

  @override
  Future<List<Tour>> getOperatorTours(String operatorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoTours.where((tour) => tour.operatorId == operatorId).toList();
  }

  @override
  Future<Map<String, dynamic>> checkAvailability({
    required String tourId,
    required DateTime date,
    required int groupSize,
    bool isPrivate = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final tour = _demoTours.firstWhere((tour) => tour.id == tourId);
    final remainingSlots = tour.getRemainingSlots(date);
    final isAvailable = remainingSlots >= groupSize;
    final price = isPrivate
        ? tour.privateTourPrice ?? tour.basePrice * 2
        : tour.getPriceForGroup(groupSize);

    return {
      'available': isAvailable,
      'remainingSlots': remainingSlots,
      'price': price,
      'message': isAvailable
          ? 'Available for booking'
          : 'Only $remainingSlots slots available',
    };
  }

  @override
  Future<Map<String, dynamic>> createBooking({
    required String tourId,
    required DateTime date,
    required int groupSize,
    required bool isPrivate,
    required List<String> travelerNames,
    required String contactEmail,
    required String contactPhone,
    String? specialRequirements,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final tour = _demoTours.firstWhere((tour) => tour.id == tourId);
    final price = isPrivate
        ? tour.privateTourPrice ?? tour.basePrice * 2
        : tour.getPriceForGroup(groupSize);
    final totalAmount = price * groupSize;
    final confirmationNumber = 'TOUR-${DateTime.now().millisecondsSinceEpoch}';

    return {
      'bookingId': 'BK-${Random().nextInt(999999)}',
      'totalAmount': totalAmount,
      'confirmationNumber': confirmationNumber,
    };
  }

  @override
  Future<Tour> createTour(Tour tour) async {
    await Future.delayed(const Duration(seconds: 2));
    return tour;
  }

  @override
  Future<Tour> updateTour(Tour tour) async {
    await Future.delayed(const Duration(seconds: 1));
    return tour;
  }

  @override
  Future<void> deleteTour(String tourId) async {
    await Future.delayed(const Duration(seconds: 1));
    // In real implementation, remove from database
  }

  @override
  Future<void> updateAvailability({
    required String tourId,
    required DateTime date,
    required int availableSlots,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real implementation, update database
  }

  @override
  Future<void> assignGuide({
    required String tourId,
    required TourGuide guide,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real implementation, update database
  }

  // Demo data creation
  static List<Tour> _createDemoTours() {
    return [
      // Dubai Desert Safari
      Tour(
        id: 'tour_001',
        title: 'Premium Desert Safari with BBQ Dinner',
        description:
            'Experience the thrill of Dubai\'s desert with dune bashing, camel rides, sandboarding, and a traditional BBQ dinner under the stars with live entertainment.',
        location: 'Dubai Desert Conservation Reserve',
        city: 'Dubai',
        country: 'UAE',
        rating: 4.9,
        reviews: 1248,
        basePrice: 299,
        images: [
          'https://www.wondergifts.ae/cdn/shop/files/Abudhabi_Desert_Safari_Main_07d056e4-bd89-4e7f-9788-4631361040c5_1200x784.jpg?v=1730187437',
          'https://sultantourism.com/wp-content/uploads/2023/06/tour_649_63e8b2d97a090.jpg',
          'https://www.pelago.com/img/products/AE-United%20Arab%20Emirates/desert-safari-premium-luxury-vip-5-live-bbq-dinner-open-buffet-tables-chair/17432242-c97d-41fa-abe7-27b2ac054de6_desert-safari-premium-luxury-vip-5-live-bbq-dinner-open-buffet-tables-chair.jpg',
        ],
        gallery: [
          'assets/tours/desert_gallery_1.jpg',
          'assets/tours/desert_gallery_2.jpg',
          'assets/tours/desert_gallery_3.jpg',
          'assets/tours/desert_gallery_4.jpg',
        ],
        inclusions: [
          'Hotel pickup & drop-off',
          'Dune bashing in 4x4 vehicle',
          'Camel ride experience',
          'Sandboarding equipment',
          'Traditional BBQ dinner',
          'Live Tanoura & Belly dance show',
          'Henna painting',
          'Unlimited soft drinks & water',
          'Professional photographer',
          'Shisha smoking (optional)',
        ],
        exclusions: [
          'Alcoholic beverages',
          'Quad biking (available as add-on)',
          'Personal expenses',
          'Gratuities (optional)',
        ],
        itinerary: [
          TourItinerary(
            day: 'Day 1',
            title: 'Desert Adventure',
            description: 'Full day desert experience with multiple activities',
            activities: [
              '15:30 - Hotel pickup',
              '16:30 - Dune bashing adventure',
              '17:30 - Sunset photography stop',
              '18:00 - Camel riding',
              '18:30 - Sandboarding',
              '19:00 - Arrive at desert camp',
              '19:30 - Traditional BBQ dinner',
              '20:30 - Live entertainment shows',
              '21:30 - Stargazing experience',
              '22:00 - Return to hotel',
            ],
            mealIncluded: 'BBQ Dinner',
          ),
        ],
        category: TourCategory.adventure,
        difficulty: TourDifficulty.easy,
        duration: '6 hours',
        maxCapacity: 50,
        minGroupSize: 2,
        currentBookings: 35,
        isPrivateAvailable: true,
        isGroupAvailable: true,
        operatorId: 'operator_001',
        operatorName: 'Arabian Adventures',
        operatorImage: 'assets/operators/arabian_adventures.jpg',
        assignedGuides: [
          TourGuide(
            id: 'guide_001',
            name: 'Ahmed Al Mansoori',
            image: 'assets/guides/ahmed.jpg',
            languages: ['English', 'Arabic', 'Hindi'],
            experienceYears: 8,
            rating: 4.9,
            totalTours: 450,
            specialization: 'Desert Safaris',
          ),
        ],
        availableDates: List.generate(
            30, (index) => DateTime.now().add(Duration(days: index + 1))),
        pricingTiers: {
          '1': 499,
          '2': 299,
          '4': 279,
          '6': 259,
          '8': 239,
          '10': 219,
        },
        availabilityCalendar: Map.fromIterable(
          List.generate(
              30, (index) => DateTime.now().add(Duration(days: index + 1))),
          key: (date) => date,
          value: (date) => Random().nextInt(20) + 10, // 10-30 slots
        ),
        tags: ['desert', 'safari', 'adventure', 'dinner', 'camel', 'dubai'],
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        updatedAt: DateTime.now(),
        isFeatured: true,
        privateTourPrice: 799,
        privateTourNotes:
            'Private tour includes exclusive vehicle and personalized guide',
      ),

      // Paris City Tour
      Tour(
        id: 'tour_002',
        title: 'Complete Paris City Tour with Seine River Cruise',
        description:
            'Discover the magic of Paris with guided visits to all major landmarks including Eiffel Tower, Louvre Museum, Notre-Dame, and a romantic Seine River cruise.',
        location: 'Paris, France',
        city: 'Paris',
        country: 'France',
        rating: 4.8,
        reviews: 892,
        basePrice: 189,
        images: [
          'https://media.tacdn.com/media/attractions-splice-spp-674x446/0d/3b/82/88.jpg',
          'https://media.tacdn.com/media/attractions-splice-spp-674x446/0d/3b/82/88.jpg'
        ],
        gallery: [
          'https://media.tacdn.com/media/attractions-splice-spp-674x446/0d/3b/82/88.jpg',
          'https://media.tacdn.com/media/attractions-splice-spp-674x446/0d/3b/82/88.jpg'
        ],
        inclusions: [
          'Professional English-speaking guide',
          'Eiffel Tower skip-the-line tickets',
          'Louvre Museum entrance',
          'Seine River cruise ticket',
          'Notre-Dame Cathedral visit',
          'Transportation between sites',
          'Bottled water',
        ],
        exclusions: [
          'Lunch',
          'Personal expenses',
          'Hotel pickup/drop-off',
        ],
        itinerary: [
          TourItinerary(
            day: 'Day 1',
            title: 'Paris Highlights',
            description: 'Full day exploring Paris iconic landmarks',
            activities: [
              '09:00 - Meet at Eiffel Tower',
              '09:30 - Eiffel Tower visit',
              '11:00 - Seine River cruise',
              '12:30 - Lunch break (own expense)',
              '14:00 - Louvre Museum tour',
              '16:00 - Notre-Dame Cathedral',
              '17:00 - Champs-Élysées walk',
              '18:00 - Arc de Triomphe',
              '19:00 - Tour ends',
            ],
            mealIncluded: 'None',
          ),
        ],
        category: TourCategory.city,
        difficulty: TourDifficulty.easy,
        duration: '10 hours',
        maxCapacity: 25,
        minGroupSize: 1,
        currentBookings: 18,
        isPrivateAvailable: true,
        isGroupAvailable: true,
        operatorId: 'operator_002',
        operatorName: 'Paris Perfect Tours',
        operatorImage: 'assets/operators/paris_perfect.jpg',
        assignedGuides: [],
        availableDates: [],
        pricingTiers: {},
        availabilityCalendar: {},
        tags: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Bali Adventure
      Tour(
        id: 'tour_003',
        title: 'Bali Waterfall & Rice Terrace Adventure',
        description:
            'Explore Bali\'s natural beauty with visits to hidden waterfalls, traditional rice terraces, and authentic Balinese village experience.',
        location: 'Ubud, Bali',
        city: 'Ubud',
        country: 'Indonesia',
        rating: 4.7,
        reviews: 567,
        basePrice: 89,
        images: [
          'https://media.tacdn.com/media/attractions-splice-spp-674x446/0f/2a/d4/cd.jpg',
          "https://balivictorytour.com/uploads/full-day-tour/leke-leke-waterfall-tabanan.jpg"
        ],
        gallery: [
          'https://media.tacdn.com/media/attractions-splice-spp-674x446/0f/2a/d4/cd.jpg',
          "https://balivictorytour.com/uploads/full-day-tour/leke-leke-waterfall-tabanan.jpg"
        ],
        inclusions: [],
        exclusions: [],
        itinerary: [],
        category: TourCategory.adventure,
        difficulty: TourDifficulty.moderate,
        duration: '8 hours',
        maxCapacity: 15,
        minGroupSize: 2,
        currentBookings: 10,
        isPrivateAvailable: true,
        isGroupAvailable: true,
        operatorId: 'operator_003',
        operatorName: 'Bali Eco Tours',
        operatorImage: 'assets/operators/bali_eco.jpg',
        assignedGuides: [],
        availableDates: [],
        pricingTiers: {},
        availabilityCalendar: {},
        tags: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isFeatured: true,
      ),

      // Add more demo tours as needed...
    ];
  }
}
