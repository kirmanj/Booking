// lib/features/home_checkin/domain/entities/home_checkin_entity.dart
import 'package:equatable/equatable.dart';

class HomeCheckInBooking extends Equatable {
  final String id;
  final String flightNumber;
  final String airline;
  final String airlineLogo;
  final String departureCity;
  final String arrivalCity;
  final DateTime flightDate;
  final String flightTime;
  final String passengerName;
  final String passportNumber;
  final String nationality;
  final String pickupLocation;
  final String detailedAddress;
  final DateTime pickupDate;
  final String pickupTime;
  final int numberOfBags;
  final double totalWeight;
  final List<BagItem> bags;
  final BookingStatus status;
  final String? driverName;
  final String? driverPhone;
  final String? vehicleNumber;
  final String? estimatedArrival;
  final String? confirmationNumber;
  final DateTime createdAt;

  const HomeCheckInBooking({
    required this.id,
    required this.flightNumber,
    required this.airline,
    required this.airlineLogo,
    required this.departureCity,
    required this.arrivalCity,
    required this.flightDate,
    required this.flightTime,
    required this.passengerName,
    required this.passportNumber,
    required this.nationality,
    required this.pickupLocation,
    required this.detailedAddress,
    required this.pickupDate,
    required this.pickupTime,
    required this.numberOfBags,
    required this.totalWeight,
    required this.bags,
    required this.status,
    this.driverName,
    this.driverPhone,
    this.vehicleNumber,
    this.estimatedArrival,
    this.confirmationNumber,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        flightNumber,
        airline,
        departureCity,
        arrivalCity,
        flightDate,
        status,
        confirmationNumber,
      ];
}

class BagItem extends Equatable {
  final String id;
  final String type; // Checked, Carry-on
  final double weight;
  final String description;

  const BagItem({
    required this.id,
    required this.type,
    required this.weight,
    required this.description,
  });

  @override
  List<Object> get props => [id, type, weight, description];
}

enum BookingStatus {
  pending,
  confirmed,
  driverAssigned,
  driverEnRoute,
  bagsCollected,
  atAirport,
  checkedIn,
  completed,
  cancelled,
}

class Airline {
  final String code;
  final String name;
  final String logo;
  final String policy;
  final BaggageAllowance baggageAllowance;
  final List<String> prohibitedItems;
  final List<String> specialInstructions;

  const Airline({
    required this.code,
    required this.name,
    required this.logo,
    required this.policy,
    required this.baggageAllowance,
    required this.prohibitedItems,
    required this.specialInstructions,
  });
}

class BaggageAllowance {
  final int maxCheckedBags;
  final double maxWeightPerBag;
  final int maxCarryOn;
  final double maxCarryOnWeight;
  final String dimensions;

  const BaggageAllowance({
    required this.maxCheckedBags,
    required this.maxWeightPerBag,
    required this.maxCarryOn,
    required this.maxCarryOnWeight,
    required this.dimensions,
  });
}

class DriverLocation {
  final double latitude;
  final double longitude;
  final String address;
  final String status;
  final int distanceInMeters;
  final int estimatedTimeInMinutes;

  const DriverLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.status,
    required this.distanceInMeters,
    required this.estimatedTimeInMinutes,
  });
}

class BoardingPass {
  final String passengerName;
  final String flightNumber;
  final String airline;
  final String airlineLogo;
  final String departureCity;
  final String arrivalCity;
  final String departureCode;
  final String arrivalCode;
  final DateTime flightDate;
  final String boardingTime;
  final String departureTime;
  final String gate;
  final String seat;
  final String bookingReference;
  final String barcode;
  final String terminal;
  final String bagTagNumbers;

  const BoardingPass({
    required this.passengerName,
    required this.flightNumber,
    required this.airline,
    required this.airlineLogo,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureCode,
    required this.arrivalCode,
    required this.flightDate,
    required this.boardingTime,
    required this.departureTime,
    required this.gate,
    required this.seat,
    required this.bookingReference,
    required this.barcode,
    required this.terminal,
    required this.bagTagNumbers,
  });
}

class PickupLocation {
  final String id;
  final String name;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final List<String> landmarks;

  const PickupLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.landmarks,
  });
}
