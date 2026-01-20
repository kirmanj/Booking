// lib/features/home_checkin/presentation/bloc/home_checkin_bloc.dart
import 'dart:async';
import 'package:aman_booking/features/home_checkin/domain/entities/home_checkin_entity.dart';
import 'package:aman_booking/features/home_checkin/domain/repositories/home_checkin_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_checkin_event.dart';
part 'home_checkin_state.dart';

class HomeCheckInBloc extends Bloc<HomeCheckInEvent, HomeCheckInState> {
  final HomeCheckInRepository repository;
  StreamSubscription<HomeCheckInBooking>? _trackingSubscription;

  HomeCheckInBloc({required this.repository})
      : super(const HomeCheckInInitial()) {
    on<LoadAirlines>(_onLoadAirlines);
    on<SelectAirline>(_onSelectAirline);
    on<LoadAirlinePolicy>(_onLoadAirlinePolicy);
    on<AcceptPolicy>(_onAcceptPolicy);
    on<LoadPickupLocations>(_onLoadPickupLocations);
    on<SelectPickupLocation>(_onSelectPickupLocation);
    on<SelectPickupDate>(_onSelectPickupDate);
    on<LoadTimeSlots>(_onLoadTimeSlots);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<CreateBooking>(_onCreateBooking);
    on<StartTracking>(_onStartTracking);
    on<UpdateTrackingStatus>(_onUpdateTrackingStatus);
    on<GetBoardingPass>(_onGetBoardingPass);
    on<SimulateStatusUpdate>(_onSimulateStatusUpdate);
    on<ResetHomeCheckIn>(_onResetHomeCheckIn);
  }

  Future<void> _onLoadAirlines(
    LoadAirlines event,
    Emitter<HomeCheckInState> emit,
  ) async {
    emit(const HomeCheckInLoading());
    try {
      final airlines = await repository.getAirlines();
      emit(AirlinesLoaded(airlines));
    } catch (e) {
      emit(HomeCheckInError(e.toString()));
    }
  }

  Future<void> _onSelectAirline(
    SelectAirline event,
    Emitter<HomeCheckInState> emit,
  ) async {
    emit(const HomeCheckInLoading());
    try {
      final airline = await repository.getAirlinePolicy(event.airlineCode);
      emit(AirlineSelected(airline));
    } catch (e) {
      emit(HomeCheckInError(e.toString()));
    }
  }

  Future<void> _onLoadAirlinePolicy(
    LoadAirlinePolicy event,
    Emitter<HomeCheckInState> emit,
  ) async {
    emit(const HomeCheckInLoading());
    try {
      final airline = await repository.getAirlinePolicy(event.airlineCode);
      emit(PolicyLoaded(airline));
    } catch (e) {
      emit(HomeCheckInError(e.toString()));
    }
  }

  Future<void> _onAcceptPolicy(
    AcceptPolicy event,
    Emitter<HomeCheckInState> emit,
  ) async {
    if (state is PolicyLoaded) {
      final currentState = state as PolicyLoaded;
      emit(PolicyLoaded(currentState.airline, policyAccepted: true));

      // Auto-load locations after accepting policy
      add(const LoadPickupLocations());
    }
  }

  Future<void> _onLoadPickupLocations(
    LoadPickupLocations event,
    Emitter<HomeCheckInState> emit,
  ) async {
    try {
      // Get airline from current state
      Airline? airline;
      if (state is PolicyLoaded) {
        airline = (state as PolicyLoaded).airline;
      } else if (state is AirlineSelected) {
        airline = (state as AirlineSelected).airline;
      }

      if (airline == null) {
        emit(const HomeCheckInError('Please select an airline first'));
        return;
      }

      emit(const HomeCheckInLoading());
      final locations = await repository.getPickupLocations();
      emit(LocationsLoaded(locations, airline));
    } catch (e) {
      emit(HomeCheckInError(e.toString()));
    }
  }

  Future<void> _onSelectPickupLocation(
    SelectPickupLocation event,
    Emitter<HomeCheckInState> emit,
  ) async {
    if (state is LocationsLoaded) {
      final currentState = state as LocationsLoaded;
      emit(LocationSelected(event.location, currentState.airline));
    }
  }

  Future<void> _onSelectPickupDate(
    SelectPickupDate event,
    Emitter<HomeCheckInState> emit,
  ) async {
    if (state is LocationSelected) {
      final currentState = state as LocationSelected;
      emit(DateSelected(
          event.date, currentState.location, currentState.airline));

      // Auto-load time slots for selected date
      add(LoadTimeSlots(event.date));
    }
  }

  Future<void> _onLoadTimeSlots(
    LoadTimeSlots event,
    Emitter<HomeCheckInState> emit,
  ) async {
    try {
      if (state is! DateSelected) return;

      final currentState = state as DateSelected;
      final timeSlots = await repository.getTimeSlots(event.date);
      emit(TimeSlotsLoaded(
        timeSlots,
        currentState.date,
        currentState.location,
        currentState.airline,
      ));
    } catch (e) {
      emit(HomeCheckInError(e.toString()));
    }
  }

