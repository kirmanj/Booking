import 'dart:convert';
import 'dart:typed_data';

import 'package:aman_booking/features/flights/booking/presentation/flight_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/flights/bloc/flights_bloc.dart';
import 'package:aman_booking/features/flights/bloc/flights_event.dart';
import 'package:aman_booking/features/flights/bloc/flights_state.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class FlightsScreen extends StatelessWidget {
  const FlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlightsBloc()..add(const LoadFlights()),
      child: const FlightsView(),
    );
  }
}

class FlightsView extends StatefulWidget {
  const FlightsView({super.key});

  @override
  State<FlightsView> createState() => _FlightsViewState();
}

class _FlightsViewState extends State<FlightsView> {
  final TextEditingController _fromController =
      TextEditingController(text: 'Erbil (EBL)');
  final TextEditingController _toController =
      TextEditingController(text: 'Dubai (DXB)');

  DateTime _departureDate = DateTime.now().add(const Duration(days: 7));
  DateTime? _returnDate;

  int _passengers = 1;
  int _selectedTripType = 0; // 0 one-way, 1 round-trip
  String _selectedClass = 'Economy';

  // Secondary accents only for borders/icons
  Color get _accent => AppColors.secondary;
  Color get _border => AppColors.primary.withOpacity(0.28);
  Color get _chipBg => AppColors.secondary.withOpacity(0.08);

