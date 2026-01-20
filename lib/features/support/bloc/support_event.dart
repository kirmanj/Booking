import 'package:equatable/equatable.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

class LoadTicketsEvent extends SupportEvent {
  final String userId;

  const LoadTicketsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadTicketDetailsEvent extends SupportEvent {
  final String ticketId;

  const LoadTicketDetailsEvent(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class CreateTicketEvent extends SupportEvent {
  final String userId;
  final SupportCategory category;
  final String subject;
  final String description;

  const CreateTicketEvent({
    required this.userId,
    required this.category,
    required this.subject,
    required this.description,
  });

  @override
  List<Object?> get props => [userId, category, subject, description];
}

class SendMessageEvent extends SupportEvent {
  final String ticketId;
  final String senderId;
  final bool isFromUser;
  final MessageType messageType;
  final String content;
  final String? mediaUrl;

  const SendMessageEvent({
    required this.ticketId,
    required this.senderId,
    required this.isFromUser,
    required this.messageType,
    required this.content,
    this.mediaUrl,
  });

  @override
  List<Object?> get props => [
        ticketId,
        senderId,
        isFromUser,
        messageType,
        content,
        mediaUrl,
      ];
}

class UpdateTicketStatusEvent extends SupportEvent {
  final String ticketId;
  final TicketStatus status;

  const UpdateTicketStatusEvent(this.ticketId, this.status);

  @override
  List<Object?> get props => [ticketId, status];
}

class CloseTicketEvent extends SupportEvent {
  final String ticketId;

  const CloseTicketEvent(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class MarkMessageAsReadEvent extends SupportEvent {
  final String messageId;

  const MarkMessageAsReadEvent(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
