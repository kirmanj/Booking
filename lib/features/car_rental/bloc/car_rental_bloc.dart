import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'car_rental_event.dart';
import 'car_rental_state.dart';

class CarRentalBloc extends Bloc<CarRentalEvent, CarRentalState> {
  CarRentalBloc() : super(const CarRentalInitial()) {
    on<LoadCarRentalHome>(_onLoadHome);
    on<ToggleCompanyFavorite>(_onToggleCompanyFavorite);
    on<ToggleCarFavorite>(_onToggleCarFavorite);
    on<UpdateSearchLocation>(_onUpdateLocation);
    on<UpdatePickupDate>(_onUpdatePickup);
    on<UpdateDropoffDate>(_onUpdateDropoff);
    on<LoadCompanyProfile>(_onLoadCompanyProfile);
  }

  Future<void> _onLoadHome(
    LoadCarRentalHome event,
    Emitter<CarRentalState> emit,
  ) async {
    emit(const CarRentalLoading());
    await Future.delayed(const Duration(milliseconds: 350));

    // ---- Demo Data ----
    const companies = <CarRentalCompany>[
      CarRentalCompany(
        id: 'c1',
        name: 'Hertz',
        logoUrl:
            'https://play-lh.googleusercontent.com/wOZDf7kAvLxbM94btZhVGo6LUn3BX9tpdIv3Qin3x97cLWe6w-xZSQpDydrpV6l8TUrz',
        rating: 4.6,
        reviews: 18420,
        fromPricePerDay: 39,
        isFavorite: true,
        highlights: ['Free cancellation', '24/7 support', 'Airport pickup'],
        coverage: 'Erbil • Dubai • Istanbul',
        description:
            'Hertz is one of the world\'s leading car rental companies with over 100 years of experience. We pride ourselves on providing exceptional service and maintaining a modern fleet of vehicles to meet all your travel needs.',
        phone: '+964 750 123 4567',
        email: 'erbil@hertz.com',
        establishedYear: 1918,
        totalCars: 120,
      ),
      CarRentalCompany(
        id: 'c2',
        name: 'Avis',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzcKA15eVwW7k6PkYoLy798rAPImQ_-nJcZQ&s',
        rating: 4.5,
        reviews: 13210,
        fromPricePerDay: 35,
        isFavorite: false,
        highlights: ['Fast checkout', 'Premium fleet', 'Insurance options'],
        coverage: 'Erbil • Dubai • London',
        description:
            'Avis offers premium car rental services with a focus on customer satisfaction. Our fleet includes the latest models and we provide comprehensive insurance coverage for your peace of mind.',
        phone: '+964 750 234 5678',
        email: 'support@avis-iraq.com',
        establishedYear: 1946,
        totalCars: 95,
      ),
      CarRentalCompany(
        id: 'c3',
        name: 'Sixt',
        logoUrl:
            'https://play-lh.googleusercontent.com/MWy4qJMCVD1OQ9fYg1ZFf9Qu_W39wvo1oYD1fKhWfZIl-QZehNfuC7gwsnz_9aZXYw',
        rating: 4.7,
        reviews: 9520,
        fromPricePerDay: 42,
        isFavorite: false,
        highlights: ['Luxury cars', 'New models', 'Unlimited mileage deals'],
        coverage: 'Dubai • Berlin • Paris',
        description:
            'Sixt specializes in luxury and premium vehicles. We offer the newest models with cutting-edge features and provide exceptional service for discerning travelers.',
        phone: '+971 4 567 8901',
        email: 'dubai@sixt.com',
        establishedYear: 1912,
        totalCars: 150,
      ),
      CarRentalCompany(
        id: 'c4',
        name: 'Budget',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/6/6c/Budget_logo.svg',
        rating: 4.4,
        reviews: 8440,
        fromPricePerDay: 29,
        isFavorite: true,
        highlights: ['Low price', 'Good for families', 'Free cancellation'],
        coverage: 'Erbil • Dubai • Ankara',
        description:
            'Budget provides affordable car rental solutions without compromising on quality. Perfect for budget-conscious travelers and families looking for reliable transportation.',
        phone: '+964 750 345 6789',
        email: 'info@budget-iraq.com',
        establishedYear: 1958,
        totalCars: 80,
      ),
    ];

    final luxury = <CarModel>[
      CarModel(
        id: 'l1',
        companyId: 'c3',
        category: CarCategory.luxury,
        name: 'Mercedes-Benz S-Class',
        brand: 'Mercedes',
        imageUrl:
            'https://stimg.cardekho.com/images/carexteriorimages/630x420/Mercedes-Benz/S-Class/10852/1763536912245/front-left-side-47.jpg?imwidth=420&impolicy=resize',
        galleryImages: [
          'https://imgd.aeplcdn.com/664x374/n/cw/ec/48067/s-class-exterior-right-front-three-quarter-10.png?isig=0&q=80',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDmz_91mElZt5uGAXTII62YWSEYsZ7suK5DA&s',
          'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=1200&q=70',
        ],
        seats: 5,
        bags: 3,
        transmission: 'Automatic',
        fuel: 'Petrol',
        ac: true,
        rating: 4.9,
        reviews: 1240,
        pricePerDay: 189,
        oldPricePerDay: 229,
        mileagePolicy: '250 km/day',
        deposit: 500,
        freeCancellation: true,
        insuranceIncluded: true,
        included: ['Free additional driver', 'Airport pickup', 'GPS included'],
        terms:
            'ID + Driving license required. Deposit refundable after return.',
        isFavorite: true,
        year: '2024',
        color: 'Black',
        features: [
          'Bluetooth',
          'USB Port',
          'Sunroof',
          'Leather Seats',
          'Navigation'
        ],
      ),
      const CarModel(
        id: 'l2',
        companyId: 'c2',
        category: CarCategory.luxury,
        name: 'Range Rover Vogue',
        brand: 'Land Rover',
        imageUrl:
            'https://media.cdn-jaguarlandrover.com/api/v2/images/104088/w/640.jpg',
        galleryImages: [
          'https://car-images.bauersecure.com/wp-images/13343/rangeroverv8_21.jpg',
          'https://trinityrental.com/_next/image?url=https%3A%2F%2Fstorage.googleapis.com%2Ftrinityrental-e51d5.appspot.com%2F0_rr_vogue_autobiography_main_62092d5dea%2F0_rr_vogue_autobiography_main_62092d5dea.jpeg&w=3840&q=75',
        ],
        seats: 5,
        bags: 4,
        transmission: 'Automatic',
        fuel: 'Petrol',
        ac: true,
        rating: 4.8,
        reviews: 860,
        pricePerDay: 199,
        oldPricePerDay: null,
        mileagePolicy: 'Unlimited',
        deposit: 600,
        freeCancellation: false,
        insuranceIncluded: true,
        included: [
          'Premium insurance',
          'Roadside assistance',
          'Bluetooth audio'
        ],
        terms: 'Unlimited mileage with fair fuel policy.',
        isFavorite: false,
        year: '2024',
        color: 'White',
        features: ['4WD', 'Premium Sound', 'Parking Sensors', 'Camera'],
      ),
    ];

    final budget = <CarModel>[
      const CarModel(
        id: 'b1',
        companyId: 'c4',
        category: CarCategory.budget,
        name: 'Hyundai Accent',
        brand: 'Hyundai',
        imageUrl:
            'https://images.hgmsites.net/lrg/2022-hyundai-accent-se-sedan-ivt-angular-front-exterior-view_100821955_l.jpg',
        galleryImages: [
          'https://platform.cstatic-images.com/xxlarge/in/v2/stock_photos/359a3466-858d-4e70-8d34-0e0a0ebfd347/db815911-f112-4984-8540-956d0054a35f.png',
        ],
        seats: 5,
        bags: 2,
        transmission: 'Automatic',
        fuel: 'Petrol',
        ac: true,
        rating: 4.5,
        reviews: 2230,
        pricePerDay: 29,
        oldPricePerDay: 39,
        mileagePolicy: 'Unlimited',
        deposit: 150,
        freeCancellation: true,
        insuranceIncluded: false,
        included: [
          'Free cancellation',
          'Basic insurance add-on',
          'Phone holder'
        ],
        terms: 'Great for city rides. Fuel policy: full-to-full.',
        isFavorite: true,
        year: '2023',
        color: 'Silver',
        features: ['Bluetooth', 'USB Port', 'Power Windows'],
      ),
      const CarModel(
        id: 'b2',
        companyId: 'c1',
        category: CarCategory.budget,
        name: 'Toyota Yaris',
        brand: 'Toyota',
        imageUrl:
            'https://tcl-s3-bucket.s3.amazonaws.com/web/media/images/YarisPlata_Mesa_de_trabajo_1-12.2e16d0ba.fill-960x540.png',
        galleryImages: [
          'https://preview.free3d.com/img/2023/11/3281651305935799585/4yk3oy5e.jpg',
        ],
        seats: 5,
        bags: 2,
        transmission: 'Automatic',
        fuel: 'Petrol',
        ac: true,
        rating: 4.6,
        reviews: 3100,
        pricePerDay: 33,
        oldPricePerDay: null,
        mileagePolicy: '250 km/day',
        deposit: 180,
        freeCancellation: true,
        insuranceIncluded: false,
        included: ['24/7 support', 'Child seat add-on', 'Free cancellation'],
        terms: 'Driver age 21+. ID & License required.',
        isFavorite: false,
        year: '2023',
        color: 'Red',
        features: ['Bluetooth', 'Backup Camera', 'Cruise Control'],
      ),
    ];

    final family = <CarModel>[
      const CarModel(
        id: 'f1',
        companyId: 'c1',
        category: CarCategory.family,
        name: 'Toyota Land Cruiser',
        brand: 'Toyota',
        imageUrl:
            'https://imgd.aeplcdn.com/664x374/n/cw/ec/139739/land-cruiser-2023-exterior-left-front-three-quarter-2.jpeg?isig=0&q=80',
        galleryImages: [
          'https://gsat.jp/wp-content/uploads/2022/07/2022-LandCruiser-LC300-GR-Sport-No.J05256.jpg',
          'https://i.redd.it/rzgph4fq059c1.jpeg',
        ],
        seats: 7,
        bags: 5,
        transmission: 'Automatic',
        fuel: 'Petrol',
        ac: true,
        rating: 4.8,
        reviews: 1560,
        pricePerDay: 119,
        oldPricePerDay: 139,
        mileagePolicy: 'Unlimited',
        deposit: 350,
        freeCancellation: true,
        insuranceIncluded: true,
        included: ['7 seats', 'Large luggage space', 'Insurance included'],
        terms: 'Perfect for family trips. Fuel: full-to-full.',
        isFavorite: true,
        year: '2024',
        color: 'Black',
        features: ['4WD', '7 Seats', 'Roof Rack', 'Climate Control'],
      ),
      const CarModel(
        id: 'f2',
        companyId: 'c2',
        category: CarCategory.family,
        name: 'Kia Carnival',
        brand: 'Kia',
        imageUrl:
            'https://www.kia.com/content/dam/kia/us/en/vehicles/ka4/2025/trims/ex/exterior/616161/360/36.png',
        galleryImages: [
          'https://i.gaw.to/content/photos/59/53/595347-la-kia-carnival-adoptera-un-style-plus-futuriste.jpg?1024x640',
        ],
        seats: 7,
        bags: 4,
        transmission: 'Automatic',
        fuel: 'Petrol',
        ac: true,
        rating: 4.7,
        reviews: 920,
        pricePerDay: 99,
        oldPricePerDay: null,
        mileagePolicy: '250 km/day',
        deposit: 300,
        freeCancellation: false,
        insuranceIncluded: true,
        included: ['Spacious interior', 'Insurance included', 'USB charging'],
        terms: 'Driver age 23+. Deposit required.',
        isFavorite: false,
        year: '2024',
        color: 'Silver',
        features: ['7 Seats', 'Sliding Doors', 'Entertainment System'],
      ),
    ];

    emit(
      CarRentalLoaded(
        location: 'Erbil, Iraq',
        pickupDate: DateTime.now().add(const Duration(days: 1)),
        dropoffDate: DateTime.now().add(const Duration(days: 4)),
        companies: companies,
        luxuryCars: luxury,
        lowPriceCars: budget,
        familyCars: family,
      ),
    );
  }

