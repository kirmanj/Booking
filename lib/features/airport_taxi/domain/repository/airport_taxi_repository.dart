// lib/features/airport_taxi/domain/repositories/airport_taxi_repository.dart
import 'package:aman_booking/features/airport_taxi/domain/entities/airport_taxi_entity.dart';

abstract class AirportTaxiRepository {
  Future<List<Airport>> getAirports();
  Future<Airport> getAirport(String airportId);
  Future<List<Vehicle>> getAvailableVehicles();
  Future<PriceEstimate> calculatePrice({
    required TaxiLocation pickup,
    required TaxiLocation dropoff,
    required List<TaxiLocation> stops,
    required Vehicle vehicle,
  });
  Future<TaxiBooking> createBooking(TaxiBooking booking);
  Future<TaxiBooking> getBooking(String bookingId);
  Stream<TrackingUpdate> trackBooking(String bookingId);
  Future<DriverLocation> getDriverLocation(String bookingId);
  Future<void> cancelBooking(String bookingId);
}
