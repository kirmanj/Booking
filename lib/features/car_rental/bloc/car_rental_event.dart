import 'package:flutter/foundation.dart';

@immutable
abstract class CarRentalEvent {
  const CarRentalEvent();
}

class LoadCarRentalHome extends CarRentalEvent {
  const LoadCarRentalHome();
}

class ToggleCompanyFavorite extends CarRentalEvent {
  final String companyId;
  const ToggleCompanyFavorite(this.companyId);
}

class ToggleCarFavorite extends CarRentalEvent {
  final String carId;
  const ToggleCarFavorite(this.carId);
}

class UpdateSearchLocation extends CarRentalEvent {
  final String location;
  const UpdateSearchLocation(this.location);
}

class UpdatePickupDate extends CarRentalEvent {
  final DateTime pickup;
  const UpdatePickupDate(this.pickup);
}

class UpdateDropoffDate extends CarRentalEvent {
  final DateTime dropoff;
  const UpdateDropoffDate(this.dropoff);
}

// NEW: Company profile events
class LoadCompanyProfile extends CarRentalEvent {
  final String companyId;
  const LoadCompanyProfile(this.companyId);
}

// NEW: Car booking events
class SelectCarForBooking extends CarRentalEvent {
  final String carId;
  const SelectCarForBooking(this.carId);
}

class ToggleDriverOption extends CarRentalEvent {
  const ToggleDriverOption();
}

class UpdateDriverDetails extends CarRentalEvent {
  final String name;
  final String? email;
  final String? phone;
  const UpdateDriverDetails({
    required this.name,
    this.email,
    this.phone,
  });
}

class AddExtraOption extends CarRentalEvent {
  final String optionId;
  const AddExtraOption(this.optionId);
}

class RemoveExtraOption extends CarRentalEvent {
  final String optionId;
  const RemoveExtraOption(this.optionId);
}

class ConfirmBooking extends CarRentalEvent {
  const ConfirmBooking();
}

class CancelBooking extends CarRentalEvent {
  const CancelBooking();
}
