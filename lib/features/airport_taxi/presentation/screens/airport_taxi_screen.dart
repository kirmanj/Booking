// lib/features/airport_taxi/presentation/screens/airport_taxi_screen.dart
// THIS FILE SERVES AS THE MAIN ENTRY POINT FOR AIRPORT TAXI SERVICE
// Contains simplified flow - expand as needed

import 'package:aman_booking/features/airport_taxi/bloc/airport_taxi_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/airport_taxi/domain/entities/airport_taxi_entity.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/core/payment/domain/entities/service_type.dart'
    as payment;
import 'package:aman_booking/core/payment/domain/entities/payment_request.dart';
import 'package:aman_booking/core/payment/domain/entities/payment_item.dart';
import 'package:aman_booking/core/payment/domain/entities/tax_item.dart';
import 'package:aman_booking/core/payment/presentation/screens/checkout_screen.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

// MAIN ENTRY SCREEN - Airport Selection
class AirportTaxiScreen extends StatelessWidget {
  const AirportTaxiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Airport Taxi Service',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          SupportButton(
            category: SupportCategory.airportTaxi,
            color: Colors.white,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<AirportTaxiBloc, AirportTaxiState>(
        listener: (context, state) {
          if (state is AirportTaxiError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error),
            );
          }

          if (state is AirportSelected) {
            // Navigate to service type selection
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<AirportTaxiBloc>(),
                  child: const ServiceTypeScreen(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AirportTaxiLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AirportsLoaded) {
            return _buildAirportList(context, state.airports);
          }

          return const Center(child: Text('Loading airports...'));
        },
      ),
    );
  }

  Widget _buildAirportList(BuildContext context, List<Airport> airports) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Select Airport',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the airport for your taxi service',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        ...airports
            .map((airport) => _buildAirportCard(context, airport))
            .toList(),
      ],
    );
  }

  Widget _buildAirportCard(BuildContext context, Airport airport) {
    return GestureDetector(
      onTap: () {
        context.read<AirportTaxiBloc>().add(SelectAirport(airport));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 70,
                height: 70,
                color: AppColors.surfaceDark,
                child: airport.imageUrl != null
                    ? Image.network(
                        airport.imageUrl!,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              airport.code,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          airport.code,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airport.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${airport.code} • ${airport.city}',
                    style:
                        TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

// SERVICE TYPE SELECTION SCREEN
class ServiceTypeScreen extends StatelessWidget {
  const ServiceTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AirportTaxiBloc>().state as AirportSelected;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Service Type',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Choose Service Type',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'Select how you want to travel',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _buildServiceTypeCard(
            context,
            icon: Iconsax.airplane,
            title: 'TO AIRPORT',
            description: 'Pick me up and take me to ${state.airport.name}',
            serviceType: ServiceType.toAirport,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          _buildServiceTypeCard(
            context,
            icon: Iconsax.car,
            title: 'FROM AIRPORT',
            description: 'Pick me up from ${state.airport.name}',
            serviceType: ServiceType.fromAirport,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required ServiceType serviceType,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<AirportTaxiBloc>().add(SelectServiceType(serviceType));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<AirportTaxiBloc>(),
              child: const LocationInputScreen(),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color),
          ],
        ),
      ),
    );
  }
}

// LOCATION INPUT SCREEN - Matches your screenshot!
class LocationInputScreen extends StatefulWidget {
  const LocationInputScreen({super.key});

  @override
  State<LocationInputScreen> createState() => _LocationInputScreenState();
}

