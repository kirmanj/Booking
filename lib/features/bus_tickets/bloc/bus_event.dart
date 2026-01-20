import 'package:aman_booking/features/bus_tickets/bloc/bus_state.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class BusEvent {
  const BusEvent();
}

class LoadBusHome extends BusEvent {
  const LoadBusHome();
}

class SwapBusCities extends BusEvent {
  const SwapBusCities();
}

class UpdateFromCity extends BusEvent {
  final String from;
  const UpdateFromCity(this.from);
}

class UpdateToCity extends BusEvent {
  final String to;
  const UpdateToCity(this.to);
}

class UpdateBusDate extends BusEvent {
  final DateTime date;
  const UpdateBusDate(this.date);
}

class UpdatePassengersCount extends BusEvent {
  final int count;
  const UpdatePassengersCount(this.count);
}

class UpdateInternationalToggle extends BusEvent {
  final bool isInternational;
  const UpdateInternationalToggle(this.isInternational);
}

class SearchBusTrips extends BusEvent {
  const SearchBusTrips();
}

class SelectBusCompany extends BusEvent {
  final String companyId;
  const SelectBusCompany(this.companyId);
}

class SelectBusTrip extends BusEvent {
  final String tripId;
  const SelectBusTrip(this.tripId);
}

class BuildCompanyMonthSchedule extends BusEvent {
  final String companyId;
  final DateTime month; // any day inside the month
  const BuildCompanyMonthSchedule(
      {required this.companyId, required this.month});
}

class PickScheduleDay extends BusEvent {
  final DateTime date;
  const PickScheduleDay(this.date);
}

class BuildSeatMap extends BusEvent {
  const BuildSeatMap();
}

class ToggleSeat extends BusEvent {
  final String seatCode;
  const ToggleSeat(this.seatCode);
}

class ProceedToPassengers extends BusEvent {
  const ProceedToPassengers();
}

class UpdatePassengerField extends BusEvent {
  final int index;
  final String
      field; // firstName,lastName,gender,nationality,idNumber,phone,email
  final String value;
  const UpdatePassengerField({
    required this.index,
    required this.field,
    required this.value,
  });
}

class ProceedToPayment extends BusEvent {
  const ProceedToPayment();
}

class UpdatePaymentMethod extends BusEvent {
  final BusPaymentMethod method;
  const UpdatePaymentMethod(this.method);
}

class ApplyPromoCode extends BusEvent {
  final String code;
  const ApplyPromoCode(this.code);
}

class ConfirmBusBooking extends BusEvent {
  const ConfirmBusBooking();
}
