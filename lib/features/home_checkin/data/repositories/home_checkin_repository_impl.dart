// lib/features/home_checkin/data/repositories/home_checkin_repository_impl.dart
import 'dart:async';
import 'dart:math';
import 'package:aman_booking/features/home_checkin/domain/entities/home_checkin_entity.dart';
import 'package:aman_booking/features/home_checkin/domain/repositories/home_checkin_repository.dart';

class HomeCheckInRepositoryImpl implements HomeCheckInRepository {
  // Simulated database
  final Map<String, HomeCheckInBooking> _bookings = {};
  final Random _random = Random();

  @override
  Future<List<Airline>> getAirlines() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoAirlines;
  }

  @override
  Future<Airline> getAirlinePolicy(String airlineCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoAirlines.firstWhere(
      (airline) => airline.code == airlineCode,
      orElse: () => _demoAirlines.first,
    );
  }

  @override
  Future<List<PickupLocation>> getPickupLocations() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _demoLocations;
  }

  @override
  Future<List<String>> getTimeSlots(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _demoTimeSlots;
  }

  @override
  Future<HomeCheckInBooking> createBooking(HomeCheckInBooking booking) async {
    await Future.delayed(const Duration(seconds: 1));

    // Generate confirmation number
    final confirmationNumber = 'HC${_random.nextInt(900000) + 100000}';

    final newBooking = HomeCheckInBooking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      flightNumber: booking.flightNumber,
      airline: booking.airline,
      airlineLogo: booking.airlineLogo,
      departureCity: booking.departureCity,
      arrivalCity: booking.arrivalCity,
      flightDate: booking.flightDate,
      flightTime: booking.flightTime,
      passengerName: booking.passengerName,
      passportNumber: booking.passportNumber,
      nationality: booking.nationality,
      pickupLocation: booking.pickupLocation,
      detailedAddress: booking.detailedAddress,
      pickupDate: booking.pickupDate,
      pickupTime: booking.pickupTime,
      numberOfBags: booking.numberOfBags,
      totalWeight: booking.totalWeight,
      bags: booking.bags,
      status: BookingStatus.confirmed,
      confirmationNumber: confirmationNumber,
      createdAt: DateTime.now(),
    );

    _bookings[newBooking.id] = newBooking;
    return newBooking;
  }

  @override
  Future<HomeCheckInBooking> getBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _bookings[bookingId]!;
  }

  @override
  Future<DriverLocation> getDriverLocation(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final booking = _bookings[bookingId]!;

    // Simulated driver location based on status
    double distanceInKm = 0;
    int estimatedMinutes = 0;

    switch (booking.status) {
      case BookingStatus.driverEnRoute:
        distanceInKm = 5.2;
        estimatedMinutes = 12;
        break;
      case BookingStatus.bagsCollected:
        distanceInKm = 15.8;
        estimatedMinutes = 25;
        break;
      case BookingStatus.atAirport:
        distanceInKm = 0;
        estimatedMinutes = 0;
        break;
      default:
        distanceInKm = 0;
        estimatedMinutes = 0;
    }

    return DriverLocation(
      latitude: 25.2048 + (_random.nextDouble() * 0.1),
      longitude: 55.2708 + (_random.nextDouble() * 0.1),
      address: 'On Sheikh Zayed Road',
      status: booking.status.toString().split('.').last,
      distanceInMeters: (distanceInKm * 1000).toInt(),
      estimatedTimeInMinutes: estimatedMinutes,
    );
  }

  @override
  Future<BoardingPass> getBoardingPass(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final booking = _bookings[bookingId]!;

    return BoardingPass(
      passengerName: booking.passengerName,
      flightNumber: booking.flightNumber,
      airline: booking.airline,
      airlineLogo: booking.airlineLogo,
      departureCity: booking.departureCity,
      arrivalCity: booking.arrivalCity,
      departureCode: _getCityCode(booking.departureCity),
      arrivalCode: _getCityCode(booking.arrivalCity),
      flightDate: booking.flightDate,
      boardingTime: _calculateBoardingTime(booking.flightTime),
      departureTime: booking.flightTime,
      gate: 'A${_random.nextInt(20) + 1}',
      seat:
          '${_random.nextInt(30) + 1}${String.fromCharCode(65 + _random.nextInt(6))}',
      bookingReference: booking.confirmationNumber ?? 'XXXXXX',
      barcode: _generateBarcode(),
      terminal: 'A${_random.nextInt(20) + 1}',
      bagTagNumbers: _generateBagTags(booking.numberOfBags),
    );
  }

  @override
  Stream<HomeCheckInBooking> trackBooking(String bookingId) async* {
    // Simulate real-time tracking with status updates every 5 seconds
    final statuses = [
      BookingStatus.confirmed,
      BookingStatus.driverAssigned,
      BookingStatus.driverEnRoute,
      BookingStatus.bagsCollected,
      BookingStatus.atAirport,
      BookingStatus.checkedIn,
      BookingStatus.completed,
    ];

    for (int i = 0; i < statuses.length; i++) {
      await Future.delayed(const Duration(seconds: 5));

      final booking = _bookings[bookingId]!;
      String? driverName;
      String? driverPhone;
      String? vehicleNumber;
      String? estimatedArrival;

      // Add driver info when driver is assigned
      if (i >= 1) {
        driverName = 'Ahmed Al Mansouri';
        driverPhone = '+971 50 XXX XXXX';
        vehicleNumber = 'ABC 1234';
      }

      // Add estimated arrival
      if (i >= 2 && i < 5) {
        estimatedArrival = '${(statuses.length - i) * 5} minutes';
      }

      final updatedBooking = HomeCheckInBooking(
        id: booking.id,
        flightNumber: booking.flightNumber,
        airline: booking.airline,
        airlineLogo: booking.airlineLogo,
        departureCity: booking.departureCity,
        arrivalCity: booking.arrivalCity,
        flightDate: booking.flightDate,
        flightTime: booking.flightTime,
        passengerName: booking.passengerName,
        passportNumber: booking.passportNumber,
        nationality: booking.nationality,
        pickupLocation: booking.pickupLocation,
        detailedAddress: booking.detailedAddress,
        pickupDate: booking.pickupDate,
        pickupTime: booking.pickupTime,
        numberOfBags: booking.numberOfBags,
        totalWeight: booking.totalWeight,
        bags: booking.bags,
        status: statuses[i],
        driverName: driverName,
        driverPhone: driverPhone,
        vehicleNumber: vehicleNumber,
        estimatedArrival: estimatedArrival,
        confirmationNumber: booking.confirmationNumber,
        createdAt: booking.createdAt,
      );

      _bookings[bookingId] = updatedBooking;
      yield updatedBooking;
    }
  }

  // Helper methods
  String _getCityCode(String cityName) {
    final codes = {
      'Dubai': 'DXB',
      'Abu Dhabi': 'AUH',
      'London': 'LHR',
      'Paris': 'CDG',
      'New York': 'JFK',
      'Tokyo': 'NRT',
      'Singapore': 'SIN',
      'Bangkok': 'BKK',
    };
    return codes[cityName] ?? 'XXX';
  }

  String _calculateBoardingTime(String flightTime) {
    // Boarding is typically 45 minutes before departure
    final parts = flightTime.split(':');
    if (parts.length != 2) return flightTime;

    int hours = int.tryParse(parts[0]) ?? 0;
    int minutes = int.tryParse(parts[1]) ?? 0;

    minutes -= 45;
    if (minutes < 0) {
      hours -= 1;
      minutes += 60;
    }

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String _generateBarcode() {
    return List.generate(12, (_) => _random.nextInt(10)).join();
  }

  String _generateBagTags(int numberOfBags) {
    return List.generate(
      numberOfBags,
      (i) => 'DXB${_random.nextInt(900000) + 100000}',
    ).join(', ');
  }

  // Demo Data
  static final List<Airline> _demoAirlines = [
    const Airline(
      code: 'EK',
      name: 'Emirates',
      logo:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Emirates_banner_logo.svg/250px-Emirates_banner_logo.svg.png?20250606171855",
      policy: 'Emirates Premium Baggage Policy',
      baggageAllowance: const BaggageAllowance(
        maxCheckedBags: 2,
        maxWeightPerBag: 30,
        maxCarryOn: 1,
        maxCarryOnWeight: 7,
        dimensions: '158 cm (62 in) total',
      ),
      prohibitedItems: const [
        'Liquids over 100ml',
        'Sharp objects (scissors, knives)',
        'Flammable items',
        'Compressed gases',
        'Lithium batteries over 100Wh',
        'Power banks over 20,000mAh',
        'E-cigarettes in checked luggage',
        'Explosives and fireworks',
        'Toxic substances',
        'Radioactive materials',
        'Corrosives',
        'Oxidizing substances',
        'Firearms and ammunition',
        'Pepper spray',
        'Paint and solvents',
        'Matches and lighters (except 1 lighter)',
        'Self-defense sprays',
        'Sporting equipment with sharp edges',
        'Tools over 7 inches',
        'Camping stoves',
        'Electronic cigarettes',
        'Hoverboards',
        'Smart luggage with non-removable batteries',
      ],
      specialInstructions: const [
        'Check-in opens 24 hours before departure',
        'Baggage must be checked in at least 60 minutes before departure',
        'Each checked bag must have a tag with your name and address',
        'Keep valuable items, medications, and documents in carry-on',
        'Liquids in carry-on must be in containers of 100ml or less',
        'All liquids must fit in a clear 1-liter plastic bag',
        'Remove electronics larger than phones for security screening',
        'Lock your checked bags with TSA-approved locks',
      ],
    ),
    const Airline(
      code: 'EY',
      name: 'Etihad',
      logo:
          "https://www.etihad.com/content/dam/eag/etihadairways/etihadcom/2025/news/2025/EY-Logo.jpg",
      policy: 'Etihad Airways Baggage Policy',
      baggageAllowance: const BaggageAllowance(
        maxCheckedBags: 2,
        maxWeightPerBag: 32,
        maxCarryOn: 1,
        maxCarryOnWeight: 7,
        dimensions: '158 cm total',
      ),
      prohibitedItems: const [
        'Liquids over 100ml',
        'Sharp objects',
        'Flammable materials',
        'Explosives',
        'Gases',
        'Oxidizers',
        'Toxic substances',
        'Infectious substances',
        'Radioactive materials',
        'Corrosives',
        'Firearms',
        'Ammunition',
        'Power banks over 100Wh',
        'E-cigarettes in checked bags',
        'Hoverboards',
      ],
      specialInstructions: const [
        'Online check-in opens 24 hours before flight',
        'Arrive at airport 3 hours before international flights',
        'Tag all bags with contact information',
        'Keep valuables in carry-on luggage',
        'Follow 3-1-1 rule for liquids',
        'Special assistance available upon request',
      ],
    ),
    const Airline(
      code: 'QR',
      name: 'Qatar Airways',
      logo:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRF52J9jm76_LHAGq2pq3-ksYT4C2prih85Rw&s",
      policy: 'Qatar Airways Baggage Guidelines',
      baggageAllowance: const BaggageAllowance(
        maxCheckedBags: 2,
        maxWeightPerBag: 30,
        maxCarryOn: 1,
        maxCarryOnWeight: 7,
        dimensions: '158 cm total',
      ),
      prohibitedItems: const [
        'Excess liquids',
        'Sharp items',
        'Flammables',
        'Explosives',
        'Compressed gases',
        'Toxic materials',
        'Radioactive items',
        'Corrosive substances',
        'Weapons',
        'Sporting equipment with sharp points',
        'Power tools',
        'Large batteries',
      ],
      specialInstructions: const [
        'Web check-in available 48 hours prior',
        'Baggage drop closes 60 minutes before departure',
        'Premium passengers receive extra allowance',
        'Sports equipment may require special handling',
        'Medical equipment allowed with documentation',
      ],
    ),
    const Airline(
      code: 'FZ',
      name: 'FlyDubai',
      logo:
          "https://cdn.uc.assets.prezly.com/27f31c96-ae55-47ef-824f-c497bbb4696d/-/quality/best/-/format/auto/",
      policy: 'FlyDubai Budget Travel Policy',
      baggageAllowance: const BaggageAllowance(
        maxCheckedBags: 1,
        maxWeightPerBag: 20,
        maxCarryOn: 1,
        maxCarryOnWeight: 7,
        dimensions: '55x38x20 cm',
      ),
      prohibitedItems: const [
        'Liquids over 100ml',
        'Sharp objects',
        'Flammable items',
        'Gases',
        'Explosives',
        'Weapons',
        'Power banks over 160Wh',
        'E-cigarettes',
        'Smart bags with non-removable batteries',
      ],
      specialInstructions: const [
        'Check-in opens 24 hours before',
        'Be at gate 30 minutes before boarding',
        'Additional bags can be purchased',
        'Sports equipment subject to fees',
        'Infants get 10kg baggage allowance',
      ],
    ),
    const Airline(
      code: 'G9',
      name: 'Air Arabia',
      logo:
          "https://upload.wikimedia.org/wikipedia/commons/1/1f/AirArabia_logo_English_%281%29.jpg",
      policy: 'Air Arabia Low-Cost Carrier Policy',
      baggageAllowance: const BaggageAllowance(
        maxCheckedBags: 1,
        maxWeightPerBag: 20,
        maxCarryOn: 1,
        maxCarryOnWeight: 10,
        dimensions: '55x40x23 cm',
      ),
      prohibitedItems: const [
        'Excess liquids',
        'Sharp items',
        'Flammables',
        'Compressed gases',
        'Explosives',
        'Weapons',
        'Large electronics',
        'Hoverboards',
      ],
      specialInstructions: const [
        'Online check-in saves time',
        'Arrive 2 hours early for domestic',
        'Arrive 3 hours early for international',
        'Extra baggage can be pre-purchased online',
        'Cabin bags must fit overhead bins',
      ],
    ),
  ];

  static final List<PickupLocation> _demoLocations = [
    const PickupLocation(
      id: '1',
      name: 'Dubai Marina',
      address: 'Dubai Marina Walk',
      city: 'Dubai',
      latitude: 25.0803,
      longitude: 55.1415,
      landmarks: const ['Marina Mall', 'JBR Beach', 'Marina Promenade'],
    ),
    const PickupLocation(
      id: '2',
      name: 'Downtown Dubai',
      address: 'Burj Khalifa Boulevard',
      city: 'Dubai',
      latitude: 25.1972,
      longitude: 55.2744,
      landmarks: const ['Burj Khalifa', 'Dubai Mall', 'Dubai Fountain'],
    ),
    const PickupLocation(
      id: '3',
      name: 'Jumeirah Beach Residence',
      address: 'The Walk, JBR',
      city: 'Dubai',
      latitude: 25.0782,
      longitude: 55.1383,
      landmarks: const ['The Beach', 'JBR Walk', 'Ain Dubai'],
    ),
    const PickupLocation(
      id: '4',
      name: 'Deira',
      address: 'Gold Souk Area',
      city: 'Dubai',
      latitude: 25.2697,
      longitude: 55.3094,
      landmarks: const ['Gold Souk', 'Spice Souk', 'Deira City Centre'],
    ),
    const PickupLocation(
      id: '5',
      name: 'Business Bay',
      address: 'Business Bay Towers',
      city: 'Dubai',
      latitude: 25.1877,
      longitude: 55.2631,
      landmarks: const ['Marasi Drive', 'Canal Walk', 'Business Bay Metro'],
    ),
    const PickupLocation(
      id: '6',
      name: 'Al Barsha',
      address: 'Mall of the Emirates Area',
      city: 'Dubai',
      latitude: 25.1179,
      longitude: 55.2005,
      landmarks: const ['Mall of Emirates', 'Ski Dubai', 'Al Barsha Mall'],
    ),
    const PickupLocation(
      id: '7',
      name: 'Dubai Silicon Oasis',
      address: 'DSO Community',
      city: 'Dubai',
      latitude: 25.1245,
      longitude: 55.3799,
      landmarks: const ['DSO Headquarters', 'Cedars Park', 'DSO Mall'],
    ),
    const PickupLocation(
      id: '8',
      name: 'International City',
      address: 'Dragon Mart Area',
      city: 'Dubai',
      latitude: 25.1698,
      longitude: 55.4125,
      landmarks: const ['Dragon Mart', 'China Cluster', 'Warsan Village'],
    ),
    const PickupLocation(
      id: '9',
      name: 'Dubai Sports City',
      address: 'Sports City',
      city: 'Dubai',
      latitude: 25.0431,
      longitude: 55.2164,
      landmarks: const ['ICC Cricket Stadium', 'Els Club', 'Victory Heights'],
    ),
    const PickupLocation(
      id: '10',
      name: 'Discovery Gardens',
      address: 'Discovery Gardens Community',
      city: 'Dubai',
      latitude: 25.0428,
      longitude: 55.1341,
      landmarks: const ['Ibn Battuta Mall', 'Gardens Centre', 'Metro Station'],
    ),
  ];

  static final List<String> _demoTimeSlots = [
    '06:00 - 08:00',
    '08:00 - 10:00',
    '10:00 - 12:00',
    '12:00 - 14:00',
    '14:00 - 16:00',
    '16:00 - 18:00',
    '18:00 - 20:00',
    '20:00 - 22:00',
  ];
}
