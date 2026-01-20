import 'package:aman_booking/features/support/data/models/support_models.dart';

abstract class SupportRepository {
  Future<List<SupportTicket>> getAllTickets(String userId);
  Future<SupportTicket> getTicketById(String ticketId);
  Future<SupportTicket> createTicket({
    required String userId,
    required SupportCategory category,
    required String subject,
    required String description,
  });
  Future<void> updateTicketStatus(String ticketId, TicketStatus status);
  Future<void> closeTicket(String ticketId);
  Future<SupportMessage> sendMessage({
    required String ticketId,
    required String senderId,
    required bool isFromUser,
    required MessageType messageType,
    required String content,
    String? mediaUrl,
  });
  Future<List<SupportMessage>> getTicketMessages(String ticketId);
  Future<void> markMessageAsRead(String messageId);
}

class SupportRepositoryImpl implements SupportRepository {
  // Mock data storage - in production, this would connect to a backend
  final List<SupportTicket> _tickets = [];
  final List<SupportMessage> _messages = [];

  @override
  Future<List<SupportTicket>> getAllTickets(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _tickets.where((ticket) => ticket.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<SupportTicket> getTicketById(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final ticket = _tickets.firstWhere((t) => t.id == ticketId);
    final messages = _messages.where((m) => m.ticketId == ticketId).toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return ticket.copyWith(messages: messages);
  }

  @override
  Future<SupportTicket> createTicket({
    required String userId,
    required SupportCategory category,
    required String subject,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final ticketId = 'ticket_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    final ticket = SupportTicket(
      id: ticketId,
      userId: userId,
      category: category,
      subject: subject,
      description: description,
      status: TicketStatus.open,
      createdAt: now,
      updatedAt: now,
    );

    _tickets.add(ticket);

    // Create initial message from user
    final initialMessage = SupportMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      ticketId: ticketId,
      senderId: userId,
      isFromUser: true,
      messageType: MessageType.text,
      content: description,
      sentAt: now,
    );

    _messages.add(initialMessage);

    // Simulate auto-reply
    await Future.delayed(const Duration(milliseconds: 500));
    final autoReply = SupportMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch + 1}',
      ticketId: ticketId,
      senderId: 'support_bot',
      isFromUser: false,
      messageType: MessageType.text,
      content: 'Thank you for contacting us! Our support team has received your request regarding ${ticket.getCategoryDisplayName()}. We will get back to you as soon as possible.',
      sentAt: DateTime.now(),
    );

    _messages.add(autoReply);

    return ticket.copyWith(messages: [initialMessage, autoReply]);
  }

  @override
  Future<void> updateTicketStatus(String ticketId, TicketStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final ticket = _tickets[index];
      _tickets[index] = ticket.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> closeTicket(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final ticket = _tickets[index];
      final now = DateTime.now();
      _tickets[index] = ticket.copyWith(
        status: TicketStatus.closed,
        updatedAt: now,
        closedAt: now,
      );
    }
  }

  @override
  Future<SupportMessage> sendMessage({
    required String ticketId,
    required String senderId,
    required bool isFromUser,
    required MessageType messageType,
    required String content,
    String? mediaUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final message = SupportMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      ticketId: ticketId,
      senderId: senderId,
      isFromUser: isFromUser,
      messageType: messageType,
      content: content,
      mediaUrl: mediaUrl,
      sentAt: DateTime.now(),
    );

    _messages.add(message);

    // Update ticket
    final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);
    if (ticketIndex != -1) {
      final ticket = _tickets[ticketIndex];
      if (ticket.status == TicketStatus.open) {
        _tickets[ticketIndex] = ticket.copyWith(
          status: TicketStatus.inProgress,
          updatedAt: DateTime.now(),
        );
      }
    }

    return message;
  }

  @override
  Future<List<SupportMessage>> getTicketMessages(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _messages.where((m) => m.ticketId == ticketId).toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(isRead: true);
    }
  }
}
