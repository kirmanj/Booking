import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/features/support/bloc/support_event.dart';
import 'package:aman_booking/features/support/bloc/support_state.dart';
import 'package:aman_booking/features/support/data/repositories/support_repository.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final SupportRepository repository;

  SupportBloc(this.repository) : super(SupportInitialState()) {
    on<LoadTicketsEvent>(_onLoadTickets);
    on<LoadTicketDetailsEvent>(_onLoadTicketDetails);
    on<CreateTicketEvent>(_onCreateTicket);
    on<SendMessageEvent>(_onSendMessage);
    on<UpdateTicketStatusEvent>(_onUpdateTicketStatus);
    on<CloseTicketEvent>(_onCloseTicket);
    on<MarkMessageAsReadEvent>(_onMarkMessageAsRead);
  }

  Future<void> _onLoadTickets(
    LoadTicketsEvent event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoadingState());
    try {
      final tickets = await repository.getAllTickets(event.userId);
      emit(TicketsLoadedState(tickets));
    } catch (e) {
      emit(SupportErrorState('Failed to load tickets: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTicketDetails(
    LoadTicketDetailsEvent event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoadingState());
    try {
      final ticket = await repository.getTicketById(event.ticketId);
      emit(TicketDetailsLoadedState(ticket));
    } catch (e) {
      emit(SupportErrorState('Failed to load ticket details: ${e.toString()}'));
    }
  }

  Future<void> _onCreateTicket(
    CreateTicketEvent event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoadingState());
    try {
      final ticket = await repository.createTicket(
        userId: event.userId,
        category: event.category,
        subject: event.subject,
        description: event.description,
      );
      emit(TicketCreatedState(ticket));
    } catch (e) {
      emit(SupportErrorState('Failed to create ticket: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<SupportState> emit,
  ) async {
    try {
      final message = await repository.sendMessage(
        ticketId: event.ticketId,
        senderId: event.senderId,
        isFromUser: event.isFromUser,
        messageType: event.messageType,
        content: event.content,
        mediaUrl: event.mediaUrl,
      );
      emit(MessageSentState(message));

      // Reload ticket details to show the new message
      final ticket = await repository.getTicketById(event.ticketId);
      emit(TicketDetailsLoadedState(ticket));
    } catch (e) {
      emit(SupportErrorState('Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateTicketStatus(
    UpdateTicketStatusEvent event,
    Emitter<SupportState> emit,
  ) async {
    try {
      await repository.updateTicketStatus(event.ticketId, event.status);
      final ticket = await repository.getTicketById(event.ticketId);
      emit(TicketUpdatedState(ticket));
    } catch (e) {
      emit(SupportErrorState('Failed to update ticket status: ${e.toString()}'));
    }
  }

  Future<void> _onCloseTicket(
    CloseTicketEvent event,
    Emitter<SupportState> emit,
  ) async {
    try {
      await repository.closeTicket(event.ticketId);
      final ticket = await repository.getTicketById(event.ticketId);
      emit(TicketUpdatedState(ticket));
    } catch (e) {
      emit(SupportErrorState('Failed to close ticket: ${e.toString()}'));
    }
  }

  Future<void> _onMarkMessageAsRead(
    MarkMessageAsReadEvent event,
    Emitter<SupportState> emit,
  ) async {
    try {
      await repository.markMessageAsRead(event.messageId);
    } catch (e) {
      emit(SupportErrorState('Failed to mark message as read: ${e.toString()}'));
    }
  }
}