  void _onToggleCompanyFavorite(
    ToggleCompanyFavorite event,
    Emitter<CarRentalState> emit,
  ) {
    final s = state;
    if (s is! CarRentalLoaded) return;

    final updated = s.companies.map((c) {
      if (c.id == event.companyId) return c.copyWith(isFavorite: !c.isFavorite);
      return c;
    }).toList();

    emit(s.copyWith(companies: updated));
  }

  void _onToggleCarFavorite(
    ToggleCarFavorite event,
    Emitter<CarRentalState> emit,
  ) {
    final s = state;
    if (s is! CarRentalLoaded) return;

    List<CarModel> mapCars(List<CarModel> cars) => cars
        .map((c) =>
            c.id == event.carId ? c.copyWith(isFavorite: !c.isFavorite) : c)
        .toList();

    emit(
      s.copyWith(
        luxuryCars: mapCars(s.luxuryCars),
        lowPriceCars: mapCars(s.lowPriceCars),
        familyCars: mapCars(s.familyCars),
      ),
    );
  }

  void _onUpdateLocation(
      UpdateSearchLocation event, Emitter<CarRentalState> emit) {
    final s = state;
    if (s is! CarRentalLoaded) return;
    emit(s.copyWith(location: event.location));
  }

  void _onUpdatePickup(UpdatePickupDate event, Emitter<CarRentalState> emit) {
    final s = state;
    if (s is! CarRentalLoaded) return;
    // keep dropoff >= pickup + 1 day
    final drop = s.dropoffDate.isAfter(event.pickup)
        ? s.dropoffDate
        : event.pickup.add(const Duration(days: 1));
    emit(s.copyWith(pickupDate: event.pickup, dropoffDate: drop));
  }

