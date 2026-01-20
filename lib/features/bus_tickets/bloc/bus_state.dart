import 'package:flutter/foundation.dart';

@immutable
abstract class BusState {
  const BusState();
}

class BusInitial extends BusState {
  const BusInitial();
}

class BusLoading extends BusState {
  const BusLoading();
}

class BusError extends BusState {
  final String message;
  const BusError(this.message);
}

class BusHomeLoaded extends BusState {
  final BusQuery query;
  final List<BusCompany> companies;
  final BusCompany? selectedCompany; // optional (for schedule viewing)
  final List<BusTrip> featuredTrips; // sample routes between destinations

  const BusHomeLoaded({
    required this.query,
    required this.companies,
    required this.selectedCompany,
    required this.featuredTrips,
  });

  BusHomeLoaded copyWith({
    BusQuery? query,
    List<BusCompany>? companies,
    BusCompany? selectedCompany,
    List<BusTrip>? featuredTrips,
  }) {
    return BusHomeLoaded(
      query: query ?? this.query,
      companies: companies ?? this.companies,
      selectedCompany: selectedCompany ?? this.selectedCompany,
      featuredTrips: featuredTrips ?? this.featuredTrips,
    );
  }
}

class BusResultsLoaded extends BusState {
  final BusQuery query;
  final List<BusCompany> companies;
  final List<BusTrip> trips;

  const BusResultsLoaded({
    required this.query,
    required this.companies,
    required this.trips,
  });
}

class BusCompanyScheduleLoaded extends BusState {
  final BusQuery query;
  final BusCompany company;
  final BusMonthSchedule schedule;
  final List<BusTrip> trips;

  const BusCompanyScheduleLoaded({
    required this.query,
    required this.company,
    required this.schedule,
    required this.trips,
  });
}

class BusTripDetailsLoaded extends BusState {
  final BusQuery query;
  final List<BusCompany> companies;
  final BusTrip trip;

  const BusTripDetailsLoaded({
    required this.query,
    required this.companies,
    required this.trip,
  });
}

class BusSeatSelectionLoaded extends BusState {
  final BusQuery query;
  final List<BusCompany> companies;
  final BusTrip trip;

  final List<BusSeat> seats;
  final List<String> selectedSeats; // seat codes

  const BusSeatSelectionLoaded({
    required this.query,
    required this.companies,
    required this.trip,
    required this.seats,
    required this.selectedSeats,
  });

  BusSeatSelectionLoaded copyWith({
    List<BusSeat>? seats,
    List<String>? selectedSeats,
  }) {
    return BusSeatSelectionLoaded(
      query: query,
      companies: companies,
      trip: trip,
      seats: seats ?? this.seats,
      selectedSeats: selectedSeats ?? this.selectedSeats,
    );
  }
}

class BusPassengersLoaded extends BusState {
  final BusQuery query;
  final List<BusCompany> companies;
  final BusTrip trip;
  final List<String> selectedSeats;

  final List<BusPassenger> passengers;

  const BusPassengersLoaded({
    required this.query,
    required this.companies,
    required this.trip,
    required this.selectedSeats,
    required this.passengers,
  });

  BusPassengersLoaded copyWith({
    List<BusPassenger>? passengers,
  }) {
    return BusPassengersLoaded(
      query: query,
      companies: companies,
      trip: trip,
      selectedSeats: selectedSeats,
      passengers: passengers ?? this.passengers,
    );
  }
}

class BusPaymentLoaded extends BusState {
  final BusQuery query;
  final List<BusCompany> companies;
  final BusTrip trip;
  final List<String> selectedSeats;
  final List<BusPassenger> passengers;

  final BusPaymentMethod method;
  final String promoCode;
  final BusPriceBreakdown breakdown;

  const BusPaymentLoaded({
    required this.query,
    required this.companies,
    required this.trip,
    required this.selectedSeats,
    required this.passengers,
    required this.method,
    required this.promoCode,
    required this.breakdown,
  });

  BusPaymentLoaded copyWith({
    BusPaymentMethod? method,
    String? promoCode,
    BusPriceBreakdown? breakdown,
  }) {
    return BusPaymentLoaded(
      query: query,
      companies: companies,
      trip: trip,
      selectedSeats: selectedSeats,
      passengers: passengers,
      method: method ?? this.method,
      promoCode: promoCode ?? this.promoCode,
      breakdown: breakdown ?? this.breakdown,
    );
  }
}

class BusTicketLoaded extends BusState {
  final BusBooking booking;
  const BusTicketLoaded(this.booking);
}

/// ---------------------- Models ----------------------

class BusQuery {
  final String from;
  final String to;
  final DateTime date;
  final int passengers;
  final bool isInternational;

  const BusQuery({
    required this.from,
    required this.to,
    required this.date,
    required this.passengers,
    required this.isInternational,
  });

