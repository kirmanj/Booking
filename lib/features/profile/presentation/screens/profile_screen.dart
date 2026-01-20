import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/features/support/presentation/screens/support_screen.dart';
import 'package:aman_booking/features/support/presentation/screens/create_ticket_screen.dart';
import 'package:aman_booking/features/bookings/presentation/screens/redesigned_bookings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // expandedHeight: 200,
            backgroundColor: AppColors.surface,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.edit, size: 22),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Profile Header
              Container(
                transform: Matrix4.translationValues(0, 20, 0),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surface,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.profile_circle,
                        size: 100,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'john.doe@email.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.verify,
                            size: 14,
                            color: AppColors.accentGreen,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Verified Account',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Stats Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RedesignedBookingsScreen(),
                            ),
                          );
                        },
                        child: _buildStatItem('Bookings', '12', Iconsax.book),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatItem('Favorites', '8', Iconsax.heart),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatItem('Reviews', '24', Iconsax.star),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Settings Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Iconsax.personalcard,
                      title: 'Personal Information',
                      subtitle: 'Update your personal details',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Iconsax.shield_tick,
                      title: 'Security',
                      subtitle: 'Change password & security settings',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Iconsax.card,
                      title: 'Payment Methods',
                      subtitle: 'Manage your payment options',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Iconsax.notification,
                      title: 'Notifications',
                      subtitle: 'Manage notification preferences',
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Iconsax.moon,
                      title: 'Dark Mode',
                      subtitle: 'Switch between light and dark theme',
                      trailing: Switch(
                        value: _darkMode,
                        onChanged: (value) {
                          setState(() {
                            _darkMode = value;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Iconsax.language_circle,
                      title: 'Language',
                      subtitle: 'English (US)',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Support Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Iconsax.message_question,
                      title: 'Help Center',
                      subtitle: 'Get help with your bookings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSettingItem(
                      icon: Iconsax.shield_security,
                      title: 'Privacy Policy',
                      subtitle: 'Learn about our privacy practices',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Iconsax.document_text,
                      title: 'Terms of Service',
                      subtitle: 'Read our terms and conditions',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withOpacity(0.1),
                    foregroundColor: AppColors.error,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: AppColors.error.withOpacity(0.2)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.logout, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: trailing ?? const Icon(Iconsax.arrow_right_3, size: 20),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
