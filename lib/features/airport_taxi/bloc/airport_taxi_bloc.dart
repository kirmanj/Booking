// lib/features/airport_taxi/presentation/bloc/airport_taxi_bloc.dart
import 'dart:async';
import 'package:aman_booking/features/airport_taxi/domain/entities/airport_taxi_entity.dart';
import 'package:aman_booking/features/airport_taxi/domain/repository/airport_taxi_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'airport_taxi_event.dart';
part 'airport_taxi_state.dart';

class AirportTaxiBloc extends Bloc<AirportTaxiEvent, AirportTaxiState> {
  final AirportTaxiRepository repository;
  StreamSubscription<TrackingUpdate>? _trackingSubscription;

  AirportTaxiBloc({required this.repository})
      : super(const AirportTaxiInitial()) {
    on<LoadAirports>(_onLoadAirports);
    on<SelectAirport>(_onSelectAirport);
    on<SelectServiceType>(_onSelectServiceType);
    on<SetPickupLocation>(_onSetPickupLocation);
    on<SetDropoffLocation>(_onSetDropoffLocation);
    on<AddStop>(_onAddStop);
    on<RemoveStop>(_onRemoveStop);
    on<LoadVehicles>(_onLoadVehicles);
    on<SelectVehicle>(_onSelectVehicle);
    on<CalculatePrice>(_onCalculatePrice);
    on<SetDateTime>(_onSetDateTime);
    on<CreateBooking>(_onCreateBooking);
    on<StartTracking>(_onStartTracking);
    on<UpdateTracking>(_onUpdateTracking);
    on<CancelBooking>(_onCancelBooking);
    on<ResetAirportTaxi>(_onResetAirportTaxi);
  }

  Future<void> _onLoadAirports(
    LoadAirports event,
    Emitter<AirportTaxiState> emit,
  ) async {
    emit(const AirportTaxiLoading());
    try {
      final airports = await repository.getAirports();
      emit(AirportsLoaded(airports));
    } catch (e) {
      emit(AirportTaxiError(e.toString()));
    }
  }

  Future<void> _onSelectAirport(
    SelectAirport event,
    Emitter<AirportTaxiState> emit,
  ) async {
    emit(AirportSelected(event.airport));
  }

  Future<void> _onSelectServiceType(
    SelectServiceType event,
    Emitter<AirportTaxiState> emit,
  ) async {
    if (state is AirportSelected) {
      final currentState = state as AirportSelected;
      emit(ServiceTypeSelected(currentState.airport, event.serviceType));
    }
  }

  Future<void> _onSetPickupLocation(
    SetPickupLocation event,
    Emitter<AirportTaxiState> emit,
  ) async {
    if (state is ServiceTypeSelected) {
      final currentState = state as ServiceTypeSelected;
      emit(LocationConfigured(
        airport: currentState.airport,
        serviceType: currentState.serviceType,
        pickupLocation: event.location,
      ));
    } else if (state is LocationConfigured) {
      final currentState = state as LocationConfigured;
      emit(currentState.copyWith(pickupLocation: event.location));
    }
  }

  Future<void> _onSetDropoffLocation(
    SetDropoffLocation event,
    Emitter<AirportTaxiState> emit,
  ) async {
    if (state is LocationConfigured) {
      final currentState = state as LocationConfigured;
      emit(currentState.copyWith(dropoffLocation: event.location));
    }
  }

  Future<void> _onAddStop(
    AddStop event,
    Emitter<AirportTaxiState> emit,
  ) async {
    if (state is LocationConfigured) {
      final currentState = state as LocationConfigured;
      final updatedStops = List<TaxiLocation>.from(currentState.stops)
        ..add(event.location);
      emit(currentState.copyWith(stops: updatedStops));
    }
  }

  Future<void> _onRemoveStop(
    RemoveStop event,
    Emitter<AirportTaxiState> emit,
  ) async {
    if (state is LocationConfigured) {
      final currentState = state as LocationConfigured;
      final updatedStops = List<TaxiLocation>.from(currentState.stops)
        ..removeAt(event.index);
      emit(currentState.copyWith(stops: updatedStops));
    }
  }

  Future<void> _onSetDateTime(
    SetDateTime event,
    Emitter<AirportTaxiState> emit,
  ) async {
    if (state is LocationConfigured) {
      final currentState = state as LocationConfigured;

      if (currentState.pickupLocation == null ||
          currentState.dropoffLocation == null) {
        emit(const AirportTaxiError('Please set pickup and dropoff locations'));
        return;
      }

      emit(DateTimeSelected(
        airport: currentState.airport,
        serviceType: currentState.serviceType,
        pickupLocation: currentState.pickupLocation!,
        dropoffLocation: currentState.dropoffLocation!,
        stops: currentState.stops,
        bookingDate: event.date,
        bookingTime: event.time,
      ));
    }
  }

