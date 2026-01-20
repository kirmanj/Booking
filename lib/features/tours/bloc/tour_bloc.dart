// lib/features/tours/presentation/bloc/tour_bloc.dart
import 'package:aman_booking/features/tours/presentation/screens/tour.dart';
import 'package:aman_booking/features/tours/presentation/screens/tour_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tour_event.dart';
part 'tour_state.dart';

class TourBloc extends Bloc<TourEvent, TourState> {
  final TourRepository tourRepository;

  TourBloc({required this.tourRepository}) : super(TourInitial()) {
    on<LoadTours>(_onLoadTours);
    on<LoadTourById>(_onLoadTourById);
    on<SearchTours>(_onSearchTours);
    on<CheckTourAvailability>(_onCheckTourAvailability);
    on<CreateTourBooking>(_onCreateTourBooking);
    on<CreateTour>(_onCreateTour);
    on<UpdateTour>(_onUpdateTour);
    on<DeleteTour>(_onDeleteTour);
    on<UpdateTourAvailability>(_onUpdateTourAvailability);
  }

  Future<void> _onLoadTours(
    LoadTours event,
    Emitter<TourState> emit,
  ) async {
    emit(TourLoading());
    try {
      final tours = await tourRepository.getTours();
      final featuredTours = tours.where((tour) => tour.isFeatured).toList();
      emit(ToursLoaded(tours: tours, featuredTours: featuredTours));
    } catch (e) {
      emit(TourError(e.toString()));
    }
  }

  Future<void> _onLoadTourById(
    LoadTourById event,
    Emitter<TourState> emit,
  ) async {
    emit(TourLoading());
    try {
      final tour = await tourRepository.getTourById(event.tourId);
      final similarTours = await tourRepository.getSimilarTours(tour);
      emit(TourDetailLoaded(tour: tour, similarTours: similarTours));
    } catch (e) {
      emit(TourError(e.toString()));
    }
  }

  Future<void> _onSearchTours(
    SearchTours event,
    Emitter<TourState> emit,
  ) async {
    emit(TourLoading());
    try {
      final tours = await tourRepository.searchTours(
        query: event.query,
        location: event.location,
        category: event.category,
        difficulty: event.difficulty,
        startDate: event.startDate,
        endDate: event.endDate,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      );
      final featuredTours = tours.where((tour) => tour.isFeatured).toList();
      emit(ToursLoaded(tours: tours, featuredTours: featuredTours));
    } catch (e) {
      emit(TourError(e.toString()));
    }
  }

  // ✅ FIXED: Preserves tour data when checking availability
  Future<void> _onCheckTourAvailability(
    CheckTourAvailability event,
    Emitter<TourState> emit,
  ) async {
    // ✅ Get current state
    final currentState = state;

    // Only proceed if we have tour data
    if (currentState is! TourDetailLoaded) return;

    try {
      final availability = await tourRepository.checkAvailability(
        tourId: event.tourId,
        date: event.date,
        groupSize: event.groupSize,
        isPrivate: event.isPrivate,
      );

      // ✅ Create availability info
      final availabilityInfo = TourAvailabilityInfo(
        isAvailable: availability['available'] ?? false,
        remainingSlots: availability['remainingSlots'] ?? 0,
        price: availability['price'] ?? 0.0,
        message: availability['message'] ?? '',
      );

      // ✅ Emit same state with updated availability info
      emit(currentState.copyWith(availabilityInfo: availabilityInfo));
    } catch (e) {
      emit(TourError(e.toString()));
    }
  }

  Future<void> _onCreateTourBooking(
    CreateTourBooking event,
    Emitter<TourState> emit,
  ) async {
    try {
      final booking = await tourRepository.createBooking(
        tourId: event.tourId,
        date: event.date,
        groupSize: event.groupSize,
        isPrivate: event.isPrivate,
        travelerNames: event.travelerNames,
        contactEmail: event.contactEmail,
        contactPhone: event.contactPhone,
        specialRequirements: event.specialRequirements,
      );
      emit(TourBookingCreated(
        bookingId: booking['bookingId'],
        totalAmount: booking['totalAmount'],
        confirmationNumber: booking['confirmationNumber'],
      ));
    } catch (e) {
      emit(TourError(e.toString()));
    }
  }

  Future<void> _onCreateTour(
    CreateTour event,
    Emitter<TourState> emit,
  ) async {
    try {
      final createdTour = await tourRepository.createTour(event.tour);
      emit(TourCreated(createdTour));
    } catch (e) {
      emit(TourError(e.toString()));
    }
  }

  Future<void> _onUpdateTour(
    UpdateTour event,
    Emitter<TourState> emit,
  ) async {
    try {
      final updatedTour = await tourRepository.updateTour(event.tour);
      emit(TourUpdated(updatedTour));
    } catch (e) {
      emit(TourError(e.toString()));
    }
  }

  Future<void> _onDeleteTour(
    DeleteTour event,
    Emitter<TourState> emit,
  ) async {
    try {
      await tourRepository.deleteTour(event.tourId);
      emit(TourDeleted(event.tourId));
    } catch (e) {
      emit(TourError(e.toString()));
    }
  }

  Future<void> _onUpdateTourAvailability(
    UpdateTourAvailability event,
    Emitter<TourState> emit,
  ) async {
    try {
      await tourRepository.updateAvailability(
        tourId: event.tourId,
        date: event.date,
        availableSlots: event.availableSlots,
      );
      // Reload the tour
      add(LoadTourById(event.tourId));
    } catch (e) {
      emit(TourError(e.toString()));
    }
  }
}
