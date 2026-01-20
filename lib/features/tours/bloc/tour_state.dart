// lib/features/tours/presentation/bloc/tour_state.dart
part of 'tour_bloc.dart';

abstract class TourState extends Equatable {
  const TourState();

  @override
  List<Object> get props => [];
}

class TourInitial extends TourState {}

class TourLoading extends TourState {}

class ToursLoaded extends TourState {
  final List<Tour> tours;
  final List<Tour> featuredTours;

  const ToursLoaded({
    required this.tours,
    required this.featuredTours,
  });

  @override
  List<Object> get props => [tours, featuredTours];
}

// ✅ FIXED: This state now includes tour data + similar tours
class TourDetailLoaded extends TourState {
  final Tour tour;
  final List<Tour> similarTours;
  final TourAvailabilityInfo? availabilityInfo; // ✅ Added this

  const TourDetailLoaded({
    required this.tour,
    required this.similarTours,
    this.availabilityInfo,
  });

  // ✅ Helper to copy with new availability info
  TourDetailLoaded copyWith({
    Tour? tour,
    List<Tour>? similarTours,
    TourAvailabilityInfo? availabilityInfo,
  }) {
    return TourDetailLoaded(
      tour: tour ?? this.tour,
      similarTours: similarTours ?? this.similarTours,
      availabilityInfo: availabilityInfo ?? this.availabilityInfo,
    );
  }

  @override
  List<Object> get props => [tour, similarTours, availabilityInfo ?? ''];
}

// ✅ New class to hold availability info
class TourAvailabilityInfo {
  final bool isAvailable;
  final int remainingSlots;
  final double price;
  final String message;

  const TourAvailabilityInfo({
    required this.isAvailable,
    required this.remainingSlots,
    required this.price,
    required this.message,
  });
}

// ✅ REMOVED: TourAvailabilityChecked (merged into TourDetailLoaded)

class TourBookingCreated extends TourState {
  final String bookingId;
  final double totalAmount;
  final String confirmationNumber;

  const TourBookingCreated({
    required this.bookingId,
    required this.totalAmount,
    required this.confirmationNumber,
  });

  @override
  List<Object> get props => [bookingId, totalAmount, confirmationNumber];
}

class TourCreated extends TourState {
  final Tour tour;

  const TourCreated(this.tour);

  @override
  List<Object> get props => [tour];
}

class TourUpdated extends TourState {
  final Tour tour;

  const TourUpdated(this.tour);

  @override
  List<Object> get props => [tour];
}

class TourDeleted extends TourState {
  final String tourId;

  const TourDeleted(this.tourId);

  @override
  List<Object> get props => [tourId];
}

class TourError extends TourState {
  final String message;

  const TourError(this.message);

  @override
  List<Object> get props => [message];
}