  Future<void> _onSelectTimeSlot(
    SelectTimeSlot event,
    Emitter<HomeCheckInState> emit,
  ) async {
    if (state is TimeSlotsLoaded) {
      final currentState = state as TimeSlotsLoaded;
      emit(TimeSlotSelected(
        event.timeSlot,
        currentState.date,
        currentState.location,
        currentState.airline,
      ));
    }
  }

  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<HomeCheckInState> emit,
  ) async {
    emit(const HomeCheckInLoading());
    try {
      final booking = await repository.createBooking(event.booking);
      emit(BookingCreated(booking));

      // Auto-start tracking
      add(StartTracking(booking.id));
    } catch (e) {
      emit(HomeCheckInError(e.toString()));
    }
  }

  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<HomeCheckInState> emit,
  ) async {
    try {
      // Cancel previous tracking if exists
      await _trackingSubscription?.cancel();

      // Get initial booking
      final booking = await repository.getBooking(event.bookingId);
      emit(TrackingActive(booking));

      // Start listening to tracking stream
      _trackingSubscription = repository.trackBooking(event.bookingId).listen(
        (updatedBooking) {
          add(UpdateTrackingStatus(updatedBooking));
        },
        onError: (error) {
          add(const ResetHomeCheckIn());
        },
      );
    } catch (e) {
      emit(HomeCheckInError(e.toString()));
    }
  }

  Future<void> _onUpdateTrackingStatus(
    UpdateTrackingStatus event,
    Emitter<HomeCheckInState> emit,
  ) async {
    try {
      // Get driver location if driver is assigned
      DriverLocation? driverLocation;
      if (event.booking.status == BookingStatus.driverAssigned ||
          event.booking.status == BookingStatus.driverEnRoute ||
          event.booking.status == BookingStatus.bagsCollected ||
          event.booking.status == BookingStatus.atAirport) {
        driverLocation = await repository.getDriverLocation(event.booking.id);
      }

      emit(TrackingActive(event.booking, driverLocation: driverLocation));

      // If completed, get boarding pass
      if (event.booking.status == BookingStatus.completed) {
        add(GetBoardingPass(event.booking.id));
      }
    } catch (e) {
      emit(HomeCheckInError(e.toString()));
    }
  }

  Future<void> _onGetBoardingPass(
    GetBoardingPass event,
    Emitter<HomeCheckInState> emit,
  ) async {
    try {
      final currentState = state;
      HomeCheckInBooking? booking;

      if (currentState is TrackingActive) {
        booking = currentState.booking;
      }

      if (booking == null) {
        booking = await repository.getBooking(event.bookingId);
      }

      final boardingPass = await repository.getBoardingPass(event.bookingId);
      emit(BoardingPassReady(boardingPass, booking));
    } catch (e) {
      emit(HomeCheckInError(e.toString()));
    }
  }

  Future<void> _onSimulateStatusUpdate(
    SimulateStatusUpdate event,
    Emitter<HomeCheckInState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! TrackingActive) return;

      final currentBooking = currentState.booking;

      // Create updated booking with new status
      final updatedBooking = HomeCheckInBooking(
        id: currentBooking.id,
        flightNumber: currentBooking.flightNumber,
        airline: currentBooking.airline,
        airlineLogo: currentBooking.airlineLogo,
        departureCity: currentBooking.departureCity,
        arrivalCity: currentBooking.arrivalCity,
        flightDate: currentBooking.flightDate,
        flightTime: currentBooking.flightTime,
        passengerName: currentBooking.passengerName,
        passportNumber: currentBooking.passportNumber,
        nationality: currentBooking.nationality,
        pickupLocation: currentBooking.pickupLocation,
        detailedAddress: currentBooking.detailedAddress,
        pickupDate: currentBooking.pickupDate,
        pickupTime: currentBooking.pickupTime,
        numberOfBags: currentBooking.numberOfBags,
        totalWeight: currentBooking.totalWeight,
        bags: currentBooking.bags,
        status: event.newStatus,
        driverName: event.newStatus.index >= BookingStatus.driverAssigned.index
            ? currentBooking.driverName ?? 'Ahmed Al Mansouri'
            : currentBooking.driverName,
        driverPhone: event.newStatus.index >= BookingStatus.driverAssigned.index
            ? currentBooking.driverPhone ?? '+971 50 XXX XXXX'
            : currentBooking.driverPhone,
        vehicleNumber:
            event.newStatus.index >= BookingStatus.driverAssigned.index
                ? currentBooking.vehicleNumber ?? 'ABC 1234'
                : currentBooking.vehicleNumber,
        estimatedArrival:
            event.newStatus.index >= BookingStatus.driverEnRoute.index &&
                    event.newStatus.index < BookingStatus.atAirport.index
                ? '15 minutes'
                : null,
        confirmationNumber: currentBooking.confirmationNumber,
        createdAt: currentBooking.createdAt,
      );

      add(UpdateTrackingStatus(updatedBooking));
    } catch (e) {
      emit(HomeCheckInError(e.toString()));
    }
  }

  Future<void> _onResetHomeCheckIn(
    ResetHomeCheckIn event,
    Emitter<HomeCheckInState> emit,
  ) async {
    await _trackingSubscription?.cancel();
    emit(const HomeCheckInInitial());
  }

  @override
  Future<void> close() {
    _trackingSubscription?.cancel();
    return super.close();
  }
}
