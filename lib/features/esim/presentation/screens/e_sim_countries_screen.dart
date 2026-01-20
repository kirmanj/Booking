import 'package:aman_booking/features/esim/bloc/e_sim_bloc.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_event.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_state.dart';
import 'package:aman_booking/features/esim/data/models/e_sim_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/features/esim/presentation/screens/e_sim_packages_screen.dart';

class ESimCountriesScreen extends StatefulWidget {
  const ESimCountriesScreen({super.key});

  @override
  State<ESimCountriesScreen> createState() => _ESimCountriesScreenState();
}

class _ESimCountriesScreenState extends State<ESimCountriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedRegion;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _ModernAppBar(
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Search Bar Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: _ModernSearchBar(
                        controller: _searchController,
                        onChanged: (query) {
                          context.read<ESimBloc>().add(SearchCountries(query));
                          setState(() {});
                        },
                        onClear: () {
                          _searchController.clear();
                          context
                              .read<ESimBloc>()
                              .add(const SearchCountries(''));
                          setState(() {});
                        },
                      ),
                    ),
                  ),

                  // Region Filters
                  SliverToBoxAdapter(
                    child: _ModernRegionFilters(
                      selectedRegion: _selectedRegion,
                      onRegionSelected: (region) {
                        setState(() {
                          _selectedRegion = region;
                        });
                        context.read<ESimBloc>().add(
                              FilterCountriesByRegion(region),
                            );
                      },
                    ),
                  ),

                  // Countries List
                  BlocBuilder<ESimBloc, ESimState>(
                    builder: (context, state) {
                      if (state is ESimLoading) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }

                      if (state is CountriesLoaded) {
                        if (state.displayedCountries.isEmpty) {
                          return SliverFillRemaining(
                            child: _EmptyState(),
                          );
                        }

                        final showPopularSection =
                            state.popularDestinations.isNotEmpty &&
                                _selectedRegion == null &&
                                (state.searchQuery?.isEmpty ?? true);

                        // Calculate countries not in popular section
                        final nonPopularCountries = showPopularSection
                            ? state.displayedCountries
                                .where((c) =>
                                    !state.popularDestinations.contains(c))
                                .toList()
                            : state.displayedCountries;

                        return SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                // Show popular section first
                                if (index == 0 && showPopularSection) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const _SectionHeader(
                                        icon: Iconsax.star_1,
                                        title: 'Popular Destinations',
                                        color: AppColors.accentOrange,
                                      ),
                                      const SizedBox(height: 12),
                                      ...state.popularDestinations
                                          .map((country) {
                                        return _ModernCountryCard(
                                          country: country as ESimCountry,
                                          isPopular: true,
                                          onTap: () =>
                                              _selectCountry(context, country),
                                        );
                                      }).toList(),
                                      const SizedBox(height: 24),
                                      const _SectionHeader(
                                        icon: Iconsax.global,
                                        title: 'All Destinations',
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  );
                                }

                                // Calculate adjusted index for non-popular countries
                                final adjustedIndex =
                                    showPopularSection ? index - 1 : index;

                                if (adjustedIndex < 0 ||
                                    adjustedIndex >= nonPopularCountries.length) {
                                  return const SizedBox.shrink();
                                }

                                final country =
                                    nonPopularCountries[adjustedIndex]
                                        as ESimCountry;

                                return _ModernCountryCard(
                                  country: country,
                                  isPopular: false,
                                  onTap: () => _selectCountry(context, country),
                                );
                              },
                              childCount: showPopularSection
                                  ? nonPopularCountries.length + 1
                                  : nonPopularCountries.length,
                            ),
                          ),
                        );
                      }

                      if (state is ESimError) {
                        return SliverFillRemaining(
                          child: _ErrorState(
                            message: state.message,
                            onRetry: () {
                              context
                                  .read<ESimBloc>()
                                  .add(const LoadCountries());
                            },
                          ),
                        );
                      }

                      return const SliverFillRemaining(
                        child: SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectCountry(BuildContext context, ESimCountry country) {
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
  }
}

class _ModernAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const _ModernAppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
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
          IconButton(
            onPressed: onBack,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Destination',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Select your travel destination',
                  style: TextStyle(
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

class _ModernSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _ModernSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search countries or regions...',
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary.withOpacity(0.6),
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              Iconsax.search_normal_1,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: onClear,
                )
              : null,
          filled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

class _ModernRegionFilters extends StatelessWidget {
  final String? selectedRegion;
  final ValueChanged<String?> onRegionSelected;

  const _ModernRegionFilters({
    required this.selectedRegion,
    required this.onRegionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final regions = [
      ('All', Iconsax.global),
      ('Europe', Iconsax.location),
      ('Asia', Iconsax.location),
      ('Americas', Iconsax.location),
      ('Middle East', Iconsax.location),
      ('Oceania', Iconsax.location),
      ('Africa', Iconsax.location),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: regions.map((regionData) {
          final region = regionData.$1;
          final icon = regionData.$2;
          final isSelected = region == 'All'
              ? selectedRegion == null
              : selectedRegion == region;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _RegionChip(
              label: region,
              icon: icon,
              isSelected: isSelected,
              onTap: () {
                onRegionSelected(region == 'All' ? null : region);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RegionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RegionChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.2)
                  : AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class _ModernCountryCard extends StatelessWidget {
  final ESimCountry country;
  final bool isPopular;
  final VoidCallback onTap;

  const _ModernCountryCard({
    required this.country,
    required this.isPopular,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isPopular
                    ? AppColors.accentOrange.withOpacity(0.3)
                    : AppColors.border.withOpacity(0.3),
                width: isPopular ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isPopular
                      ? AppColors.accentOrange.withOpacity(0.1)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Flag Container
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      country.flagEmoji,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              country.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          if (isPopular)
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
                                    size: 12,
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
                          Icon(
                            Iconsax.location,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            country.region,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (country.isRegional) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${country.coverageCountries.length}+ countries',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'From \$4.99',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Arrow
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Iconsax.arrow_right_3,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Iconsax.search_normal,
              size: 64,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No countries found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different search or filter',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Iconsax.danger,
              size: 64,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Error loading countries',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
