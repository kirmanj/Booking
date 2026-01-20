import 'package:equatable/equatable.dart';

enum BookingType {
  flight,
  hotel,
  carRental,
  tour,
  busTicket,
  eSim,
  airportTaxi,
  homeCheckin,
}

enum BookingStatus {
  upcoming,
  pending,
  completed,
  cancelled,
  confirmed,

  inProgress,
}

abstract class Booking extends Equatable {
  final String id;
  final BookingType type;
  final BookingStatus status;
  final DateTime bookingDate;
  final DateTime serviceDate;
  final double totalAmount;
  final double taxAmount;
  final double subtotal;
  final String customerName;
  final String customerEmail;
  final String customerPhone;

  const Booking({
    required this.id,
    required this.type,
    required this.status,
    required this.bookingDate,
    required this.serviceDate,
    required this.totalAmount,
    required this.taxAmount,
    required this.subtotal,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
  });

  String getTypeDisplayName() {
    switch (type) {
      case BookingType.flight:
        return 'Flight';
      case BookingType.hotel:
        return 'Hotel';
      case BookingType.carRental:
        return 'Car Rental';
      case BookingType.tour:
        return 'Tour';
      case BookingType.busTicket:
        return 'Bus Ticket';
      case BookingType.eSim:
        return 'E-SIM';
      case BookingType.airportTaxi:
        return 'Airport Taxi';
      case BookingType.homeCheckin:
        return 'Home Check-In';
    }
  }

  String getStatusDisplayName() {
    switch (status) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.confirmed:
        return 'Confirmed';
    }
  }

  @override
  List<Object?> get props => [
        id,
        type,
        status,
        bookingDate,
        serviceDate,
        totalAmount,
        taxAmount,
        subtotal,
      ];
}

class FlightBooking extends Booking {
  final String airline;
  final String flightNumber;
  final String from;
  final String to;
  final String fromCode;
  final String toCode;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String classType;
  final int passengers;
  final String seatNumbers;
  final String pnr;

  const FlightBooking({
    required super.id,
    required super.status,
    required super.bookingDate,
    required super.serviceDate,
    required super.totalAmount,
    required super.taxAmount,
    required super.subtotal,
    required super.customerName,
    required super.customerEmail,
    required super.customerPhone,
    required this.airline,
    required this.flightNumber,
    required this.from,
    required this.to,
    required this.fromCode,
    required this.toCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.classType,
    required this.passengers,
    required this.seatNumbers,
    required this.pnr,
  }) : super(type: BookingType.flight);

  @override
  List<Object?> get props => [...super.props, airline, flightNumber, pnr];
}

class HotelBooking extends Booking {
  final String hotelName;
  final String location;
  final String roomType;
  final int rooms;
  final int guests;
  final DateTime checkIn;
  final DateTime checkOut;
  final int nights;
  final String confirmationNumber;
  final List<String> amenities;

  const HotelBooking({
    required super.id,
    required super.status,
    required super.bookingDate,
    required super.serviceDate,
    required super.totalAmount,
    required super.taxAmount,
    required super.subtotal,
    required super.customerName,
    required super.customerEmail,
    required super.customerPhone,
    required this.hotelName,
    required this.location,
    required this.roomType,
    required this.rooms,
    required this.guests,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.confirmationNumber,
    required this.amenities,
  }) : super(type: BookingType.hotel);

  @override
  List<Object?> get props => [
        ...super.props,
        hotelName,
        confirmationNumber,
        nights,
      ];
}

class CarRentalBooking extends Booking {
  final String carModel;
  final String carBrand;
  final String carType;
  final String licensePlate;
  final DateTime pickupDate;
  final DateTime returnDate;
  final String pickupLocation;
  final String returnLocation;
  final int days;
  final bool withDriver;
  final String? driverName;
  final List<String> extras;

  const CarRentalBooking({
    required super.id,
    required super.status,
    required super.bookingDate,
    required super.serviceDate,
    required super.totalAmount,
    required super.taxAmount,
    required super.subtotal,
    required super.customerName,
    required super.customerEmail,
    required super.customerPhone,
    required this.carModel,
    required this.carBrand,
    required this.carType,
    required this.licensePlate,
    required this.pickupDate,
    required this.returnDate,
    required this.pickupLocation,
    required this.returnLocation,
    required this.days,
    required this.withDriver,
    this.driverName,
    required this.extras,
  }) : super(type: BookingType.carRental);

