import 'package:equatable/equatable.dart';

enum SupportCategory {
  flights,
  hotels,
  carRental,
  tours,
  busTickets,
  eSim,
  airportTaxi,
  homeCheckin,
  payment,
  general,
}

enum TicketStatus {
  open,
  inProgress,
  closed,
}

enum MessageType {
  text,
  image,
  voice,
}

class SupportTicket extends Equatable {
  final String id;
  final String userId;
  final SupportCategory category;
  final String subject;
  final String description;
  final TicketStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? closedAt;
  final List<SupportMessage> messages;

  const SupportTicket({
    required this.id,
    required this.userId,
    required this.category,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.closedAt,
    this.messages = const [],
  });

  SupportTicket copyWith({
    String? id,
    String? userId,
    SupportCategory? category,
    String? subject,
    String? description,
    TicketStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
    List<SupportMessage>? messages,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt ?? this.closedAt,
      messages: messages ?? this.messages,
    );
  }

  String getCategoryDisplayName() {
    switch (category) {
      case SupportCategory.flights:
        return 'Flights';
      case SupportCategory.hotels:
        return 'Hotels';
      case SupportCategory.carRental:
        return 'Car Rental';
      case SupportCategory.tours:
        return 'Tours';
      case SupportCategory.busTickets:
        return 'Bus Tickets';
      case SupportCategory.eSim:
        return 'E-SIM';
      case SupportCategory.airportTaxi:
        return 'Airport Taxi';
      case SupportCategory.homeCheckin:
        return 'Home Check-In';
      case SupportCategory.payment:
        return 'Payment';
      case SupportCategory.general:
        return 'General';
    }
  }

  String getStatusDisplayName() {
    switch (status) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.closed:
        return 'Closed';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        category,
        subject,
        description,
        status,
        createdAt,
        updatedAt,
        closedAt,
        messages,
      ];
}

class SupportMessage extends Equatable {
  final String id;
  final String ticketId;
  final String senderId;
  final bool isFromUser;
  final MessageType messageType;
  final String content;
  final String? mediaUrl;
  final DateTime sentAt;
  final bool isRead;

  const SupportMessage({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.isFromUser,
    required this.messageType,
    required this.content,
    this.mediaUrl,
    required this.sentAt,
    this.isRead = false,
  });

  SupportMessage copyWith({
    String? id,
    String? ticketId,
    String? senderId,
    bool? isFromUser,
    MessageType? messageType,
    String? content,
    String? mediaUrl,
    DateTime? sentAt,
    bool? isRead,
  }) {
    return SupportMessage(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      senderId: senderId ?? this.senderId,
      isFromUser: isFromUser ?? this.isFromUser,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ticketId,
        senderId,
        isFromUser,
        messageType,
        content,
        mediaUrl,
        sentAt,
        isRead,
      ];
}

class CategorySupportInfo {
  final SupportCategory category;
  final String name;
  final String icon;
  final String description;

  const CategorySupportInfo({
    required this.category,
    required this.name,
    required this.icon,
    required this.description,
  });

  static List<CategorySupportInfo> getAllCategories() {
    return [
      const CategorySupportInfo(
        category: SupportCategory.general,
        name: 'General Support',
        icon: 'help-circle',
        description: 'General inquiries and assistance',
      ),
      const CategorySupportInfo(
        category: SupportCategory.flights,
        name: 'Flights',
        icon: 'airplane',
        description: 'Flight bookings and related queries',
      ),
      const CategorySupportInfo(
        category: SupportCategory.hotels,
        name: 'Hotels',
        icon: 'building',
        description: 'Hotel reservations and accommodations',
      ),
      const CategorySupportInfo(
        category: SupportCategory.carRental,
        name: 'Car Rental',
        icon: 'car',
        description: 'Car rental bookings and services',
      ),
      const CategorySupportInfo(
        category: SupportCategory.tours,
        name: 'Tours',
        icon: 'map',
        description: 'Tour packages and activities',
      ),
      const CategorySupportInfo(
        category: SupportCategory.busTickets,
        name: 'Bus Tickets',
        icon: 'bus',
        description: 'Bus ticket bookings and schedules',
      ),
      const CategorySupportInfo(
        category: SupportCategory.eSim,
        name: 'E-SIM',
        icon: 'sim-card',
        description: 'E-SIM packages and activation',
      ),
      const CategorySupportInfo(
        category: SupportCategory.airportTaxi,
        name: 'Airport Taxi',
        icon: 'taxi',
        description: 'Airport taxi services and transfers',
      ),
      const CategorySupportInfo(
        category: SupportCategory.homeCheckin,
        name: 'Home Check-In',
        icon: 'home',
        description: 'Home check-in services',
      ),
      const CategorySupportInfo(
        category: SupportCategory.payment,
        name: 'Payment',
        icon: 'wallet',
        description: 'Payment issues and transactions',
      ),
    ];
  }
}
