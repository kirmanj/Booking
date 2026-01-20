import 'package:equatable/equatable.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object?> get props => [];
}

class SupportInitialState extends SupportState {}

class SupportLoadingState extends SupportState {}

class TicketsLoadedState extends SupportState {
  final List<SupportTicket> tickets;

  const TicketsLoadedState(this.tickets);

  @override
  List<Object?> get props => [tickets];
}

class TicketDetailsLoadedState extends SupportState {
  final SupportTicket ticket;

  const TicketDetailsLoadedState(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class TicketCreatedState extends SupportState {
  final SupportTicket ticket;

  const TicketCreatedState(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class MessageSentState extends SupportState {
  final SupportMessage message;

  const MessageSentState(this.message);

  @override
  List<Object?> get props => [message];
}

class TicketUpdatedState extends SupportState {
  final SupportTicket ticket;

  const TicketUpdatedState(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class SupportErrorState extends SupportState {
  final String message;

  const SupportErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
