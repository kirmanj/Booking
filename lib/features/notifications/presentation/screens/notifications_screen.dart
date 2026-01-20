import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/notifications/data/models/notification_models.dart';
import 'package:aman_booking/features/notifications/data/sample_notifications.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<AppNotification> _allNotifications;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _allNotifications = SampleNotifications.getAllNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AppNotification> get _filteredNotifications {
    if (_tabController.index == 1) {
      return _allNotifications.where((n) => !n.isRead).toList();
    }

    if (_selectedFilter == 'All') {
      return _allNotifications;
    }

    final filterType = NotificationType.values.firstWhere(
      (type) => type.name.toLowerCase() == _selectedFilter.toLowerCase(),
      orElse: () => NotificationType.booking,
    );

    return _allNotifications.where((n) => n.type == filterType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildTabBar(),
                const SizedBox(height: 16),
                if (_tabController.index == 0) _buildFilterChips(),
                const SizedBox(height: 8),
              ],
            ),
          ),
          _buildNotificationsList(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final unreadCount = SampleNotifications.getUnreadCount();

    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.tick_circle, color: Colors.white),
          onPressed: _markAllAsRead,
        ),
        IconButton(
          icon: const Icon(Iconsax.setting_2, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification settings coming soon')),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Iconsax.notification_bing,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$unreadCount Unread',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_allNotifications.length} Total',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        onTap: (index) => setState(() {}),
        tabs: const [
          Tab(text: 'All Notifications'),
          Tab(text: 'Unread'),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      'All',
      'Booking',
      'Payment',
      'Promotion',
      'Support',
      'Update',
      'Reminder',
      'Alert',
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary.withOpacity(0.2),
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationsList() {
    final notifications = _filteredNotifications;

    if (notifications.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.notification_bing,
                size: 80,
                color: AppColors.textSecondary.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'re all caught up!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification);
          },
          childCount: notifications.length,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isRead
              ? Colors.transparent
              : AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTypeColor(notification.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(notification.type),
                    color: _getTypeColor(notification.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getTypeColor(notification.type)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              notification.getTypeDisplayName(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _getTypeColor(notification.type),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Iconsax.clock,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeago.format(notification.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(AppNotification notification) {
    setState(() {
      final index = _allNotifications.indexOf(notification);
      if (index != -1) {
        _allNotifications[index] = notification.copyWith(isRead: true);
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNotificationDetails(notification),
    );
  }

  Widget _buildNotificationDetails(AppNotification notification) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getTypeColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getTypeIcon(notification.type),
                  color: _getTypeColor(notification.type),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.getTypeDisplayName(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getTypeColor(notification.type),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeago.format(notification.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            notification.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            notification.message,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          if (notification.actionUrl != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Action triggered')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      _allNotifications = _allNotifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Iconsax.book;
      case NotificationType.payment:
        return Iconsax.wallet_money;
      case NotificationType.promotion:
        return Iconsax.discount_shape;
      case NotificationType.support:
        return Iconsax.message_question;
      case NotificationType.update:
        return Iconsax.refresh;
      case NotificationType.reminder:
        return Iconsax.clock;
      case NotificationType.alert:
        return Iconsax.warning_2;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Colors.blue;
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.promotion:
        return Colors.orange;
      case NotificationType.support:
        return Colors.purple;
      case NotificationType.update:
        return Colors.teal;
      case NotificationType.reminder:
        return Colors.indigo;
      case NotificationType.alert:
        return Colors.red;
    }
  }
}
