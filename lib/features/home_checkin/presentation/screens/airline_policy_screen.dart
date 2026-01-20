// lib/features/home_checkin/presentation/screens/airline_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/home_checkin/domain/entities/home_checkin_entity.dart';
import 'package:aman_booking/features/home_checkin/presentation/bloc/home_checkin_bloc.dart';
import 'package:aman_booking/features/home_checkin/presentation/screens/booking_form_screen.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AirlinePolicyScreen extends StatefulWidget {
  const AirlinePolicyScreen({super.key});

  @override
  State<AirlinePolicyScreen> createState() => _AirlinePolicyScreenState();
}

class _AirlinePolicyScreenState extends State<AirlinePolicyScreen> {
  Airline? _selectedAirline;
  bool _policyAccepted = false;
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Airline & Review Policy',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
      ),
      body: BlocConsumer<HomeCheckInBloc, HomeCheckInState>(
        listener: (context, state) {
          if (state is PolicyLoaded && state.policyAccepted) {
            // Navigate to booking form
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<HomeCheckInBloc>(),
                  child: const BookingFormScreen(),
                ),
              ),
            );
          }
          if (state is HomeCheckInError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeCheckInLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AirlinesLoaded) {
            return _buildAirlineSelection(state.airlines);
          }

          if (state is PolicyLoaded || state is AirlineSelected) {
            final airline = state is PolicyLoaded
                ? state.airline
                : (state as AirlineSelected).airline;

            if (_selectedAirline == null) {
              _selectedAirline = airline;
            }

            return _buildPolicyReview(airline);
          }

          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }

  Widget _buildAirlineSelection(List<Airline> airlines) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Iconsax.info_circle, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select your airline to view baggage policies',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Available Airlines',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...airlines.map((airline) => _buildAirlineCard(airline)).toList(),
        ],
      ),
    );
  }

  Widget _buildAirlineCard(Airline airline) {
    final isSelected = _selectedAirline?.code == airline.code;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedAirline = airline);
        context.read<HomeCheckInBloc>().add(LoadAirlinePolicy(airline.code));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  airline.logo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print(error.toString());
                    print("airline.logo");
                    print(airline.logo);
                    print(airline);
                    print(airline.name);

                    return Center(
                      child: Icon(
                        Icons.flight,
                        size: 32,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airline.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    airline.code,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Iconsax.box,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${airline.baggageAllowance.maxCheckedBags} bags • ${airline.baggageAllowance.maxWeightPerBag}kg each',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.tick_circle,
                  color: Colors.white,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyReview(Airline airline) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Airline Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.primaryGradient,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.network(
                            airline.logo,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                airline.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Baggage Policy',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tabs
                  _buildPolicyTabs(),
                  const SizedBox(height: 20),

                  // Tab Content
                  _buildTabContent(airline),
                ],
              ),
            ),
          ),

          // Bottom Accept Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  value: _policyAccepted,
                  onChanged: (value) {
                    setState(() => _policyAccepted = value ?? false);
                  },
                  title: const Text(
                    'I have read and accept the airline baggage policy',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _policyAccepted
                        ? () {
                            context
                                .read<HomeCheckInBloc>()
                                .add(const AcceptPolicy());
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.surfaceDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Continue to Booking',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Iconsax.arrow_right_3,
                          color: Colors.white,
                        ),
                      ],
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

  Widget _buildPolicyTabs() {
    final tabs = [
      {'title': 'Checked Bags', 'icon': Iconsax.box},
      {'title': 'Carry-On', 'icon': Iconsax.bag_2},
      {'title': 'Prohibited', 'icon': Iconsax.danger},
      {'title': 'Notes', 'icon': Iconsax.note},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTab == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: AppColors.primaryGradient)
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 18,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tab['title'] as String,
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
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(Airline airline) {
    switch (_selectedTab) {
      case 0:
        return _buildCheckedBaggageSection(airline.baggageAllowance);
      case 1:
        return _buildCarryOnSection(airline.baggageAllowance);
      case 2:
        return _buildProhibitedItemsSection(airline.prohibitedItems);
      case 3:
        return _buildImportantNotesSection(airline.specialInstructions);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCheckedBaggageSection(BaggageAllowance allowance) {
    return _buildPolicySection(
      'Checked Baggage',
      Iconsax.box,
      [
        'Maximum pieces: ${allowance.maxCheckedBags}',
        'Weight per bag: ${allowance.maxWeightPerBag} kg',
        'Maximum dimensions: ${allowance.dimensions}',
        'Each bag must be properly tagged',
        'Additional bags may incur extra fees',
      ],
      AppColors.primary,
    );
  }

  Widget _buildCarryOnSection(BaggageAllowance allowance) {
    return _buildPolicySection(
      'Carry-On Luggage',
      Iconsax.bag_2,
      [
        'Maximum pieces: ${allowance.maxCarryOn}',
        'Maximum weight: ${allowance.maxCarryOnWeight} kg',
        'Must fit in overhead compartment',
        'Liquids limited to 100ml containers',
        'All liquids in clear 1L plastic bag',
      ],
      AppColors.secondary,
    );
  }

  Widget _buildProhibitedItemsSection(List<String> items) {
    return _buildPolicySection(
      'Prohibited Items',
      Iconsax.danger,
      items,
      AppColors.error,
      showBullets: true,
    );
  }

  Widget _buildImportantNotesSection(List<String> notes) {
    return _buildPolicySection(
      'Important Notes',
      Iconsax.info_circle,
      notes,
      AppColors.accentOrange,
      showBullets: true,
    );
  }

  Widget _buildPolicySection(
    String title,
    IconData icon,
    List<String> items,
    Color color, {
    bool showBullets = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showBullets) ...[
                    Container(
                      margin: const EdgeInsets.only(top: 7, right: 12),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Iconsax.tick_circle,
                      size: 18,
                      color: color,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
