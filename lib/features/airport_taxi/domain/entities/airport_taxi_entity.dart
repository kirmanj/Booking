// lib/features/airport_taxi/domain/entities/airport_taxi_entity.dart
import 'package:equatable/equatable.dart';

class Airport extends Equatable {
  final String id;
  final String name;
  final String code;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final String emoji;
  final String? imageUrl;

  const Airport({
    required this.id,
    required this.name,
    required this.code,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.emoji,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, code, imageUrl];
}

enum ServiceType {
  toAirport,
  fromAirport,
}

class TaxiLocation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String type; // pickup, dropoff, stop

  const TaxiLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.type,
  });
}

class Vehicle extends Equatable {
  final String id;
  final String name;
  final String model;
  final String brand;
  final int capacity;
  final String imageUrl;
  final double pricePerKm;
  final double basePrice;
  final List<String> features;
  final bool isAvailable;
  final String vehicleClass; // Economy, Comfort, Premium

  const Vehicle({
    required this.id,
    required this.name,
    required this.model,
    required this.brand,
    required this.capacity,
    required this.imageUrl,
    required this.pricePerKm,
    required this.basePrice,
    required this.features,
    required this.isAvailable,
    required this.vehicleClass,
  });

  @override
  List<Object> get props => [id, name, model];
}

class TaxiBooking extends Equatable {
  final String id;
  final Airport airport;
  final ServiceType serviceType;
  final TaxiLocation pickupLocation;
  final TaxiLocation dropoffLocation;
  final List<TaxiLocation> stops;
  final Vehicle vehicle;
  final DateTime bookingDate;
  final String bookingTime;
  final String passengerName;
  final String passengerPhone;
  final String passengerEmail;
  final int numberOfPassengers;
  final double estimatedDistance;
  final double totalPrice;
  final BookingStatus status;
  final String? driverName;
  final String? driverPhone;
  final String? driverPhoto;
  final String? vehiclePlate;
  final double? driverRating;
  final String? confirmationNumber;
  final DateTime createdAt;

  const TaxiBooking({
    required this.id,
    required this.airport,
    required this.serviceType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stops,
    required this.vehicle,
    required this.bookingDate,
    required this.bookingTime,
    required this.passengerName,
    required this.passengerPhone,
    required this.passengerEmail,
    required this.numberOfPassengers,
    required this.estimatedDistance,
    required this.totalPrice,
    required this.status,
    this.driverName,
    this.driverPhone,
    this.driverPhoto,
    this.vehiclePlate,
    this.driverRating,
    this.confirmationNumber,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        confirmationNumber,
        status,
        bookingDate,
      ];
}

enum BookingStatus {
  pending,
  confirmed,
  driverAssigned,
  driverEnRoute,
  arrived,
  started,
  completed,
  cancelled,
}

class DriverLocation {
  final double latitude;
  final double longitude;
  final String address;
  final double speed;
  final int distanceToPickup;
  final int estimatedTimeToPickup;
  final DateTime timestamp;

  const DriverLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.speed,
    required this.distanceToPickup,
    required this.estimatedTimeToPickup,
    required this.timestamp,
  });
}

class TrackingUpdate {
  final String id;
  final BookingStatus status;
  final String message;
  final DateTime timestamp;
  final DriverLocation? driverLocation;

  const TrackingUpdate({
    required this.id,
    required this.status,
    required this.message,
    required this.timestamp,
    this.driverLocation,
  });
}

class PriceEstimate {
  final double basePrice;
  final double distancePrice;
  final double stopCharges;
  final double totalPrice;
  final double estimatedDuration; // in minutes
  final double estimatedDistance; // in km

  const PriceEstimate({
    required this.basePrice,
    required this.distancePrice,
    required this.stopCharges,
    required this.totalPrice,
    required this.estimatedDuration,
    required this.estimatedDistance,
  });
}
