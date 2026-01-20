import 'package:aman_booking/features/esim/data/models/e_sim_models.dart';
import 'package:equatable/equatable.dart';

abstract class ESimEvent extends Equatable {
  const ESimEvent();

  @override
  List<Object?> get props => [];
}

// Load all countries/regions
class LoadCountries extends ESimEvent {
  const LoadCountries();
}

// Search countries
class SearchCountries extends ESimEvent {
  final String query;

  const SearchCountries(this.query);

  @override
  List<Object?> get props => [query];
}

// Filter countries by region
class FilterCountriesByRegion extends ESimEvent {
  final String? region; // null for all regions

  const FilterCountriesByRegion(this.region);

  @override
  List<Object?> get props => [region];
}

// Select a country
class SelectCountry extends ESimEvent {
  final ESimCountry country;

  const SelectCountry(this.country);

  @override
  List<Object?> get props => [country];
}

// Load packages for selected country
class LoadPackagesForCountry extends ESimEvent {
  final String countryId;

  const LoadPackagesForCountry(this.countryId);

  @override
  List<Object?> get props => [countryId];
}

// Select a package
class SelectPackage extends ESimEvent {
  final ESimPackage package;

  const SelectPackage(this.package);

  @override
  List<Object?> get props => [package];
}

// Add package to cart
class AddToCart extends ESimEvent {
  final ESimPackage package;
  final int quantity;

  const AddToCart(this.package, {this.quantity = 1});

  @override
  List<Object?> get props => [package, quantity];
}

// Remove from cart
class RemoveFromCart extends ESimEvent {
  final String packageId;

  const RemoveFromCart(this.packageId);

  @override
  List<Object?> get props => [packageId];
}

// Update cart item quantity
class UpdateCartQuantity extends ESimEvent {
  final String packageId;
  final int quantity;

  const UpdateCartQuantity(this.packageId, this.quantity);

  @override
  List<Object?> get props => [packageId, quantity];
}

// Clear cart
class ClearCart extends ESimEvent {
  const ClearCart();
}

// Purchase/Checkout
class PurchaseEsim extends ESimEvent {
  final List<ESimCartItem> items;
  final PaymentMethod paymentMethod;
  final String? promoCode;

  const PurchaseEsim({
    required this.items,
    required this.paymentMethod,
    this.promoCode,
  });

  @override
  List<Object?> get props => [items, paymentMethod, promoCode];
}

// Load user's E-SIM orders
class LoadMyEsims extends ESimEvent {
  const LoadMyEsims();
}

// Activate E-SIM
class ActivateEsim extends ESimEvent {
  final String orderId;

  const ActivateEsim(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

// Load installation instructions
class LoadInstallationInstructions extends ESimEvent {
  final String platform; // 'ios' or 'android'

  const LoadInstallationInstructions(this.platform);

  @override
  List<Object?> get props => [platform];
}

// Check device compatibility
class CheckDeviceCompatibility extends ESimEvent {
  final String deviceModel;

  const CheckDeviceCompatibility(this.deviceModel);

  @override
  List<Object?> get props => [deviceModel];
}

// Apply promo code
class ApplyPromoCode extends ESimEvent {
  final String code;

  const ApplyPromoCode(this.code);

  @override
  List<Object?> get props => [code];
}

// Remove promo code
class RemovePromoCode extends ESimEvent {
  const RemovePromoCode();
}

// Sort packages
class SortPackages extends ESimEvent {
  final PackageSortOption sortBy;

  const SortPackages(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}

// Filter packages by criteria
class FilterPackages extends ESimEvent {
  final PackageFilter filter;

  const FilterPackages(this.filter);

  @override
  List<Object?> get props => [filter];
}

// Load popular destinations
class LoadPopularDestinations extends ESimEvent {
  const LoadPopularDestinations();
}

// Load recommended packages
class LoadRecommendedPackages extends ESimEvent {
  const LoadRecommendedPackages();
}

// Enums for sorting and filtering
enum PackageSortOption {
  priceAsc,
  priceDesc,
  dataAsc,
  dataDesc,
  validityAsc,
  validityDesc,
  popular,
}

class PackageFilter {
  final double? minPrice;
  final double? maxPrice;
  final int? minDataGB;
  final int? maxDataGB;
  final int? minDays;
  final int? maxDays;
  final bool? onlyUnlimited;
  final bool? includeCalls;
  final bool? includeSMS;

  const PackageFilter({
    this.minPrice,
    this.maxPrice,
    this.minDataGB,
    this.maxDataGB,
    this.minDays,
    this.maxDays,
    this.onlyUnlimited,
    this.includeCalls,
    this.includeSMS,
  });

  bool matches(ESimPackage package) {
    if (minPrice != null && package.finalPrice < minPrice!) return false;
    if (maxPrice != null && package.finalPrice > maxPrice!) return false;

    final dataGB = package.dataAmountMB / 1024;
    if (minDataGB != null && dataGB < minDataGB!) return false;
    if (maxDataGB != null && dataGB > maxDataGB!) return false;

    if (minDays != null && package.validityDays < minDays!) return false;
    if (maxDays != null && package.validityDays > maxDays!) return false;

    if (onlyUnlimited == true && !package.isUnlimited) return false;
    if (includeCalls == true && package.callsMinutes == null) return false;
    if (includeSMS == true && package.smsCount == null) return false;

    return true;
  }
}
