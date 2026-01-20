// lib/features/home_checkin/domain/repositories/home_checkin_repository.dart
import 'package:aman_booking/features/home_checkin/domain/entities/home_checkin_entity.dart';

abstract class HomeCheckInRepository {
  Future<List<Airline>> getAirlines();
  Future<Airline> getAirlinePolicy(String airlineCode);
  Future<List<PickupLocation>> getPickupLocations();
  Future<List<String>> getTimeSlots(DateTime date);
  Future<HomeCheckInBooking> createBooking(HomeCheckInBooking booking);
  Future<HomeCheckInBooking> getBooking(String bookingId);
  Future<DriverLocation> getDriverLocation(String bookingId);
  Future<BoardingPass> getBoardingPass(String bookingId);
  Stream<HomeCheckInBooking> trackBooking(String bookingId);
}
