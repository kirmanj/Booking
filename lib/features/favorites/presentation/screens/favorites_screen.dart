import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<FavoriteItem> _favorites = [
    FavoriteItem(
      id: '1',
      title: 'Bali Paradise Resort',
      subtitle: '5-star Hotel in Kuta',
      image: 'assets/images/hotel1.jpg',
      type: 'Hotel',
      rating: 4.8,
      price: '\$299',
      isLiked: true,
    ),
    FavoriteItem(
      id: '2',
      title: 'Tokyo to Seoul Flight',
      subtitle: 'Round Trip • Japan Airlines',
      image: 'assets/images/flight1.jpg',
      type: 'Flight',
      rating: 4.5,
      price: '\$420',
      isLiked: true,
    ),
    FavoriteItem(
      id: '3',
      title: 'Premium SUV Rental',
      subtitle: '7 Days • Free Cancellation',
      image: 'assets/images/car1.jpg',
      type: 'Car',
      rating: 4.7,
      price: '\$599',
      isLiked: true,
    ),
    FavoriteItem(
      id: '4',
      title: 'Santorini Sunset Tour',
      subtitle: 'Guided Tour • 5 Hours',
      image: 'assets/images/tour1.jpg',
      type: 'Tour',
      rating: 4.9,
      price: '\$189',
      isLiked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'My Favorites',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: false,
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.search_normal, size: 22),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Iconsax.more, size: 22),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Stats Card
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved Items',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '24',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Across all categories',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.heart,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Filter Chips
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFilterChip('All', true),
              const SizedBox(width: 8),
              _buildFilterChip('Hotels', false),
              const SizedBox(width: 8),
              _buildFilterChip('Flights', false),
              const SizedBox(width: 8),
              _buildFilterChip('Cars', false),
              const SizedBox(width: 8),
              _buildFilterChip('Tours', false),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Favorites List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              return _buildFavoriteCard(_favorites[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isActive) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
          width: 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(FavoriteItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image with Overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  height: 180,
                  color: AppColors.primary,
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.accentYellow,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor(item.type),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          // item.isLiked = !item.isLiked;
                        });
                      },
                      icon: Icon(
                        item.isLiked ? Iconsax.heart_circle : Iconsax.heart,
                        color: item.isLiked
                            ? AppColors.error
                            : AppColors.textTertiary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.price,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'hotel':
        return AppColors.accentPurple;
      case 'flight':
        return AppColors.accentGreen;
      case 'car':
        return AppColors.accentOrange;
      case 'tour':
        return AppColors.accentRed;
      default:
        return AppColors.primary;
    }
  }
}

class FavoriteItem {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String type;
  final double rating;
  final String price;
  bool isLiked;

  FavoriteItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.type,
    required this.rating,
    required this.price,
    required this.isLiked,
  });
}
