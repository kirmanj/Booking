// lib/features/airport_taxi/presentation/bloc/airport_taxi_event.dart
part of 'airport_taxi_bloc.dart';

abstract class AirportTaxiEvent extends Equatable {
  const AirportTaxiEvent();

  @override
  List<Object?> get props => [];
}

// Load airports
class LoadAirports extends AirportTaxiEvent {
  const LoadAirports();
}

// Select airport
class SelectAirport extends AirportTaxiEvent {
  final Airport airport;

  const SelectAirport(this.airport);

  @override
  List<Object> get props => [airport];
}

// Select service type (To/From Airport)
class SelectServiceType extends AirportTaxiEvent {
  final ServiceType serviceType;

  const SelectServiceType(this.serviceType);

  @override
  List<Object> get props => [serviceType];
}

// Set pickup location
class SetPickupLocation extends AirportTaxiEvent {
  final TaxiLocation location;

  const SetPickupLocation(this.location);

  @override
  List<Object> get props => [location];
}

// Set dropoff location
class SetDropoffLocation extends AirportTaxiEvent {
  final TaxiLocation location;

  const SetDropoffLocation(this.location);

  @override
  List<Object> get props => [location];
}

// Add stop
class AddStop extends AirportTaxiEvent {
  final TaxiLocation location;

  const AddStop(this.location);

  @override
  List<Object> get props => [location];
}

// Remove stop
class RemoveStop extends AirportTaxiEvent {
  final int index;

  const RemoveStop(this.index);

  @override
  List<Object> get props => [index];
}

// Load vehicles
class LoadVehicles extends AirportTaxiEvent {
  const LoadVehicles();
}

// Select vehicle
class SelectVehicle extends AirportTaxiEvent {
  final Vehicle vehicle;

  const SelectVehicle(this.vehicle);

  @override
  List<Object> get props => [vehicle];
}

// Calculate price
class CalculatePrice extends AirportTaxiEvent {
  const CalculatePrice();
}

// Set date and time
class SetDateTime extends AirportTaxiEvent {
  final DateTime date;
  final String time;

  const SetDateTime(this.date, this.time);

  @override
  List<Object> get props => [date, time];
}

// Create booking
class CreateBooking extends AirportTaxiEvent {
  final TaxiBooking booking;

  const CreateBooking(this.booking);

  @override
  List<Object> get props => [booking];
}

// Start tracking
class StartTracking extends AirportTaxiEvent {
  final String bookingId;

  const StartTracking(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

// Update tracking
class UpdateTracking extends AirportTaxiEvent {
  final TrackingUpdate update;

  const UpdateTracking(this.update);

  @override
  List<Object> get props => [update];
}

// Cancel booking
class CancelBooking extends AirportTaxiEvent {
  final String bookingId;

  const CancelBooking(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

// Reset to initial
class ResetAirportTaxi extends AirportTaxiEvent {
  const ResetAirportTaxi();
}
