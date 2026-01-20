// lib/features/home_checkin/presentation/screens/service_info_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/home_checkin/presentation/bloc/home_checkin_bloc.dart';
import 'package:aman_booking/features/home_checkin/presentation/screens/airline_policy_screen.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ServiceInfoScreen extends StatelessWidget {
  const ServiceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with gradient
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Iconsax.home,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Home Check-In Service',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Skip the airport queues - We bring check-in to you!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.95),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // What is it?
                  _buildWhatIsItSection(),
                  const SizedBox(height: 32),

                  // Benefits
                  _buildSectionTitle('Why Choose Home Check-In?'),
                  const SizedBox(height: 16),
                  _buildBenefitsList(),
                  const SizedBox(height: 32),

                  // How it Works
                  _buildSectionTitle('How It Works'),
                  const SizedBox(height: 16),
                  _buildHowItWorksSteps(),
                  const SizedBox(height: 32),

                  // Pricing
                  _buildPricingCard(),
                  const SizedBox(height: 32),

                  // Get Started Button
                  _buildGetStartedButton(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatIsItSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.secondary.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.info_circle,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'What is Home Check-In?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Home Check-In is a premium convenience service designed for busy travelers. Our professional team comes to your home or office to:',
            style: TextStyle(
              fontSize: 12,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          _buildCheckItem('✓ Collect your luggage securely'),
          _buildCheckItem('✓ Check your bags at the airport'),
          _buildCheckItem('✓ Process your boarding pass'),
          _buildCheckItem('✓ Deliver your boarding pass to you'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Iconsax.tick_circle,
                    color: AppColors.accentGreen, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Result: Go directly to passport control!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildBenefitsList() {
    final benefits = [
      {
        'icon': Iconsax.timer_1,
        'title': 'Save Precious Time',
        'description': 'No more standing in long check-in queues',
        'color': AppColors.primary,
      },
      {
        'icon': Iconsax.security_safe,
        'title': 'Professional & Secure',
        'description': 'Licensed handlers with insurance coverage',
        'color': AppColors.accentGreen,
      },
      {
        'icon': Iconsax.home_2,
        'title': 'Ultimate Convenience',
        'description': 'Service right at your doorstep',
        'color': AppColors.secondary,
      },
      {
        'icon': Iconsax.ticket,
        'title': 'Digital Boarding Pass',
        'description': 'Instant delivery to your device',
        'color': AppColors.accentOrange,
      },
      {
        'icon': Iconsax.airplane,
        'title': 'Stress-Free Travel',
        'description': 'Start your journey relaxed and on time',
        'color': AppColors.primary,
      },
    ];

    return Column(
      children: benefits.map((benefit) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (benefit['color'] as Color),
                      (benefit['color'] as Color).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: (benefit['color'] as Color).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  benefit['icon'] as IconData,
                  color: Colors.white,
                  size: 14,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      benefit['description'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.4,
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

  Widget _buildHowItWorksSteps() {
    final steps = [
      {
        'number': '1',
        'title': 'Book Online',
        'description': 'Select your airline and provide flight details',
        'icon': Iconsax.mobile,
      },
      {
        'number': '2',
        'title': 'Review Policies',
        'description': 'Read and accept airline baggage policies',
        'icon': Iconsax.document_text,
      },
      {
        'number': '3',
        'title': 'Schedule Pickup',
        'description': 'Choose convenient time and location',
        'icon': Iconsax.calendar,
      },
      {
        'number': '4',
        'title': 'We Collect',
        'description': 'Our team picks up your bags safely',
        'icon': Iconsax.box,
      },
      {
        'number': '5',
        'title': 'Track Progress',
        'description': 'Real-time updates on your phone',
        'icon': Iconsax.location,
      },
      {
        'number': '6',
        'title': 'Get Boarding Pass',
        'description': 'Digital pass delivered instantly',
        'icon': Iconsax.ticket,
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
                  width: 40,
                  height: 40,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 3,
                    height: 30,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.2),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        step['icon'] as IconData,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step['description'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
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

  Widget _buildPricingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withOpacity(0.12),
            AppColors.primary.withOpacity(0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.wallet_3,
              size: 30,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Service Fee',
            style: TextStyle(
              fontSize: 12,
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
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '49',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  height: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '.99',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Per booking • One-time payment',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGreen,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Includes home pickup, airport check-in,\nand boarding pass delivery',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return BlocBuilder<HomeCheckInBloc, HomeCheckInState>(
      builder: (context, state) {
        final isLoading = state is HomeCheckInLoading;

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
            onPressed: isLoading
                ? null
                : () {
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
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Get Started Now',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Iconsax.arrow_right_3,
                          size: 24, color: Colors.white),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
