import 'package:aman_booking/features/bus_tickets/bloc/bus_bloc.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_event.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/bus_tickets/presentation/screens/bus_trip_details_screen.dart';
import 'package:aman_booking/features/bus_tickets/presentation/screens/bus_seat_selection_screen.dart';

class BusCompanyScheduleScreen extends StatefulWidget {
  final String companyId;
  const BusCompanyScheduleScreen({super.key, required this.companyId});

  @override
  State<BusCompanyScheduleScreen> createState() =>
      _BusCompanyScheduleScreenState();
}

class _BusCompanyScheduleScreenState extends State<BusCompanyScheduleScreen> {
  DateTime month = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<BusBloc>().add(
        BuildCompanyMonthSchedule(companyId: widget.companyId, month: month));
  }

  void _changeMonth(int offset) {
    setState(() => month = DateTime(month.year, month.month + offset, 1));
    context.read<BusBloc>().add(
          BuildCompanyMonthSchedule(companyId: widget.companyId, month: month),
        );
  }

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
        } else if (state is BusSeatSelectionLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<BusBloc>(),
                child: const BusSeatSelectionScreen(),
              ),
            ),
          );
        } else if (state is BusHomeLoaded) {
          // returning to home from back
          Navigator.pop(context);
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

        if (state is BusError) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(state.message),
            ),
          );
        }

        if (state is! BusCompanyScheduleLoaded) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Schedule not ready')),
          );
        }

        final s = state;
        final schedule = s.schedule;

        final monthLabel = DateFormat('MMMM yyyy')
            .format(DateTime(schedule.year, schedule.month, 1));
        final domesticTrips = s.trips.where((t) => !t.borderCrossing).toList();
        final intlTrips = s.trips.where((t) => t.borderCrossing).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Company Schedule',
                  subtitle: s.company.name,
                  onBack: () =>
                      context.read<BusBloc>().add(const LoadBusHome()),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.14)),
                    ),
                    child: Row(
                      children: [
                        _NetLogo(url: s.company.logoUrl),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.company.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s.company.support,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.14)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 14, color: AppColors.accentYellow),
                              const SizedBox(width: 6),
                              Text(
                                s.company.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Column(
                    children: [
                      _RoutesList(
                        title: 'Domestic Routes',
                        trips: domesticTrips,
                        badgeColor: AppColors.accentGreen,
                      ),
                      const SizedBox(height: 12),
                      _RoutesList(
                        title: 'International Routes',
                        trips: intlTrips,
                        badgeColor: AppColors.accentOrange,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _changeMonth(-1),
                        icon: const Icon(Iconsax.arrow_left_2),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            monthLabel,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _changeMonth(1),
                        icon: const Icon(Iconsax.arrow_right_3),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: schedule.days.length,
                    itemBuilder: (_, i) {
                      final d = schedule.days[i];
                      final dayOfWeek = DateFormat('E').format(d.date);
                      final active = d.tripsCount > 0;
                      final isToday = d.date.year == DateTime.now().year &&
                          d.date.month == DateTime.now().month &&
                          d.date.day == DateTime.now().day;

                      Color bgColor;
                      Color borderColor;
                      Color textColor;
                      Color subTextColor;

                      if (active) {
                        bgColor = AppColors.primary;
                        borderColor = AppColors.primary;
                        textColor = Colors.white;
                        subTextColor = Colors.white.withOpacity(0.85);
                      } else {
                        bgColor = Colors.white;
                        borderColor = AppColors.border;
                        textColor = AppColors.textTertiary;
                        subTextColor = AppColors.textTertiary.withOpacity(0.6);
                      }

                      return InkWell(
                        onTap: active
                            ? () => _showTripsForDate(context, s, d.date)
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isToday ? AppColors.secondary : borderColor,
                              width: isToday ? 2.5 : 1.2,
                            ),
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color:
                                          AppColors.primary.withOpacity(0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayOfWeek,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: subTextColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${d.date.day}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                  height: 1.0,
                                ),
                              ),
                              if (active) ...[
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${d.tripsCount}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
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
}

class _RoutesList extends StatelessWidget {
  final String title;
  final List<BusTrip> trips;
  final Color badgeColor;

  const _RoutesList({
    required this.title,
    required this.trips,
    this.badgeColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('HH:mm');
    if (trips.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          '$title • No upcoming trips',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...trips.take(6).map((t) {
            final dur = t.duration;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      t.borderCrossing ? 'INTL' : 'DOM',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: badgeColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${t.from} → ${t.to}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              timeFmt.format(t.departAt),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Iconsax.arrow_right_3,
                                size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              timeFmt.format(t.arriveAt),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${dur.inHours}h ${dur.inMinutes.remainder(60)}m',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${t.pricePerPassenger.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        t.classLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

void _showTripsForDate(
  BuildContext context,
  BusCompanyScheduleLoaded state,
  DateTime date,
) {
  final trips = state.trips.where((t) {
    return t.departAt.year == date.year &&
        t.departAt.month == date.month &&
        t.departAt.day == date.day;
  }).toList();

  if (trips.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No trips for this date')),
    );
    return;
  }

  final timeFmt = DateFormat('HH:mm');

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Trips on ${DateFormat('EEE, MMM dd').format(date)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...trips.map((t) {
                final dur = t.duration;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            const Icon(Iconsax.bus, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${t.from} → ${t.to}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(timeFmt.format(t.departAt),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(width: 4),
                                const Icon(Iconsax.arrow_right_3,
                                    size: 12, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(timeFmt.format(t.arriveAt),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(width: 6),
                                Text(
                                  '${dur.inHours}h ${dur.inMinutes.remainder(60)}m',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              children: [
                                _miniChip(t.classLabel),
                                _miniChip(t.borderCrossing
                                    ? 'International'
                                    : 'Domestic'),
                                _miniChip('${t.seatsLeft} seats left'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${t.pricePerPassenger.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<BusBloc>().add(SelectBusTrip(t.id));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<BusBloc>(),
                                    child: const BusTripDetailsScreen(),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Select',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    },
  );
}

Widget _miniChip(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.surfaceDark,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    ),
  );
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

class _NetLogo extends StatelessWidget {
  final String url;
  const _NetLogo({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 52,
        height: 52,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.primary.withOpacity(0.06),
            child: const Icon(Iconsax.bus, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
