import 'package:flutter/foundation.dart';

@immutable
abstract class CarRentalState {
  const CarRentalState();
}

class CarRentalInitial extends CarRentalState {
  const CarRentalInitial();
}

class CarRentalLoading extends CarRentalState {
  const CarRentalLoading();
}

class CarRentalError extends CarRentalState {
  final String message;
  const CarRentalError(this.message);
}

class CarRentalLoaded extends CarRentalState {
  final String location;
  final DateTime pickupDate;
  final DateTime dropoffDate;

  final List<CarRentalCompany> companies;
  final List<CarModel> luxuryCars;
  final List<CarModel> lowPriceCars;
  final List<CarModel> familyCars;

  const CarRentalLoaded({
    required this.location,
    required this.pickupDate,
    required this.dropoffDate,
    required this.companies,
    required this.luxuryCars,
    required this.lowPriceCars,
    required this.familyCars,
  });

  CarRentalLoaded copyWith({
    String? location,
    DateTime? pickupDate,
    DateTime? dropoffDate,
    List<CarRentalCompany>? companies,
    List<CarModel>? luxuryCars,
    List<CarModel>? lowPriceCars,
    List<CarModel>? familyCars,
  }) {
    return CarRentalLoaded(
      location: location ?? this.location,
      pickupDate: pickupDate ?? this.pickupDate,
      dropoffDate: dropoffDate ?? this.dropoffDate,
      companies: companies ?? this.companies,
      luxuryCars: luxuryCars ?? this.luxuryCars,
      lowPriceCars: lowPriceCars ?? this.lowPriceCars,
      familyCars: familyCars ?? this.familyCars,
    );
  }
}

// NEW: Company profile state
class CompanyProfileLoaded extends CarRentalState {
  final CarRentalCompany company;
  final List<CarModel> companyCars;
  final List<String> locations;
  final List<String> services;

  const CompanyProfileLoaded({
    required this.company,
    required this.companyCars,
    required this.locations,
    required this.services,
  });
}

// NEW: Car booking state
class CarBookingInProgress extends CarRentalState {
  final CarModel car;
  final DateTime pickupDate;
  final DateTime dropoffDate;
  final String location;
  final bool withDriver;
  final DriverDetails? driverDetails;
  final List<ExtraOption> selectedExtras;
  final double totalPrice;

  const CarBookingInProgress({
    required this.car,
    required this.pickupDate,
    required this.dropoffDate,
    required this.location,
    this.withDriver = false,
    this.driverDetails,
    this.selectedExtras = const [],
    required this.totalPrice,
  });

  int get totalDays {
    return dropoffDate.difference(pickupDate).inDays;
  }

  double get carCost => car.pricePerDay * totalDays;

  double get driverCost => withDriver ? (35.0 * totalDays) : 0.0;

  double get extrasCost {
    return selectedExtras.fold(
      0.0,
      (sum, extra) => sum + (extra.pricePerDay * totalDays),
    );
  }

