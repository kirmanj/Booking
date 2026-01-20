import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_bloc.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_event.dart';
import 'package:aman_booking/features/esim/bloc/e_sim_state.dart';
import 'package:aman_booking/features/esim/data/models/e_sim_models.dart';
import 'package:aman_booking/features/esim/presentation/screens/e_sim_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ESimOrdersScreen extends StatelessWidget {
  const ESimOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<ESimBloc, ESimState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ESimLoading || state is ESimInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is! MyEsimsLoaded) {
              context.read<ESimBloc>().add(const LoadMyEsims());
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final active = state.activeEsims;
            final expired = state.expiredEsims;

            return Column(
              children: [
                _TopBar(
                  title: 'My eSIMs',
                  subtitle:
                      '${active.length} active • ${expired.length} expired',
                  onBack: () => Navigator.pop(context),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    children: [
                      const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (active.isEmpty)
                        _Empty(text: 'No active eSIMs')
                      else
                        ...active
                            .map((o) => _OrderTile(
                                  order: o,
                                  onTap: () => _openQr(context, o),
                                ))
                            .toList(),
                      const SizedBox(height: 16),
                      const Text(
                        'Expired',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (expired.isEmpty)
                        _Empty(text: 'No expired eSIMs')
                      else
                        ...expired
                            .map((o) => _OrderTile(
                                  order: o,
                                  onTap: () => _openQr(context, o),
                                ))
                            .toList(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openQr(BuildContext context, ESimOrder order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ESimQrScreen(order: order),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final ESimOrder order;
  final VoidCallback onTap;

  const _OrderTile({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Iconsax.simcard, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.package.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.package.dataAmount} • ${order.package.validityText}',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ref: ${order.id}',
                    style: TextStyle(color: AppColors.textTertiary, fontSize: 11),
                  ),
                ],
              ),
            ),
            _StatusPill(status: order.status),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final ESimOrderStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case ESimOrderStatus.active:
        color = AppColors.accentGreen;
        label = 'Active';
        break;
      case ESimOrderStatus.pending:
        color = AppColors.accentOrange;
        label = 'Pending';
        break;
      case ESimOrderStatus.expired:
        color = AppColors.textTertiary;
        label = 'Expired';
        break;
      case ESimOrderStatus.cancelled:
        color = AppColors.error;
        label = 'Cancelled';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const _TopBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.10),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String text;
  const _Empty({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.info_circle, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
