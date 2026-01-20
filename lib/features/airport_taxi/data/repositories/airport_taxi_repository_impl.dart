// lib/features/airport_taxi/data/repositories/airport_taxi_repository_impl.dart
import 'dart:async';
import 'dart:math';
import 'package:aman_booking/features/airport_taxi/domain/entities/airport_taxi_entity.dart';
import 'package:aman_booking/features/airport_taxi/domain/repository/airport_taxi_repository.dart';

class AirportTaxiRepositoryImpl implements AirportTaxiRepository {
  final Map<String, TaxiBooking> _bookings = {};
  final Random _random = Random();

  @override
  Future<List<Airport>> getAirports() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoAirports;
  }

  @override
  Future<Airport> getAirport(String airportId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoAirports.firstWhere((a) => a.id == airportId);
  }

  @override
  Future<List<Vehicle>> getAvailableVehicles() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _demoVehicles.where((v) => v.isAvailable).toList();
  }

  @override
  Future<PriceEstimate> calculatePrice({
    required TaxiLocation pickup,
    required TaxiLocation dropoff,
    required List<TaxiLocation> stops,
    required Vehicle vehicle,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Calculate distance (simplified)
    final distance = _calculateDistance(
      pickup.latitude,
      pickup.longitude,
      dropoff.latitude,
      dropoff.longitude,
    );

    // Base calculations
    final basePrice = vehicle.basePrice;
    final distancePrice = distance * vehicle.pricePerKm;
    final stopCharges = stops.length * 2.0; // $2 per stop

    // Vehicle class multiplier
    double multiplier = 1.0;
    if (vehicle.vehicleClass == 'Premium') multiplier = 1.5;
    if (vehicle.vehicleClass == 'Luxury') multiplier = 2.0;

    final totalPrice = (basePrice + distancePrice + stopCharges) * multiplier;
    final duration = (distance / 60) * 60; // Rough estimate: 60 km/h avg

    return PriceEstimate(
      basePrice: basePrice,
      distancePrice: distancePrice,
      stopCharges: stopCharges,
      totalPrice: totalPrice,
      estimatedDuration: duration,
      estimatedDistance: distance,
    );
  }

  @override
  Future<TaxiBooking> createBooking(TaxiBooking booking) async {
    await Future.delayed(const Duration(seconds: 1));

    final confirmationNumber = 'EIA${_random.nextInt(900000) + 100000}';

    final newBooking = TaxiBooking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      airport: booking.airport,
      serviceType: booking.serviceType,
      pickupLocation: booking.pickupLocation,
      dropoffLocation: booking.dropoffLocation,
      stops: booking.stops,
      vehicle: booking.vehicle,
      bookingDate: booking.bookingDate,
      bookingTime: booking.bookingTime,
      passengerName: booking.passengerName,
      passengerPhone: booking.passengerPhone,
      passengerEmail: booking.passengerEmail,
      numberOfPassengers: booking.numberOfPassengers,
      estimatedDistance: booking.estimatedDistance,
      totalPrice: booking.totalPrice,
      status: BookingStatus.confirmed,
      confirmationNumber: confirmationNumber,
      createdAt: DateTime.now(),
    );

    _bookings[newBooking.id] = newBooking;
    return newBooking;
  }

  @override
  Future<TaxiBooking> getBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _bookings[bookingId]!;
  }

  @override
  Stream<TrackingUpdate> trackBooking(String bookingId) async* {
    final statuses = [
      BookingStatus.confirmed,
      BookingStatus.driverAssigned,
      BookingStatus.driverEnRoute,
      BookingStatus.arrived,
      BookingStatus.started,
      BookingStatus.completed,
    ];

    final messages = {
      BookingStatus.confirmed: 'Your booking is confirmed',
      BookingStatus.driverAssigned: 'Driver has been assigned to your booking',
      BookingStatus.driverEnRoute: 'Driver is on the way to pickup location',
      BookingStatus.arrived: 'Driver has arrived at pickup location',
      BookingStatus.started: 'Trip has started',
      BookingStatus.completed: 'Trip completed successfully',
    };

    for (int i = 0; i < statuses.length; i++) {
      await Future.delayed(const Duration(seconds: 5));

      final booking = _bookings[bookingId]!;
      String? driverName;
      String? driverPhone;
      String? vehiclePlate;
      double? driverRating;
      String? driverPhoto;

      if (i >= 1) {
        driverName = 'Ahmed Al Mansouri';
        driverPhone = '+964 750 XXX XXXX';
        vehiclePlate = 'EIA-${_random.nextInt(9000) + 1000}';
        driverRating = 4.9;
        driverPhoto = '👨‍✈️';
      }

      final updatedBooking = TaxiBooking(
        id: booking.id,
        airport: booking.airport,
        serviceType: booking.serviceType,
        pickupLocation: booking.pickupLocation,
        dropoffLocation: booking.dropoffLocation,
        stops: booking.stops,
        vehicle: booking.vehicle,
        bookingDate: booking.bookingDate,
        bookingTime: booking.bookingTime,
        passengerName: booking.passengerName,
        passengerPhone: booking.passengerPhone,
        passengerEmail: booking.passengerEmail,
        numberOfPassengers: booking.numberOfPassengers,
        estimatedDistance: booking.estimatedDistance,
        totalPrice: booking.totalPrice,
        status: statuses[i],
        driverName: driverName,
        driverPhone: driverPhone,
        vehiclePlate: vehiclePlate,
        driverRating: driverRating,
        driverPhoto: driverPhoto,
        confirmationNumber: booking.confirmationNumber,
        createdAt: booking.createdAt,
      );

      _bookings[bookingId] = updatedBooking;

      yield TrackingUpdate(
        id: bookingId,
        status: statuses[i],
        message: messages[statuses[i]]!,
        timestamp: DateTime.now(),
      );
    }
  }

  @override
  Future<DriverLocation> getDriverLocation(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final booking = _bookings[bookingId]!;
    double speed = 45.0;
    int distanceToPickup = 0;
    int estimatedTime = 0;

    switch (booking.status) {
      case BookingStatus.driverEnRoute:
        distanceToPickup = 3500; // 3.5 km
        estimatedTime = 8;
        break;
      case BookingStatus.arrived:
        distanceToPickup = 0;
        estimatedTime = 0;
        break;
      case BookingStatus.started:
        distanceToPickup = 0;
        estimatedTime = 0;
        break;
      default:
        distanceToPickup = 0;
        estimatedTime = 0;
    }

    return DriverLocation(
      latitude: 36.1911 + (_random.nextDouble() * 0.01),
      longitude: 44.0091 + (_random.nextDouble() * 0.01),
      address: 'On 100 Meter Street, approaching pickup',
      speed: speed,
      distanceToPickup: distanceToPickup,
      estimatedTimeToPickup: estimatedTime,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final booking = _bookings[bookingId];
    if (booking != null) {
      final cancelledBooking = TaxiBooking(
        id: booking.id,
        airport: booking.airport,
        serviceType: booking.serviceType,
        pickupLocation: booking.pickupLocation,
        dropoffLocation: booking.dropoffLocation,
        stops: booking.stops,
        vehicle: booking.vehicle,
        bookingDate: booking.bookingDate,
        bookingTime: booking.bookingTime,
        passengerName: booking.passengerName,
        passengerPhone: booking.passengerPhone,
        passengerEmail: booking.passengerEmail,
        numberOfPassengers: booking.numberOfPassengers,
        estimatedDistance: booking.estimatedDistance,
        totalPrice: booking.totalPrice,
        status: BookingStatus.cancelled,
        driverName: booking.driverName,
        driverPhone: booking.driverPhone,
        vehiclePlate: booking.vehiclePlate,
        driverRating: booking.driverRating,
        confirmationNumber: booking.confirmationNumber,
        createdAt: booking.createdAt,
      );
      _bookings[bookingId] = cancelledBooking;
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  // DEMO DATA

  static final List<Airport> _demoAirports = [
    const Airport(
      id: '1',
      name: 'Erbil International Airport',
      code: 'EIA',
      city: 'Erbil',
      address: 'Erbil, Kurdistan Region, Iraq',
      latitude: 36.2376,
      longitude: 43.9633,
      emoji: '✈️',
      imageUrl:
          'https://images.unsplash.com/photo-1500395235658-f87dff62cbf3?auto=format&fit=crop&w=900&q=70',
    ),
    const Airport(
      id: '2',
      name: 'Baghdad International Airport',
      code: 'BGW',
      city: 'Baghdad',
      address: 'Baghdad, Iraq',
      latitude: 33.2625,
      longitude: 44.2346,
      emoji: '✈️',
      imageUrl:
          'https://images.unsplash.com/photo-1505678261036-a3fcc5e884ee?auto=format&fit=crop&w=900&q=70',
    ),
    const Airport(
      id: '3',
      name: 'Sulaymaniyah International Airport',
      code: 'ISU',
      city: 'Sulaymaniyah',
      address: 'Sulaymaniyah, Kurdistan Region, Iraq',
      latitude: 35.5608,
      longitude: 45.3147,
      emoji: '✈️',
      imageUrl:
          'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?auto=format&fit=crop&w=900&q=70',
    ),
    const Airport(
      id: '4',
      name: 'Basra International Airport',
      code: 'BSR',
      city: 'Basra',
      address: 'Basra, Iraq',
      latitude: 30.5491,
      longitude: 47.6621,
      emoji: '✈️',
      imageUrl:
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=900&q=70',
    ),
  ];

  static final List<Vehicle> _demoVehicles = [
    // Economy Class
    const Vehicle(
      id: '1',
      name: 'Corolla',
      model: 'Toyota Corolla',
      brand: 'Toyota',
      capacity: 4,
      imageUrl:
          'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?auto=format&fit=crop&w=900&q=70',
      pricePerKm: 0.40,
      basePrice: 5.0,
      features: [
        'Air Conditioning',
        'Comfortable Seats',
        'Radio',
        'GPS Navigation'
      ],
      isAvailable: true,
      vehicleClass: 'Economy',
    ),

    // Comfort Class - INCLUDING CAMRY HYBRID FROM SCREENSHOT!
    const Vehicle(
      id: '3',
      name: 'Camry Hybrid',
      model: 'Toyota Camry Hybrid',
      brand: 'Toyota',
      capacity: 4,
      imageUrl:
          'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?auto=format&fit=crop&w=900&q=70',
      pricePerKm: 0.50,
      basePrice: 7.0,
      features: [
        'Premium Air Conditioning',
        'Leather Seats',
        'Premium Sound System',
        'GPS Navigation',
        'USB Charging'
      ],
      isAvailable: true,
      vehicleClass: 'Comfort',
    ),

    // Premium Class - INCLUDING FORTUNER 2024 FROM SCREENSHOT!
    const Vehicle(
      id: '5',
      name: 'Fortuner 2024',
      model: 'Toyota Fortuner 2024',
      brand: 'Toyota',
      capacity: 7,
      imageUrl:
          'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?auto=format&fit=crop&w=900&q=70',
      pricePerKm: 0.70,
      basePrice: 10.0,
      features: [
        'Premium Air Conditioning',
        'Leather Seats',
        'Premium Sound System',
        'GPS Navigation',
        'Extra Luggage Space',
        '7 Passengers',
        'USB Charging'
      ],
      isAvailable: true,
      vehicleClass: 'Premium',
    ),
    const Vehicle(
      id: '6',
      name: 'Land Cruiser',
      model: 'Toyota Land Cruiser',
      brand: 'Toyota',
      capacity: 7,
      imageUrl:
          'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?auto=format&fit=crop&w=900&q=70',
      pricePerKm: 0.75,
      basePrice: 12.0,
      features: [
        'Premium Air Conditioning',
        'Luxury Leather Seats',
        'Premium Sound System',
        'GPS Navigation',
        'Extra Luggage Space',
        '7 Passengers'
      ],
      isAvailable: true,
      vehicleClass: 'Premium',
    ),

    // Luxury Class
    const Vehicle(
      id: '8',
      name: 'BMW 5 Series',
      model: 'BMW 5 Series',
      brand: 'BMW',
      capacity: 4,
      imageUrl:
          'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?auto=format&fit=crop&w=900&q=70',
      pricePerKm: 0.95,
      basePrice: 15.0,
      features: [
        'Luxury Air Conditioning',
        'Premium Leather Seats',
        'High-End Sound System',
        'Advanced GPS',
        'WiFi',
        'Professional Chauffeur'
      ],
      isAvailable: true,
      vehicleClass: 'Luxury',
    ),
  ];

  // Demo locations in Erbil - INCLUDING FAMILY MALL FROM SCREENSHOT!
  static final List<TaxiLocation> _demoLocations = [
    const TaxiLocation(
      id: '1',
      name: 'Family Mall',
      address: '100 Meter Street, Erbil',
      latitude: 36.1911,
      longitude: 44.0091,
      type: 'popular',
    ),
    const TaxiLocation(
      id: '2',
      name: 'Downtown Erbil',
      address: 'City Center, Erbil',
      latitude: 36.1911,
      longitude: 44.0091,
      type: 'popular',
    ),
    const TaxiLocation(
      id: '3',
      name: 'Empire World',
      address: 'Empire Business Complex, Erbil',
      latitude: 36.1995,
      longitude: 44.0166,
      type: 'popular',
    ),
    const TaxiLocation(
      id: '4',
      name: 'Majidi Mall',
      address: 'Gulan Street, Erbil',
      latitude: 36.1850,
      longitude: 44.0150,
      type: 'popular',
    ),
    const TaxiLocation(
      id: '5',
      name: 'Dream City',
      address: 'Dream City Complex, Erbil',
      latitude: 36.1750,
      longitude: 44.0050,
      type: 'popular',
    ),
    const TaxiLocation(
      id: '6',
      name: 'Noble Tower',
      address: 'Gulan Street, Erbil',
      latitude: 36.1920,
      longitude: 44.0220,
      type: 'popular',
    ),
    const TaxiLocation(
      id: '7',
      name: 'Erbil Citadel',
      address: 'Old City, Erbil',
      latitude: 36.1911,
      longitude: 44.0091,
      type: 'landmark',
    ),
    const TaxiLocation(
      id: '8',
      name: 'Sami Abdulrahman Park',
      address: '100 Meter Street, Erbil',
      latitude: 36.1800,
      longitude: 44.0100,
      type: 'landmark',
    ),
    const TaxiLocation(
      id: '9',
      name: 'Erbil Rotana Hotel',
      address: 'Gulan Street, Erbil',
      latitude: 36.1850,
      longitude: 44.0200,
      type: 'hotel',
    ),
    const TaxiLocation(
      id: '10',
      name: 'Divan Erbil Hotel',
      address: 'Gulan Street, Erbil',
      latitude: 36.1900,
      longitude: 44.0180,
      type: 'hotel',
    ),
  ];
}
