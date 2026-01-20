import 'package:equatable/equatable.dart';

abstract class FlightsEvent extends Equatable {
  const FlightsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFlights extends FlightsEvent {
  const LoadFlights();
}

class SearchFlights extends FlightsEvent {
  final String origin;
  final String destination;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengers;

  const SearchFlights({
    required this.origin,
    required this.destination,
    required this.departureDate,
    this.returnDate,
    this.passengers = 1,
  });

  @override
  List<Object?> get props => [origin, destination, departureDate, returnDate, passengers];
}

class FilterFlights extends FlightsEvent {
  final double? maxPrice;
  final int? maxStops;
  final String? airline;

  const FilterFlights({
    this.maxPrice,
    this.maxStops,
    this.airline,
  });

  @override
  List<Object?> get props => [maxPrice, maxStops, airline];
}

class SelectFlight extends FlightsEvent {
  final String flightId;

  const SelectFlight(this.flightId);

  @override
  List<Object?> get props => [flightId];
}
