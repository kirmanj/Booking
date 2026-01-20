import 'package:aman_booking/features/bus_tickets/bloc/bus_bloc.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_event.dart';
import 'package:aman_booking/features/bus_tickets/bloc/bus_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/bus_tickets/presentation/screens/bus_company_schedule_screen.dart';

class BusHomeScreen extends StatelessWidget {
  const BusHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BusBloc()..add(const LoadBusHome()),
      child: const _BusHomeView(),
    );
  }
}

class _BusHomeView extends StatelessWidget {
  const _BusHomeView();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<BusBloc, BusState>(
          listener: (context, state) {
            if (state is BusResultsLoaded) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => BlocProvider.value(
              //       value: context.read<BusBloc>(),
              //       child: const BusResultsScreen(),
              //     ),
              //   ),
              // );
            }

            if (state is BusError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              // return to home quickly after showing error (optional)
              context.read<BusBloc>().add(const LoadBusHome());
            }
          },
          builder: (context, state) {
            if (state is BusLoading || state is BusInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is BusHomeLoaded) {
              final q = state.query;

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    backgroundColor: AppColors.surface,
                    elevation: 0,
                    toolbarHeight: 64,
                    automaticallyImplyLeading: false,
                    titleSpacing: 8,
                    shape: Border(
                      bottom: BorderSide(
                        color: AppColors.primary.withOpacity(0.26),
                        width: 1,
                      ),
                    ),
                    title: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 18),
                          color: AppColors.textPrimary,
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Bus Tickets',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: _SearchCard(
                        query: q,
                        onToggleInternational: (v) => context
                            .read<BusBloc>()
                            .add(UpdateInternationalToggle(v)),
                        onPickFrom: () => _pickCity(
                          context,
                          title: 'From',
                          current: q.from,
                          onSelected: (v) =>
                              context.read<BusBloc>().add(UpdateFromCity(v)),
                        ),
                        onPickTo: () => _pickCity(
                          context,
                          title: 'To',
                          current: q.to,
                          onSelected: (v) =>
                              context.read<BusBloc>().add(UpdateToCity(v)),
                        ),
                        onSwap: () =>
                            context.read<BusBloc>().add(const SwapBusCities()),
                        onPickDate: () => _pickDate(
                          context,
                          initial: q.date,
                          onSelected: (d) =>
                              context.read<BusBloc>().add(UpdateBusDate(d)),
                        ),
                        onPickPassengers: () => _pickPassengers(
                          context,
                          current: q.passengers,
                          onSelected: (n) => context
                              .read<BusBloc>()
                              .add(UpdatePassengersCount(n)),
                        ),
                        onSearch: () =>
                            context.read<BusBloc>().add(const SearchBusTrips()),
                      ),
                    ),
                  ),
                  if (state.featuredTrips.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Routes between your cities',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ...state.featuredTrips
                                .take(6)
                                .map(
                                  (trip) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _RoutePreviewCard(
                                      trip: trip,
                                      company: state.companies.firstWhere(
                                          (c) => c.id == trip.companyId,
                                          orElse: () => state.companies.first),
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Bus Companies',
                      subtitle: 'Profiles + Monthly schedules',
                      onSeeAll: () {},
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: (screen.height * 0.20),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.companies.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          final c = state.companies[i];
                          return _CompanyCard(
                            company: c,
                            query: q,
                            onSchedule: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<BusBloc>(),
                                    child: BusCompanyScheduleScreen(
                                      companyId: c.id,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                      child: _InfoBox(
                        title: 'What you can do here',
                        lines: const [
                          '• Search buses between cities inside the same country (Domestic).',
                          '• Search cross-border routes (International).',
                          '• View each company monthly schedule (available days + sample departures).',
                          '• Pick seats, add passenger details, and finish payment with an e-ticket.',
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is BusError) return Center(child: Text(state.message));
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime initial,
    required void Function(DateTime) onSelected,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onSelected(picked);
  }

  Future<void> _pickCity(
    BuildContext context, {
    required String title,
    required String current,
    required void Function(String) onSelected,
  }) async {
    final controller = TextEditingController(text: current);

    // demo list: domestic + international
    final cities = <String>[
      'Erbil, Iraq',
      'Baghdad, Iraq',
      'Basra, Iraq',
      'Najaf, Iraq',
      'Duhok, Iraq',
      'Sulaymaniyah, Iraq',
      'Istanbul, Turkey',
      'Ankara, Turkey',
      'Gaziantep, Turkey',
      'Tehran, Iran',
      'Amman, Jordan',
    ];

    final res = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
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
                  Expanded(
                    child: Text(
                      '$title city',
                      style: const TextStyle(
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
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  prefixIcon:
                      const Icon(Iconsax.location, color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: AppColors.primary.withOpacity(0.16)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: AppColors.primary.withOpacity(0.16)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.6),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: (MediaQuery.sizeOf(context).height * 0.35)
                    .clamp(220.0, 360.0),
                child: ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (_, i) {
                    final c = cities[i];
                    return ListTile(
                      leading: const Icon(Iconsax.location,
                          color: AppColors.primary),
                      title: Text(
                        c,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      onTap: () => Navigator.pop(context, c),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, controller.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Use this city',
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (res != null && res.trim().isNotEmpty) onSelected(res.trim());
  }

  Future<void> _pickPassengers(
    BuildContext context, {
    required int current,
    required void Function(int) onSelected,
  }) async {
    final res = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Passengers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(6, (i) => i + 1).map((n) {
                  final isActive = n == current;
                  return InkWell(
                    onTap: () => Navigator.pop(context, n),
                    child: Container(
                      width: 54,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.16),
                        ),
                      ),
                      child: Text(
                        '$n',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color:
                              isActive ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );

    if (res != null) onSelected(res);
  }
}

/// --- UI widgets for home ---

class _SearchCard extends StatelessWidget {
  final BusQuery query;
  final void Function(bool) onToggleInternational;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSwap;
  final VoidCallback onPickDate;
  final VoidCallback onPickPassengers;
  final VoidCallback onSearch;

  const _SearchCard({
    required this.query,
    required this.onToggleInternational,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSwap,
    required this.onPickDate,
    required this.onPickPassengers,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('EEE, MMM dd');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _ToggleChip(
                title: 'Domestic',
                active: !query.isInternational,
                onTap: () => onToggleInternational(false),
              ),
              const SizedBox(width: 10),
              _ToggleChip(
                title: 'International',
                active: query.isInternational,
                onTap: () => onToggleInternational(true),
              ),
              const Spacer(),
              InkWell(
                onTap: onSwap,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.16)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Iconsax.refresh, size: 18, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text(
                        'Swap',
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
          const SizedBox(height: 10),
          _PickField(
            icon: Iconsax.location,
            label: 'From',
            value: query.from,
            onTap: onPickFrom,
          ),
          const SizedBox(height: 10),
          _PickField(
            icon: Iconsax.location,
            label: 'To',
            value: query.to,
            onTap: onPickTo,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PickField(
                  icon: Iconsax.calendar_1,
                  label: 'Date',
                  value: df.format(query.date),
                  onTap: onPickDate,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PickField(
                  icon: Iconsax.profile_2user,
                  label: 'Passengers',
                  value: '${query.passengers}',
                  onTap: onPickPassengers,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.search_normal, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Search buses',
                    style: TextStyle(
                      fontSize: 14,
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
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;
  const _ToggleChip(
      {required this.title, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.14),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            color: active ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _PickField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _PickField({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.14)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12.8,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_down_1,
                size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSeeAll;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Row(
        children: [
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
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text(
              'See all',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final BusCompany company;
  final BusQuery query;
  final VoidCallback onSchedule;

  const _CompanyCard({
    required this.company,
    required this.query,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.sizeOf(context).width * 0.72).clamp(250.0, 320.0);

    return Container(
      width: w,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NetImage(url: company.logoUrl, size: 70),
                Text(
                  company.name,
                  style: const TextStyle(
                    fontSize: 13.8,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    const Icon(Iconsax.routing,
                        size: 12, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${query.from} → ${query.to}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    const Icon(Icons.star,
                        size: 12, color: AppColors.accentYellow),
                    const SizedBox(width: 2),
                    Text(
                      company.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text(
                      ' (${company.reviews})',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: company.highlights.take(2).map((h) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.14)),
                      ),
                      child: Text(
                        h,
                        style: const TextStyle(
                          fontSize: 10.2,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onSchedule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Schedule',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePreviewCard extends StatelessWidget {
  final BusTrip trip;
  final BusCompany company;
  const _RoutePreviewCard({required this.trip, required this.company});

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('HH:mm');
    final dur = trip.duration;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.network(
                    company.logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Iconsax.bus,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 14, color: AppColors.accentYellow),
                        const SizedBox(width: 4),
                        Text(
                          '${company.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${company.reviews})',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: trip.borderCrossing
                      ? AppColors.accentOrange.withOpacity(0.15)
                      : AppColors.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  trip.borderCrossing ? 'INTL' : 'DOM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: trip.borderCrossing
                        ? AppColors.accentOrange
                        : AppColors.accentGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.location,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${trip.from} → ${trip.to}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Iconsax.clock,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      timeFmt.format(trip.departAt),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 24,
                      height: 2,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeFmt.format(trip.arriveAt),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${dur.inHours}h ${dur.inMinutes.remainder(60)}m',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Text(
                  trip.classLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '\$${trip.pricePerPassenger.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/person',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final List<String> lines;
  const _InfoBox({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.14)),
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
          ...lines.map(
            (l) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                l,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetImage extends StatelessWidget {
  final String url;
  final double size;
  const _NetImage({required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: size,
        height: size,
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