  CarBookingInProgress copyWith({
    CarModel? car,
    DateTime? pickupDate,
    DateTime? dropoffDate,
    String? location,
    bool? withDriver,
    DriverDetails? driverDetails,
    List<ExtraOption>? selectedExtras,
    double? totalPrice,
  }) {
    return CarBookingInProgress(
      car: car ?? this.car,
      pickupDate: pickupDate ?? this.pickupDate,
      dropoffDate: dropoffDate ?? this.dropoffDate,
      location: location ?? this.location,
      withDriver: withDriver ?? this.withDriver,
      driverDetails: driverDetails ?? this.driverDetails,
      selectedExtras: selectedExtras ?? this.selectedExtras,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

// NEW: Booking confirmed state
class BookingConfirmed extends CarRentalState {
  final String bookingId;
  final CarModel car;
  final DateTime pickupDate;
  final DateTime dropoffDate;
  final String location;
  final bool withDriver;
  final double totalPaid;
  final DateTime confirmedAt;

  const BookingConfirmed({
    required this.bookingId,
    required this.car,
    required this.pickupDate,
    required this.dropoffDate,
    required this.location,
    required this.withDriver,
    required this.totalPaid,
    required this.confirmedAt,
  });
}

/// ---------------- Models (updated) ----------------

class CarRentalCompany {
  final String id;
  final String name;
  final String logoUrl; // network logo
  final double rating;
  final int reviews;
  final double fromPricePerDay;
  final bool isFavorite;

  final List<String> highlights; // e.g. Free cancellation, 24/7 support
  final String coverage; // e.g. "Erbil • Dubai • Istanbul"

  // NEW: Additional company details
  final String description;
  final String phone;
  final String email;
  final int establishedYear;
  final int totalCars;

  const CarRentalCompany({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.rating,
    required this.reviews,
    required this.fromPricePerDay,
    required this.isFavorite,
    required this.highlights,
    required this.coverage,
    this.description = '',
    this.phone = '+964 750 123 4567',
    this.email = 'info@company.com',
    this.establishedYear = 2010,
    this.totalCars = 50,
  });

  CarRentalCompany copyWith({bool? isFavorite}) {
    return CarRentalCompany(
      id: id,
      name: name,
      logoUrl: logoUrl,
      rating: rating,
      reviews: reviews,
      fromPricePerDay: fromPricePerDay,
      isFavorite: isFavorite ?? this.isFavorite,
      highlights: highlights,
      coverage: coverage,
      description: description,
      phone: phone,
      email: email,
      establishedYear: establishedYear,
      totalCars: totalCars,
    );
  }
}

enum CarCategory { luxury, budget, family }

class CarModel {
  final String id;
  final String companyId;
  final CarCategory category;

  final String name;
  final String brand;
  final String imageUrl; // network image
  final List<String> galleryImages; // NEW: Multiple images

  final int seats;
  final int bags;
  final String transmission; // Auto/Manual
  final String fuel; // Petrol/Hybrid/Electric
  final bool ac;

  final double rating;
  final int reviews;

  final double pricePerDay;
  final double? oldPricePerDay;
  final String mileagePolicy; // e.g. "Unlimited" / "250 km/day"
  final double deposit; // refundable
  final bool freeCancellation;
  final bool insuranceIncluded;

  final List<String> included; // e.g. Airport pickup, Free additional driver...
  final String terms; // short terms preview
  final bool isFavorite;

  // NEW: Additional car details
  final String year;
  final String color;
  final List<String> features; // Bluetooth, USB, Sunroof, etc.

  const CarModel({
    required this.id,
    required this.companyId,
    required this.category,
    required this.name,
    required this.brand,
    required this.imageUrl,
    this.galleryImages = const [],
    required this.seats,
    required this.bags,
    required this.transmission,
    required this.fuel,
    required this.ac,
    required this.rating,
    required this.reviews,
    required this.pricePerDay,
    required this.oldPricePerDay,
    required this.mileagePolicy,
    required this.deposit,
    required this.freeCancellation,
    required this.insuranceIncluded,
    required this.included,
    required this.terms,
    required this.isFavorite,
    this.year = '2024',
    this.color = 'Black',
    this.features = const [],
  });

  CarModel copyWith({bool? isFavorite}) {
    return CarModel(
      id: id,
      companyId: companyId,
      category: category,
      name: name,
      brand: brand,
      imageUrl: imageUrl,
      galleryImages: galleryImages,
      seats: seats,
      bags: bags,
      transmission: transmission,
      fuel: fuel,
      ac: ac,
      rating: rating,
      reviews: reviews,
      pricePerDay: pricePerDay,
      oldPricePerDay: oldPricePerDay,
      mileagePolicy: mileagePolicy,
      deposit: deposit,
      freeCancellation: freeCancellation,
      insuranceIncluded: insuranceIncluded,
      included: included,
      terms: terms,
      isFavorite: isFavorite ?? this.isFavorite,
      year: year,
      color: color,
      features: features,
    );
  }
}

// NEW: Driver details model
class DriverDetails {
  final String name;
  final String? email;
  final String? phone;
  final String? licenseNumber;

  const DriverDetails({
    required this.name,
    this.email,
    this.phone,
    this.licenseNumber,
  });
}

// NEW: Extra options model (child seat, GPS, etc.)
class ExtraOption {
  final String id;
  final String name;
  final String description;
  final double pricePerDay;
  final String icon;

  const ExtraOption({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerDay,
    required this.icon,
  });
}
