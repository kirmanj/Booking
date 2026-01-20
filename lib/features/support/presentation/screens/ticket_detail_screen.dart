import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/bloc/support_bloc.dart';
import 'package:aman_booking/features/support/bloc/support_event.dart';
import 'package:aman_booking/features/support/bloc/support_state.dart';
import 'package:intl/intl.dart';

class TicketDetailScreen extends StatefulWidget {
  final SupportTicket ticket;

  const TicketDetailScreen({
    super.key,
    required this.ticket,
  });

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _mockUserId = 'user_123';
  SupportTicket? _currentTicket;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _currentTicket = widget.ticket;
    context.read<SupportBloc>().add(LoadTicketDetailsEvent(widget.ticket.id));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocListener<SupportBloc, SupportState>(
        listener: (context, state) {
          if (state is TicketDetailsLoadedState) {
            setState(() {
              _currentTicket = state.ticket;
            });
            _scrollToBottom();
          } else if (state is MessageSentState) {
            _messageController.clear();
            context
                .read<SupportBloc>()
                .add(LoadTicketDetailsEvent(widget.ticket.id));
          } else if (state is SupportErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Column(
          children: [
            _buildTicketHeader(),
            Expanded(
              child: BlocBuilder<SupportBloc, SupportState>(
                builder: (context, state) {
                  if (state is SupportLoadingState && _currentTicket == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_currentTicket == null) {
                    return const Center(child: Text('No ticket data'));
                  }

                  return _buildMessagesList();
                },
              ),
            ),
            if (_currentTicket?.status != TicketStatus.closed)
              _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        '#${widget.ticket.id.substring(7, 13)}',
        style: const TextStyle(
          fontSize: 18,
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
      actions: [
        if (_currentTicket?.status != TicketStatus.closed)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'close') {
                _showCloseTicketDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'close',
                child: Row(
                  children: [
                    Icon(Iconsax.close_circle, size: 20),
                    SizedBox(width: 12),
                    Text('Close Ticket'),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTicketHeader() {
    if (_currentTicket == null) return const SizedBox.shrink();

    final colorMap = {
      TicketStatus.open: AppColors.accentOrange,
      TicketStatus.inProgress: AppColors.primary,
      TicketStatus.closed: AppColors.textSecondary,
    };

    final color = colorMap[_currentTicket!.status] ?? AppColors.primary;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
                  _currentTicket!.getCategoryDisplayName(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _currentTicket!.getStatusDisplayName(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _currentTicket!.subject,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Iconsax.clock,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Created ${DateFormat('MMM dd, yyyy • HH:mm').format(_currentTicket!.createdAt)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    final messages = _currentTicket!.messages;

    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'No messages yet',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isUser = message.isFromUser;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) _buildAvatar(false),
              if (!isUser) const SizedBox(width: 12),
              Flexible(
                child: _buildMessageBubble(message, isUser),
              ),
              if (isUser) const SizedBox(width: 12),
              if (isUser) _buildAvatar(true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: isUser
            ? LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isUser ? null : AppColors.accentGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isUser ? Iconsax.user : Iconsax.support,
        color: isUser ? Colors.white : AppColors.accentGreen,
        size: 20,
      ),
    );
  }

  Widget _buildMessageBubble(SupportMessage message, bool isUser) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUser
            ? AppColors.primary
            : AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isUser ? 20 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.messageType == MessageType.image && message.mediaUrl != null)
            _buildImageAttachment(message.mediaUrl!),
          if (message.messageType == MessageType.voice && message.mediaUrl != null)
            _buildVoiceAttachment(message.mediaUrl!),
          Text(
            message.content,
            style: TextStyle(
              fontSize: 15,
              color: isUser ? Colors.white : AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('HH:mm').format(message.sentAt),
            style: TextStyle(
              fontSize: 11,
              color: isUser
                  ? Colors.white.withOpacity(0.7)
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageAttachment(String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.gallery,
              size: 40,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              'Image Attachment',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceAttachment(String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Voice Message',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '0:15',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: _pickImage,
              icon: const Icon(Iconsax.gallery),
              color: AppColors.primary,
            ),
            IconButton(
              onPressed: _toggleRecording,
              icon: Icon(_isRecording ? Iconsax.stop_circle : Iconsax.microphone),
              color: _isRecording ? AppColors.error : AppColors.primary,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(
                  Iconsax.send_2,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    context.read<SupportBloc>().add(
          SendMessageEvent(
            ticketId: widget.ticket.id,
            senderId: _mockUserId,
            isFromUser: true,
            messageType: MessageType.text,
            content: _messageController.text.trim(),
          ),
        );
  }

  void _pickImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image picker will be implemented with backend integration'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording... (Will be implemented with backend)'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showCloseTicketDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Close Ticket',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to close this ticket? This action cannot be undone.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SupportBloc>().add(CloseTicketEvent(widget.ticket.id));
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Close Ticket'),
          ),
        ],
      ),
    );
  }
}
