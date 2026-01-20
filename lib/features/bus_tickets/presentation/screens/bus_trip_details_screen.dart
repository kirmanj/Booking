import 'package:aman_booking/features/bus_tickets/bloc/bus_bloc.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_event.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/bus_tickets/presentation/screens/bus_seat_selection_screen.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/presentation/widgets/support_button.dart';

class BusTripDetailsScreen extends StatelessWidget {
  const BusTripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusBloc, BusState>(
      listener: (context, state) {
        if (state is BusSeatSelectionLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<BusBloc>(),
                child: const BusSeatSelectionScreen(),
              ),
            ),
          );
        }

        if (state is BusError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is BusLoading || state is BusInitial) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is! BusTripDetailsLoaded) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Trip details not ready')),
          );
        }

        final t = state.trip;
        final q = state.query;

        final tf = DateFormat('HH:mm');
        final df = DateFormat('EEE, MMM dd');
        final dur = t.duration;
        final durStr = '${dur.inHours}h ${dur.inMinutes.remainder(60)}m';

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Trip Details',
                  subtitle: '${t.companyName} • ${t.classLabel}',
                  onBack: () => Navigator.pop(context),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    children: [
                      _Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${t.from} → ${t.to}',
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _Chip(
                                    icon: Iconsax.calendar_1,
                                    text: df.format(t.departAt)),
                                const SizedBox(width: 8),
                                _Chip(
                                    icon: Iconsax.clock,
                                    text:
                                        '${tf.format(t.departAt)} → ${tf.format(t.arriveAt)}'),
                                const SizedBox(width: 8),
                                _Chip(icon: Iconsax.timer_1, text: durStr),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Bus type: ${t.busType} • Code: ${t.plateOrCode}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: t.amenities.map((a) {
                                return _Chip(
                                    icon: Iconsax.tick_circle, text: a);
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Stops',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (t.stops.isEmpty)
                              Text(
                                'Direct trip (no stops)',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            else
                              ...t.stops.map((s) => _StopRow(text: s)).toList(),
                            const SizedBox(height: 10),
                            if (t.borderCrossing)
                              _InfoBox(
                                icon: Iconsax.global,
                                text:
                                    'Border crossing route: passengers must carry passport/ID and required visas.',
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Policies',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _PolicyRow(
                                icon: Iconsax.briefcase,
                                title: 'Baggage',
                                value: t.baggagePolicy),
                            const SizedBox(height: 8),
                            _PolicyRow(
                                icon: Iconsax.refresh,
                                title: 'Cancellation',
                                value: t.cancellationPolicy),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Price Summary',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _PriceRow(
                              label: 'Per passenger',
                              value:
                                  '\$${t.pricePerPassenger.toStringAsFixed(0)}',
                            ),
                            const SizedBox(height: 8),
                            _PriceRow(
                              label: 'Passengers',
                              value: '${q.passengers}',
                            ),
                            const Divider(height: 18),
                            _PriceRow(
                              label: 'Estimated total',
                              value:
                                  '\$${(t.pricePerPassenger * q.passengers).toStringAsFixed(0)}',
                              bold: true,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Final total may include taxes/service fees in the payment step.',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.black.withOpacity(0.06)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${t.pricePerPassenger.toStringAsFixed(0)} / passenger',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () =>
                              context.read<BusBloc>().add(const BuildSeatMap()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.chair, size: 18, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Select seats',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          const SupportButton(
            category: SupportCategory.busTickets,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.14)),
      ),
      child: child,
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Chip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  final String text;
  const _StopRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Iconsax.location, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _PolicyRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          '$title:',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        )
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 12.5,
      fontWeight: bold ? FontWeight.w900 : FontWeight.w800,
      color: bold ? AppColors.textPrimary : AppColors.textSecondary,
    );

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBox({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