  Future<void> _onLoadVehicles(
    LoadVehicles event,
    Emitter<AirportTaxiState> emit,
  ) async {
    if (state is DateTimeSelected) {
      final currentState = state as DateTimeSelected;
      emit(const AirportTaxiLoading());

      try {
        final vehicles = await repository.getAvailableVehicles();
        emit(VehiclesLoaded(
          airport: currentState.airport,
          serviceType: currentState.serviceType,
          pickupLocation: currentState.pickupLocation,
          dropoffLocation: currentState.dropoffLocation,
          stops: currentState.stops,
          bookingDate: currentState.bookingDate,
          bookingTime: currentState.bookingTime,
          vehicles: vehicles,
        ));
      } catch (e) {
        emit(AirportTaxiError(e.toString()));
      }
    }
  }

  Future<void> _onSelectVehicle(
    SelectVehicle event,
    Emitter<AirportTaxiState> emit,
  ) async {
    if (state is VehiclesLoaded) {
      final currentState = state as VehiclesLoaded;
      emit(const AirportTaxiLoading());

      try {
        final priceEstimate = await repository.calculatePrice(
          pickup: currentState.pickupLocation,
          dropoff: currentState.dropoffLocation,
          stops: currentState.stops,
          vehicle: event.vehicle,
        );

        emit(VehicleSelected(
          airport: currentState.airport,
          serviceType: currentState.serviceType,
          pickupLocation: currentState.pickupLocation,
          dropoffLocation: currentState.dropoffLocation,
          stops: currentState.stops,
          bookingDate: currentState.bookingDate,
          bookingTime: currentState.bookingTime,
          vehicle: event.vehicle,
          priceEstimate: priceEstimate,
        ));
      } catch (e) {
        emit(AirportTaxiError(e.toString()));
      }
    }
  }

  Future<void> _onCalculatePrice(
    CalculatePrice event,
    Emitter<AirportTaxiState> emit,
  ) async {
    if (state is VehiclesLoaded) {
      final currentState = state as VehiclesLoaded;

      try {
        // Calculate price for each vehicle
        for (var vehicle in currentState.vehicles) {
          final priceEstimate = await repository.calculatePrice(
            pickup: currentState.pickupLocation,
            dropoff: currentState.dropoffLocation,
            stops: currentState.stops,
            vehicle: vehicle,
          );

          emit(VehiclesLoaded(
            airport: currentState.airport,
            serviceType: currentState.serviceType,
            pickupLocation: currentState.pickupLocation,
            dropoffLocation: currentState.dropoffLocation,
            stops: currentState.stops,
            bookingDate: currentState.bookingDate,
            bookingTime: currentState.bookingTime,
            vehicles: currentState.vehicles,
            priceEstimate: priceEstimate,
          ));
        }
      } catch (e) {
        emit(AirportTaxiError(e.toString()));
      }
    }
  }

  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<AirportTaxiState> emit,
  ) async {
    emit(const AirportTaxiLoading());
    try {
      final booking = await repository.createBooking(event.booking);
      emit(BookingCreated(booking));
    } catch (e) {
      emit(AirportTaxiError(e.toString()));
    }
  }

  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<AirportTaxiState> emit,
  ) async {
    try {
      await _trackingSubscription?.cancel();

      final booking = await repository.getBooking(event.bookingId);
      emit(TrackingActive(booking: booking));

      _trackingSubscription = repository.trackBooking(event.bookingId).listen(
        (update) {
          add(UpdateTracking(update));
        },
        onError: (error) {
          add(const ResetAirportTaxi());
        },
      );
    } catch (e) {
      emit(AirportTaxiError(e.toString()));
    }
  }

  Future<void> _onUpdateTracking(
    UpdateTracking event,
    Emitter<AirportTaxiState> emit,
  ) async {
    try {
      final booking = await repository.getBooking(event.update.id);

      DriverLocation? driverLocation;
      if (booking.status == BookingStatus.driverAssigned ||
          booking.status == BookingStatus.driverEnRoute ||
          booking.status == BookingStatus.arrived ||
          booking.status == BookingStatus.started) {
        driverLocation = await repository.getDriverLocation(booking.id);
      }

      if (booking.status == BookingStatus.completed) {
        await _trackingSubscription?.cancel();
        emit(BookingCompleted(booking));
      } else {
        emit(TrackingActive(
          booking: booking,
          latestUpdate: event.update,
          driverLocation: driverLocation,
        ));
      }
    } catch (e) {
      emit(AirportTaxiError(e.toString()));
    }
  }

  Future<void> _onCancelBooking(
    CancelBooking event,
    Emitter<AirportTaxiState> emit,
  ) async {
    try {
      await _trackingSubscription?.cancel();
      await repository.cancelBooking(event.bookingId);
      emit(BookingCancelled(event.bookingId, 'Cancelled by user'));
    } catch (e) {
      emit(AirportTaxiError(e.toString()));
    }
  }

  Future<void> _onResetAirportTaxi(
    ResetAirportTaxi event,
    Emitter<AirportTaxiState> emit,
  ) async {
    await _trackingSubscription?.cancel();
    emit(const AirportTaxiInitial());
  }

  @override
  Future<void> close() {
    _trackingSubscription?.cancel();
    return super.close();
  }
}