  void _onUpdateDropoff(UpdateDropoffDate event, Emitter<CarRentalState> emit) {
    final s = state;
    if (s is! CarRentalLoaded) return;
    if (!event.dropoff.isAfter(s.pickupDate)) return;
    emit(s.copyWith(dropoffDate: event.dropoff));
  }

  // NEW: Load company profile
  Future<void> _onLoadCompanyProfile(
    LoadCompanyProfile event,
    Emitter<CarRentalState> emit,
  ) async {
    emit(const CarRentalLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // Get current state to access all cars
      final currentState = state;
      List<CarModel> allCars = [];

      if (currentState is CarRentalLoaded) {
        allCars = [
          ...currentState.luxuryCars,
          ...currentState.lowPriceCars,
          ...currentState.familyCars,
        ];
      }

      // Get company cars
      final companyCars =
          allCars.where((car) => car.companyId == event.companyId).toList();

      // Get company (from demo data - in real app, fetch from API)
      final company = _getCompanyById(event.companyId);

      if (company == null) {
        emit(const CarRentalError('Company not found'));
        return;
      }

      // Demo locations and services
      final locations =
          company.coverage.split('•').map((e) => e.trim()).toList();
      final services = [
        'Airport Pickup & Delivery',
        '24/7 Customer Support',
        'Free Cancellation',
        'Comprehensive Insurance',
        'Unlimited Mileage Options',
        'Child Seats Available',
        'GPS Navigation',
        'Additional Drivers',
      ];

      emit(CompanyProfileLoaded(
        company: company,
        companyCars: companyCars,
        locations: locations,
        services: services,
      ));
    } catch (e) {
      emit(CarRentalError('Failed to load company: ${e.toString()}'));
    }
  }

