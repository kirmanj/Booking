import 'package:aman_booking/features/esim/data/models/e_sim_models.dart';
import 'package:equatable/equatable.dart';
import 'e_sim_event.dart';

abstract class ESimState extends Equatable {
  const ESimState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ESimInitial extends ESimState {
  const ESimInitial();
}

// Loading state
class ESimLoading extends ESimState {
  final String? message;

  const ESimLoading({this.message});

  @override
  List<Object?> get props => [message];
}

// Countries loaded state
class CountriesLoaded extends ESimState {
  final List<ESimCountry> allCountries;
  final List<ESimCountry> displayedCountries;
  final List<ESimCountry> popularDestinations;
  final String? selectedRegion;
  final String? searchQuery;

  const CountriesLoaded({
    required this.allCountries,
    required this.displayedCountries,
    this.popularDestinations = const [],
    this.selectedRegion,
    this.searchQuery,
  });

  CountriesLoaded copyWith({
    List<ESimCountry>? allCountries,
    List<ESimCountry>? displayedCountries,
    List<ESimCountry>? popularDestinations,
    String? selectedRegion,
    String? searchQuery,
  }) {
    return CountriesLoaded(
      allCountries: allCountries ?? this.allCountries,
      displayedCountries: displayedCountries ?? this.displayedCountries,
      popularDestinations: popularDestinations ?? this.popularDestinations,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        allCountries,
        displayedCountries,
        popularDestinations,
        selectedRegion,
        searchQuery,
      ];
}

// Country selected, show packages
class PackagesLoaded extends ESimState {
  final ESimCountry selectedCountry;
  final List<ESimPackage> allPackages;
  final List<ESimPackage> displayedPackages;
  final PackageSortOption sortBy;
  final PackageFilter? filter;

  const PackagesLoaded({
    required this.selectedCountry,
    required this.allPackages,
    required this.displayedPackages,
    this.sortBy = PackageSortOption.popular,
    this.filter,
  });

  PackagesLoaded copyWith({
    ESimCountry? selectedCountry,
    List<ESimPackage>? allPackages,
    List<ESimPackage>? displayedPackages,
    PackageSortOption? sortBy,
    PackageFilter? filter,
  }) {
    return PackagesLoaded(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      allPackages: allPackages ?? this.allPackages,
      displayedPackages: displayedPackages ?? this.displayedPackages,
      sortBy: sortBy ?? this.sortBy,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [
        selectedCountry,
        allPackages,
        displayedPackages,
        sortBy,
        filter,
      ];
}

// Package details state
class PackageDetailsLoaded extends ESimState {
  final ESimPackage package;
  final ESimCountry country;
  final List<ESimPackage> relatedPackages;

  const PackageDetailsLoaded({
    required this.package,
    required this.country,
    this.relatedPackages = const [],
  });

  @override
  List<Object?> get props => [package, country, relatedPackages];
}

// Cart state
class CartUpdated extends ESimState {
  final List<ESimCartItem> items;
  final double subtotal;
  final double discount;
  final double total;
  final String? promoCode;

  const CartUpdated({
    required this.items,
    required this.subtotal,
    this.discount = 0,
    required this.total,
    this.promoCode,
  });

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartUpdated copyWith({
    List<ESimCartItem>? items,
    double? subtotal,
    double? discount,
    double? total,
    String? promoCode,
  }) {
    return CartUpdated(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      promoCode: promoCode ?? this.promoCode,
    );
  }

  @override
  List<Object?> get props => [items, subtotal, discount, total, promoCode];
}

// Purchase processing state
class PurchaseProcessing extends ESimState {
  final List<ESimCartItem> items;
  final double total;

  const PurchaseProcessing({
    required this.items,
    required this.total,
  });

  @override
  List<Object?> get props => [items, total];
}

// Purchase success state
class PurchaseSuccess extends ESimState {
  final List<ESimOrder> orders;
  final double totalPaid;
  final String transactionId;

  const PurchaseSuccess({
    required this.orders,
    required this.totalPaid,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [orders, totalPaid, transactionId];
}

// My E-SIMs loaded
class MyEsimsLoaded extends ESimState {
  final List<ESimOrder> activeEsims;
  final List<ESimOrder> expiredEsims;
  final List<ESimOrder> allOrders;

  const MyEsimsLoaded({
    required this.activeEsims,
    required this.expiredEsims,
    required this.allOrders,
  });

  @override
  List<Object?> get props => [activeEsims, expiredEsims, allOrders];
}

// E-SIM details/QR code state
class ESimDetailsLoaded extends ESimState {
  final ESimOrder order;
  final List<InstallationStep> installationSteps;

  const ESimDetailsLoaded({
    required this.order,
    required this.installationSteps,
  });

  @override
  List<Object?> get props => [order, installationSteps];
}

// Installation instructions loaded
class InstallationInstructionsLoaded extends ESimState {
  final String platform;
  final List<InstallationStep> steps;
  final List<String> requirements;
  final List<String> troubleshooting;

  const InstallationInstructionsLoaded({
    required this.platform,
    required this.steps,
    this.requirements = const [],
    this.troubleshooting = const [],
  });

  @override
  List<Object?> get props => [platform, steps, requirements, troubleshooting];
}

// Device compatibility checked
class DeviceCompatibilityChecked extends ESimState {
  final bool isCompatible;
  final String deviceModel;
  final String? message;
  final List<String>? alternativeModels;

  const DeviceCompatibilityChecked({
    required this.isCompatible,
    required this.deviceModel,
    this.message,
    this.alternativeModels,
  });

  @override
  List<Object?> get props => [
        isCompatible,
        deviceModel,
        message,
        alternativeModels,
      ];
}

// Promo code state
class PromoCodeApplied extends ESimState {
  final String code;
  final double discountPercentage;
  final double discountAmount;
  final String message;

  const PromoCodeApplied({
    required this.code,
    required this.discountPercentage,
    required this.discountAmount,
    required this.message,
  });

  @override
  List<Object?> get props => [
        code,
        discountPercentage,
        discountAmount,
        message,
      ];
}

// Error state
class ESimError extends ESimState {
  final String message;
  final String? details;
  final bool canRetry;

  const ESimError({
    required this.message,
    this.details,
    this.canRetry = true,
  });

  @override
  List<Object?> get props => [message, details, canRetry];
}

// Success message state
class ESimSuccess extends ESimState {
  final String message;
  final dynamic data;

  const ESimSuccess({
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [message, data];
}
