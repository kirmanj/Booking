import 'package:aman_booking/features/hotels/presentation/screens/hotel_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class HotelsScreen extends StatelessWidget {
  const HotelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HotelsBloc()..add(LoadHotels()),
      child: const HotelsView(),
    );
  }
}

class HotelsView extends StatefulWidget {
  const HotelsView({super.key});

  @override
  State<HotelsView> createState() => _HotelsViewState();
}

class _HotelsViewState extends State<HotelsView> {
  final TextEditingController _locationController =
      TextEditingController(text: 'Dubai, UAE');

  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 3));
  int _guests = 2;
  int _rooms = 1;

  // ✅ Use secondary only for borders/icons
  Color get _accent => AppColors.secondary;
  Color get _border => AppColors.primary.withOpacity(0.26);

  final List<String> _popularDestinations = const [
    'Dubai',
    'Maldives',
    'Paris',
    'Bali',
    'New York',
    'Tokyo',
  ];

  final List<Hotel> _demoHotels = [
    Hotel(
      id: '1',
      name: 'Burj Al Arab Jumeirah',
      location: 'Dubai, UAE',
      hotelImage:
          "https://mywowo.net/media/images/cache/dubai_jumeirah_02_burj_al_arab_jpg_1200_630_cover_85.jpg",
      rating: 4.9,
      reviews: 4286,
      price: 899,
      amenities: ['WiFi', 'Pool', 'Spa', 'Private Beach', 'Butler Service'],
      isDeal: true,
      isFavorite: true,
      description:
          'Luxury 5-star hotel with stunning views of the Arabian Gulf.',
      distance: '5 km from city center',
    ),
    Hotel(
      id: '2',
      hotelImage:
          "https://www.fivestaralliance.com/files/fivestaralliance.com/field/image/nodes/2020/47174/0-G.jpg",
      name: 'Atlantis The Palm',
      location: 'Palm Jumeirah, Dubai',
      rating: 4.7,
      reviews: 3952,
      price: 599,
      amenities: ['WiFi', 'Water Park', 'Aquarium', 'Kids Club', 'Gym'],
      isDeal: true,
      isFavorite: false,
      description:
          'Iconic resort with underwater suites and marine adventures.',
      distance: '12 km from airport',
    ),
    Hotel(
      id: '3',
      hotelImage:
          "https://images.trvl-media.com/lodging/4000000/3040000/3033100/3033052/0ac7ba1f.jpg?impolicy=resizecrop&rw=575&rh=575&ra=fill",
      name: 'Armani Hotel Dubai',
      location: 'Burj Khalifa, Dubai',
      rating: 4.8,
      reviews: 2874,
      price: 749,
      amenities: ['WiFi', 'Spa', 'Gym', 'Fine Dining', 'City View'],
      isDeal: false,
      isFavorite: true,
      description:
          'Elegant hotel designed by Giorgio Armani in the Burj Khalifa.',
      distance: 'In downtown Dubai',
    ),
    Hotel(
      id: '4',
      hotelImage:
          "https://www.swaindestinations.com/middle-east/images/lodging/jumeirah-beach-hotel/Jumeirah_Beach_Hotel_-_Exterior_Shot_4.jpg",
      name: 'Jumeirah Beach Hotel',
      location: 'Jumeirah Beach, Dubai',
      rating: 4.6,
      reviews: 3248,
      price: 429,
      amenities: ['WiFi', 'Private Beach', 'Water Sports', 'Pool', 'Spa'],
      isDeal: true,
      isFavorite: false,
      description:
          'Wave-shaped hotel offering direct beach access and family amenities.',
      distance: '8 km from downtown',
    ),
    Hotel(
      id: '5',
      name: 'The Ritz-Carlton Dubai',
      hotelImage:
          "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/d5/66/9c/hotel-exterior.jpg?w=900&h=500&s=1",
      location: 'JBR, Dubai',
      rating: 4.8,
      reviews: 2563,
      price: 549,
      amenities: ['WiFi', 'Pool', 'Spa', 'Beach Access', 'Fine Dining'],
      isDeal: false,
      isFavorite: true,
      description: 'Luxurious beachfront resort with Arabian hospitality.',
      distance: 'On The Walk, JBR',
    ),
    Hotel(
      id: '6',
      name: 'Waldorf Astoria Dubai Palm',
      hotelImage:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5iIvMueKLr3IHP81LtwOz_X-mdQo0hhESJw&s",
      location: 'Palm Jumeirah, Dubai',
      rating: 4.7,
      reviews: 1987,
      price: 649,
      amenities: ['WiFi', 'Private Beach', 'Spa', 'Golf', 'Pool'],
      isDeal: true,
      isFavorite: false,
      description: 'Elegant retreat on the iconic Palm Jumeirah.',
      distance: 'On Palm Jumeirah',
    ),
    Hotel(
      id: '7',
      name: 'Four Seasons Resort Dubai',
      hotelImage:
          "https://images.squarespace-cdn.com/content/v1/5956050736e5d3e59a162d74/1571316067975-SCN5EWCC3BG8LID8I1XE/Dubai-Web-124-20151130.jpg",
      location: 'Jumeirah Beach, Dubai',
      rating: 4.8,
      reviews: 2341,
      price: 699,
      amenities: ['WiFi', 'Beach Club', 'Spa', 'Kids Club', 'Pool'],
      isDeal: false,
      isFavorite: false,
      description:
          'Contemporary luxury with traditional Arabian design elements.',
      distance: '7 km from Dubai Mall',
    ),
    Hotel(
      id: '8',
      name: 'Park Hyatt Dubai',
      hotelImage:
          "https://designertravel.co.uk/storage/images/ParkHyattDubaiext2/ParkHyattDubaiext2_1920.webp",
      location: 'Dubai Creek, Dubai',
      rating: 4.6,
      reviews: 1876,
      price: 399,
      amenities: ['WiFi', 'Creek View', 'Spa', 'Golf', 'Pool'],
      isDeal: true,
      isFavorite: true,
      description: 'Tranquil resort overlooking the Dubai Creek and skyline.',
      distance: 'Near Dubai Creek',
    ),
    Hotel(
      id: '9',
      name: 'Shangri-La Hotel Dubai',
      hotelImage:
          "https://middleeasttraveller-com.b-cdn.net/wp-content/uploads/2024/02/Hotel-exterior-Sea-night-time-1.jpg",
      location: 'Sheikh Zayed Road, Dubai',
      rating: 4.7,
      reviews: 2134,
      price: 449,
      amenities: ['WiFi', 'Pool', 'Spa', 'City View', 'Club Lounge'],
      isDeal: true,
      isFavorite: false,
      description: 'Iconic hotel offering panoramic views of the city.',
      distance: 'On Sheikh Zayed Road',
    ),
    Hotel(
      id: '10',
      name: 'Address Downtown Dubai',
      hotelImage:
          "https://dcxnozgahgy2a.cloudfront.net/AcuCustom/Sitename/DAM/386/address-downtown-dubai1_Main.webp",
      location: 'Downtown Dubai',
      rating: 4.8,
      reviews: 2987,
      price: 599,
      amenities: [
        'WiFi',
        'Burj Khalifa View',
        'Spa',
        'Pool',
        'Luxury Shopping'
      ],
      isDeal: true,
      isFavorite: true,
      description: 'Modern luxury hotel with direct views of Burj Khalifa.',
      distance: 'Next to Dubai Mall',
    ),
  ];

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  int get _nights =>
      _checkOutDate.difference(_checkInDate).inDays.clamp(1, 365);

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMM dd');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header (smaller)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: _border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    style:
                        IconButton.styleFrom(padding: const EdgeInsets.all(6)),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Hotels',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Iconsax.search_normal, size: 18, color: _accent),
                    style:
                        IconButton.styleFrom(padding: const EdgeInsets.all(6)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Iconsax.filter, size: 18, color: _accent),
                    style:
                        IconButton.styleFrom(padding: const EdgeInsets.all(6)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Iconsax.map, size: 18, color: _accent),
                    style:
                        IconButton.styleFrom(padding: const EdgeInsets.all(6)),
                  ),
                ],
              ),
            ),

            // Compact Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Iconsax.location, size: 18, color: _accent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Where to?',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _locationController.text.isEmpty
                                      ? 'Dubai, UAE'
                                      : _locationController.text,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Iconsax.calendar,
                                    size: 14, color: _accent),
                                const SizedBox(width: 6),
                                Text(
                                  '${dateFmt.format(_checkInDate)}-${dateFmt.format(_checkOutDate)}',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.search_normal,
                          size: 18, color: Colors.white),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

            // Popular Destinations (smaller chips)
            SizedBox(
              height: 34,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: _popularDestinations.map((destination) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(destination),
                      onPressed: () => setState(() {
                        _locationController.text = destination;
                      }),
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: _border),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // Results Header (compact)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_demoHotels.length} hotels found',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Dubai, UAE • ${dateFmt.format(_checkInDate)}-${dateFmt.format(_checkOutDate)} • $_guests Guests',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Iconsax.sort, size: 18, color: _accent),
                    style:
                        IconButton.styleFrom(padding: const EdgeInsets.all(6)),
                  ),
                ],
              ),
            ),

            // Hotels List (smaller padding)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                itemCount: _demoHotels.length,
                itemBuilder: (_, index) =>
                    _buildHotelCard(context, _demoHotels[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelCard(BuildContext context, Hotel hotel) {
    final total = (hotel.price * _nights).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image (shorter)
          Stack(
            children: [
              // Image (network)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: Image.network(
                        hotel.hotelImage,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: AppColors.surfaceDark,
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: AppColors.secondary,
                                value: progress.expectedTotalBytes == null
                                    ? null
                                    : progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.surfaceDark,
                          alignment: Alignment.center,
                          child: Icon(Iconsax.image,
                              size: 36, color: AppColors.secondary),
                        ),
                      ),
                    ),
                  ),

                  // Gradient overlay (so text is readable)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Rating pill
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                            color: AppColors.secondary.withOpacity(0.26)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star,
                              size: 12, color: AppColors.accentYellow),
                          const SizedBox(width: 4),
                          Text(
                            hotel.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            ' (${hotel.reviews})',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Deal pill
                  if (hotel.isDeal)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Best Deal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Distance text
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(
                      hotel.distance,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              // Rating pill
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: _border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 12, color: AppColors.accentYellow),
                      const SizedBox(width: 4),
                      Text(
                        hotel.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ' (${hotel.reviews})',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Deal pill
              if (hotel.isDeal)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Best Deal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Distance text
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Text(
                  hotel.distance,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // Details (tighter)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Favorite
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel.name,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Iconsax.location, size: 14, color: _accent),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  hotel.location,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          hotel.isFavorite ? Iconsax.heart : Iconsax.heart,
                          color: hotel.isFavorite
                              ? AppColors.error
                              : AppColors.textTertiary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  hotel.description,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Amenities (smaller)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: hotel.amenities.take(3).map((amenity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getAmenityIcon(amenity),
                              size: 12, color: _accent),
                          const SizedBox(width: 5),
                          Text(
                            amenity,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                if (hotel.amenities.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '+${hotel.amenities.length - 3} more',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // Price + Button (compact)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '\$${hotel.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '/night',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Total: \$$total for $_nights night${_nights > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HotelDetailsScreen(
                                hotel: hotel,
                                checkIn: _checkInDate,
                                checkOut: _checkOutDate,
                                guests: _guests,
                                rooms: _rooms,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Book',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Iconsax.wifi;
      case 'pool':
        return Iconsax.drop;
      case 'spa':
        return Iconsax.health;
      case 'private beach':
        return Icons.beach_access_sharp;
      case 'butler service':
        return Iconsax.profile_2user;
      case 'water park':
        return Iconsax.safe_home;
      case 'aquarium':
        return Iconsax.activity;
      case 'kids club':
        return Iconsax.emoji_happy;
      case 'gym':
        return Iconsax.health;
      case 'fine dining':
        return Iconsax.cup;
      case 'city view':
        return Iconsax.buildings;
      case 'water sports':
        return Iconsax.ship;
      case 'beach access':
        return Icons.beach_access;
      case 'golf':
        return Icons.golf_course;
      case 'club lounge':
        return Iconsax.crown;
      case 'luxury shopping':
        return Iconsax.shop;
      case 'burj khalifa view':
        return Iconsax.buildings_2;
      default:
        return Iconsax.tick_circle;
    }
  }
}

// ------------------ BLoC (simple demo) ------------------

abstract class HotelsEvent {}

class LoadHotels extends HotelsEvent {}

class SearchHotels extends HotelsEvent {
  final String location;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;

  SearchHotels({
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
  });
}

class ApplyFilters extends HotelsEvent {
  final int minPrice;
  final int maxPrice;
  final double minRating;
  final List<String> amenities;

  ApplyFilters({
    required this.minPrice,
    required this.maxPrice,
    required this.minRating,
    required this.amenities,
  });
}

abstract class HotelsState {}

class HotelsInitial extends HotelsState {}

class HotelsLoading extends HotelsState {}

class HotelsLoaded extends HotelsState {
  final List<Hotel> hotels;
  HotelsLoaded(this.hotels);
}

class HotelsError extends HotelsState {
  final String message;
  HotelsError(this.message);
}

// class Hotel {
//   final String id;
//   final String name;
//   final String location;
//   final double rating;
//   final int reviews;
//   final double price;
//   final List<String> amenities;
//   final bool isDeal;
//   final bool isFavorite;
//   final String description;
//   final String distance;
//   final String hotelImage;

//   Hotel({
//     required this.id,
//     required this.name,
//     required this.location,
//     required this.rating,
//     required this.reviews,
//     required this.price,
//     required this.amenities,
//     required this.hotelImage,
//     this.isDeal = false,
//     this.isFavorite = false,
//     required this.description,
//     required this.distance,
//   });
// }

class HotelsBloc extends Bloc<HotelsEvent, HotelsState> {
  HotelsBloc() : super(HotelsInitial()) {
    on<LoadHotels>((event, emit) async {
      emit(HotelsLoading());
      await Future.delayed(const Duration(milliseconds: 450));
      emit(HotelsLoaded([])); // connect your API here
    });

    on<SearchHotels>((event, emit) async {
      emit(HotelsLoading());
      await Future.delayed(const Duration(milliseconds: 450));
      emit(HotelsLoaded([])); // connect your API here
    });

    on<ApplyFilters>((event, emit) async {
      // implement filters in your repository
    });
  }
}
