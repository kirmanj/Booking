import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/features/flights/bloc/flights_state.dart';
import 'flight_booking_event.dart';
import 'flight_booking_state.dart';
import 'dart:math';

class FlightBookingBloc extends Bloc<FlightBookingEvent, FlightBookingState> {
  FlightBookingBloc() : super(const FlightBookingInitial()) {
    on<LoadFlightBooking>(_onLoadFlightBooking);
    on<AddTraveler>(_onAddTraveler);
    on<RemoveTraveler>(_onRemoveTraveler);
    on<UpdateTraveler>(_onUpdateTraveler);
    on<UpdateContactInfo>(_onUpdateContactInfo);
    on<ConfirmBooking>(_onConfirmBooking);
  }

  Future<void> _onLoadFlightBooking(
    LoadFlightBooking event,
    Emitter<FlightBookingState> emit,
  ) async {
    emit(const FlightBookingLoading());

    try {
      // Simulate loading flight details
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock flight data (in production, fetch from repository)
      final flight = FlightModel(
        id: event.flightId,
        airline: 'Emirates',
        airlineCode: 'EK',
        origin: 'Erbil (EBL)',
        destination: 'Dubai (DXB)',
        airlineLogoUrl: '',
        departureTime: DateTime.now().add(const Duration(days: 7, hours: 10)),
        arrivalTime: DateTime.now().add(const Duration(days: 7, hours: 13)),
        price: 599.00,
        stops: 0,
        flightNumber: 'EK201',
      );

      emit(FlightBookingLoaded(
        flight: flight,
        travelers: [],
        totalPrice: flight.price,
      ));
    } catch (e) {
      emit(FlightBookingError('Failed to load booking: ${e.toString()}'));
    }
  }

  Future<void> _onAddTraveler(
    AddTraveler event,
    Emitter<FlightBookingState> emit,
  ) async {
    if (state is FlightBookingLoaded) {
      final currentState = state as FlightBookingLoaded;
      final newTravelers = List<TravelerModel>.from(currentState.travelers)
        ..add(event.traveler);

      final newTotalPrice = currentState.flight.price * newTravelers.length;

      emit(currentState.copyWith(
        travelers: newTravelers,
        totalPrice: newTotalPrice,
      ));
    }
  }

  Future<void> _onRemoveTraveler(
    RemoveTraveler event,
    Emitter<FlightBookingState> emit,
  ) async {
    if (state is FlightBookingLoaded) {
      final currentState = state as FlightBookingLoaded;
      
      if (currentState.travelers.length > 1) {
        final newTravelers = List<TravelerModel>.from(currentState.travelers)
          ..removeAt(event.index);

        final newTotalPrice = currentState.flight.price * newTravelers.length;

        emit(currentState.copyWith(
          travelers: newTravelers,
          totalPrice: newTotalPrice,
        ));
      }
    }
  }

  Future<void> _onUpdateTraveler(
    UpdateTraveler event,
    Emitter<FlightBookingState> emit,
  ) async {
    if (state is FlightBookingLoaded) {
      final currentState = state as FlightBookingLoaded;
      final newTravelers = List<TravelerModel>.from(currentState.travelers);
      newTravelers[event.index] = event.traveler;

      emit(currentState.copyWith(travelers: newTravelers));
    }
  }

  Future<void> _onUpdateContactInfo(
    UpdateContactInfo event,
    Emitter<FlightBookingState> emit,
  ) async {
    if (state is FlightBookingLoaded) {
      final currentState = state as FlightBookingLoaded;
      emit(currentState.copyWith(
        contactEmail: event.email,
        contactPhone: event.phone,
      ));
    }
  }

  Future<void> _onConfirmBooking(
    ConfirmBooking event,
    Emitter<FlightBookingState> emit,
  ) async {
    if (state is FlightBookingLoaded) {
      final currentState = state as FlightBookingLoaded;

      emit(const FlightBookingLoading());

      try {
        // Simulate booking API call
        await Future.delayed(const Duration(seconds: 2));

        // Generate booking reference
        final bookingRef = _generateBookingReference();

        emit(FlightBookingConfirmed(
          bookingReference: bookingRef,
          flight: currentState.flight,
          travelers: currentState.travelers,
          totalPrice: currentState.totalPrice,
        ));
      } catch (e) {
        emit(FlightBookingError('Booking failed: ${e.toString()}'));
      }
    }
  }

  String _generateBookingReference() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
