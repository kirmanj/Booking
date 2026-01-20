import 'package:aman_booking/features/esim/data/models/e_sim_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'e_sim_event.dart';
import 'e_sim_state.dart';
import 'dart:math';

class ESimBloc extends Bloc<ESimEvent, ESimState> {
  final List<ESimCartItem> _cart = [];
  String? _appliedPromoCode;
  double _promoDiscount = 0.0;

  ESimBloc() : super(const ESimInitial()) {
    on<LoadCountries>(_onLoadCountries);
    on<SearchCountries>(_onSearchCountries);
    on<FilterCountriesByRegion>(_onFilterCountriesByRegion);
    on<SelectCountry>(_onSelectCountry);
    on<LoadPackagesForCountry>(_onLoadPackagesForCountry);
    on<SelectPackage>(_onSelectPackage);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
    on<ClearCart>(_onClearCart);
    on<PurchaseEsim>(_onPurchaseEsim);
    on<LoadMyEsims>(_onLoadMyEsims);
    on<ActivateEsim>(_onActivateEsim);
    on<LoadInstallationInstructions>(_onLoadInstallationInstructions);
    on<CheckDeviceCompatibility>(_onCheckDeviceCompatibility);
    on<ApplyPromoCode>(_onApplyPromoCode);
    on<RemovePromoCode>(_onRemovePromoCode);
    on<SortPackages>(_onSortPackages);
    on<FilterPackages>(_onFilterPackages);
    on<LoadPopularDestinations>(_onLoadPopularDestinations);
    on<LoadRecommendedPackages>(_onLoadRecommendedPackages);
  }

  // Demo data - Replace with API calls later
  static final List<ESimCountry> _demoCountries = [
    // Popular destinations
    const ESimCountry(
      id: 'tr',
      name: 'Turkey',
      code: 'TR',
      flagEmoji: '🇹🇷',
      region: 'Europe',
      isPopular: true,
    ),
    const ESimCountry(
      id: 'ae',
      name: 'United Arab Emirates',
      code: 'AE',
      flagEmoji: '🇦🇪',
      region: 'Middle East',
      isPopular: true,
    ),
    const ESimCountry(
      id: 'us',
      name: 'United States',
      code: 'US',
      flagEmoji: '🇺🇸',
      region: 'Americas',
      isPopular: true,
    ),
    const ESimCountry(
      id: 'gb',
      name: 'United Kingdom',
      code: 'GB',
      flagEmoji: '🇬🇧',
      region: 'Europe',
      isPopular: true,
    ),
    const ESimCountry(
      id: 'fr',
      name: 'France',
      code: 'FR',
      flagEmoji: '🇫🇷',
      region: 'Europe',
      isPopular: true,
    ),
    const ESimCountry(
      id: 'de',
      name: 'Germany',
      code: 'DE',
      flagEmoji: '🇩🇪',
      region: 'Europe',
      isPopular: true,
    ),
    const ESimCountry(
      id: 'it',
      name: 'Italy',
      code: 'IT',
      flagEmoji: '🇮🇹',
      region: 'Europe',
    ),
    const ESimCountry(
      id: 'es',
      name: 'Spain',
      code: 'ES',
      flagEmoji: '🇪🇸',
      region: 'Europe',
    ),
    const ESimCountry(
      id: 'jp',
      name: 'Japan',
      code: 'JP',
      flagEmoji: '🇯🇵',
      region: 'Asia',
      isPopular: true,
    ),
    const ESimCountry(
      id: 'th',
      name: 'Thailand',
      code: 'TH',
      flagEmoji: '🇹🇭',
      region: 'Asia',
      isPopular: true,
    ),
    const ESimCountry(
      id: 'sg',
      name: 'Singapore',
      code: 'SG',
      flagEmoji: '🇸🇬',
      region: 'Asia',
    ),
    const ESimCountry(
      id: 'au',
      name: 'Australia',
      code: 'AU',
      flagEmoji: '🇦🇺',
      region: 'Oceania',
    ),
    const ESimCountry(
      id: 'ca',
      name: 'Canada',
      code: 'CA',
      flagEmoji: '🇨🇦',
      region: 'Americas',
    ),
    const ESimCountry(
      id: 'mx',
      name: 'Mexico',
      code: 'MX',
      flagEmoji: '🇲🇽',
      region: 'Americas',
    ),
    const ESimCountry(
      id: 'br',
      name: 'Brazil',
      code: 'BR',
      flagEmoji: '🇧🇷',
      region: 'Americas',
    ),

    // Regional plans
    const ESimCountry(
      id: 'europe',
      name: 'Europe (30+ countries)',
      code: 'EU',
      flagEmoji: '🇪🇺',
      region: 'Europe',
      isRegional: true,
      coverageCountries: [
        'France',
        'Germany',
        'Italy',
        'Spain',
        'UK',
        'Netherlands',
        'Belgium',
        'Austria',
        'Switzerland',
        'Portugal',
        'Greece',
        'Poland',
        'Czech Republic',
        'Hungary',
        'Sweden',
        'Norway',
      ],
      isPopular: true,
    ),
    const ESimCountry(
      id: 'asia',
      name: 'Asia (15+ countries)',
      code: 'ASIA',
      flagEmoji: '🌏',
      region: 'Asia',
      isRegional: true,
      coverageCountries: [
        'Japan',
        'Thailand',
        'Singapore',
        'Malaysia',
        'Indonesia',
        'Vietnam',
        'South Korea',
        'Taiwan',
        'Philippines',
        'India',
      ],
      isPopular: true,
    ),
    const ESimCountry(
      id: 'global',
      name: 'Global (100+ countries)',
      code: 'GLOBAL',
      flagEmoji: '🌍',
      region: 'Global',
      isRegional: true,
      coverageCountries: [],
      isPopular: true,
    ),
  ];

