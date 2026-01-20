import 'package:aman_booking/features/bus_tickets/bloc/bus_bloc.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_event.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import 'package:aman_booking/core/constants/app_colors.dart';

import 'bus_trip_details_screen.dart';

class BusResultsScreen extends StatelessWidget {
  const BusResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusBloc, BusState>(
      listener: (context, state) {
        if (state is BusTripDetailsLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<BusBloc>(),
                child: const BusTripDetailsScreen(),
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

        if (state is! BusResultsLoaded) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(
                'No results state.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }

        final q = state.query;
        final trips = state.trips;

        final df = DateFormat('EEE, MMM dd');
        final tf = DateFormat('HH:mm');

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Bus Results',
                  subtitle:
                      '${q.from} → ${q.to} • ${df.format(q.date)} • ${q.passengers} pax',
                  onBack: () => Navigator.pop(context),
                  onFilter: () => _showFilters(context, q),
                ),
                if (trips.isEmpty)
                  Expanded(
                    child: _EmptyResults(
                      isInternational: q.isInternational,
                      onChangeSearch: () => Navigator.pop(context),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                      itemCount: trips.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final t = trips[i];
                        final dur = t.duration;
                        final durStr =
                            '${dur.inHours}h ${dur.inMinutes.remainder(60)}m';

                        return _TripCard(
                          trip: t,
                          timeLabel:
                              '${tf.format(t.departAt)} → ${tf.format(t.arriveAt)}',
                          durationLabel: durStr,
                          onTap: () =>
                              context.read<BusBloc>().add(SelectBusTrip(t.id)),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFilters(BuildContext context, BusQuery q) async {
    // demo UI only (you can later add filter events)
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filters (Demo)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _HintLine(
                  text: q.isInternational
                      ? 'International routes: show border crossing trips.'
                      : 'Domestic routes: show same-country trips.'),
              const SizedBox(height: 12),
              const _FakeFilterRow(
                title: 'Bus class',
                value: 'Economy • Business • VIP',
                icon: Iconsax.crown,
              ),
              const SizedBox(height: 10),
              const _FakeFilterRow(
                title: 'Amenities',
                value: 'WiFi • WC • Meals • Charging',
                icon: Iconsax.wifi,
              ),
              const SizedBox(height: 10),
              const _FakeFilterRow(
                title: 'Price sort',
                value: 'Lowest • Best rated • Earliest',
                icon: Iconsax.sort,
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Apply (Demo)',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
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
  final VoidCallback onFilter;

  const _TopBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.onFilter,
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
          InkWell(
            onTap: onFilter,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.14)),
              ),
              child: const Row(
                children: [
                  Icon(Iconsax.filter, size: 18, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final BusTrip trip;
  final String timeLabel;
  final String durationLabel;
  final VoidCallback onTap;

  const _TripCard({
    required this.trip,
    required this.timeLabel,
    required this.durationLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final price = '\$${trip.pricePerPassenger.toStringAsFixed(0)}';
    final old =
        trip.oldPrice == null ? null : '\$${trip.oldPrice!.toStringAsFixed(0)}';

    final seatsColor = trip.seatsLeft <= 5
        ? AppColors.error
        : (trip.seatsLeft <= 12
            ? AppColors.accentOrange
            : AppColors.accentGreen);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary.withOpacity(0.14)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    trip.companyName,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _Chip(
                  icon: Iconsax.bus,
                  text: '${trip.busType} • ${trip.classLabel}',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${trip.from} → ${trip.to}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trip.borderCrossing)
                  const _Badge(text: 'Border', isGood: false),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoLine(
                    icon: Iconsax.clock,
                    title: timeLabel,
                    subtitle: 'Duration: $durationLabel',
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: seatsColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: seatsColor.withOpacity(0.20)),
                  ),
                  child: Text(
                    '${trip.seatsLeft} seats left',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                      color: seatsColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: trip.amenities.take(4).map((a) {
                return _Chip(icon: Iconsax.tick_circle, text: a);
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '/passenger',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (old != null)
                  Text(
                    old,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textTertiary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.textTertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoLine({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
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

class _Badge extends StatelessWidget {
  final String text;
  final bool isGood;
  const _Badge({required this.text, required this.isGood});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: (isGood ? AppColors.accentGreen : AppColors.accentOrange)
            .withOpacity(0.92),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final bool isInternational;
  final VoidCallback onChangeSearch;

  const _EmptyResults({
    required this.isInternational,
    required this.onChangeSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.search_status,
                size: 50, color: AppColors.primary),
            const SizedBox(height: 12),
            const Text(
              'No trips found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isInternational
                  ? 'Try another date or route. International trips depend on border schedules.'
                  : 'Try another date or route. Domestic trips may be limited for some cities.',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: onChangeSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Change search',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FakeFilterRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _FakeFilterRow({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Iconsax.arrow_right_3, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

class _HintLine extends StatelessWidget {
  final String text;
  const _HintLine({required this.text});

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
          const Icon(Iconsax.info_circle, color: AppColors.primary),
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