  BusQuery copyWith({
    String? from,
    String? to,
    DateTime? date,
    int? passengers,
    bool? isInternational,
  }) {
    return BusQuery(
      from: from ?? this.from,
      to: to ?? this.to,
      date: date ?? this.date,
      passengers: passengers ?? this.passengers,
      isInternational: isInternational ?? this.isInternational,
    );
  }
}

class BusCompany {
  final String id;
  final String name;
  final String logoUrl; // network
  final double rating;
  final int reviews;
  final List<String> highlights; // e.g. Free rebooking, VIP lounge
  final List<String> coverage; // cities/countries
  final String support; // e.g. 24/7 WhatsApp
  final bool hasWiFi;
  final bool hasVIP;
  final bool isFavorite;

  const BusCompany({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.rating,
    required this.reviews,
    required this.highlights,
    required this.coverage,
    required this.support,
    required this.hasWiFi,
    required this.hasVIP,
    required this.isFavorite,
  });

  BusCompany copyWith({bool? isFavorite}) {
    return BusCompany(
      id: id,
      name: name,
      logoUrl: logoUrl,
      rating: rating,
      reviews: reviews,
      highlights: highlights,
      coverage: coverage,
      support: support,
      hasWiFi: hasWiFi,
      hasVIP: hasVIP,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

enum BusClass { economy, business, vip }

class BusTrip {
  final String id;
  final String companyId;
  final String companyName;

  final String from;
  final String to;
  final DateTime departAt;
  final DateTime arriveAt;

  final BusClass busClass;
  final String busType; // Coach / Sleeper / MiniBus
  final String plateOrCode; // internal code
  final double rating;
  final int reviews;

  final int totalSeats;
  final int seatsLeft;

  final double pricePerPassenger;
  final double? oldPrice;

  final String baggagePolicy; // e.g. "2 bags (20kg)"
  final String cancellationPolicy; // short policy
  final List<String> amenities; // WiFi, AC, Charging, WC, Snacks
  final List<String> stops; // cities/points
  final bool borderCrossing; // for international

  const BusTrip({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.from,
    required this.to,
    required this.departAt,
    required this.arriveAt,
    required this.busClass,
    required this.busType,
    required this.plateOrCode,
    required this.rating,
    required this.reviews,
    required this.totalSeats,
    required this.seatsLeft,
    required this.pricePerPassenger,
    required this.oldPrice,
    required this.baggagePolicy,
    required this.cancellationPolicy,
    required this.amenities,
    required this.stops,
    required this.borderCrossing,
  });

  Duration get duration => arriveAt.difference(departAt);

  String get classLabel {
    switch (busClass) {
      case BusClass.economy:
        return 'Economy';
      case BusClass.business:
        return 'Business';
      case BusClass.vip:
        return 'VIP';
    }
  }
}

class BusMonthSchedule {
  final int year;
  final int month; // 1-12
  final List<BusScheduleDay> days;

  const BusMonthSchedule({
    required this.year,
    required this.month,
    required this.days,
  });
}

class BusScheduleDay {
  final DateTime date;
  final int tripsCount;
  final List<String> sampleDepartures; // e.g. ["07:00","13:30","23:00"]
  const BusScheduleDay({
    required this.date,
    required this.tripsCount,
    required this.sampleDepartures,
  });
}

enum SeatStatus { available, selected, booked, blocked }

class BusSeat {
  final String code; // A1, A2...
  final int row;
  final int col;
  final bool isAisle;
  final SeatStatus status;

  const BusSeat({
    required this.code,
    required this.row,
    required this.col,
    required this.isAisle,
    required this.status,
  });

  BusSeat copyWith({SeatStatus? status}) {
    return BusSeat(
      code: code,
      row: row,
      col: col,
      isAisle: isAisle,
      status: status ?? this.status,
    );
  }
}

class BusPassenger {
  String firstName;
  String lastName;
  String gender;
  String nationality;
  String idNumber;
  String phone;
  String email;

  BusPassenger({
    this.firstName = '',
    this.lastName = '',
    this.gender = '',
    this.nationality = '',
    this.idNumber = '',
    this.phone = '',
    this.email = '',
  });
}

enum BusPaymentMethod { card, wallet, payAtStation }

class BusPriceBreakdown {
  final double baseFare;
  final double taxes;
  final double serviceFee;
  final double discount;
  final double total;

  const BusPriceBreakdown({
    required this.baseFare,
    required this.taxes,
    required this.serviceFee,
    required this.discount,
    required this.total,
  });
}

class BusBooking {
  final String bookingRef;
  final DateTime createdAt;

  final BusTrip trip;
  final List<String> seats;
  final List<BusPassenger> passengers;

  final BusPaymentMethod paymentMethod;
  final BusPriceBreakdown breakdown;

  const BusBooking({
    required this.bookingRef,
    required this.createdAt,
    required this.trip,
    required this.seats,
    required this.passengers,
    required this.paymentMethod,
    required this.breakdown,
  });
}
