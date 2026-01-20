// lib/features/home_checkin/presentation/screens/home_checkin_main_screen.dart
import 'package:aman_booking/features/home_checkin/presentation/screens/airline_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/home_checkin/presentation/bloc/home_checkin_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomeCheckInMainScreen extends StatelessWidget {
  const HomeCheckInMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Home Check-In Service',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.home,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Get your boarding pass & bag pickup at home',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // What is Home Check-In?
                  _buildSectionTitle('What is Home Check-In?'),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Home Check-In is a premium service that brings airport convenience to your doorstep. Our professional team will collect your luggage from your home, check it in for your flight, and deliver your boarding pass - all before you even leave for the airport!',
                    Icons.info_outline,
                    AppColors.primary,
                  ),
                  const SizedBox(height: 32),

                  // Benefits
                  _buildSectionTitle('Why Choose Home Check-In?'),
                  const SizedBox(height: 16),
                  _buildBenefitsList(),
                  const SizedBox(height: 32),

                  // How It Works
                  _buildSectionTitle('How It Works'),
                  const SizedBox(height: 16),
                  _buildHowItWorks(),
                  const SizedBox(height: 32),

                  // Pricing
                  _buildPricingCard(width),
                  const SizedBox(height: 32),

                  // Supported Airlines
                  _buildSectionTitle('Supported Airlines'),
                  const SizedBox(height: 16),
                  _buildAirlinesGrid(),
                  const SizedBox(height: 32),

                  // Get Started Button
                  _buildGetStartedButton(context, width),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoCard(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList() {
    final benefits = [
      {
        'icon': Iconsax.timer,
        'title': 'Save Time',
        'description': 'Skip long queues at the airport',
        'color': AppColors.primary,
      },
      {
        'icon': Iconsax.shield_tick,
        'title': 'Secure Service',
        'description': 'Professional handling of your luggage',
        'color': AppColors.accentGreen,
      },
      {
        'icon': Iconsax.home,
        'title': 'Home Convenience',
        'description': 'Pickup right from your doorstep',
        'color': AppColors.secondary,
      },
      {
        'icon': Iconsax.ticket,
        'title': 'Boarding Pass',
        'description': 'Delivered directly to you',
        'color': AppColors.accentOrange,
      },
      {
        'icon': Iconsax.direct,
        'title': 'Direct to Passport',
        'description': 'Go straight to security check',
        'color': AppColors.primary,
      },
    ];

    return Column(
      children: benefits.map((benefit) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (benefit['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  benefit['icon'] as IconData,
                  color: benefit['color'] as Color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      benefit['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      benefit['description'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      {
        'number': '1',
        'title': 'Book Service',
        'description': 'Select your airline and flight details',
      },
      {
        'number': '2',
        'title': 'Read Policy',
        'description': 'Review airline baggage policies',
      },
      {
        'number': '3',
        'title': 'Choose Time & Location',
        'description': 'Pick convenient pickup time and address',
      },
      {
        'number': '4',
        'title': 'Track Driver',
        'description': 'Real-time updates on bag collection',
      },
      {
        'number': '5',
        'title': 'Get Boarding Pass',
        'description': 'Receive digital boarding pass',
      },
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      step['number'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.3),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step['description'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPricingCard(double width) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          const Icon(
            Iconsax.wallet,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Service Fee',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '49.99',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'One-time payment per booking',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGreen,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Includes pickup, bag check-in, and boarding pass delivery',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAirlinesGrid() {
    return BlocBuilder<HomeCheckInBloc, HomeCheckInState>(
      builder: (context, state) {
        // Get airlines from state or use empty list
        final airlines = state is AirlinesLoaded ? state.airlines : [];

        if (airlines.isEmpty) {
          // Show loading or placeholder
          return const SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: airlines.map((airline) {
            return Container(
              width: 100,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        airline.logo,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.flight,
                            color: AppColors.primary,
                            size: 30,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    airline.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildGetStartedButton(BuildContext context, double width) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Load airlines and navigate to booking screen
          context.read<HomeCheckInBloc>().add(const LoadAirlines());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<HomeCheckInBloc>(),
                child: const AirlinePolicyScreen(),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Iconsax.arrow_right_3, size: 24),
            SizedBox(width: 12),
            Text(
              'Get Started',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
