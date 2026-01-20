import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aman_booking/core/constants/app_colors.dart';

class TourScreen extends StatelessWidget {
  const TourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Book Hotels',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Section
            Text(
              'Where do you want to stay?',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                hintText: 'City, hotel name, or landmark',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                      context, 'Check-in', Icons.calendar_today),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(
                      context, 'Check-out', Icons.calendar_today),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Search Hotels',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Popular Hotels Section
            Text(
              'Popular Hotels',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            ..._buildHotelCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String label, IconData icon) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () {
        // Show date picker
      },
    );
  }

  List<Widget> _buildHotelCards() {
    final hotels = [
      {
        'name': 'Luxury Beach Resort',
        'location': 'Maldives',
        'price': '\$299',
        'rating': '4.8'
      },
      {
        'name': 'City Center Hotel',
        'location': 'Dubai',
        'price': '\$189',
        'rating': '4.5'
      },
      {
        'name': 'Mountain View Lodge',
        'location': 'Switzerland',
        'price': '\$249',
        'rating': '4.7'
      },
    ];

    return hotels.map((hotel) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.hotel, color: AppColors.primary),
          ),
          title: Text(
            hotel['name']!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                hotel['location']!,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    hotel['rating']!,
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          trailing: Text(
            hotel['price']!,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }).toList();
  }
}