class _LocationInputScreenState extends State<LocationInputScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _pickupLocation;
  String? _dropoffLocation;
  final List<String> _stops = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header matching screenshot
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Where Would You Like To Go?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your Personal Chauffeur Services',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Form matching screenshot style
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Date
                    _buildInputCard(
                      icon: Iconsax.calendar,
                      label: 'Date',
                      value: _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : '2026-01-17',
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 16),

                    // Time
                    _buildInputCard(
                      icon: Iconsax.clock,
                      label: 'Time',
                      value: _selectedTime != null
                          ? _selectedTime!.format(context)
                          : '10:52 PM',
                      onTap: () => _selectTime(context),
                    ),
                    const SizedBox(height: 16),

                    // From
                    _buildInputCard(
                      icon: Iconsax.location,
                      label: 'From',
                      value: _pickupLocation ?? 'Family Mall',
                      onTap: () => _showLocationPicker(context, true),
                    ),
                    const SizedBox(height: 16),

                    // To
                    _buildInputCard(
                      icon: Iconsax.location,
                      label: 'To',
                      value: _dropoffLocation ??
                          'Erbil International Airport (EIA)',
                      onTap: () => _showLocationPicker(context, false),
                    ),
                    const SizedBox(height: 16),

                    // Stop At
                    _buildInputCard(
                      icon: Iconsax.add_circle,
                      label: 'Stop At',
                      value: _stops.isEmpty
                          ? 'Stop at location'
                          : _stops.join(', '),
                      onTap: () => _addStop(context),
                    ),
                    const SizedBox(height: 32),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _continue(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  void _showLocationPicker(BuildContext context, bool isPickup) {
    // Simplified - in real app, show location picker
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isPickup
                ? 'Select Pickup Location'
                : 'Select Dropoff Location'),
            // Add location list here
          ],
        ),
      ),
    );
  }

  void _addStop(BuildContext context) {
    // Simplified
    setState(() => _stops.add('Stop ${_stops.length + 1}'));
  }

  void _continue(BuildContext context) {
    // Create demo locations
    final pickupLocation = TaxiLocation(
      id: 'pickup_1',
      name: _pickupLocation ?? 'Family Mall',
      address: 'Family Mall, Erbil',
      latitude: 36.1911,
      longitude: 44.0091,
      type: 'pickup',
    );

    final dropoffLocation = TaxiLocation(
      id: 'dropoff_1',
      name: _dropoffLocation ?? 'Erbil International Airport (EIA)',
      address: 'Erbil International Airport',
      latitude: 36.2378,
      longitude: 43.9633,
      type: 'dropoff',
    );

    // Set pickup location
    context.read<AirportTaxiBloc>().add(SetPickupLocation(pickupLocation));

    // Set dropoff location
    context.read<AirportTaxiBloc>().add(SetDropoffLocation(dropoffLocation));

    // Set date and time
    final selectedDateTime =
        _selectedDate ?? DateTime.now().add(const Duration(days: 1));
    final selectedTimeString = _selectedTime?.format(context) ?? '10:52 PM';
    context
        .read<AirportTaxiBloc>()
        .add(SetDateTime(selectedDateTime, selectedTimeString));

    // Navigate to vehicle selection
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AirportTaxiBloc>(),
          child: const VehicleSelectionScreen(),
        ),
      ),
    );
  }
}

// VEHICLE SELECTION SCREEN - Camry & Fortuner!
class VehicleSelectionScreen extends StatelessWidget {
  const VehicleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load vehicles
    context.read<AirportTaxiBloc>().add(const LoadVehicles());

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
          'Choose Your Vehicle',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<AirportTaxiBloc, AirportTaxiState>(
        builder: (context, state) {
          if (state is AirportTaxiLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VehiclesLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = state.vehicles[index];
                return _buildVehicleCard(context, vehicle);
              },
            );
          }

