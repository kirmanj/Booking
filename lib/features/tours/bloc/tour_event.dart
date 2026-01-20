// lib/features/tours/presentation/bloc/tour_event.dart
part of 'tour_bloc.dart';

abstract class TourEvent extends Equatable {
  const TourEvent();

  @override
  List<Object> get props => [];
}

// Loading events
class LoadTours extends TourEvent {
  const LoadTours();
}

class LoadTourById extends TourEvent {
  final String tourId;

  const LoadTourById(this.tourId);

  @override
  List<Object> get props => [tourId];
}

class LoadOperatorTours extends TourEvent {
  final String operatorId;

  const LoadOperatorTours(this.operatorId);

  @override
  List<Object> get props => [operatorId];
}

// Search and filter events
class SearchTours extends TourEvent {
  final String query;
  final String? location;
  final TourCategory? category;
  final TourDifficulty? difficulty;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minPrice;
  final double? maxPrice;

  const SearchTours({
    this.query = '',
    this.location,
    this.category,
    this.difficulty,
    this.startDate,
    this.endDate,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object> get props => [
        query,
        location ?? '',
        category?.label ?? '',
        difficulty?.label ?? '',
        startDate?.toString() ?? '',
        endDate?.toString() ?? '',
        minPrice ?? 0,
        maxPrice ?? 0,
      ];
}

// Booking events
class CheckTourAvailability extends TourEvent {
  final String tourId;
  final DateTime date;
  final int groupSize;
  final bool isPrivate;

  const CheckTourAvailability({
    required this.tourId,
    required this.date,
    required this.groupSize,
    this.isPrivate = false,
  });

  @override
  List<Object> get props => [tourId, date, groupSize, isPrivate];
}

class CreateTourBooking extends TourEvent {
  final String tourId;
  final DateTime date;
  final int groupSize;
  final bool isPrivate;
  final List<String> travelerNames;
  final String contactEmail;
  final String contactPhone;
  final String? specialRequirements;

  const CreateTourBooking({
    required this.tourId,
    required this.date,
    required this.groupSize,
    required this.isPrivate,
    required this.travelerNames,
    required this.contactEmail,
    required this.contactPhone,
    this.specialRequirements,
  });

  @override
  List<Object> get props => [
        tourId,
        date,
        groupSize,
        isPrivate,
        travelerNames,
        contactEmail,
        contactPhone,
        specialRequirements ?? '',
      ];
}

// Operator management events
class CreateTour extends TourEvent {
  final Tour tour;

  const CreateTour(this.tour);

  @override
  List<Object> get props => [tour];
}

class UpdateTour extends TourEvent {
  final Tour tour;

  const UpdateTour(this.tour);

  @override
  List<Object> get props => [tour];
}

class DeleteTour extends TourEvent {
  final String tourId;

  const DeleteTour(this.tourId);

  @override
  List<Object> get props => [tourId];
}

class UpdateTourAvailability extends TourEvent {
  final String tourId;
  final DateTime date;
  final int availableSlots;

  const UpdateTourAvailability({
    required this.tourId,
    required this.date,
    required this.availableSlots,
  });

  @override
  List<Object> get props => [tourId, date, availableSlots];
}

class AssignTourGuide extends TourEvent {
  final String tourId;
  final TourGuide guide;

  const AssignTourGuide({
    required this.tourId,
    required this.guide,
  });

  @override
  List<Object> get props => [tourId, guide];
}
