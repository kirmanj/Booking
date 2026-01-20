import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_bloc.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_event.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_state.dart';
import 'package:aman_booking/features/esim/data/models/e_sim_models.dart';
import 'package:aman_booking/features/esim/presentation/screens/e_sim_package_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ESimPackagesScreen extends StatelessWidget {
  const ESimPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<ESimBloc, ESimState>(
          listener: (context, state) {
            if (state is PackageDetailsLoaded) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ESimBloc>(),
                    child: const ESimPackageDetailScreen(),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ESimLoading || state is ESimInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is! PackagesLoaded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select a country first',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              );
            }

            final country = state.selectedCountry;
            final packages = state.displayedPackages;

            return Column(
              children: [
                _ModernAppBar(
                  country: country,
                  packageCount: packages.length,
                  onBack: () => Navigator.pop(context),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    itemCount: packages.length,
                    itemBuilder: (_, i) {
                      final pkg = packages[i];
                      return _ModernPackageCard(
                        package: pkg,
                        country: country,
                        onTap: () => context.read<ESimBloc>().add(SelectPackage(pkg)),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ModernAppBar extends StatelessWidget {
  final ESimCountry country;
  final int packageCount;
  final VoidCallback onBack;

  const _ModernAppBar({
    required this.country,
    required this.packageCount,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          country.flagEmoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            country.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$packageCount plan${packageCount == 1 ? '' : 's'} available',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernPackageCard extends StatelessWidget {
  final ESimPackage package;
  final ESimCountry country;
  final VoidCallback onTap;

  const _ModernPackageCard({
    required this.package,
    required this.country,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = package.discount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: package.isPopular
                    ? AppColors.accentOrange.withOpacity(0.3)
                    : AppColors.border.withOpacity(0.2),
                width: package.isPopular ? 2 : 1,
              ),
              color: package.isPopular
                  ? AppColors.accentOrange.withOpacity(0.05)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: package.isPopular
                      ? AppColors.accentOrange.withOpacity(0.15)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.simcard_1,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title & Badges
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  package.name,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              if (package.isPopular)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentOrange,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Iconsax.star_1,
                                        size: 11,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Popular',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _InfoPill(
                                icon: Iconsax.layer,
                                text: package.dataAmount,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              _InfoPill(
                                icon: Iconsax.calendar,
                                text: package.validityText,
                                color: AppColors.accentGreen,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Features
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: package.features.take(4).map((feature) {
                    return _FeatureChip(text: feature);
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Speed Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Iconsax.flash_1,
                        size: 16,
                        color: AppColors.accentOrange,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        package.speed,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (package.callsMinutes != null || package.smsCount != null) ...[
                        const SizedBox(width: 12),
                        const Icon(
                          Iconsax.call,
                          size: 16,
                          color: AppColors.accentGreen,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          package.callsMinutes ?? 'Calls',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                // Price Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasDiscount) ...[
                            Row(
                              children: [
                                Text(
                                  '\$${package.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '-${package.discount}%',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${package.finalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  package.pricePerDay,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.arrow_right_3,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String text;

  const _FeatureChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Iconsax.tick_circle,
            size: 13,
            color: AppColors.accentGreen,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