          return const Center(child: Text('Loading vehicles...'));
        },
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, Vehicle vehicle) {
    return GestureDetector(
      onTap: () {
        context.read<AirportTaxiBloc>().add(SelectVehicle(vehicle));
        // Navigate to confirmation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<AirportTaxiBloc>(),
              child: const BookingConfirmationScreen(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vehicle.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Model: ${vehicle.brand}',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            // Vehicle image placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 150,
                color: AppColors.surfaceDark,
                child: Image.network(
                  vehicle.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        '🚗 ${vehicle.name}',
                        style: const TextStyle(fontSize: 28),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Iconsax.user, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Capacity: ${vehicle.capacity} Passengers',
                  style:
                      TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// BOOKING CONFIRMATION SCREEN
class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Confirm Booking',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<AirportTaxiBloc, AirportTaxiState>(
        builder: (context, state) {
          if (state is! VehicleSelected) {
            return const Center(child: Text('Loading...'));
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Vehicle Info
                          _buildSectionTitle('Vehicle'),
                          _buildInfoCard(
                            icon: Iconsax.car,
                            title: state.vehicle.name,
                            subtitle:
                                '${state.vehicle.brand} - ${state.vehicle.model}',
                          ),
                          const SizedBox(height: 16),

                          // Route Info
                          _buildSectionTitle('Route'),
                          _buildInfoCard(
                            icon: Iconsax.location,
                            title: 'From: ${state.pickupLocation.name}',
                            subtitle: 'To: ${state.dropoffLocation.name}',
                          ),
                          const SizedBox(height: 16),

                          // Date & Time
                          _buildSectionTitle('Schedule'),
                          _buildInfoCard(
                            icon: Iconsax.clock,
                            title: DateFormat('MMM dd, yyyy')
                                .format(state.bookingDate),
                            subtitle: state.bookingTime,
                          ),
                          const SizedBox(height: 16),

                          // Price Estimate
                          _buildSectionTitle('Price Estimate'),
                          _buildInfoCard(
                            icon: Iconsax.dollar_circle,
                            title:
                                '\$${state.priceEstimate.totalPrice.toStringAsFixed(2)}',
                            subtitle:
                                '${state.priceEstimate.estimatedDistance.toStringAsFixed(1)} km',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _proceedToPayment(context, state),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Payment',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
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

  void _proceedToPayment(BuildContext context, VehicleSelected state) {
    // Calculate pricing
    final baseFare = state.priceEstimate.basePrice;
    final distanceFare = state.priceEstimate.distancePrice;
    final stopCharges = state.priceEstimate.stopCharges;
    final subtotal = baseFare + distanceFare + stopCharges;
    final vat = subtotal * 0.05;
    const convenienceFee = 2.0;
    final total = subtotal + vat + convenienceFee;

    // Build payment request
    final paymentRequest = PaymentRequest(
      id: 'TAXI${DateTime.now().millisecondsSinceEpoch}',
      serviceType: payment.ServiceType.airportTaxi,
      serviceName:
          '${state.pickupLocation.name} to ${state.dropoffLocation.name}',
      serviceIcon: payment.ServiceType.airportTaxi.icon,
      items: [
        PaymentItem(
          id: 'taxi_ride',
          title: state.vehicle.name,
          description:
              '${state.priceEstimate.estimatedDistance.toStringAsFixed(1)} km, ${state.priceEstimate.estimatedDuration.toInt()} mins',
          basePrice: baseFare,
          quantity: 1,
          serviceType: payment.ServiceType.airportTaxi,
          metadata: {
            'vehicle_name': state.vehicle.name,
            'vehicle_model': state.vehicle.model,
            'vehicle_brand': state.vehicle.brand,
            'vehicle_class': state.vehicle.vehicleClass,
            'pickup_location': state.pickupLocation.name,
            'pickup_address': state.pickupLocation.address,
            'dropoff_location': state.dropoffLocation.name,
            'dropoff_address': state.dropoffLocation.address,
            'booking_date': state.bookingDate.toIso8601String(),
            'booking_time': state.bookingTime,
            'estimated_distance': state.priceEstimate.estimatedDistance,
            'estimated_duration': state.priceEstimate.estimatedDuration,
            'airport': state.airport.name,
            'airport_code': state.airport.code,
            'service_type': state.serviceType.name,
          },
        ),
        if (distanceFare > 0)
          PaymentItem(
            id: 'distance_charge',
            title: 'Distance Charge',
            description:
                '${state.priceEstimate.estimatedDistance.toStringAsFixed(1)} km',
            basePrice: distanceFare,
            quantity: 1,
            serviceType: payment.ServiceType.airportTaxi,
          ),
        if (stopCharges > 0)
          PaymentItem(
            id: 'stop_charges',
            title: 'Additional Stops',
            description: '${state.stops.length} stop(s)',
            basePrice: stopCharges,
            quantity: 1,
            serviceType: payment.ServiceType.airportTaxi,
          ),
      ],
      subtotal: subtotal,
      taxes: [
        TaxItem(
          id: 'vat',
          name: 'VAT',
          amount: vat,
          percentage: 0.05,
          isInclusive: false,
        ),
      ],
      discountAmount: 0.0,
      convenienceFee: convenienceFee,
      total: total,
      currency: 'USD',
      serviceMetadata: {
        'booking_reference': 'TAXI${DateTime.now().millisecondsSinceEpoch}',
        'service_type': 'airport_taxi',
      },
      createdAt: DateTime.now(),
    );

    // Navigate to payment hub checkout
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          paymentRequest: paymentRequest,
          onPaymentComplete: (invoice) {
            // Create booking after successful payment
            final booking = TaxiBooking(
              id: '',
              airport: state.airport,
              serviceType: state.serviceType,
              pickupLocation: state.pickupLocation,
              dropoffLocation: state.dropoffLocation,
              stops: state.stops,
              vehicle: state.vehicle,
              bookingDate: state.bookingDate,
              bookingTime: state.bookingTime,
              passengerName: invoice.customerName ?? "Guest",
              //invoice.customerInfo['name'] ?? 'Guest',
              passengerPhone: invoice.customerPhone ?? '',
              passengerEmail: invoice.customerEmail ?? '',
              numberOfPassengers: 1,
              estimatedDistance: state.priceEstimate.estimatedDistance,
              totalPrice: total,
              status: BookingStatus.pending,
              confirmationNumber: invoice.invoiceNumber,
              createdAt: DateTime.now(),
            );

            context.read<AirportTaxiBloc>().add(CreateBooking(booking));

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Airport taxi booked successfully! Invoice: ${invoice.invoiceNumber}'),
                backgroundColor: AppColors.accentGreen,
              ),
            );

            // Navigate back to home
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }
}
