import 'package:flutter/material.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/screens/create_ticket_screen.dart';

class SupportButton extends StatelessWidget {
  final SupportCategory category;
  final Color? color;

  const SupportButton({
    super.key,
    required this.category,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateTicketScreen(
              preselectedCategory: category,
            ),
          ),
        );
      },
      icon: Icon(
        Iconsax.support,
        color: color ?? Colors.white,
      ),
      tooltip: 'Get Support',
    );
  }
}

class SupportFloatingButton extends StatelessWidget {
  final SupportCategory category;

  const SupportFloatingButton({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateTicketScreen(
              preselectedCategory: category,
            ),
          ),
        );
      },
      backgroundColor: AppColors.accentOrange,
      child: const Icon(
        Iconsax.support,
        color: Colors.white,
      ),
    );
  }
}
