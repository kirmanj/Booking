// lib/features/airport_taxi/presentation/bloc/airport_taxi_state.dart
part of 'airport_taxi_bloc.dart';

abstract class AirportTaxiState extends Equatable {
  const AirportTaxiState();

  @override
  List<Object?> get props => [];
}

// Initial state
class AirportTaxiInitial extends AirportTaxiState {
  const AirportTaxiInitial();
}

// Loading state
class AirportTaxiLoading extends AirportTaxiState {
  const AirportTaxiLoading();
}

// Airports loaded
class AirportsLoaded extends AirportTaxiState {
  final List<Airport> airports;

  const AirportsLoaded(this.airports);

  @override
  List<Object> get props => [airports];
}

// Airport selected
class AirportSelected extends AirportTaxiState {
  final Airport airport;

  const AirportSelected(this.airport);

  @override
  List<Object> get props => [airport];
}

// Service type selected
class ServiceTypeSelected extends AirportTaxiState {
  final Airport airport;
  final ServiceType serviceType;

  const ServiceTypeSelected(this.airport, this.serviceType);

  @override
  List<Object> get props => [airport, serviceType];
}

// Location configuration
class LocationConfigured extends AirportTaxiState {
  final Airport airport;
  final ServiceType serviceType;
  final TaxiLocation? pickupLocation;
  final TaxiLocation? dropoffLocation;
  final List<TaxiLocation> stops;

  const LocationConfigured({
    required this.airport,
    required this.serviceType,
    this.pickupLocation,
    this.dropoffLocation,
    this.stops = const [],
  });

  @override
  List<Object?> get props => [
        airport,
        serviceType,
        pickupLocation,
        dropoffLocation,
        stops,
      ];

  LocationConfigured copyWith({
    Airport? airport,
    ServiceType? serviceType,
    TaxiLocation? pickupLocation,
    TaxiLocation? dropoffLocation,
    List<TaxiLocation>? stops,
  }) {
    return LocationConfigured(
      airport: airport ?? this.airport,
      serviceType: serviceType ?? this.serviceType,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      stops: stops ?? this.stops,
    );
  }
}

// Date and time selected
class DateTimeSelected extends AirportTaxiState {
  final Airport airport;
  final ServiceType serviceType;
  final TaxiLocation pickupLocation;
  final TaxiLocation dropoffLocation;
  final List<TaxiLocation> stops;
  final DateTime bookingDate;
  final String bookingTime;

  const DateTimeSelected({
    required this.airport,
    required this.serviceType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stops,
    required this.bookingDate,
    required this.bookingTime,
  });

  @override
  List<Object> get props => [
        airport,
        serviceType,
        pickupLocation,
        dropoffLocation,
        stops,
        bookingDate,
        bookingTime,
      ];
}

// Vehicles loaded
class VehiclesLoaded extends AirportTaxiState {
  final Airport airport;
  final ServiceType serviceType;
  final TaxiLocation pickupLocation;
  final TaxiLocation dropoffLocation;
  final List<TaxiLocation> stops;
  final DateTime bookingDate;
  final String bookingTime;
  final List<Vehicle> vehicles;
  final PriceEstimate? priceEstimate;

  const VehiclesLoaded({
    required this.airport,
    required this.serviceType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stops,
    required this.bookingDate,
    required this.bookingTime,
    required this.vehicles,
    this.priceEstimate,
  });

  @override
  List<Object?> get props => [
        airport,
        serviceType,
        pickupLocation,
        dropoffLocation,
        stops,
        bookingDate,
        bookingTime,
        vehicles,
        priceEstimate,
      ];
}

// Vehicle selected with price
class VehicleSelected extends AirportTaxiState {
  final Airport airport;
  final ServiceType serviceType;
  final TaxiLocation pickupLocation;
  final TaxiLocation dropoffLocation;
  final List<TaxiLocation> stops;
  final DateTime bookingDate;
  final String bookingTime;
  final Vehicle vehicle;
  final PriceEstimate priceEstimate;

  const VehicleSelected({
    required this.airport,
    required this.serviceType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stops,
    required this.bookingDate,
    required this.bookingTime,
    required this.vehicle,
    required this.priceEstimate,
  });

  @override
  List<Object> get props => [
        airport,
        serviceType,
        pickupLocation,
        dropoffLocation,
        stops,
        bookingDate,
        bookingTime,
        vehicle,
        priceEstimate,
      ];
}

// Booking created
class BookingCreated extends AirportTaxiState {
  final TaxiBooking booking;

  const BookingCreated(this.booking);

  @override
  List<Object> get props => [booking];
}

// Tracking active
class TrackingActive extends AirportTaxiState {
  final TaxiBooking booking;
  final TrackingUpdate? latestUpdate;
  final DriverLocation? driverLocation;

  const TrackingActive({
    required this.booking,
    this.latestUpdate,
    this.driverLocation,
  });

  @override
  List<Object?> get props => [booking, latestUpdate, driverLocation];
}

// Booking completed
class BookingCompleted extends AirportTaxiState {
  final TaxiBooking booking;

  const BookingCompleted(this.booking);

  @override
  List<Object> get props => [booking];
}

// Booking cancelled
class BookingCancelled extends AirportTaxiState {
  final String bookingId;
  final String reason;

  const BookingCancelled(this.bookingId, this.reason);

  @override
  List<Object> get props => [bookingId, reason];
}

// Error state
class AirportTaxiError extends AirportTaxiState {
  final String message;

  const AirportTaxiError(this.message);

  @override
  List<Object> get props => [message];
}
