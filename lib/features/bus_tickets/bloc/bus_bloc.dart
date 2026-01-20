import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bus_event.dart';
import 'bus_state.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  BusBloc() : super(const BusInitial()) {
    on<LoadBusHome>(_onLoadHome);
    on<SwapBusCities>(_onSwap);
    on<UpdateFromCity>(_onUpdateFrom);
    on<UpdateToCity>(_onUpdateTo);
    on<UpdateBusDate>(_onUpdateDate);
    on<UpdatePassengersCount>(_onUpdatePassengers);
    on<UpdateInternationalToggle>(_onUpdateInternational);

    on<SearchBusTrips>(_onSearchTrips);
    on<SelectBusCompany>(_onSelectCompany);

    on<BuildCompanyMonthSchedule>(_onBuildCompanySchedule);
    on<PickScheduleDay>(_onPickScheduleDay);

    on<SelectBusTrip>(_onSelectTrip);
    on<BuildSeatMap>(_onBuildSeatMap);
    on<ToggleSeat>(_onToggleSeat);

    on<ProceedToPassengers>(_onProceedToPassengers);
    on<UpdatePassengerField>(_onUpdatePassengerField);

    on<ProceedToPayment>(_onProceedToPayment);
    on<UpdatePaymentMethod>(_onUpdatePaymentMethod);
    on<ApplyPromoCode>(_onApplyPromo);
    on<ConfirmBusBooking>(_onConfirmBooking);
  }

  // cached demo data
  late List<BusCompany> _companies;
  late List<BusTrip> _allTrips;

  Future<void> _onLoadHome(LoadBusHome event, Emitter<BusState> emit) async {
    emit(const BusLoading());
    await Future.delayed(const Duration(milliseconds: 250));

    _companies = _demoCompanies();
    _allTrips = _demoTrips();

    final query = BusQuery(
      from: 'Erbil, Iraq',
      to: 'Baghdad, Iraq',
      date: DateTime.now().add(const Duration(days: 1)),
      passengers: 1,
      isInternational: false,
    );

    emit(
      BusHomeLoaded(
        query: query,
        companies: _companies,
        selectedCompany: _companies.first,
        featuredTrips: _allTrips
            .where((t) => t.from == query.from && t.to == query.to)
            .toList(),
      ),
    );
  }

  void _onSwap(SwapBusCities event, Emitter<BusState> emit) {
    final s = state;
    if (s is BusHomeLoaded) {
      emit(s.copyWith(
          query: s.query.copyWith(from: s.query.to, to: s.query.from)));
    } else if (s is BusResultsLoaded) {
      emit(BusHomeLoaded(
        query: s.query.copyWith(from: s.query.to, to: s.query.from),
        companies: s.companies,
        selectedCompany: s.companies.first,
        featuredTrips: _allTrips
            .where((t) =>
                t.from == s.query.to &&
                t.to == s.query.from &&
                (s.query.isInternational
                    ? t.borderCrossing
                    : !t.borderCrossing))
            .toList(),
      ));
    }
  }

  void _onUpdateFrom(UpdateFromCity event, Emitter<BusState> emit) {
    final s = state;
    if (s is BusHomeLoaded)
      emit(s.copyWith(
        query: s.query.copyWith(from: event.from),
        featuredTrips: _allTrips
            .where((t) =>
                t.from.toLowerCase() == event.from.toLowerCase() &&
                t.to.toLowerCase() == s.query.to.toLowerCase() &&
                (s.query.isInternational
                    ? t.borderCrossing
                    : !t.borderCrossing))
            .toList(),
      ));
  }

  void _onUpdateTo(UpdateToCity event, Emitter<BusState> emit) {
    final s = state;
    if (s is BusHomeLoaded)
      emit(s.copyWith(
        query: s.query.copyWith(to: event.to),
        featuredTrips: _allTrips
            .where((t) =>
                t.from.toLowerCase() == s.query.from.toLowerCase() &&
                t.to.toLowerCase() == event.to.toLowerCase() &&
                (s.query.isInternational
                    ? t.borderCrossing
                    : !t.borderCrossing))
            .toList(),
      ));
  }

  void _onUpdateDate(UpdateBusDate event, Emitter<BusState> emit) {
    final s = state;
    if (s is BusHomeLoaded)
      emit(s.copyWith(query: s.query.copyWith(date: event.date)));
  }

  void _onUpdatePassengers(
      UpdatePassengersCount event, Emitter<BusState> emit) {
    final s = state;
    if (s is BusHomeLoaded) {
      final c = event.count.clamp(1, 6);
      emit(s.copyWith(query: s.query.copyWith(passengers: c)));
    }
  }

  void _onUpdateInternational(
      UpdateInternationalToggle event, Emitter<BusState> emit) {
    final s = state;
    if (s is BusHomeLoaded) {
      emit(s.copyWith(
        query: s.query.copyWith(isInternational: event.isInternational),
        featuredTrips: _allTrips
            .where((t) =>
                t.from.toLowerCase() == s.query.from.toLowerCase() &&
                t.to.toLowerCase() == s.query.to.toLowerCase() &&
                (event.isInternational ? t.borderCrossing : !t.borderCrossing))
            .toList(),
      ));
    }
  }

  Future<void> _onSearchTrips(
      SearchBusTrips event, Emitter<BusState> emit) async {
    final s = state;
    if (s is! BusHomeLoaded) return;

    emit(const BusLoading());
    await Future.delayed(const Duration(milliseconds: 220));

    final q = s.query;

    final trips = _allTrips.where((t) {
      final sameFrom = t.from.toLowerCase() == q.from.toLowerCase();
      final sameTo = t.to.toLowerCase() == q.to.toLowerCase();
      final sameDay = t.departAt.year == q.date.year &&
          t.departAt.month == q.date.month &&
          t.departAt.day == q.date.day;

      final intlOk = q.isInternational ? t.borderCrossing : !t.borderCrossing;
      return sameFrom && sameTo && sameDay && intlOk;
    }).toList()
      ..sort((a, b) => a.departAt.compareTo(b.departAt));

    emit(BusResultsLoaded(query: q, companies: s.companies, trips: trips));
  }

  void _onSelectCompany(SelectBusCompany event, Emitter<BusState> emit) {
    final s = state;
    if (s is BusHomeLoaded) {
      final c = s.companies.firstWhere((x) => x.id == event.companyId,
          orElse: () => s.companies.first);
      emit(s.copyWith(selectedCompany: c));
    }
  }

  Future<void> _onBuildCompanySchedule(
    BuildCompanyMonthSchedule event,
    Emitter<BusState> emit,
  ) async {
    final s = state;
    BusQuery? q;
    List<BusCompany>? companies;
    if (s is BusHomeLoaded) {
      q = s.query;
      companies = s.companies;
    } else if (s is BusResultsLoaded) {
      q = s.query;
      companies = s.companies;
    } else {
      return;
    }

    emit(const BusLoading());
    await Future.delayed(const Duration(milliseconds: 160));

    final company = companies!.firstWhere((c) => c.id == event.companyId);
    final companyTrips = _allTrips
        .where((t) => t.companyId == company.id)
        .toList()
      ..sort((a, b) => a.departAt.compareTo(b.departAt));
    final schedule = _buildMonthSchedule(event.month, companyTrips);

    emit(BusCompanyScheduleLoaded(
      query: q!,
      company: company,
      schedule: schedule,
      trips: companyTrips,
    ));
  }

  void _onPickScheduleDay(PickScheduleDay event, Emitter<BusState> emit) {
    final s = state;
    if (s is BusCompanyScheduleLoaded) {
      // Return to home with date updated (nice UX)
      emit(
        BusHomeLoaded(
          query: s.query.copyWith(date: event.date),
          companies: _companies,
          selectedCompany: s.company,
          featuredTrips: _allTrips
              .where((t) =>
                  t.from.toLowerCase() == s.query.from.toLowerCase() &&
                  t.to.toLowerCase() == s.query.to.toLowerCase() &&
                  (s.query.isInternational
                      ? t.borderCrossing
                      : !t.borderCrossing))
              .toList(),
        ),
      );
    }
  }

  Future<void> _onSelectTrip(
      SelectBusTrip event, Emitter<BusState> emit) async {
    final s = state;
    if (s is BusResultsLoaded) {
      final trip = s.trips.firstWhere((t) => t.id == event.tripId);
      emit(BusTripDetailsLoaded(
          query: s.query, companies: s.companies, trip: trip));
    } else if (s is BusCompanyScheduleLoaded) {
      final trip = s.trips.firstWhere((t) => t.id == event.tripId);
      emit(BusTripDetailsLoaded(
          query: s.query, companies: _companies, trip: trip));
    }
  }

  Future<void> _onBuildSeatMap(
      BuildSeatMap event, Emitter<BusState> emit) async {
    final s = state;
    if (s is! BusTripDetailsLoaded) return;

    emit(const BusLoading());
    await Future.delayed(const Duration(milliseconds: 140));

    final seats = _generateSeatMap(
      total: s.trip.totalSeats,
      bookedRatio: 1 - (s.trip.seatsLeft / s.trip.totalSeats),
    );

    emit(
      BusSeatSelectionLoaded(
        query: s.query,
        companies: s.companies,
        trip: s.trip,
        seats: seats,
        selectedSeats: const [],
      ),
    );
  }

  void _onToggleSeat(ToggleSeat event, Emitter<BusState> emit) {
    final s = state;
    if (s is! BusSeatSelectionLoaded) return;

    final requiredCount = s.query.passengers;
    final seats = s.seats;

    final idx = seats.indexWhere((x) => x.code == event.seatCode);
    if (idx < 0) return;

    final seat = seats[idx];
    if (seat.status == SeatStatus.booked || seat.status == SeatStatus.blocked)
      return;

    var selected = List<String>.from(s.selectedSeats);

    if (seat.status == SeatStatus.available) {
      if (selected.length >= requiredCount)
        return; // can’t select more than passengers
      seats[idx] = seat.copyWith(status: SeatStatus.selected);
      selected.add(seat.code);
    } else if (seat.status == SeatStatus.selected) {
      seats[idx] = seat.copyWith(status: SeatStatus.available);
      selected.remove(seat.code);
    }

    emit(s.copyWith(seats: List<BusSeat>.from(seats), selectedSeats: selected));
  }

  Future<void> _onProceedToPassengers(
    ProceedToPassengers event,
    Emitter<BusState> emit,
  ) async {
    final s = state;
    if (s is! BusSeatSelectionLoaded) return;

    if (s.selectedSeats.length != s.query.passengers) {
      emit(const BusError('Please select seats equal to passengers count.'));
      return;
    }

    final passengers = List.generate(s.query.passengers, (_) => BusPassenger());
    emit(
      BusPassengersLoaded(
        query: s.query,
        companies: s.companies,
        trip: s.trip,
        selectedSeats: s.selectedSeats,
        passengers: passengers,
      ),
    );
  }

  void _onUpdatePassengerField(
      UpdatePassengerField event, Emitter<BusState> emit) {
    final s = state;
    if (s is! BusPassengersLoaded) return;

    final list = List<BusPassenger>.from(s.passengers);
    if (event.index < 0 || event.index >= list.length) return;

    final p = list[event.index];

    switch (event.field) {
      case 'firstName':
        p.firstName = event.value;
        break;
      case 'lastName':
        p.lastName = event.value;
        break;
      case 'gender':
        p.gender = event.value;
        break;
      case 'nationality':
        p.nationality = event.value;
        break;
      case 'idNumber':
        p.idNumber = event.value;
        break;
      case 'phone':
        p.phone = event.value;
        break;
      case 'email':
        p.email = event.value;
        break;
    }

    list[event.index] = p;
    emit(s.copyWith(passengers: list));
  }

  Future<void> _onProceedToPayment(
      ProceedToPayment event, Emitter<BusState> emit) async {
    final s = state;
    if (s is! BusPassengersLoaded) return;

    // Basic validation (demo)
    for (int i = 0; i < s.passengers.length; i++) {
      final p = s.passengers[i];
      if (p.firstName.trim().isEmpty || p.lastName.trim().isEmpty) {
        emit(const BusError('Please fill passengers first & last name.'));
        return;
      }
    }

    final breakdown =
        _calcPrice(s.trip.pricePerPassenger, s.query.passengers, promo: '');
    emit(
      BusPaymentLoaded(
        query: s.query,
        companies: s.companies,
        trip: s.trip,
        selectedSeats: s.selectedSeats,
        passengers: s.passengers,
        method: BusPaymentMethod.card,
        promoCode: '',
        breakdown: breakdown,
      ),
    );
  }

  void _onUpdatePaymentMethod(
      UpdatePaymentMethod event, Emitter<BusState> emit) {
    final s = state;
    if (s is! BusPaymentLoaded) return;
    emit(s.copyWith(method: event.method));
  }

  void _onApplyPromo(ApplyPromoCode event, Emitter<BusState> emit) {
    final s = state;
    if (s is! BusPaymentLoaded) return;

    final code = event.code.trim();
    final breakdown =
        _calcPrice(s.trip.pricePerPassenger, s.query.passengers, promo: code);

    emit(s.copyWith(promoCode: code, breakdown: breakdown));
  }

  Future<void> _onConfirmBooking(
      ConfirmBusBooking event, Emitter<BusState> emit) async {
    final s = state;
    if (s is! BusPaymentLoaded) return;

    emit(const BusLoading());
    await Future.delayed(const Duration(milliseconds: 380));

    final ref = _makeBookingRef();
    final booking = BusBooking(
      bookingRef: ref,
      createdAt: DateTime.now(),
      trip: s.trip,
      seats: s.selectedSeats,
      passengers: s.passengers,
      paymentMethod: s.method,
      breakdown: s.breakdown,
    );

    emit(BusTicketLoaded(booking));
  }

  // ---------------- DEMO HELPERS ----------------

  List<BusCompany> _demoCompanies() {
    return const [
      BusCompany(
        id: 'bc1',
        name: 'Noor Bus',
        logoUrl:
            'https://noorislamtransport.ae/admin/image/labor-transport-service-in-dubai-and-uae.webp',
        rating: 4.7,
        reviews: 11240,
        highlights: ['VIP lounges', 'On-time guarantee', 'Free reschedule 1x'],
        coverage: ['Erbil', 'Baghdad', 'Basra', 'Najaf', 'Kirkuk'],
        support: '24/7 WhatsApp support',
        hasWiFi: true,
        hasVIP: true,
        isFavorite: true,
      ),
      BusCompany(
        id: 'bc2',
        name: 'Sultan Coach',
        logoUrl:
            'https://coachmanluxury.com/wp-content/uploads/2019/06/Mini-Shuttle-Exterior-view.png',
        rating: 4.5,
        reviews: 8450,
        highlights: ['Low prices', 'Daily departures', 'USB charging'],
        coverage: ['Erbil', 'Duhok', 'Sulaymaniyah', 'Baghdad'],
        support: 'Ticket office + hotline',
        hasWiFi: true,
        hasVIP: false,
        isFavorite: false,
      ),
      BusCompany(
        id: 'bc3',
        name: 'Anatolia Lines (International)',
        logoUrl:
            'https://all-andorra.com/wp-content/uploads/2023/11/Istanbul-transport_bus-min.png',
        rating: 4.6,
        reviews: 5320,
        highlights: ['Border assistance', 'Sleeper seats', 'Meals included'],
        coverage: ['Erbil', 'Istanbul', 'Ankara', 'Gaziantep'],
        support: 'Border + travel documents help',
        hasWiFi: true,
        hasVIP: true,
        isFavorite: false,
      ),
    ];
  }

  List<BusTrip> _demoTrips() {
    final now = DateTime.now();
    DateTime d(int daysFromNow, int hour, int minute) =>
        DateTime(now.year, now.month, now.day)
            .add(Duration(days: daysFromNow, hours: hour, minutes: minute));

    return [
      // Domestic example: Erbil -> Baghdad (tomorrow)
      BusTrip(
        id: 't1',
        companyId: 'bc1',
        companyName: 'Noor Bus',
        from: 'Erbil, Iraq',
        to: 'Baghdad, Iraq',
        departAt: d(1, 7, 30),
        arriveAt: d(1, 12, 45),
        busClass: BusClass.vip,
        busType: 'Coach',
        plateOrCode: 'NB-ERB-BGW-0730',
        rating: 4.8,
        reviews: 2140,
        totalSeats: 44,
        seatsLeft: 13,
        pricePerPassenger: 18,
        oldPrice: 22,
        baggagePolicy: '2 bags (20kg) + 1 cabin bag',
        cancellationPolicy: 'Free cancellation up to 6 hours before departure.',
        amenities: ['WiFi', 'AC', 'Charging', 'WC', 'Snacks'],
        stops: ['Kirkuk (Stop 15m)'],
        borderCrossing: false,
      ),
      BusTrip(
        id: 't2',
        companyId: 'bc2',
        companyName: 'Sultan Coach',
        from: 'Erbil, Iraq',
        to: 'Baghdad, Iraq',
        departAt: d(1, 10, 0),
        arriveAt: d(1, 15, 30),
        busClass: BusClass.economy,
        busType: 'Coach',
        plateOrCode: 'SC-ERB-BGW-1000',
        rating: 4.4,
        reviews: 1810,
        totalSeats: 50,
        seatsLeft: 22,
        pricePerPassenger: 13,
        oldPrice: null,
        baggagePolicy: '1 bag (15kg) + cabin bag',
        cancellationPolicy: 'Change allowed up to 3 hours before departure.',
        amenities: ['AC', 'Charging'],
        stops: ['Kirkuk (Stop 10m)', 'Samarra (Stop 10m)'],
        borderCrossing: false,
      ),

      // International example: Erbil -> Istanbul (tomorrow) borderCrossing=true
      BusTrip(
        id: 't3',
        companyId: 'bc3',
        companyName: 'Anatolia Lines (International)',
        from: 'Erbil, Iraq',
        to: 'Istanbul, Turkey',
        departAt: d(1, 18, 0),
        arriveAt: d(2, 16, 0),
        busClass: BusClass.business,
        busType: 'Sleeper',
        plateOrCode: 'AL-ERB-IST-1800',
        rating: 4.7,
        reviews: 980,
        totalSeats: 38,
        seatsLeft: 9,
        pricePerPassenger: 55,
        oldPrice: 69,
        baggagePolicy: '2 bags (25kg) + cabin bag',
        cancellationPolicy:
            'Border routes: cancellation up to 12 hours before.',
        amenities: ['WiFi', 'AC', 'Charging', 'WC', 'Meals'],
        stops: [
          'Mosul (Stop 20m)',
          'Gaziantep (Stop 25m)',
          'Ankara (Stop 30m)'
        ],
        borderCrossing: true,
      ),
    ];
  }

  BusMonthSchedule _buildMonthSchedule(
      DateTime anyDayInMonth, List<BusTrip> trips) {
    final year = anyDayInMonth.year;
    final month = anyDayInMonth.month;
    final first = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final days = <BusScheduleDay>[];

    // Group trips by date to show real departures
    final tripsByDay = <int, List<BusTrip>>{};
    for (final t in trips) {
      if (t.departAt.year == year && t.departAt.month == month) {
        tripsByDay.putIfAbsent(t.departAt.day, () => []).add(t);
      }
    }

    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(year, month, d);
      final dayTrips = tripsByDay[d] ?? [];
      final samples = dayTrips
          .map((t) =>
              '${t.departAt.hour.toString().padLeft(2, '0')}:${t.departAt.minute.toString().padLeft(2, '0')}')
          .take(3)
          .toList();
      days.add(BusScheduleDay(
          date: date, tripsCount: dayTrips.length, sampleDepartures: samples));
    }

    return BusMonthSchedule(year: year, month: month, days: days);
  }

  List<BusSeat> _generateSeatMap(
      {required int total, required double bookedRatio}) {
    // layout 2 + aisle + 2 (like coach) -> 4 seats per row
    const cols = 5; // 0 1 [aisle] 3 4
    const aisleCol = 2;

    final rows = (total / 4).ceil();
    final r = Random(total);

    final seats = <BusSeat>[];
    int seatNum = 1;

    final bookedCount = (total * bookedRatio).round().clamp(0, total);

    final bookedSet = <int>{};
    while (bookedSet.length < bookedCount) {
      bookedSet.add(r.nextInt(total) + 1);
    }

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (col == aisleCol) {
          seats.add(BusSeat(
            code: 'AISLE-$row',
            row: row,
            col: col,
            isAisle: true,
            status: SeatStatus.blocked,
          ));
          continue;
        }

        if (seatNum > total) {
          seats.add(BusSeat(
            code: 'X-$row-$col',
            row: row,
            col: col,
            isAisle: false,
            status: SeatStatus.blocked,
          ));
          continue;
        }

        final code = seatNum.toString().padLeft(2, '0');
        final isBooked = bookedSet.contains(seatNum);

        seats.add(BusSeat(
          code: code,
          row: row,
          col: col,
          isAisle: false,
          status: isBooked ? SeatStatus.booked : SeatStatus.available,
        ));
        seatNum++;
      }
    }

    return seats;
  }

  BusPriceBreakdown _calcPrice(double per, int count, {required String promo}) {
    final base = per * count;
    final taxes = base * 0.05;
    final fee = base * 0.03;

    double discount = 0;
    final code = promo.trim().toUpperCase();

    if (code == 'BUS10') discount = base * 0.10;
    if (code == 'VIP5') discount = base * 0.05;

    final double total =
        (base + taxes + fee - discount).clamp(0, double.infinity);

    return BusPriceBreakdown(
      baseFare: base,
      taxes: taxes,
      serviceFee: fee,
      discount: discount,
      total: total,
    );
  }

  String _makeBookingRef() {
    final r = Random();
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(8, (_) => chars[r.nextInt(chars.length)]).join();
  }
}
