import 'package:aman_booking/features/notifications/data/models/notification_models.dart';

class SampleNotifications {
  static List<AppNotification> getAllNotifications() {
    final now = DateTime.now();

    return [
      // Booking Notifications
      AppNotification(
        id: 'notif_001',
        type: NotificationType.booking,
        priority: NotificationPriority.high,
        title: 'Flight Booking Confirmed',
        message: 'Your flight from New York to London has been confirmed. Flight AA123 departs at 10:30 AM.',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      AppNotification(
        id: 'notif_002',
        type: NotificationType.booking,
        priority: NotificationPriority.medium,
        title: 'Hotel Check-in Tomorrow',
        message: 'Reminder: Your check-in at Grand Plaza Hotel is scheduled for tomorrow at 3:00 PM.',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: false,
      ),
      AppNotification(
        id: 'notif_003',
        type: NotificationType.booking,
        priority: NotificationPriority.medium,
        title: 'Car Rental Ready for Pickup',
        message: 'Your Tesla Model 3 is ready for pickup at LAX Airport. Confirmation code: TR45678.',
        timestamp: now.subtract(const Duration(hours: 8)),
        isRead: true,
      ),

      // Payment Notifications
      AppNotification(
        id: 'notif_004',
        type: NotificationType.payment,
        priority: NotificationPriority.high,
        title: 'Payment Successful',
        message: 'Your payment of \$1,250.00 for Flight AA123 has been processed successfully.',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: 'notif_005',
        type: NotificationType.payment,
        priority: NotificationPriority.urgent,
        title: 'Payment Pending',
        message: 'Your hotel booking payment is pending. Please complete the payment to confirm your reservation.',
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        isRead: false,
      ),

      // Promotion Notifications
      AppNotification(
        id: 'notif_006',
        type: NotificationType.promotion,
        priority: NotificationPriority.low,
        title: '🎉 Flash Sale: 40% Off Hotels',
        message: 'Book now and save up to 40% on luxury hotels worldwide. Limited time offer!',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      AppNotification(
        id: 'notif_007',
        type: NotificationType.promotion,
        priority: NotificationPriority.low,
        title: '✈️ Early Bird Special',
        message: 'Save 20% on flights when you book 30 days in advance. Use code: EARLY20',
        timestamp: now.subtract(const Duration(days: 2, hours: 12)),
        isRead: false,
      ),
      AppNotification(
        id: 'notif_008',
        type: NotificationType.promotion,
        priority: NotificationPriority.medium,
        title: '🚗 Weekend Car Rental Deal',
        message: 'Get 30% off on weekend car rentals. Perfect for your road trip!',
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),

      // Support Notifications
      AppNotification(
        id: 'notif_009',
        type: NotificationType.support,
        priority: NotificationPriority.high,
        title: 'Support Ticket Resolved',
        message: 'Your support ticket #12345 regarding flight change has been resolved. Check the details.',
        timestamp: now.subtract(const Duration(days: 3, hours: 6)),
        isRead: false,
      ),
      AppNotification(
        id: 'notif_010',
        type: NotificationType.support,
        priority: NotificationPriority.medium,
        title: 'New Message from Support',
        message: 'Our support team has replied to your inquiry about hotel cancellation policy.',
        timestamp: now.subtract(const Duration(days: 4)),
        isRead: true,
      ),

      // Update Notifications
      AppNotification(
        id: 'notif_011',
        type: NotificationType.update,
        priority: NotificationPriority.medium,
        title: 'App Update Available',
        message: 'Version 2.0 is now available with new features and improvements. Update now!',
        timestamp: now.subtract(const Duration(days: 5)),
        isRead: true,
      ),
      AppNotification(
        id: 'notif_012',
        type: NotificationType.update,
        priority: NotificationPriority.low,
        title: 'New Feature: E-SIM Service',
        message: 'Travel worry-free with our new E-SIM service. Stay connected anywhere in the world!',
        timestamp: now.subtract(const Duration(days: 6)),
        isRead: true,
      ),

      // Reminder Notifications
      AppNotification(
        id: 'notif_013',
        type: NotificationType.reminder,
        priority: NotificationPriority.high,
        title: 'Flight Departure in 24 Hours',
        message: 'Don\'t forget to complete your online check-in for flight AA123.',
        timestamp: now.subtract(const Duration(days: 6, hours: 12)),
        isRead: false,
      ),
      AppNotification(
        id: 'notif_014',
        type: NotificationType.reminder,
        priority: NotificationPriority.medium,
        title: 'Tour Starts Tomorrow',
        message: 'Your guided tour of Paris starts tomorrow at 9:00 AM. Meeting point: Eiffel Tower.',
        timestamp: now.subtract(const Duration(days: 7)),
        isRead: true,
      ),

      // Alert Notifications
      AppNotification(
        id: 'notif_015',
        type: NotificationType.alert,
        priority: NotificationPriority.urgent,
        title: 'Flight Delay Alert',
        message: 'Your flight AA123 has been delayed by 2 hours. New departure time: 12:30 PM.',
        timestamp: now.subtract(const Duration(days: 7, hours: 8)),
        isRead: false,
      ),
      AppNotification(
        id: 'notif_016',
        type: NotificationType.alert,
        priority: NotificationPriority.high,
        title: 'Gate Change',
        message: 'Gate changed for flight AA123. Please proceed to Gate B12.',
        timestamp: now.subtract(const Duration(days: 8)),
        isRead: true,
      ),
    ];
  }

  static List<AppNotification> getUnreadNotifications() {
    return getAllNotifications().where((n) => !n.isRead).toList();
  }

  static int getUnreadCount() {
    return getUnreadNotifications().length;
  }

  static List<AppNotification> getNotificationsByType(NotificationType type) {
    return getAllNotifications().where((n) => n.type == type).toList();
  }

  static List<AppNotification> getTodayNotifications() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return getAllNotifications()
        .where((n) => n.timestamp.isAfter(today))
        .toList();
  }
}
