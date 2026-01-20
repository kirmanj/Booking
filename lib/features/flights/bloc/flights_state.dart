import 'package:equatable/equatable.dart';

abstract class FlightsState extends Equatable {
  const FlightsState();

  @override
  List<Object?> get props => [];
}

class FlightsInitial extends FlightsState {
  const FlightsInitial();
}

class FlightsLoading extends FlightsState {
  const FlightsLoading();
}

class FlightsLoaded extends FlightsState {
  final List<FlightModel> flights;
  final String? searchQuery;

  const FlightsLoaded({
    required this.flights,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [flights, searchQuery];
}

class FlightSelected extends FlightsState {
  final FlightModel flight;

  const FlightSelected(this.flight);

  @override
  List<Object?> get props => [flight];
}

class FlightsError extends FlightsState {
  final String message;

  const FlightsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Flight Model with Airline Code
class FlightModel {
  final String id;
  final String airline;
  final String airlineLogoUrl;

  final String airlineCode; // NEW: For logo file names (emirates, qatar, etc.)
  final String origin;
  final String destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int stops;
  final String flightNumber;

  FlightModel({
    required this.id,
    required this.airline,
    required this.airlineCode, // NEW: Add this parameter
    required this.origin,
    required this.destination,
    required this.airlineLogoUrl,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.stops,
    required this.flightNumber,
  });

  String get duration {
    final diff = arrivalTime.difference(departureTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get stopsText {
    if (stops == 0) return 'Direct';
    if (stops == 1) return '1 stop';
    return '$stops stops';
  }
}
