import 'package:aman_booking/features/airport_taxi/bloc/airport_taxi_bloc.dart';
import 'package:aman_booking/features/airport_taxi/data/repositories/airport_taxi_repository_impl.dart';
import 'package:aman_booking/features/airport_taxi/presentation/screens/airport_taxi_screen.dart';
import 'package:aman_booking/features/bus_tickets/presentation/screens/bus_screen.dart';
import 'package:aman_booking/features/car_rental/presentation/screens/car_rental_screen.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_bloc.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_event.dart';
import 'package:aman_booking/features/esim/presentation/screens/e_sim_countries_screen.dart';
import 'package:aman_booking/features/flights/presentation/screens/flights_screen.dart';
import 'package:aman_booking/features/home_checkin/data/repositories/home_checkin_repository_impl.dart';
import 'package:aman_booking/features/home_checkin/presentation/bloc/home_checkin_bloc.dart';
import 'package:aman_booking/features/home_checkin/presentation/screens/home_checkin_screen.dart';
import 'package:aman_booking/features/home_checkin/presentation/screens/service_info_screen.dart';
import 'package:aman_booking/features/hotels/presentation/screens/hotels_screen.dart';
import 'package:aman_booking/features/tours/presentation/screens/tours_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:aman_booking/features/bookings/presentation/screens/redesigned_bookings_screen.dart';
import 'package:aman_booking/features/profile/presentation/screens/profile_screen.dart';
import 'package:aman_booking/features/support/presentation/screens/support_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final VideoPlayerController _bgVideoController;
  late final Future<void> _bgVideoInit;

  @override
  void initState() {
    super.initState();

    _bgVideoController =
        VideoPlayerController.asset('assets/images/airplane-2.mp4');

    _bgVideoInit = _initBgVideo();
  }

  Future<void> _initBgVideo() async {
    await _bgVideoController.initialize();
    await _bgVideoController.setLooping(true);
    await _bgVideoController.setVolume(0); // muted
    await _bgVideoController.play();
  }

  @override
  void dispose() {
    _bgVideoController.dispose();
    super.dispose();
  }

  void _showServicesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ServicesBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: _buildDrawer(),
        body: Builder(
          builder: (context) => Stack(
            children: [
              // ✅ Background VIDEO (no controls, loop, autoplay)
              Positioned.fill(
                child: FutureBuilder<void>(
                  future: _bgVideoInit,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        _bgVideoController.value.isInitialized) {
                      final size = _bgVideoController.value.size;
                      return ClipRect(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: size.width,
                            height: size.height,
                            child: VideoPlayer(_bgVideoController),
                          ),
                        ),
                      );
                    }

                    // Fallback (same gradient you had)
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF7EC8E3),
                            Color(0xFFB8D4E1),
                            Color(0xFFE8D5C4),
                            Color(0xFFF5E6D3),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Dark overlay (kept exactly as you had)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),

              // Content (kept same)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Column(
                    children: [
                      // Top Bar
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Menu Button
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.menu,
                                    color: Colors.black87),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                            ),

                            // Search Bar
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 16),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Where to go...',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.search, color: Colors.grey[400]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // ✅ Removed image dots (because slider removed)

                      // Services Container with IMAGES
                      GestureDetector(
                        onTap: _showServicesBottomSheet,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Up Arrow
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Services Row with IMAGES
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildQuickService(
                                    imagePath: 'assets/icons/flight.png',
                                    label: 'Flights',
                                    color: AppColors.primary,
                                    destination: FlightsScreen(),
                                  ),
                                  _buildQuickService(
                                    imagePath: 'assets/icons/hotel.png',
                                    label: 'Hotels',
                                    color: const Color(0xFF2DD4BF),
                                    destination: const HotelsScreen(),
                                  ),
                                  _buildQuickService(
                                    imagePath: 'assets/icons/car.png',
                                    label: 'Car Rental',
                                    color: AppColors.primary,
                                    destination: const CarRentalScreen(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickService({
    required String imagePath,
    required String label,
    required Color color,
    required Widget destination,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported,
                    size: 32,
                    color: color,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: 500,
              padding: const EdgeInsets.all(0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Guest User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'guest@amanbooking.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildDrawerItem(
                    icon: Icons.favorite,
                    title: 'Favorites',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.confirmation_number,
                    title: 'My Bookings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RedesignedBookingsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.support_agent,
                    title: 'Support',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SupportScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 32),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Aman Booking v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
      ),
    );
  }
}

// Bottom Sheet with Custom IMAGES
class ServicesBottomSheet extends StatelessWidget {
  const ServicesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(bottom: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Our Services',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // All 8 Services with CUSTOM IMAGES
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Row 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildServiceIcon(
                          imagePath: 'assets/icons/flight.png',
                          label: 'Flights',
                          color: AppColors.primary,
                          destinationBuilder: (context) =>
                              const FlightsScreen(),
                          context: context),
                      _buildServiceIcon(
                          imagePath: 'assets/icons/hotel.png',
                          label: 'Hotels',
                          color: const Color(0xFF2DD4BF),
                          destinationBuilder: (context) => const HotelsScreen(),
                          context: context),
                      _buildServiceIcon(
                          imagePath: 'assets/icons/car.png',
                          label: 'Car Rental',
                          color: AppColors.primary,
                          destinationBuilder: (context) =>
                              const CarRentalScreen(),
                          context: context),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Row 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildServiceIcon(
                          imagePath: 'assets/icons/tour.png',
                          label: 'Tours',
                          color: const Color(0xFF2DD4BF),
                          destinationBuilder: (context) =>
                              const ToursMainScreen(),
                          context: context),
                      _buildServiceIcon(
                          imagePath: 'assets/icons/bus.png',
                          label: 'Bus Tickets',
                          color: AppColors.primary,
                          destinationBuilder: (context) =>
                              const BusHomeScreen(),
                          context: context),
                      _buildServiceIcon(
                          imagePath: 'assets/icons/esim.png',
                          label: 'E-SIM',
                          color: const Color(0xFF2DD4BF),
                          destinationBuilder: (context) {
                            return BlocProvider(
                              create: (context) =>
                                  ESimBloc()..add(const LoadCountries()),
                              child: const ESimCountriesScreen(),
                            );
                          },
                          context: context),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Row 3
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ✅ CORRECT - Return the widget directly
                      _buildServiceIcon(
                          imagePath: 'assets/icons/home.png',
                          label: 'Home Check-In',
                          color: AppColors.primary,
                          destinationBuilder: (context) {
                            return BlocProvider(
                              // ← Just return the widget!
                              create: (_) => HomeCheckInBloc(
                                repository: HomeCheckInRepositoryImpl(),
                              ),
                              child: const ServiceInfoScreen(),
                            );
                          },
                          context: context),

                      _buildServiceIcon(
                          imagePath: 'assets/icons/taxi.png',
                          label: 'Airport Taxi',
                          color: const Color(0xFF2DD4BF),
                          destinationBuilder: (context) {
                            return BlocProvider(
                              create: (_) => AirportTaxiBloc(
                                repository: AirportTaxiRepositoryImpl(),
                              )..add(const LoadAirports()),
                              child: const AirportTaxiScreen(),
                            );
                          },
                          context: context),

                      const SizedBox(width: 95),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon({
    required String imagePath,
    required String label,
    required Color color,
    required BuildContext context,
    Widget Function(BuildContext)? destinationBuilder,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (destinationBuilder != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: destinationBuilder,
            ),
          );
        }
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported,
                    size: 38,
                    color: color,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 95,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
