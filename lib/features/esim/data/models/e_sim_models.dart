import 'package:equatable/equatable.dart';

// Country/Region Model
class ESimCountry extends Equatable {
  final String id;
  final String name;
  final String code; // ISO country code
  final String flagEmoji;
  final String region; // Europe, Asia, Americas, etc.
  final bool isRegional; // True for regional plans like "Europe" or "Global"
  final List<String> coverageCountries; // For regional plans
  final bool isPopular;

  const ESimCountry({
    required this.id,
    required this.name,
    required this.code,
    required this.flagEmoji,
    required this.region,
    this.isRegional = false,
    this.coverageCountries = const [],
    this.isPopular = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        flagEmoji,
        region,
        isRegional,
        coverageCountries,
        isPopular,
      ];
}

// Data Package/Plan Model
class ESimPackage extends Equatable {
  final String id;
  final String countryId;
  final String countryName;
  final String name;
  final String dataAmount; // e.g., "5GB", "10GB", "Unlimited"
  final int dataAmountMB; // For sorting/comparison
  final int validityDays;
  final double price;
  final String currency;
  final List<String> features;
  final String speed; // e.g., "4G LTE", "5G"
  final bool isUnlimited;
  final String? callsMinutes; // null if data only
  final String? smsCount; // null if data only
  final bool isPopular;
  final int discount; // Percentage discount if any

  const ESimPackage({
    required this.id,
    required this.countryId,
    required this.countryName,
    required this.name,
    required this.dataAmount,
    required this.dataAmountMB,
    required this.validityDays,
    required this.price,
    this.currency = 'USD',
    this.features = const [],
    this.speed = '4G LTE',
    this.isUnlimited = false,
    this.callsMinutes,
    this.smsCount,
    this.isPopular = false,
    this.discount = 0,
  });

  double get finalPrice => price * (1 - discount / 100);

  String get validityText {
    if (validityDays == 1) return '1 Day';
    if (validityDays < 30) return '$validityDays Days';
    if (validityDays == 30) return '1 Month';
    final months = (validityDays / 30).floor();
    return '$months Months';
  }

  String get pricePerDay => '\$${(finalPrice / validityDays).toStringAsFixed(2)}/day';

  @override
  List<Object?> get props => [
        id,
        countryId,
        countryName,
        name,
        dataAmount,
        dataAmountMB,
        validityDays,
        price,
        currency,
        features,
        speed,
        isUnlimited,
        callsMinutes,
        smsCount,
        isPopular,
        discount,
      ];
}

// E-SIM Provider Model
class ESimProvider extends Equatable {
  final String id;
  final String name;
  final String logo;
  final double rating;
  final int reviewCount;
  final List<String> supportedCountries;

  const ESimProvider({
    required this.id,
    required this.name,
    required this.logo,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.supportedCountries = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        logo,
        rating,
        reviewCount,
        supportedCountries,
      ];
}

// E-SIM Order/Purchase Model
class ESimOrder extends Equatable {
  final String id;
  final String packageId;
  final ESimPackage package;
  final String userId;
  final DateTime purchaseDate;
  final DateTime activationDate;
  final DateTime expiryDate;
  final ESimOrderStatus status;
  final String qrCodeData;
  final String iccid; // E-SIM card number
  final String activationCode;
  final double pricePaid;
  final String currency;
  final PaymentMethod paymentMethod;
  final String? transactionId;

  const ESimOrder({
    required this.id,
    required this.packageId,
    required this.package,
    required this.userId,
    required this.purchaseDate,
    required this.activationDate,
    required this.expiryDate,
    required this.status,
    required this.qrCodeData,
    required this.iccid,
    required this.activationCode,
    required this.pricePaid,
    this.currency = 'USD',
    required this.paymentMethod,
    this.transactionId,
  });

  bool get isActive {
    final now = DateTime.now();
    return status == ESimOrderStatus.active &&
        now.isAfter(activationDate) &&
        now.isBefore(expiryDate);
  }

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  int get daysRemaining {
    if (isExpired) return 0;
    return expiryDate.difference(DateTime.now()).inDays;
  }

  double get dataUsedPercentage {
    // In real app, this would come from provider API
    // For demo, return random usage
    return 0.0; // 0-100
  }

  @override
  List<Object?> get props => [
        id,
        packageId,
        package,
        userId,
        purchaseDate,
        activationDate,
        expiryDate,
        status,
        qrCodeData,
        iccid,
        activationCode,
        pricePaid,
        currency,
        paymentMethod,
        transactionId,
      ];
}

// Enums
enum ESimOrderStatus {
  pending,
  active,
  expired,
  cancelled,
}

enum PaymentMethod {
  creditCard,
  debitCard,
  paypal,
  applePay,
  googlePay,
}

// Installation Step Model
class InstallationStep extends Equatable {
  final int stepNumber;
  final String title;
  final String description;
  final String? imageUrl;
  final List<String>? subSteps;

  const InstallationStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.imageUrl,
    this.subSteps,
  });

  @override
  List<Object?> get props => [
        stepNumber,
        title,
        description,
        imageUrl,
        subSteps,
      ];
}

// Device Compatibility Model
class DeviceCompatibility extends Equatable {
  final String brand;
  final List<String> compatibleModels;
  final List<String> incompatibleModels;

  const DeviceCompatibility({
    required this.brand,
    this.compatibleModels = const [],
    this.incompatibleModels = const [],
  });

  @override
  List<Object?> get props => [brand, compatibleModels, incompatibleModels];
}

// Cart Item Model
class ESimCartItem extends Equatable {
  final ESimPackage package;
  final int quantity;

  const ESimCartItem({
    required this.package,
    this.quantity = 1,
  });

  double get totalPrice => package.finalPrice * quantity;

  @override
  List<Object?> get props => [package, quantity];
}