  @override
  List<Object?> get props => [
        ...super.props,
        carModel,
        licensePlate,
        days,
      ];
}

class TourBooking extends Booking {
  final String tourName;
  final String destination;
  final String tourOperator;
  final DateTime tourDate;
  final String duration;
  final int participants;
  final bool isPrivate;
  final String meetingPoint;
  final List<String> includes;

  const TourBooking({
    required super.id,
    required super.status,
    required super.bookingDate,
    required super.serviceDate,
    required super.totalAmount,
    required super.taxAmount,
    required super.subtotal,
    required super.customerName,
    required super.customerEmail,
    required super.customerPhone,
    required this.tourName,
    required this.destination,
    required this.tourOperator,
    required this.tourDate,
    required this.duration,
    required this.participants,
    required this.isPrivate,
    required this.meetingPoint,
    required this.includes,
  }) : super(type: BookingType.tour);

  @override
  List<Object?> get props => [...super.props, tourName, destination];
}

class BusTicketBooking extends Booking {
  final String busCompany;
  final String busNumber;
  final String from;
  final String to;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int passengers;
  final String seatNumbers;
  final String ticketNumber;
  final String boardingPoint;

  const BusTicketBooking({
    required super.id,
    required super.status,
    required super.bookingDate,
    required super.serviceDate,
    required super.totalAmount,
    required super.taxAmount,
    required super.subtotal,
    required super.customerName,
    required super.customerEmail,
    required super.customerPhone,
    required this.busCompany,
    required this.busNumber,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.passengers,
    required this.seatNumbers,
    required this.ticketNumber,
    required this.boardingPoint,
  }) : super(type: BookingType.busTicket);

  @override
  List<Object?> get props => [...super.props, ticketNumber, seatNumbers];
}

class ESimBooking extends Booking {
  final String packageName;
  final String country;
  final String dataAmount;
  final int validityDays;
  final String simNumber;
  final String activationCode;
  final DateTime activationDate;
  final bool isActivated;

  const ESimBooking({
    required super.id,
    required super.status,
    required super.bookingDate,
    required super.serviceDate,
    required super.totalAmount,
    required super.taxAmount,
    required super.subtotal,
    required super.customerName,
    required super.customerEmail,
    required super.customerPhone,
    required this.packageName,
    required this.country,
    required this.dataAmount,
    required this.validityDays,
    required this.simNumber,
    required this.activationCode,
    required this.activationDate,
    required this.isActivated,
  }) : super(type: BookingType.eSim);

  @override
  List<Object?> get props => [...super.props, simNumber, country];
}

class AirportTaxiBooking extends Booking {
  final String driverName;
  final String driverPhone;
  final String vehicleModel;
  final String vehiclePlate;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime pickupTime;
  final String flightNumber;
  final String terminal;
  final int passengers;

  const AirportTaxiBooking({
    required super.id,
    required super.status,
    required super.bookingDate,
    required super.serviceDate,
    required super.totalAmount,
    required super.taxAmount,
    required super.subtotal,
    required super.customerName,
    required super.customerEmail,
    required super.customerPhone,
    required this.driverName,
    required this.driverPhone,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupTime,
    required this.flightNumber,
    required this.terminal,
    required this.passengers,
  }) : super(type: BookingType.airportTaxi);

  @override
  List<Object?> get props => [...super.props, vehiclePlate, flightNumber];
}

class HomeCheckinBooking extends Booking {
  final String agentName;
  final String flightNumber;
  final String airline;
  final DateTime flightTime;
  final String pickupLocation;
  final String pickupTime;
  final String passportNumber;
  final String nationality;
  final String boardingPassNumber;
  final String seatNumber;

  const HomeCheckinBooking({
    required super.id,
    required super.status,
    required super.bookingDate,
    required super.serviceDate,
    required super.totalAmount,
    required super.taxAmount,
    required super.subtotal,
    required super.customerName,
    required super.customerEmail,
    required super.customerPhone,
    required this.agentName,
    required this.flightNumber,
    required this.airline,
    required this.flightTime,
    required this.pickupLocation,
    required this.pickupTime,
    required this.passportNumber,
    required this.nationality,
    required this.boardingPassNumber,
    required this.seatNumber,
  }) : super(type: BookingType.homeCheckin);

  @override
  List<Object?> get props => [
        ...super.props,
        boardingPassNumber,
        flightNumber,
      ];
}