  static List<ESimPackage> _getPackagesForCountry(String countryId) {
    // Demo packages - Replace with API call
    final country = _demoCountries.firstWhere((c) => c.id == countryId);

    return [
      ESimPackage(
        id: '${countryId}_1gb_7d',
        countryId: countryId,
        countryName: country.name,
        name: 'Starter Plan',
        dataAmount: '1GB',
        dataAmountMB: 1024,
        validityDays: 7,
        price: 4.99,
        features: [
          '4G LTE Speed',
          'Instant Activation',
          'Data Only',
          '24/7 Support',
        ],
        speed: '4G LTE',
      ),
      ESimPackage(
        id: '${countryId}_3gb_15d',
        countryId: countryId,
        countryName: country.name,
        name: 'Tourist Plan',
        dataAmount: '3GB',
        dataAmountMB: 3072,
        validityDays: 15,
        price: 9.99,
        features: [
          '4G LTE Speed',
          'Instant Activation',
          'Data Only',
          '24/7 Support',
          'Hotspot Enabled',
        ],
        speed: '4G LTE',
        isPopular: true,
      ),
      ESimPackage(
        id: '${countryId}_5gb_30d',
        countryId: countryId,
        countryName: country.name,
        name: 'Business Plan',
        dataAmount: '5GB',
        dataAmountMB: 5120,
        validityDays: 30,
        price: 14.99,
        features: [
          '5G Speed (where available)',
          'Instant Activation',
          'Data + 50 min calls',
          '100 SMS',
          '24/7 Priority Support',
          'Hotspot Enabled',
        ],
        speed: '5G',
        callsMinutes: '50 min',
        smsCount: '100 SMS',
        discount: 10,
      ),
      ESimPackage(
        id: '${countryId}_10gb_30d',
        countryId: countryId,
        countryName: country.name,
        name: 'Premium Plan',
        dataAmount: '10GB',
        dataAmountMB: 10240,
        validityDays: 30,
        price: 24.99,
        features: [
          '5G Speed',
          'Instant Activation',
          'Data + 100 min calls',
          '200 SMS',
          '24/7 Priority Support',
          'Hotspot Enabled',
          'Rollover Data',
        ],
        speed: '5G',
        callsMinutes: '100 min',
        smsCount: '200 SMS',
        isPopular: true,
        discount: 15,
      ),
      ESimPackage(
        id: '${countryId}_20gb_30d',
        countryId: countryId,
        countryName: country.name,
        name: 'Unlimited Plan',
        dataAmount: '20GB',
        dataAmountMB: 20480,
        validityDays: 30,
        price: 39.99,
        features: [
          '5G Speed',
          'Instant Activation',
          'Unlimited Calls',
          'Unlimited SMS',
          '24/7 VIP Support',
          'Hotspot Enabled',
          'Rollover Data',
          'Free Extension Available',
        ],
        speed: '5G',
        callsMinutes: 'Unlimited',
        smsCount: 'Unlimited',
        discount: 20,
      ),
      ESimPackage(
        id: '${countryId}_unlimited',
        countryId: countryId,
        countryName: country.name,
        name: 'Unlimited Pro',
        dataAmount: 'Unlimited',
        dataAmountMB: 999999,
        validityDays: 30,
        price: 59.99,
        features: [
          'Unlimited 5G Data',
          'Instant Activation',
          'Unlimited Calls',
          'Unlimited SMS',
          '24/7 VIP Support',
          'Hotspot Enabled',
          'Premium Network Priority',
          'Free Roaming in Select Countries',
        ],
        speed: '5G',
        isUnlimited: true,
        callsMinutes: 'Unlimited',
        smsCount: 'Unlimited',
        discount: 25,
      ),
    ];
  }

