// lib/features/tours/data/models/tour_model.dart

import 'package:equatable/equatable.dart';

class TourModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final double rating;
  final int reviews;
  final double price;
  final List<String> images;
  final List<String> inclusions;
  final List<String> exclusions;
  final String duration;
  final int maxCapacity;
  final int currentBookings;
  final bool isPrivate;
  final List<String> availableDates;
  final String operatorId;
  final String operatorName;
  final String operatorImage;
  final List<String> gallery;
  final List<Map<String, dynamic>> itinerary;
  final Map<String, double> pricingTiers; // For group rates, etc.

  const TourModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.images,
    required this.inclusions,
    required this.exclusions,
    required this.duration,
    required this.maxCapacity,
    required this.currentBookings,
    required this.isPrivate,
    required this.availableDates,
    required this.operatorId,
    required this.operatorName,
    required this.operatorImage,
    required this.gallery,
    required this.itinerary,
    required this.pricingTiers,
  });

  // Method to check if the tour is available on a specific date
  bool isAvailableOn(String date) {
    return availableDates.contains(date);
  }

  // Method to get the remaining slots
  int get remainingSlots => maxCapacity - currentBookings;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        rating,
        reviews,
        price,
        images,
        inclusions,
        exclusions,
        duration,
        maxCapacity,
        currentBookings,
        isPrivate,
        availableDates,
        operatorId,
        operatorName,
        operatorImage,
        gallery,
        itinerary,
        pricingTiers,
      ];
}
