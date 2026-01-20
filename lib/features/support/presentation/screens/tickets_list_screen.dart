import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/bloc/support_bloc.dart';
import 'package:aman_booking/features/support/bloc/support_event.dart';
import 'package:aman_booking/features/support/bloc/support_state.dart';
import 'package:aman_booking/features/support/presentation/screens/ticket_detail_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class TicketsListScreen extends StatefulWidget {
  const TicketsListScreen({super.key});

  @override
  State<TicketsListScreen> createState() => _TicketsListScreenState();
}

class _TicketsListScreenState extends State<TicketsListScreen>
    with SingleTickerProviderStateMixin {
  final String _mockUserId = 'user_123';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<SupportBloc>().add(LoadTicketsEvent(_mockUserId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: BlocBuilder<SupportBloc, SupportState>(
              builder: (context, state) {
                if (state is SupportLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TicketsLoadedState) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTicketsList(
                        state.tickets
                            .where((t) => t.status == TicketStatus.open)
                            .toList(),
                        'No open tickets',
                      ),
                      _buildTicketsList(
                        state.tickets
                            .where((t) => t.status == TicketStatus.inProgress)
                            .toList(),
                        'No tickets in progress',
                      ),
                      _buildTicketsList(
                        state.tickets
                            .where((t) => t.status == TicketStatus.closed)
                            .toList(),
                        'No closed tickets',
                      ),
                    ],
                  );
                } else if (state is SupportErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.warning_2,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _buildTicketsList([], 'No tickets found');
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'My Support Tickets',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: false,
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(4),
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
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: '  Open  '),
          Tab(text: '  In Progress  '),
          Tab(text: '  Closed  '),
        ],
      ),
    );
  }

  Widget _buildTicketsList(List<SupportTicket> tickets, String emptyMessage) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.document,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<SupportBloc>().add(LoadTicketsEvent(_mockUserId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return _buildTicketCard(tickets[index]);
        },
      ),
    );
  }

  Widget _buildTicketCard(SupportTicket ticket) {
    final colorMap = {
      TicketStatus.open: AppColors.accentOrange,
      TicketStatus.inProgress: AppColors.primary,
      TicketStatus.closed: AppColors.textSecondary,
    };

    final color = colorMap[ticket.status] ?? AppColors.primary;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailScreen(ticket: ticket),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticket.getCategoryDisplayName(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    ticket.getStatusDisplayName(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ticket.subject,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              ticket.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Iconsax.clock,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  timeago.format(ticket.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (ticket.messages.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Iconsax.message,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${ticket.messages.length} message${ticket.messages.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