  // Helper method to get company by ID (demo data)
  CarRentalCompany? _getCompanyById(String id) {
    const companies = <CarRentalCompany>[
      CarRentalCompany(
        id: 'c1',
        name: 'Hertz',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/7/7d/Hertz_logo.svg',
        rating: 4.6,
        reviews: 18420,
        fromPricePerDay: 39,
        isFavorite: true,
        highlights: ['Free cancellation', '24/7 support', 'Airport pickup'],
        coverage: 'Erbil • Dubai • Istanbul',
        description:
            'Hertz is one of the world\'s leading car rental companies with over 100 years of experience. We pride ourselves on providing exceptional service and maintaining a modern fleet of vehicles to meet all your travel needs.',
        phone: '+964 750 123 4567',
        email: 'erbil@hertz.com',
        establishedYear: 1918,
        totalCars: 120,
      ),
      CarRentalCompany(
        id: 'c2',
        name: 'Avis',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/8/8b/Avis_logo.svg',
        rating: 4.5,
        reviews: 13210,
        fromPricePerDay: 35,
        isFavorite: false,
        highlights: ['Fast checkout', 'Premium fleet', 'Insurance options'],
        coverage: 'Erbil • Dubai • London',
        description:
            'Avis offers premium car rental services with a focus on customer satisfaction. Our fleet includes the latest models and we provide comprehensive insurance coverage for your peace of mind.',
        phone: '+964 750 234 5678',
        email: 'support@avis-iraq.com',
        establishedYear: 1946,
        totalCars: 95,
      ),
      CarRentalCompany(
        id: 'c3',
        name: 'Sixt',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/2/2d/Sixt_logo.svg',
        rating: 4.7,
        reviews: 9520,
        fromPricePerDay: 42,
        isFavorite: false,
        highlights: ['Luxury cars', 'New models', 'Unlimited mileage deals'],
        coverage: 'Dubai • Berlin • Paris',
        description:
            'Sixt specializes in luxury and premium vehicles. We offer the newest models with cutting-edge features and provide exceptional service for discerning travelers.',
        phone: '+971 4 567 8901',
        email: 'dubai@sixt.com',
        establishedYear: 1912,
        totalCars: 150,
      ),
      CarRentalCompany(
        id: 'c4',
        name: 'Budget',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/6/6c/Budget_logo.svg',
        rating: 4.4,
        reviews: 8440,
        fromPricePerDay: 29,
        isFavorite: true,
        highlights: ['Low price', 'Good for families', 'Free cancellation'],
        coverage: 'Erbil • Dubai • Ankara',
        description:
            'Budget provides affordable car rental solutions without compromising on quality. Perfect for budget-conscious travelers and families looking for reliable transportation.',
        phone: '+964 750 345 6789',
        email: 'info@budget-iraq.com',
        establishedYear: 1958,
        totalCars: 80,
      ),
    ];

    try {
      return companies.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
