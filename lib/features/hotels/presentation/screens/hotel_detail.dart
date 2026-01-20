import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import 'room_booking_screen.dart'; // create below

// Support Imports
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class HotelDetailsScreen extends StatefulWidget {
  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;

  const HotelDetailsScreen({
    super.key,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
  });

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  // Secondary only for borders/icons
  Color get _accent => AppColors.secondary;
  Color get _border => AppColors.primary.withOpacity(0.26);
  Color get _chipBg => AppColors.primary.withOpacity(0.08);

  late DateTime _checkIn;
  late DateTime _checkOut;
  late int _guests;
  late int _rooms;

  int get _nights => _checkOut.difference(_checkIn).inDays.clamp(1, 365);

  final List<RoomOffer> _demoRooms = const [
    RoomOffer(
      id: 'r1',
      name: 'Deluxe King Room',
      subtitle: 'City view • 1 King bed',
      imageUrl:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1200&q=70',
      sizeSqm: 38,
      maxGuests: 2,
      refundable: true,
      breakfastIncluded: true,
      payLater: true,
      freeCancelHours: 24,
      leftCount: 3,
      pricePerNight: 210,
      taxesPerNight: 18,
      features: ['Free Wi-Fi', 'Air conditioning', 'Smart TV', 'Safe box'],
    ),
    RoomOffer(
      id: 'r2',
      name: 'Executive Suite',
      subtitle: 'Sea view • 1 King bed + lounge',
      imageUrl:
          "https://sitecore-cd-imgr.shangri-la.com/MediaFiles/A/3/E/%7BA3E0D259-9270-48D4-BE08-8822E4295B68%7DKHHK_RM_Executive_Sea_View_Suite_Bedroom_1920x940.jpg",
      sizeSqm: 62,
      maxGuests: 3,
      refundable: true,
      breakfastIncluded: true,
      payLater: false,
      freeCancelHours: 48,
      leftCount: 2,
      pricePerNight: 360,
      taxesPerNight: 28,
      features: ['Sea view', 'Lounge area', 'Bathtub', 'Priority check-in'],
    ),
    RoomOffer(
      id: 'r3',
      name: 'Family Room',
      subtitle: '2 Queen beds • Ideal for families',
      imageUrl:
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1200&q=70',
      sizeSqm: 52,
      maxGuests: 4,
      refundable: false,
      breakfastIncluded: false,
      payLater: true,
      freeCancelHours: 0,
      leftCount: 5,
      pricePerNight: 280,
      taxesPerNight: 22,
      features: ['2 Queen beds', 'Sofa corner', 'Mini fridge', 'Kids friendly'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkIn = widget.checkIn;
    _checkOut = widget.checkOut;
    _guests = widget.guests;
    _rooms = widget.rooms;
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMM dd, EEE');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            title: Text(
              widget.hotel.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              const SupportButton(
                category: SupportCategory.hotels,
                color: AppColors.textPrimary,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Iconsax.heart, size: 18, color: _accent),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),

          // Header image
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 190,
                      width: double.infinity,
                      child: Image.network(
                        widget.hotel.hotelImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.surfaceDark,
                          alignment: Alignment.center,
                          child: Icon(Iconsax.image, size: 42, color: _accent),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.60),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              widget.hotel.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _pill(
                            icon: Icons.star,
                            iconColor: AppColors.accentYellow,
                            text:
                                '${widget.hotel.rating.toStringAsFixed(1)} (${widget.hotel.reviews})',
                            bg: Colors.white,
                            textColor: AppColors.textPrimary,
                            border: _border,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Quick summary chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _pill(
                    icon: Iconsax.calendar,
                    iconColor: _accent,
                    text:
                        '${dateFmt.format(_checkIn)} → ${dateFmt.format(_checkOut)}',
                    bg: AppColors.surface,
                    textColor: AppColors.textSecondary,
                    border: _border,
                  ),
                  _pill(
                    icon: Iconsax.profile_2user,
                    iconColor: _accent,
                    text: '$_guests guest${_guests > 1 ? 's' : ''}',
                    bg: AppColors.surface,
                    textColor: AppColors.textSecondary,
                    border: _border,
                  ),
                  _pill(
                    icon: Iconsax.building_3,
                    iconColor: _accent,
                    text: '$_rooms room${_rooms > 1 ? 's' : ''}',
                    bg: AppColors.surface,
                    textColor: AppColors.textSecondary,
                    border: _border,
                  ),
                  if (widget.hotel.isDeal)
                    _pill(
                      icon: Iconsax.tick_circle,
                      iconColor: AppColors.accentGreen,
                      text: 'Best deal',
                      bg: AppColors.accentGreen.withOpacity(0.10),
                      textColor: AppColors.accentGreen,
                      border: AppColors.accentGreen.withOpacity(0.25),
                    ),
                ],
              ),
            ),
          ),

          // Overview
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About this hotel',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.hotel.description,
                      style: const TextStyle(
                        fontSize: 11.8,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.hotel.amenities.take(6).map((a) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Iconsax.tick_circle,
                                  size: 14, color: _accent),
                              const SizedBox(width: 6),
                              Text(
                                a,
                                style: const TextStyle(
                                  fontSize: 10.8,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Rooms header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Available rooms',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _chipBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: _border),
                    ),
                    child: Text(
                      '$_nights night${_nights > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 10.8,
                        fontWeight: FontWeight.w800,
                        color: _accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rooms list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final room = _demoRooms[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: _roomCard(room),
                );
              },
              childCount: _demoRooms.length,
            ),
          ),

          // Policies
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Policies',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _policyRow(
                      icon: Iconsax.clock,
                      title: 'Check-in / Check-out',
                      subtitle: 'Check-in from 14:00 • Check-out until 12:00',
                    ),
                    const SizedBox(height: 10),
                    _policyRow(
                      icon: Iconsax.note_2,
                      title: 'Important info',
                      subtitle:
                          'Prices may exclude local taxes/fees. ID may be required at check-in.',
                    ),
                    const SizedBox(height: 10),
                    _policyRow(
                      icon: Iconsax.security_safe,
                      title: 'Payment',
                      subtitle:
                          'Some rooms allow pay-later. Card may be required for guarantee.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // sticky bottom summary
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: _border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'From \$${_demoRooms.map((e) => e.pricePerNight).reduce((a, b) => a < b ? a : b).toStringAsFixed(0)} / night',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: () {
                    // scroll to rooms quickly
                    // (simple UX: just show message)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Select a room to continue')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: const Text(
                    'Choose room',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roomCard(RoomOffer room) {
    final total = room.totalPrice(
      nights: _nights,
      rooms: _rooms,
    );

    final cancelText = room.refundable
        ? 'Free cancellation (${room.freeCancelHours}h)'
        : 'Non-refundable';

    final cancelColor =
        room.refundable ? AppColors.accentGreen : AppColors.accentOrange;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // room image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            child: Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.network(
                    room.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceDark,
                      alignment: Alignment.center,
                      child: Icon(Iconsax.image, size: 34, color: _accent),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: _border),
                    ),
                    child: Text(
                      '${room.leftCount} left',
                      style: TextStyle(
                        fontSize: 10.8,
                        fontWeight: FontWeight.w800,
                        color: _accent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            room.subtitle,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${room.pricePerNight.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        const Text(
                          '/night',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // key info chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _miniChip(
                        Iconsax.profile_2user, '${room.maxGuests} guests'),
                    _miniChip(Iconsax.building_3, '${room.sizeSqm} m²'),
                    _miniChip(Iconsax.wifi, 'Wi-Fi'),
                    if (room.breakfastIncluded)
                      _miniChip(Icons.restaurant, 'Breakfast'),
                    if (room.payLater)
                      _miniChip(Icons.payments_outlined, 'Pay later'),
                  ],
                ),

                const SizedBox(height: 10),

                // cancellation
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: cancelColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cancelColor.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        room.refundable
                            ? Iconsax.tick_circle
                            : Iconsax.warning_2,
                        size: 16,
                        color: cancelColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cancelText,
                          style: TextStyle(
                            fontSize: 11.2,
                            fontWeight: FontWeight.w800,
                            color: cancelColor,
                          ),
                        ),
                      ),
                      Text(
                        '+\$${room.taxesPerNight.toStringAsFixed(0)} tax/night',
                        style: const TextStyle(
                          fontSize: 10.8,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // total + select
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total: \$${total.toStringAsFixed(0)} • $_rooms room${_rooms > 1 ? 's' : ''} • $_nights night${_nights > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 11.2,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomBookingScreen(
                                hotel: widget.hotel,
                                room: room,
                                checkIn: _checkIn,
                                checkOut: _checkOut,
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
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        child: const Text(
                          'Select',
                          style: TextStyle(
                            fontSize: 12.2,
                            fontWeight: FontWeight.w800,
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

  Widget _miniChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _accent),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10.8,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _policyRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _chipBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: Icon(icon, size: 18, color: _accent),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.2,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pill({
    required IconData icon,
    required Color iconColor,
    required String text,
    required Color bg,
    required Color textColor,
    required Color border,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.8,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Demo Models (keep same as your list) ----------
// You already have Hotel class in your list file.
// To avoid conflicts, you can either:
// 1) Import your Hotel model here instead of redefining
// OR
// 2) Keep this minimal copy matching your current fields.

class Hotel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviews;
  final double price;
  final List<String> amenities;
  final bool isDeal;
  final bool isFavorite;
  final String description;
  final String distance;
  final String hotelImage;

  const Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.amenities,
    required this.hotelImage,
    this.isDeal = false,
    this.isFavorite = false,
    required this.description,
    required this.distance,
  });
}

class RoomOffer {
  final String id;
  final String name;
  final String subtitle;
  final String imageUrl;

  final int sizeSqm;
  final int maxGuests;

  final bool refundable;
  final bool breakfastIncluded;
  final bool payLater;
  final int freeCancelHours; // 0 if not applicable

  final int leftCount;

  final double pricePerNight;
  final double taxesPerNight;

  final List<String> features;

  const RoomOffer({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.sizeSqm,
    required this.maxGuests,
    required this.refundable,
    required this.breakfastIncluded,
    required this.payLater,
    required this.freeCancelHours,
    required this.leftCount,
    required this.pricePerNight,
    required this.taxesPerNight,
    required this.features,
  });

  double totalPrice({required int nights, required int rooms}) {
    final perNight = pricePerNight + taxesPerNight;
    return perNight * nights * rooms;
  }
}