  Future<void> _onLoadCountries(
    LoadCountries event,
    Emitter<ESimState> emit,
  ) async {
    emit(const ESimLoading(message: 'Loading countries...'));

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final popularDestinations =
          _demoCountries.where((c) => c.isPopular).toList();

      emit(CountriesLoaded(
        allCountries: _demoCountries,
        displayedCountries: _demoCountries,
        popularDestinations: popularDestinations,
      ));
    } catch (e) {
      emit(ESimError(message: 'Failed to load countries: ${e.toString()}'));
    }
  }

  Future<void> _onSearchCountries(
    SearchCountries event,
    Emitter<ESimState> emit,
  ) async {
    if (state is! CountriesLoaded) return;

    final currentState = state as CountriesLoaded;
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      emit(currentState.copyWith(
        displayedCountries: currentState.allCountries,
        searchQuery: null,
      ));
      return;
    }

    final filtered = currentState.allCountries
        .where((country) =>
            country.name.toLowerCase().contains(query) ||
            country.code.toLowerCase().contains(query))
        .toList();

    emit(currentState.copyWith(
      displayedCountries: filtered,
      searchQuery: query,
    ));
  }

  Future<void> _onFilterCountriesByRegion(
    FilterCountriesByRegion event,
    Emitter<ESimState> emit,
  ) async {
    if (state is! CountriesLoaded) return;

    final currentState = state as CountriesLoaded;

    if (event.region == null) {
      emit(currentState.copyWith(
        displayedCountries: currentState.allCountries,
        selectedRegion: null,
      ));
      return;
    }

    final filtered = currentState.allCountries
        .where((country) => country.region == event.region)
        .toList();

    emit(currentState.copyWith(
      displayedCountries: filtered,
      selectedRegion: event.region,
    ));
  }

  Future<void> _onSelectCountry(
    SelectCountry event,
    Emitter<ESimState> emit,
  ) async {
    emit(const ESimLoading(message: 'Loading packages...'));

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final packages = _getPackagesForCountry(event.country.id);

      emit(PackagesLoaded(
        selectedCountry: event.country,
        allPackages: packages,
        displayedPackages: packages,
      ));
    } catch (e) {
      emit(ESimError(message: 'Failed to load packages: ${e.toString()}'));
    }
  }

  Future<void> _onLoadPackagesForCountry(
    LoadPackagesForCountry event,
    Emitter<ESimState> emit,
  ) async {
    emit(const ESimLoading(message: 'Loading packages...'));

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final country = _demoCountries.firstWhere((c) => c.id == event.countryId);
      final packages = _getPackagesForCountry(event.countryId);

      emit(PackagesLoaded(
        selectedCountry: country,
        allPackages: packages,
        displayedPackages: packages,
      ));
    } catch (e) {
      emit(ESimError(message: 'Failed to load packages: ${e.toString()}'));
    }
  }

  Future<void> _onSelectPackage(
    SelectPackage event,
    Emitter<ESimState> emit,
  ) async {
    if (state is! PackagesLoaded) return;

    final currentState = state as PackagesLoaded;

    // Get related packages (same country, different data amounts)
    final relatedPackages = currentState.allPackages
        .where((p) => p.id != event.package.id)
        .take(3)
        .toList();

    emit(PackageDetailsLoaded(
      package: event.package,
      country: currentState.selectedCountry,
      relatedPackages: relatedPackages,
    ));
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<ESimState> emit,
  ) async {
    final existingIndex = _cart.indexWhere(
      (item) => item.package.id == event.package.id,
    );

    if (existingIndex >= 0) {
      _cart[existingIndex] = ESimCartItem(
        package: event.package,
        quantity: _cart[existingIndex].quantity + event.quantity,
      );
    } else {
      _cart.add(ESimCartItem(
        package: event.package,
        quantity: event.quantity,
      ));
    }

    _emitCartState(emit);

    emit(const ESimSuccess(message: 'Added to cart successfully!'));
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<ESimState> emit,
  ) async {
    _cart.removeWhere((item) => item.package.id == event.packageId);
    _emitCartState(emit);
  }

  Future<void> _onUpdateCartQuantity(
    UpdateCartQuantity event,
    Emitter<ESimState> emit,
  ) async {
    final index = _cart.indexWhere(
      (item) => item.package.id == event.packageId,
    );

    if (index >= 0) {
      if (event.quantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index] = ESimCartItem(
          package: _cart[index].package,
          quantity: event.quantity,
        );
      }
      _emitCartState(emit);
    }
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<ESimState> emit,
  ) async {
    _cart.clear();
    _appliedPromoCode = null;
    _promoDiscount = 0.0;
    _emitCartState(emit);
  }

  void _emitCartState(Emitter<ESimState> emit) {
    final subtotal = _cart.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    final discount = subtotal * _promoDiscount;
    final total = subtotal - discount;

    emit(CartUpdated(
      items: List.from(_cart),
      subtotal: subtotal,
      discount: discount,
      total: total,
      promoCode: _appliedPromoCode,
    ));
  }

  Future<void> _onPurchaseEsim(
    PurchaseEsim event,
    Emitter<ESimState> emit,
  ) async {
    final total = event.items.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    emit(PurchaseProcessing(items: event.items, total: total));

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Generate orders
      final orders = event.items.map((item) {
        return _generateOrder(item.package, event.paymentMethod);
      }).toList();

      final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

      // Clear cart
      _cart.clear();
      _appliedPromoCode = null;
      _promoDiscount = 0.0;

      emit(PurchaseSuccess(
        orders: orders,
        totalPaid: total,
        transactionId: transactionId,
      ));
    } catch (e) {
      print(e.toString());
      emit(ESimError(
        message: 'Purchase failed: ${e.toString()}',
        canRetry: true,
      ));
    }
  }

  ESimOrder _generateOrder(ESimPackage package, PaymentMethod paymentMethod) {
    final now = DateTime.now();
    final random = Random();

    // Generate ICCID: 89 (country code) + 10-12 digits
    final iccidPart1 = random.nextInt(1000000).toString().padLeft(6, '0');
    final iccidPart2 = random.nextInt(1000000).toString().padLeft(6, '0');
    final iccid = '89${random.nextInt(99)}$iccidPart1$iccidPart2';

    return ESimOrder(
      id: 'ORD${now.millisecondsSinceEpoch}${random.nextInt(1000)}',
      packageId: package.id,
      package: package,
      userId: 'user123', // Replace with actual user ID
      purchaseDate: now,
      activationDate: now,
      expiryDate: now.add(Duration(days: package.validityDays)),
      status: ESimOrderStatus.active,
      qrCodeData: 'LPA:1\$\$esim.aman-booking.com\$\$${random.nextInt(999999)}',
      iccid: iccid,
      activationCode: 'ACT${random.nextInt(999999).toString().padLeft(6, '0')}',
      pricePaid: package.finalPrice,
      paymentMethod: paymentMethod,
      transactionId: 'TXN${now.millisecondsSinceEpoch}${random.nextInt(1000)}',
    );
  }

  Future<void> _onLoadMyEsims(
    LoadMyEsims event,
    Emitter<ESimState> emit,
  ) async {
    emit(const ESimLoading(message: 'Loading your E-SIMs...'));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Demo: Generate some sample orders
      final demoOrders = _generateDemoOrders();

      final activeEsims = demoOrders.where((order) => order.isActive).toList();

      final expiredEsims =
          demoOrders.where((order) => order.isExpired).toList();

      emit(MyEsimsLoaded(
        activeEsims: activeEsims,
        expiredEsims: expiredEsims,
        allOrders: demoOrders,
      ));
    } catch (e) {
      emit(ESimError(message: 'Failed to load E-SIMs: ${e.toString()}'));
    }
  }

  List<ESimOrder> _generateDemoOrders() {
    // Generate 2 active and 1 expired for demo
    final now = DateTime.now();
    final packages = _getPackagesForCountry('tr');

    return [
      ESimOrder(
        id: 'ORD001',
        packageId: packages[1].id,
        package: packages[1],
        userId: 'user123',
        purchaseDate: now.subtract(const Duration(days: 5)),
        activationDate: now.subtract(const Duration(days: 5)),
        expiryDate: now.add(const Duration(days: 10)),
        status: ESimOrderStatus.active,
        qrCodeData: 'LPA:1\$\$example.com\$\$123456',
        iccid: '8901234567890123456',
        activationCode: 'ACT123456',
        pricePaid: packages[1].finalPrice,
        paymentMethod: PaymentMethod.creditCard,
        transactionId: 'TXN001',
      ),
      ESimOrder(
        id: 'ORD002',
        packageId: packages[3].id,
        package: packages[3],
        userId: 'user123',
        purchaseDate: now.subtract(const Duration(days: 2)),
        activationDate: now.subtract(const Duration(days: 2)),
        expiryDate: now.add(const Duration(days: 28)),
        status: ESimOrderStatus.active,
        qrCodeData: 'LPA:1\$\$example.com\$\$789012',
        iccid: '8901234567890123457',
        activationCode: 'ACT789012',
        pricePaid: packages[3].finalPrice,
        paymentMethod: PaymentMethod.applePay,
        transactionId: 'TXN002',
      ),
    ];
  }

  Future<void> _onActivateEsim(
    ActivateEsim event,
    Emitter<ESimState> emit,
  ) async {
    emit(const ESimLoading(message: 'Activating E-SIM...'));

    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const ESimSuccess(message: 'E-SIM activated successfully!'));
    } catch (e) {
      emit(ESimError(message: 'Activation failed: ${e.toString()}'));
    }
  }

  Future<void> _onLoadInstallationInstructions(
    LoadInstallationInstructions event,
    Emitter<ESimState> emit,
  ) async {
    final steps = event.platform == 'ios'
        ? _getIosInstallationSteps()
        : _getAndroidInstallationSteps();

    emit(InstallationInstructionsLoaded(
      platform: event.platform,
      steps: steps,
      requirements: [
        'Device must support E-SIM',
        'iOS 12.1 or later / Android 9.0 or later',
        'Active internet connection',
        'Device must be unlocked',
      ],
      troubleshooting: [
        'Restart your device',
        'Check if E-SIM is supported',
        'Ensure you have stable internet',
        'Contact support if issue persists',
      ],
    ));
  }

  List<InstallationStep> _getIosInstallationSteps() {
    return [
      const InstallationStep(
        stepNumber: 1,
        title: 'Open Settings',
        description: 'Go to Settings > Cellular > Add Cellular Plan',
      ),
      const InstallationStep(
        stepNumber: 2,
        title: 'Scan QR Code',
        description: 'Use your camera to scan the QR code provided',
      ),
      const InstallationStep(
        stepNumber: 3,
        title: 'Add Cellular Plan',
        description: 'Tap "Add Cellular Plan" when prompted',
      ),
      const InstallationStep(
        stepNumber: 4,
        title: 'Label Your Plan',
        description: 'Give your E-SIM a label (e.g., "Turkey Travel")',
      ),
      const InstallationStep(
        stepNumber: 5,
        title: 'Select Default Line',
        description: 'Choose which line to use for calls and data',
      ),
      const InstallationStep(
        stepNumber: 6,
        title: 'Done!',
        description: 'Your E-SIM is now active and ready to use',
      ),
    ];
  }

  List<InstallationStep> _getAndroidInstallationSteps() {
    return [
      const InstallationStep(
        stepNumber: 1,
        title: 'Open Settings',
        description: 'Go to Settings > Network & Internet > Mobile Network',
      ),
      const InstallationStep(
        stepNumber: 2,
        title: 'Add Carrier',
        description: 'Tap "Add Carrier" or "+" button',
      ),
      const InstallationStep(
        stepNumber: 3,
        title: 'Scan QR Code',
        description: 'Select "Scan QR Code" and use your camera',
      ),
      const InstallationStep(
        stepNumber: 4,
        title: 'Download Profile',
        description: 'Wait for the E-SIM profile to download',
      ),
      const InstallationStep(
        stepNumber: 5,
        title: 'Enable E-SIM',
        description: 'Turn on the E-SIM in your mobile network settings',
      ),
      const InstallationStep(
        stepNumber: 6,
        title: 'Done!',
        description: 'Your E-SIM is now active and ready to use',
      ),
    ];
  }

  Future<void> _onCheckDeviceCompatibility(
    CheckDeviceCompatibility event,
    Emitter<ESimState> emit,
  ) async {
    emit(const ESimLoading(message: 'Checking compatibility...'));

    await Future.delayed(const Duration(milliseconds: 500));

    // Demo: Check if device supports E-SIM
    final compatibleDevices = [
      'iPhone XS',
      'iPhone XR',
      'iPhone 11',
      'iPhone 12',
      'iPhone 13',
      'iPhone 14',
      'iPhone 15',
      'Samsung Galaxy S20',
      'Samsung Galaxy S21',
      'Samsung Galaxy S22',
      'Samsung Galaxy S23',
      'Google Pixel 3',
      'Google Pixel 4',
      'Google Pixel 5',
      'Google Pixel 6',
      'Google Pixel 7',
    ];

    final isCompatible = compatibleDevices.any(
      (device) =>
          event.deviceModel.toLowerCase().contains(device.toLowerCase()),
    );

    emit(DeviceCompatibilityChecked(
      isCompatible: isCompatible,
      deviceModel: event.deviceModel,
      message: isCompatible
          ? 'Great! Your device supports E-SIM.'
          : 'Sorry, your device may not support E-SIM.',
      alternativeModels:
          isCompatible ? null : compatibleDevices.take(5).toList(),
    ));
  }

  Future<void> _onApplyPromoCode(
    ApplyPromoCode event,
    Emitter<ESimState> emit,
  ) async {
    emit(const ESimLoading(message: 'Validating promo code...'));

    await Future.delayed(const Duration(milliseconds: 500));

    // Demo promo codes
    final promoCodes = {
      'WELCOME10': 0.10,
      'TRAVEL20': 0.20,
      'SUMMER25': 0.25,
      'FIRSTBUY': 0.15,
    };

    final discount = promoCodes[event.code.toUpperCase()];

    if (discount != null) {
      _appliedPromoCode = event.code.toUpperCase();
      _promoDiscount = discount;

      final subtotal = _cart.fold(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

      emit(PromoCodeApplied(
        code: _appliedPromoCode!,
        discountPercentage: discount * 100,
        discountAmount: subtotal * discount,
        message: 'Promo code applied! You save ${(discount * 100).toInt()}%',
      ));

      _emitCartState(emit);
    } else {
      emit(const ESimError(
        message: 'Invalid promo code',
        canRetry: true,
      ));
    }
  }

  Future<void> _onRemovePromoCode(
    RemovePromoCode event,
    Emitter<ESimState> emit,
  ) async {
    _appliedPromoCode = null;
    _promoDiscount = 0.0;
    _emitCartState(emit);
  }

  Future<void> _onSortPackages(
    SortPackages event,
    Emitter<ESimState> emit,
  ) async {
    if (state is! PackagesLoaded) return;

    final currentState = state as PackagesLoaded;
    final sortedPackages =
        List<ESimPackage>.from(currentState.displayedPackages);

    switch (event.sortBy) {
      case PackageSortOption.priceAsc:
        sortedPackages.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
        break;
      case PackageSortOption.priceDesc:
        sortedPackages.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
        break;
      case PackageSortOption.dataAsc:
        sortedPackages.sort((a, b) => a.dataAmountMB.compareTo(b.dataAmountMB));
        break;
      case PackageSortOption.dataDesc:
        sortedPackages.sort((a, b) => b.dataAmountMB.compareTo(a.dataAmountMB));
        break;
      case PackageSortOption.validityAsc:
        sortedPackages.sort((a, b) => a.validityDays.compareTo(b.validityDays));
        break;
      case PackageSortOption.validityDesc:
        sortedPackages.sort((a, b) => b.validityDays.compareTo(a.validityDays));
        break;
      case PackageSortOption.popular:
        sortedPackages.sort((a, b) {
          if (a.isPopular && !b.isPopular) return -1;
          if (!a.isPopular && b.isPopular) return 1;
          return 0;
        });
        break;
    }

    emit(currentState.copyWith(
      displayedPackages: sortedPackages,
      sortBy: event.sortBy,
    ));
  }

  Future<void> _onFilterPackages(
    FilterPackages event,
    Emitter<ESimState> emit,
  ) async {
    if (state is! PackagesLoaded) return;

    final currentState = state as PackagesLoaded;
    final filteredPackages = currentState.allPackages
        .where((package) => event.filter.matches(package))
        .toList();

    emit(currentState.copyWith(
      displayedPackages: filteredPackages,
      filter: event.filter,
    ));
  }

  Future<void> _onLoadPopularDestinations(
    LoadPopularDestinations event,
    Emitter<ESimState> emit,
  ) async {
    emit(const ESimLoading(message: 'Loading popular destinations...'));

    await Future.delayed(const Duration(milliseconds: 300));

    final popularDestinations =
        _demoCountries.where((c) => c.isPopular).toList();

    emit(CountriesLoaded(
      allCountries: _demoCountries,
      displayedCountries: popularDestinations,
      popularDestinations: popularDestinations,
    ));
  }

  Future<void> _onLoadRecommendedPackages(
    LoadRecommendedPackages event,
    Emitter<ESimState> emit,
  ) async {
    emit(const ESimLoading(message: 'Loading recommendations...'));

    await Future.delayed(const Duration(milliseconds: 300));

    // Get popular packages from popular countries
    final recommendedPackages = <ESimPackage>[];

    for (final country in _demoCountries.where((c) => c.isPopular).take(5)) {
      final packages = _getPackagesForCountry(country.id);
      recommendedPackages.addAll(
        packages.where((p) => p.isPopular).take(1),
      );
    }

    emit(const ESimSuccess(
      message: 'Recommendations loaded',
      data: null, // Would contain recommendedPackages in real app
    ));
  }
}
