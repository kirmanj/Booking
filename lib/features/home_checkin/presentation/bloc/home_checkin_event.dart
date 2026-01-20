// lib/features/home_checkin/presentation/bloc/home_checkin_event.dart
part of 'home_checkin_bloc.dart';

abstract class HomeCheckInEvent extends Equatable {
  const HomeCheckInEvent();

  @override
  List<Object?> get props => [];
}

// Load airlines list
class LoadAirlines extends HomeCheckInEvent {
  const LoadAirlines();
}

// Select an airline
class SelectAirline extends HomeCheckInEvent {
  final String airlineCode;

  const SelectAirline(this.airlineCode);

  @override
  List<Object> get props => [airlineCode];
}

// Load airline policy
class LoadAirlinePolicy extends HomeCheckInEvent {
  final String airlineCode;

  const LoadAirlinePolicy(this.airlineCode);

  @override
  List<Object> get props => [airlineCode];
}

// Accept policy
class AcceptPolicy extends HomeCheckInEvent {
  const AcceptPolicy();
}

// Load pickup locations
class LoadPickupLocations extends HomeCheckInEvent {
  const LoadPickupLocations();
}

// Select pickup location
class SelectPickupLocation extends HomeCheckInEvent {
  final PickupLocation location;

  const SelectPickupLocation(this.location);

  @override
  List<Object> get props => [location];
}

// Select date
class SelectPickupDate extends HomeCheckInEvent {
  final DateTime date;

  const SelectPickupDate(this.date);

  @override
  List<Object> get props => [date];
}

// Load time slots for selected date
class LoadTimeSlots extends HomeCheckInEvent {
  final DateTime date;

  const LoadTimeSlots(this.date);

  @override
  List<Object> get props => [date];
}

// Select time slot
class SelectTimeSlot extends HomeCheckInEvent {
  final String timeSlot;

  const SelectTimeSlot(this.timeSlot);

  @override
  List<Object> get props => [timeSlot];
}

// Create booking
class CreateBooking extends HomeCheckInEvent {
  final HomeCheckInBooking booking;

  const CreateBooking(this.booking);

  @override
  List<Object> get props => [booking];
}

// Start tracking
class StartTracking extends HomeCheckInEvent {
  final String bookingId;

  const StartTracking(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

// Update tracking status (auto-called)
class UpdateTrackingStatus extends HomeCheckInEvent {
  final HomeCheckInBooking booking;

  const UpdateTrackingStatus(this.booking);

  @override
  List<Object> get props => [booking];
}

// Get boarding pass
class GetBoardingPass extends HomeCheckInEvent {
  final String bookingId;

  const GetBoardingPass(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

// Simulate status update (for demo/testing)
class SimulateStatusUpdate extends HomeCheckInEvent {
  final String bookingId;
  final BookingStatus newStatus;

  const SimulateStatusUpdate(this.bookingId, this.newStatus);

  @override
  List<Object> get props => [bookingId, newStatus];
}

// Reset to initial state
class ResetHomeCheckIn extends HomeCheckInEvent {
  const ResetHomeCheckIn();
}
