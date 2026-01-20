import 'package:equatable/equatable.dart';

abstract class FlightBookingEvent extends Equatable {
  const FlightBookingEvent();

  @override
  List<Object?> get props => [];
}

class LoadFlightBooking extends FlightBookingEvent {
  final String flightId;

  const LoadFlightBooking(this.flightId);

  @override
  List<Object?> get props => [flightId];
}

class AddTraveler extends FlightBookingEvent {
  final TravelerModel traveler;

  const AddTraveler(this.traveler);

  @override
  List<Object?> get props => [traveler];
}

class RemoveTraveler extends FlightBookingEvent {
  final int index;

  const RemoveTraveler(this.index);

  @override
  List<Object?> get props => [index];
}

class UpdateTraveler extends FlightBookingEvent {
  final int index;
  final TravelerModel traveler;

  const UpdateTraveler(this.index, this.traveler);

  @override
  List<Object?> get props => [index, traveler];
}

class UpdateContactInfo extends FlightBookingEvent {
  final String email;
  final String phone;

  const UpdateContactInfo(this.email, this.phone);

  @override
  List<Object?> get props => [email, phone];
}

class ConfirmBooking extends FlightBookingEvent {
  const ConfirmBooking();
}

class TravelerModel {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String nationality;
  final String passportNumber;
  final String passportExpiry;

  const TravelerModel({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    this.passportNumber = '',
    this.passportExpiry = '',
  });

  TravelerModel copyWith({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? nationality,
    String? passportNumber,
    String? passportExpiry,
  }) {
    return TravelerModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      passportNumber: passportNumber ?? this.passportNumber,
      passportExpiry: passportExpiry ?? this.passportExpiry,
    );
  }

  bool get isComplete {
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        dateOfBirth.isNotEmpty &&
        gender.isNotEmpty &&
        nationality.isNotEmpty;
  }
}
