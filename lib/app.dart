import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/home/presentation/screens/home_screen.dart';

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aman Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),

        // Modern Font - Poppins
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme,
        ),

        // AppBar with Poppins font
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textDark),
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),

        // Drawer
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
          elevation: 16,
        ),

        // Buttons with Poppins
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Input fields with Poppins
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.poppins(),
          hintStyle: GoogleFonts.poppins(),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
