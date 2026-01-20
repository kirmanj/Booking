// lib/features/home_checkin/presentation/screens/booking_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/home_checkin/domain/entities/home_checkin_entity.dart';
import 'package:aman_booking/features/home_checkin/presentation/bloc/home_checkin_bloc.dart';
import 'package:aman_booking/features/home_checkin/presentation/screens/tracking_screen.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _passengerNameController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _passportController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _addressController = TextEditingController();
  final _flightTimeController = TextEditingController(text: '10:30');

  // Selections
  PickupLocation? _selectedLocation;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String _selectedDepartureCity = 'Dubai';
  String _selectedArrivalCity = 'London';
  int _numberOfBags = 1;
  List<PickupLocation> _locationsCache = [];
  List<String> _timeSlotsCache = [];

  @override
  void initState() {
    super.initState();
    // Pre-fill with demo data
    _passengerNameController.text = 'John Doe';
    _flightNumberController.text = 'EK521';
    _passportController.text = 'AB1234567';
    _nationalityController.text = 'United States';
    _addressController.text = 'Apartment 205, Building 12, Dubai Marina';
    _flightTimeController.text = '14:30';
    _selectedDate = DateTime.now().add(const Duration(days: 2));
    _selectedTimeSlot = '09:00';

    // Load pickup locations
    context.read<HomeCheckInBloc>().add(const LoadPickupLocations());
  }

  @override
  void dispose() {
    _passengerNameController.dispose();
    _flightNumberController.dispose();
    _passportController.dispose();
    _nationalityController.dispose();
    _addressController.dispose();
    _flightTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Booking Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        actions: const [
          SupportButton(
            category: SupportCategory.homeCheckin,
            color: Colors.white,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<HomeCheckInBloc, HomeCheckInState>(
        listener: (context, state) {
          if (state is LocationsLoaded) {
            setState(() {
              _locationsCache = state.locations;
              _selectedLocation ??=
                  state.locations.isNotEmpty ? state.locations.first : null;
            });
            if (_selectedLocation != null) {
              context
                  .read<HomeCheckInBloc>()
                  .add(SelectPickupLocation(_selectedLocation!));
            }
          }
          if (state is TimeSlotsLoaded) {
            setState(() {
              _timeSlotsCache = state.timeSlots;
              _selectedTimeSlot ??=
                  state.timeSlots.isNotEmpty ? state.timeSlots.first : null;
            });
          }
          if (state is BookingCreated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<HomeCheckInBloc>(),
                  child: TrackingScreen(bookingId: state.booking.id),
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

          return Form(
            key: _formKey,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pickup Details Section
                          _buildSectionHeader(
                              'Pickup Details', Iconsax.location),
                          const SizedBox(height: 16),
                          _buildPickupDetailsSection(state),
                          const SizedBox(height: 28),

                          // Flight Information Section
                          _buildSectionHeader(
                              'Flight Information', Iconsax.airplane),
                          const SizedBox(height: 16),
                          _buildFlightInfoSection(),
                          const SizedBox(height: 28),

                          // Passenger Details Section
                          _buildSectionHeader(
                              'Passenger Details', Iconsax.user),
                          const SizedBox(height: 16),
                          _buildPassengerDetailsSection(),
                          const SizedBox(height: 28),

                          // Baggage Information Section
                          _buildSectionHeader(
                              'Baggage Information', Iconsax.box),
                          const SizedBox(height: 16),
                          _buildBaggageSection(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),

                  // Confirm Button
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
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _submitBooking(context, state),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Iconsax.tick_circle, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'Confirm Booking',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPickupDetailsSection(HomeCheckInState state) {
    List<PickupLocation> locations = _locationsCache;
    if (state is LocationsLoaded) {
      locations = state.locations;
    }

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
          // Location Dropdown
          const Text(
            'Pickup Location',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (locations.isNotEmpty)
            DropdownButtonFormField<PickupLocation>(
              value: _selectedLocation ?? locations.first,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.location, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              hint: const Text('Select your location'),
              items: locations.map((loc) {
                return DropdownMenuItem(
                  value: loc,
                  child: Text(
                    loc.name,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedLocation = value);
                if (value != null) {
                  context
                      .read<HomeCheckInBloc>()
                      .add(SelectPickupLocation(value));
                }
              },
              validator: (value) =>
                  value == null ? 'Please select a location' : null,
            )
          else
            const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 20),

          // Detailed Address
          const Text(
            'Detailed Address',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'Building, Floor, Apartment number',
              prefixIcon: const Icon(Iconsax.home_2, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLines: 2,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your address' : null,
          ),
          const SizedBox(height: 20),

          // Date Picker
          const Text(
            'Pickup Date',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.calendar, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDate != null
                        ? DateFormat('EEEE, MMM dd, yyyy')
                            .format(_selectedDate!)
                        : 'Select pickup date',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedDate != null
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Time Picker
          const Text(
            'Pickup Time',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectTime(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.clock, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _selectedTimeSlot ?? 'Select pickup time',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedTimeSlot != null
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotChip(String timeSlot) {
    final isSelected = _selectedTimeSlot == timeSlot;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedTimeSlot = timeSlot);
        context.read<HomeCheckInBloc>().add(SelectTimeSlot(timeSlot));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: AppColors.primaryGradient)
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
          ),
        ),
        child: Text(
          timeSlot,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildFlightInfoSection() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Flight Number
          TextFormField(
            controller: _flightNumberController,
            decoration: InputDecoration(
              labelText: 'Flight Number',
              hintText: 'e.g., EK521',
              prefixIcon: const Icon(Iconsax.airplane, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter flight number' : null,
          ),
          const SizedBox(height: 16),

          // From & To Cities
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDepartureCity,
                  decoration: InputDecoration(
                    labelText: 'From',
                    prefixIcon: const Icon(Iconsax.send_1, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Dubai', 'Abu Dhabi', 'Sharjah']
                      .map((city) => DropdownMenuItem(
                            value: city,
                            child: Text(city,
                                style: const TextStyle(fontSize: 12)),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedDepartureCity = value!),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedArrivalCity,
                  decoration: InputDecoration(
                    labelText: 'To',
                    prefixIcon: const Icon(Iconsax.receive_square, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['London', 'Paris', 'New York', 'Tokyo', 'Singapore']
                      .map((city) => DropdownMenuItem(
                            value: city,
                            child: Text(city,
                                style: const TextStyle(fontSize: 12)),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedArrivalCity = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Flight Time
          TextFormField(
            controller: _flightTimeController,
            decoration: InputDecoration(
              labelText: 'Departure Time',
              hintText: 'HH:MM',
              prefixIcon: const Icon(Iconsax.clock, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter departure time' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Passenger Name
          TextFormField(
            controller: _passengerNameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'As shown on passport',
              prefixIcon: const Icon(Iconsax.user, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter passenger name' : null,
          ),
          const SizedBox(height: 16),

          // Passport & Nationality
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _passportController,
                  decoration: InputDecoration(
                    labelText: 'Passport Number',
                    prefixIcon: const Icon(Iconsax.card, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _nationalityController,
                  decoration: InputDecoration(
                    labelText: 'Nationality',
                    prefixIcon: const Icon(Iconsax.flag, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBaggageSection() {
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
          const Text(
            'Number of Bags',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _numberOfBags > 1
                    ? () => setState(() => _numberOfBags--)
                    : null,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _numberOfBags > 1
                        ? AppColors.primary
                        : AppColors.surfaceDark,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: _numberOfBags > 1
                        ? Colors.white
                        : AppColors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: AppColors.primaryGradient),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        const Icon(Iconsax.box, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_numberOfBags',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    _numberOfBags == 1 ? 'Bag' : 'Bags',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              IconButton(
                onPressed: _numberOfBags < 4
                    ? () => setState(() => _numberOfBags++)
                    : null,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _numberOfBags < 4
                        ? AppColors.primary
                        : AppColors.surfaceDark,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: _numberOfBags < 4
                        ? Colors.white
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Iconsax.info_circle, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Estimated weight: ${_numberOfBags * 20} kg',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
      if (!mounted) return;
      context.read<HomeCheckInBloc>().add(SelectPickupDate(date));
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final timeString =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      setState(() => _selectedTimeSlot = timeString);
      if (!mounted) return;
      context.read<HomeCheckInBloc>().add(SelectTimeSlot(timeString));
    }
  }

  void _submitBooking(BuildContext context, HomeCheckInState state) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedLocation == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete pickup details'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Get airline from state or use default demo airline
    Airline? airline;
    if (state is LocationsLoaded) {
      airline = state.airline;
    } else if (state is TimeSlotsLoaded) {
      airline = state.airline;
    }

    // If no airline from state, use demo Emirates data
    airline ??= const Airline(
      code: 'EK',
      name: 'Emirates',
      logo:
          "data:image/png;base64,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",
      policy: 'Emirates Premium Baggage Policy',
      baggageAllowance: BaggageAllowance(
        maxCheckedBags: 2,
        maxWeightPerBag: 30,
        maxCarryOn: 1,
        maxCarryOnWeight: 7,
        dimensions: '158 cm (62 in) total',
      ),
      prohibitedItems: [],
      specialInstructions: [],
    );

    final booking = HomeCheckInBooking(
      id: '',
      flightNumber: _flightNumberController.text,
      airline: airline.name,
      airlineLogo: airline.logo,
      departureCity: _selectedDepartureCity,
      arrivalCity: _selectedArrivalCity,
      flightDate: _selectedDate!,
      flightTime: _flightTimeController.text,
      passengerName: _passengerNameController.text,
      passportNumber: _passportController.text,
      nationality: _nationalityController.text,
      pickupLocation: _selectedLocation!.name,
      detailedAddress: _addressController.text,
      pickupDate: _selectedDate!,
      pickupTime: _selectedTimeSlot!,
      numberOfBags: _numberOfBags,
      totalWeight: _numberOfBags * 20.0,
      bags: List.generate(
        _numberOfBags,
        (i) => BagItem(
          id: 'bag_$i',
          type: 'Checked',
          weight: 20.0,
          description: 'Checked bag ${i + 1}',
        ),
      ),
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );

    context.read<HomeCheckInBloc>().add(CreateBooking(booking));
  }
}
