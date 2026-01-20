import 'package:flutter/material.dart';
import 'package:aman_booking/features/home/presentation/screens/home_screen.dart';
import 'package:aman_booking/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:aman_booking/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:aman_booking/features/bookings/presentation/screens/redesigned_bookings_screen.dart';
import 'package:aman_booking/features/profile/presentation/screens/profile_screen.dart';
import 'package:aman_booking/features/support/presentation/screens/support_screen.dart';
import 'package:aman_booking/features/notifications/data/sample_notifications.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const NotificationsScreen(),
    const RedesignedBookingsScreen(),
    const ProfileScreen(),
    const SupportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = SampleNotifications.getUnreadCount();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: _buildNotificationIcon(unreadCount, false),
            activeIcon: _buildNotificationIcon(unreadCount, true),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            activeIcon: Icon(Icons.confirmation_number),
            label: 'Bookings',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.support_agent_outlined),
            activeIcon: Icon(Icons.support_agent),
            label: 'Support',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(int unreadCount, bool isActive) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          isActive ? Iconsax.notification_bing : Iconsax.notification,
        ),
        if (unreadCount > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                unreadCount > 9 ? '9+' : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