  final List<FlightCategory> _flightCategories = const [
    FlightCategory(
      title: 'Private Jet',
      subtitle: 'Luxury • Privacy • VIP',
      icon: Iconsax.airplane_square,
      imageUrl:
          'https://www.privatejetcoach.com/wp-content/uploads/2020/07/04.jpg',
    ),
    FlightCategory(
      title: 'Ambulance',
      subtitle: 'The one we hope you never need it.',
      icon: Iconsax.airplane,
      imageUrl:
          'https://www.jftjet.com/wp-content/uploads/2019/07/Air-Ambulance-–-JFT-Jet.jpg',
    ),
  ];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _showDatePicker(bool isDeparture) async {
    final initialDate = isDeparture
        ? _departureDate
        : (_returnDate ?? _departureDate.add(const Duration(days: 3)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (picked == null) return;

    setState(() {
      if (isDeparture) {
        _departureDate = picked;
        if (_selectedTripType == 1 &&
            _returnDate != null &&
            _returnDate!.isBefore(_departureDate)) {
          _returnDate = _departureDate.add(const Duration(days: 1));
        }
      } else {
        _returnDate = picked;
      }
    });
  }

  void _swapRoute() {
    setState(() {
      final temp = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = temp;
    });
  }

  void _search() {
    context.read<FlightsBloc>().add(
          SearchFlights(
            origin: _fromController.text,
            destination: _toController.text,
            departureDate: _departureDate,
            returnDate: _selectedTripType == 1 ? _returnDate : null,
            passengers: _passengers,
          ),
        );
  }

  void _showPassengerSelector() {
    int temp = _passengers;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: StatefulBuilder(
          builder: (context, setLocal) {
            return Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Passengers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _counterRow(
                    label: 'Travelers',
                    subtitle: 'Adults / total',
                    value: temp,
                    onMinus: temp > 1 ? () => setLocal(() => temp--) : null,
                    onPlus: temp < 9 ? () => setLocal(() => temp++) : null,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _passengers = temp);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _counterRow({
    required String label,
    required String subtitle,
    required int value,
    required VoidCallback? onMinus,
    required VoidCallback? onPlus,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _chipBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _border),
            ),
            child: Icon(Iconsax.profile_2user, color: _accent, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _roundBtn(Icons.remove, enabled: onMinus != null, onTap: onMinus),
          SizedBox(
            width: 32,
            child: Center(
              child: Text(
                '$value',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          _roundBtn(Icons.add, enabled: onPlus != null, onTap: onPlus),
        ],
      ),
    );
  }

  Widget _roundBtn(IconData icon,
      {required bool enabled, required VoidCallback? onTap}) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled ? _chipBg : AppColors.border.withOpacity(0.25),
          shape: BoxShape.circle,
          border: Border.all(color: enabled ? _border : Colors.transparent),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? _accent : AppColors.textTertiary,
        ),
      ),
    );
  }

  void _showClassSelector() {
    final options = const [
      'Economy',
      'Premium Economy',
      'Business',
      'First Class'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Travel Class',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...options.map((opt) {
                final selected = _selectedClass == opt;
                return ListTile(
                  dense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: selected ? _chipBg : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: selected ? _border : Colors.transparent),
                    ),
                    child: Icon(
                      opt == 'Economy'
                          ? Iconsax.user
                          : opt == 'Premium Economy'
                              ? Iconsax.user_square
                              : opt == 'Business'
                                  ? Iconsax.crown_1
                                  : Iconsax.star_1,
                      size: 18,
                      color: selected ? _accent : AppColors.textSecondary,
                    ),
                  ),
                  title: Text(
                    opt,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    _classDesc(opt),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: selected
                      ? Icon(Iconsax.tick_circle, color: _accent, size: 22)
                      : null,
                  onTap: () {
                    setState(() => _selectedClass = opt);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  String _classDesc(String opt) {
    switch (opt) {
      case 'Economy':
        return 'Standard seat & basic services';
      case 'Premium Economy':
        return 'Extra comfort & priority';
      case 'Business':
        return 'Lounge access & premium';
      case 'First Class':
        return 'Luxury suites & dining';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMM dd, EEE');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 14,
              right: 14,
              bottom: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Book Flights',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    Iconsax.setting_2,
                    size: 20,
                    color: _accent,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                children: [
                  _longCategoryCard(_flightCategories[0]),
                  const SizedBox(height: 10),
                  _longCategoryCard(_flightCategories[1]),
                  const SizedBox(height: 10),

                  // Search Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: _border),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _border),
                          ),
                          child: Row(
                            children: [
                              _tripBtn('One-way', 0),
                              _tripBtn('Round-trip', 1),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _field(
                                label: 'From',
                                controller: _fromController,
                                icon: Iconsax.location,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: _swapRoute,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 38,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _chipBg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: _border),
                                ),
                                child: Icon(Iconsax.arrow_swap_horizontal,
                                    size: 18, color: _accent),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _field(
                                label: 'To',
                                controller: _toController,
                                icon: Iconsax.location,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _tapField(
                                label: 'Departure',
                                value: dateFmt.format(_departureDate),
                                icon: Iconsax.calendar,
                                onTap: () => _showDatePicker(true),
                              ),
                            ),
                            if (_selectedTripType == 1)
                              const SizedBox(width: 10),
                            if (_selectedTripType == 1)
                              Expanded(
                                child: _tapField(
                                  label: 'Return',
                                  value: _returnDate == null
                                      ? 'Select'
                                      : dateFmt.format(_returnDate!),
                                  icon: Iconsax.calendar_1,
                                  onTap: () => _showDatePicker(false),
                                  trailing: _returnDate == null
                                      ? null
                                      : InkWell(
                                          onTap: () => setState(
                                              () => _returnDate = null),
                                          child: const Icon(
                                            Icons.close,
                                            size: 18,
                                            color: AppColors.textTertiary,
                                          ),
                                        ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _tapField(
                                label: 'Passengers',
                                value:
                                    '$_passengers Traveler${_passengers > 1 ? 's' : ''}',
                                icon: Iconsax.profile_circle,
                                onTap: _showPassengerSelector,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _tapField(
                                label: 'Class',
                                value: _selectedClass,
                                icon: Iconsax.crown,
                                onTap: _showClassSelector,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: _search,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: EdgeInsets.zero,
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.search_normal, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Search Flights',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Results
                  BlocBuilder<FlightsBloc, FlightsState>(
                    builder: (context, state) {
                      if (state is FlightsInitial) return _initialState();
                      if (state is FlightsLoading) return _loadingState();
                      if (state is FlightsError)
                        return _errorState(state.message);
                      if (state is FlightsLoaded) {
                        if (state.flights.isEmpty) return _noResultsState();
                        return Column(
                          children:
                              state.flights.map((f) => _flightCard(f)).toList(),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ NEW: airline image widget (Network)
  // You will provide flight.airlineLogoUrl (or add it in your model).

  Widget _airlineLogo(String? dataUri) {
    print('dataUri = $dataUri');

    // 1. no string → placeholder
    if (dataUri == null || dataUri.trim().isEmpty) {
      return _placeholder();
    }

    // 2. extract the base-64 payload that comes after the first comma
    final comma = dataUri.indexOf(',');
    if (comma == -1) return _placeholder(); // not a valid data-uri
    final base64 = dataUri.substring(comma + 1);

    Uint8List? bytes;
    try {
      bytes = base64Decode(base64); // 3. decode
    } catch (_) {
      return _placeholder(); // bad base-64
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _chipBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          bytes,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      ),
    );
  }

  Widget _placeholder() => Icon(Iconsax.airplane, color: _accent, size: 18);
  Widget _flightCard(FlightModel flight) {
    final timeFmt = DateFormat('HH:mm');

    String stopsText(int stops) =>
        stops == 0 ? 'Non-stop' : '$stops stop${stops > 1 ? 's' : ''}';

    final badgeColor =
        flight.stops == 0 ? AppColors.accentGreen : AppColors.accentOrange;

    // IMPORTANT:
    // Add this field to your FlightModel:
    // final String? airlineLogoUrl;
    // and pass it from API.
    final String? logoUrl = (flight as dynamic).airlineLogoUrl as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              border: Border(
                bottom: BorderSide(color: _border),
              ),
            ),
            child: Row(
              children: [
                // ✅ Airline Logo instead of code text
                _airlineLogo(logoUrl),
                const SizedBox(width: 10),

                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.airline,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        flight.flightNumber,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'From',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '\$${flight.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: badgeColor.withOpacity(0.25)),
                  ),
                  child: Text(
                    stopsText(flight.stops),
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _timeCity(
                        time: timeFmt.format(flight.departureTime),
                        city: flight.origin.split('(')[0].trim(),
                        code: flight.origin.split('(')[1].replaceAll(')', ''),
                        end: false,
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _border),
                          ),
                          child: Text(
                            flight.duration,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(Iconsax.airplane, size: 16, color: _accent),
                      ],
                    ),
                    Expanded(
                      child: _timeCity(
                        time: timeFmt.format(flight.arrivalTime),
                        city: flight.destination.split('(')[0].trim(),
                        code: flight.destination
                            .split('(')[1]
                            .replaceAll(')', ''),
                        end: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _amenity(Iconsax.bag_tick, '23kg'),
                    _amenity(Iconsax.wifi, 'WiFi'),
                    _amenity(Icons.restaurant, 'Meal'),
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlightBookingScreen(
                                flight: flight,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Select',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Small UI widgets ----------

  Widget _longCategoryCard(FlightCategory c) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              c.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: _chipBg,
                child: Center(
                  child: Icon(Iconsax.image, color: _accent, size: 22),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.68), Colors.transparent],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          c.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.92),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.9), size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripBtn(String label, int index) {
    final selected = _selectedTripType == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() {
          _selectedTripType = index;
          if (_selectedTripType == 0) _returnDate = null;
        }),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? _border : Colors.transparent),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    selected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: _accent, size: 18),
            prefixIconConstraints: const BoxConstraints(minWidth: 42),
            filled: true,
            fillColor: AppColors.surfaceDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _accent.withOpacity(0.7), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _tapField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                Icon(icon, color: _accent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: value == 'Select'
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing ??
                    Icon(Iconsax.arrow_down_1,
                        size: 16, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _timeCity({
    required String time,
    required String city,
    required String code,
    required bool end,
  }) {
    return Column(
      crossAxisAlignment:
          end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          code,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _amenity(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- States ----------

  Widget _initialState() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        children: [
          Icon(Iconsax.airplane_square,
              size: 64, color: AppColors.primary.withOpacity(0.18)),
          const SizedBox(height: 10),
          const Text(
            'Find Your Flight',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Search between Erbil and Dubai',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _loadingState() {
    return const Padding(
      padding: EdgeInsets.only(top: 18),
      child: Column(
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 10),
          Text(
            'Searching…',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _noResultsState() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        children: [
          Icon(Iconsax.search_status,
              size: 64, color: AppColors.accentOrange.withOpacity(0.22)),
          const SizedBox(height: 10),
          const Text(
            'No flights found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try changing dates or passengers',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              setState(() {
                _returnDate = null;
                _passengers = 1;
                _selectedClass = 'Economy';
                _selectedTripType = 0;
              });
            },
            child: const Text(
              'Reset',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorState(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        children: [
          Icon(Iconsax.warning_2,
              size: 64, color: AppColors.error.withOpacity(0.25)),
          const SizedBox(height: 10),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () =>
                context.read<FlightsBloc>().add(const LoadFlights()),
            child: const Text(
              'Try again',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class FlightCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final String imageUrl;

  const FlightCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imageUrl,
  });
}
