import 'package:aman_booking/features/esim/data/models/e_sim_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_bloc.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_event.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_state.dart';
import 'package:aman_booking/features/esim/presentation/screens/e_sim_countries_screen.dart';
import 'package:aman_booking/features/esim/presentation/screens/e_sim_packages_screen.dart';
import 'package:aman_booking/features/esim/presentation/screens/e_sim_orders_screen.dart';

class ESimScreen extends StatelessWidget {
  const ESimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ESimBloc()..add(const LoadCountries()),
      child: const _ESimHome(),
    );
  }
}

class _ESimHome extends StatelessWidget {
  const _ESimHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _ModernHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _HeroGradientCard(onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ESimBloc>(),
                            child: const ESimCountriesScreen(),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    _QuickActionGrid(context),
                    const SizedBox(height: 28),
                    _PopularDestinationsSection(),
                    const SizedBox(height: 28),
                    _FeaturesSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Iconsax.simcard_1,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'eSIM Store',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Stay connected in 150+ countries',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Iconsax.book,
                color: AppColors.secondary,
                size: 20,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ESimBloc>()..add(const LoadMyEsims()),
                    child: const ESimOrdersScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroGradientCard extends StatelessWidget {
  final VoidCallback onTap;
  const _HeroGradientCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Iconsax.global,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Iconsax.flash_1, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Instant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Explore Global\nConnectivity',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Browse destinations and get online in minutes',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Browse Destinations',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Iconsax.arrow_right_3,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _QuickActionGrid(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: _QuickActionCard(
          icon: Iconsax.location,
          title: 'Destinations',
          subtitle: 'Browse all',
          gradient: AppColors.primaryGradient,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<ESimBloc>(),
                  child: const ESimCountriesScreen(),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _QuickActionCard(
          icon: Iconsax.book_1,
          title: 'My eSIMs',
          subtitle: 'View orders',
          gradient: const [AppColors.accentOrange, AppColors.accentYellow],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<ESimBloc>()..add(const LoadMyEsims()),
                  child: const ESimOrdersScreen(),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularDestinationsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Iconsax.star_1,
                size: 18,
                color: AppColors.accentOrange,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Popular Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<ESimBloc, ESimState>(
          builder: (context, state) {
            if (state is CountriesLoaded) {
              final popular = state.popularDestinations.take(4).toList();
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: popular.map((country) {
                  return _PopularDestinationChip(
                    country: country,
                    onTap: () {
                      context.read<ESimBloc>().add(SelectCountry(country));
                      context.read<ESimBloc>().add(LoadPackagesForCountry(country.id));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ESimBloc>(),
                            child: const ESimPackagesScreen(),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _PopularDestinationChip extends StatelessWidget {
  final ESimCountry country;
  final VoidCallback onTap;

  const _PopularDestinationChip({
    required this.country,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              country.flagEmoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 10),
            Text(
              country.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Why Choose eSIM?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        _FeatureItem(
          icon: Iconsax.flash_1,
          title: 'Instant Activation',
          description: 'Get connected in minutes, no waiting',
          color: AppColors.accentYellow,
        ),
        const SizedBox(height: 12),
        _FeatureItem(
          icon: Iconsax.shield_tick,
          title: 'Secure & Reliable',
          description: 'Top-tier network providers worldwide',
          color: AppColors.accentGreen,
        ),
        const SizedBox(height: 12),
        _FeatureItem(
          icon: Iconsax.wallet_2,
          title: 'Affordable Plans',
          description: 'Competitive pricing, no hidden fees',
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        _FeatureItem(
          icon: Iconsax.call_calling,
          title: '24/7 Support',
          description: 'Always here to help you stay connected',
          color: AppColors.accentRed,
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
