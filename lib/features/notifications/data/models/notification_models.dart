import 'package:equatable/equatable.dart';

enum NotificationType {
  booking,
  payment,
  promotion,
  support,
  update,
  reminder,
  alert,
}

enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}

class AppNotification extends Equatable {
  final String id;
  final NotificationType type;
  final NotificationPriority priority;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final String? actionUrl;
  final Map<String, dynamic>? data;

  const AppNotification({
    required this.id,
    required this.type,
    required this.priority,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.actionUrl,
    this.data,
  });

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    NotificationPriority? priority,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
    String? actionUrl,
    Map<String, dynamic>? data,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      data: data ?? this.data,
    );
  }

  String getTypeDisplayName() {
    switch (type) {
      case NotificationType.booking:
        return 'Booking';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.promotion:
        return 'Promotion';
      case NotificationType.support:
        return 'Support';
      case NotificationType.update:
        return 'Update';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.alert:
        return 'Alert';
    }
  }

  @override
  List<Object?> get props => [
        id,
        type,
        priority,
        title,
        message,
        timestamp,
        isRead,
        imageUrl,
        actionUrl,
        data,
      ];
}
