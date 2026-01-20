// lib/core/payment/domain/entities/service_type.dart

enum ServiceType {
  flight,
  hotel,
  carRental,
  busTicket,
  eSim,
  homeCheckin,
  airportTaxi,
  tour;

  String get displayName {
    switch (this) {
      case ServiceType.flight:
        return 'Flight Service';
      case ServiceType.hotel:
        return 'Hotel Stays';
      case ServiceType.carRental:
        return 'Car Rental';
      case ServiceType.busTicket:
        return 'Bus Tickets';
      case ServiceType.eSim:
        return 'E-SIMs';
      case ServiceType.homeCheckin:
        return 'Home Check-in';
      case ServiceType.airportTaxi:
        return 'Airport Taxi';
      case ServiceType.tour:
        return 'Tours';
    }
  }

  String get fullName => 'AMAN BOOKING $displayName';

  String get icon {
    switch (this) {
      case ServiceType.flight:
        return 'assets/icons/flight.png';
      case ServiceType.hotel:
        return 'assets/icons/hotel.png';
      case ServiceType.carRental:
        return "assets/icons/car.png";
      case ServiceType.busTicket:
        return 'assets/icons/bus.png';
      case ServiceType.eSim:
        return 'assets/icons/esim.png';
      case ServiceType.homeCheckin:
        return 'assets/icons/home.png';
      case ServiceType.airportTaxi:
        return 'assets/icons/taxi.png';
      case ServiceType.tour:
        return 'assets/icons/tour.png';
    }
  }
}
