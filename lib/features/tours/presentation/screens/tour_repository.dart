// lib/features/tours/domain/repositories/tour_repository.dart
import 'package:aman_booking/features/tours/presentation/screens/tour.dart';

abstract class TourRepository {
  // Tour operations
  Future<List<Tour>> getTours();
  Future<Tour> getTourById(String tourId);
  Future<List<Tour>> getSimilarTours(Tour tour);
  Future<List<Tour>> searchTours({
    String query = '',
    String? location,
    TourCategory? category,
    TourDifficulty? difficulty,
    DateTime? startDate,
    DateTime? endDate,
    double? minPrice,
    double? maxPrice,
  });
  Future<List<Tour>> getOperatorTours(String operatorId);

  // Availability and booking
  Future<Map<String, dynamic>> checkAvailability({
    required String tourId,
    required DateTime date,
    required int groupSize,
    bool isPrivate = false,
  });

  Future<Map<String, dynamic>> createBooking({
    required String tourId,
    required DateTime date,
    required int groupSize,
    required bool isPrivate,
    required List<String> travelerNames,
    required String contactEmail,
    required String contactPhone,
    String? specialRequirements,
  });

  // Operator management
  Future<Tour> createTour(Tour tour);
  Future<Tour> updateTour(Tour tour);
  Future<void> deleteTour(String tourId);
  Future<void> updateAvailability({
    required String tourId,
    required DateTime date,
    required int availableSlots,
  });
  Future<void> assignGuide({
    required String tourId,
    required TourGuide guide,
  });
}
