import 'package:equatable/equatable.dart';
import 'package:aman_booking/features/flights/bloc/flights_state.dart';
import 'flight_booking_event.dart';

abstract class FlightBookingState extends Equatable {
  const FlightBookingState();

  @override
  List<Object?> get props => [];
}

class FlightBookingInitial extends FlightBookingState {
  const FlightBookingInitial();
}

class FlightBookingLoading extends FlightBookingState {
  const FlightBookingLoading();
}

class FlightBookingLoaded extends FlightBookingState {
  final FlightModel flight;
  final List<TravelerModel> travelers;
  final String contactEmail;
  final String contactPhone;
  final double totalPrice;

  const FlightBookingLoaded({
    required this.flight,
    required this.travelers,
    this.contactEmail = '',
    this.contactPhone = '',
    required this.totalPrice,
  });

  FlightBookingLoaded copyWith({
    FlightModel? flight,
    List<TravelerModel>? travelers,
    String? contactEmail,
    String? contactPhone,
    double? totalPrice,
  }) {
    return FlightBookingLoaded(
      flight: flight ?? this.flight,
      travelers: travelers ?? this.travelers,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  bool get canProceed {
    return travelers.isNotEmpty &&
        travelers.every((t) => t.isComplete) &&
        contactEmail.isNotEmpty &&
        contactPhone.isNotEmpty;
  }

  @override
  List<Object?> get props => [flight, travelers, contactEmail, contactPhone, totalPrice];
}

class FlightBookingConfirmed extends FlightBookingState {
  final String bookingReference;
  final FlightModel flight;
  final List<TravelerModel> travelers;
  final double totalPrice;

  const FlightBookingConfirmed({
    required this.bookingReference,
    required this.flight,
    required this.travelers,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [bookingReference, flight, travelers, totalPrice];
}

class FlightBookingError extends FlightBookingState {
  final String message;

  const FlightBookingError(this.message);

  @override
  List<Object?> get props => [message];
}
