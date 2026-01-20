// lib/features/home_checkin/presentation/bloc/home_checkin_state.dart
part of 'home_checkin_bloc.dart';

abstract class HomeCheckInState extends Equatable {
  const HomeCheckInState();

  @override
  List<Object?> get props => [];
}

// Initial state
class HomeCheckInInitial extends HomeCheckInState {
  const HomeCheckInInitial();
}

// Loading state
class HomeCheckInLoading extends HomeCheckInState {
  const HomeCheckInLoading();
}

// Airlines loaded
class AirlinesLoaded extends HomeCheckInState {
  final List<Airline> airlines;

  const AirlinesLoaded(this.airlines);

  @override
  List<Object> get props => [airlines];
}

// Airline selected
class AirlineSelected extends HomeCheckInState {
  final Airline airline;

  const AirlineSelected(this.airline);

  @override
  List<Object> get props => [airline];
}

// Policy loaded
class PolicyLoaded extends HomeCheckInState {
  final Airline airline;
  final bool policyAccepted;

  const PolicyLoaded(this.airline, {this.policyAccepted = false});

  @override
  List<Object> get props => [airline, policyAccepted];
}

// Locations loaded
class LocationsLoaded extends HomeCheckInState {
  final List<PickupLocation> locations;
  final Airline airline;

  const LocationsLoaded(this.locations, this.airline);

  @override
  List<Object> get props => [locations, airline];
}

// Location selected
class LocationSelected extends HomeCheckInState {
  final PickupLocation location;
  final Airline airline;

  const LocationSelected(this.location, this.airline);

  @override
  List<Object> get props => [location, airline];
}

// Date selected
class DateSelected extends HomeCheckInState {
  final DateTime date;
  final PickupLocation location;
  final Airline airline;

  const DateSelected(this.date, this.location, this.airline);

  @override
  List<Object> get props => [date, location, airline];
}

// Time slots loaded
class TimeSlotsLoaded extends HomeCheckInState {
  final List<String> timeSlots;
  final DateTime date;
  final PickupLocation location;
  final Airline airline;

  const TimeSlotsLoaded(this.timeSlots, this.date, this.location, this.airline);

  @override
  List<Object> get props => [timeSlots, date, location, airline];
}

// Time slot selected
class TimeSlotSelected extends HomeCheckInState {
  final String timeSlot;
  final DateTime date;
  final PickupLocation location;
  final Airline airline;

  const TimeSlotSelected(this.timeSlot, this.date, this.location, this.airline);

  @override
  List<Object> get props => [timeSlot, date, location, airline];
}

// Booking created successfully
class BookingCreated extends HomeCheckInState {
  final HomeCheckInBooking booking;

  const BookingCreated(this.booking);

  @override
  List<Object> get props => [booking];
}

// Tracking active
class TrackingActive extends HomeCheckInState {
  final HomeCheckInBooking booking;
  final DriverLocation? driverLocation;

  const TrackingActive(this.booking, {this.driverLocation});

  @override
  List<Object?> get props => [booking, driverLocation];
}

// Boarding pass ready
class BoardingPassReady extends HomeCheckInState {
  final BoardingPass boardingPass;
  final HomeCheckInBooking booking;

  const BoardingPassReady(this.boardingPass, this.booking);

  @override
  List<Object> get props => [boardingPass, booking];
}

// Error state
class HomeCheckInError extends HomeCheckInState {
  final String message;

  const HomeCheckInError(this.message);

  @override
  List<Object> get props => [message];
}
