// lib/features/tours/domain/entities/tour.dart
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Tour extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final String city;
  final String country;
  final double rating;
  final int reviews;
  final double basePrice;
  final List<String> images;
  final List<String> gallery;
  final List<String> inclusions;
  final List<String> exclusions;
  final List<TourItinerary> itinerary;
  final TourCategory category;
  final TourDifficulty difficulty;
  final String duration;
  final int maxCapacity;
  final int minGroupSize;
  final int currentBookings;
  final bool isPrivateAvailable;
  final bool isGroupAvailable;
  final String operatorId;
  final String operatorName;
  final String operatorImage;
  final List<TourGuide> assignedGuides;
  final List<DateTime> availableDates;
  final Map<String, dynamic> pricingTiers; // groupSize -> price
  final Map<DateTime, int> availabilityCalendar; // date -> available slots
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFeatured;
  final double? privateTourPrice;
  final String? privateTourNotes;

  const Tour({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.city,
    required this.country,
    required this.rating,
    required this.reviews,
    required this.basePrice,
    required this.images,
    required this.gallery,
    required this.inclusions,
    required this.exclusions,
    required this.itinerary,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.maxCapacity,
    required this.minGroupSize,
    required this.currentBookings,
    required this.isPrivateAvailable,
    required this.isGroupAvailable,
    required this.operatorId,
    required this.operatorName,
    required this.operatorImage,
    required this.assignedGuides,
    required this.availableDates,
    required this.pricingTiers,
    required this.availabilityCalendar,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.isFeatured = false,
    this.privateTourPrice,
    this.privateTourNotes,
  });

  // Helper methods
  bool isAvailableOn(DateTime date) {
    return availableDates.any((availableDate) =>
        availableDate.year == date.year &&
        availableDate.month == date.month &&
        availableDate.day == date.day);
  }

  int getRemainingSlots(DateTime date) {
    return availabilityCalendar[date] ?? 0;
  }

  double getPriceForGroup(int groupSize) {
    if (pricingTiers.containsKey(groupSize.toString())) {
      return pricingTiers[groupSize.toString()].toDouble();
    }

    // Find the appropriate tier
    final sortedTiers = pricingTiers.keys.map(int.parse).toList()..sort();

    for (final tier in sortedTiers) {
      if (groupSize <= tier) {
        return pricingTiers[tier.toString()].toDouble();
      }
    }

    // If group is larger than all tiers, use the last tier price
    return pricingTiers[sortedTiers.last.toString()].toDouble();
  }

  bool hasAvailableSlot(DateTime date, int groupSize) {
    return getRemainingSlots(date) >= groupSize;
  }

  @override
  List<Object?> get props => [id];
}

class TourItinerary {
  final String day;
  final String title;
  final String description;
  final List<String> activities;
  final String? mealIncluded;
  final String? accommodation;

  TourItinerary({
    required this.day,
    required this.title,
    required this.description,
    required this.activities,
    this.mealIncluded,
    this.accommodation,
  });
}

class TourGuide {
  final String id;
  final String name;
  final String? image;
  final List<String> languages;
  final int experienceYears;
  final double rating;
  final int totalTours;
  final String? specialization;

  TourGuide({
    required this.id,
    required this.name,
    this.image,
    required this.languages,
    required this.experienceYears,
    required this.rating,
    required this.totalTours,
    this.specialization,
  });
}

enum TourCategory {
  adventure('Adventure'),
  cultural('Cultural'),
  wildlife('Wildlife'),
  beach('Beach'),
  mountain('Mountain'),
  city('City'),
  food('Food & Wine'),
  historical('Historical'),
  luxury('Luxury');

  final String label;
  const TourCategory(this.label);
}

enum TourDifficulty {
  easy('Easy'),
  moderate('Moderate'),
  challenging('Challenging'),
  expert('Expert');

  final String label;
  const TourDifficulty(this.label);
}
