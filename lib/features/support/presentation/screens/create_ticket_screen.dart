import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:aman_booking/features/support/data/models/support_models.dart';
import 'package:aman_booking/features/support/bloc/support_bloc.dart';
import 'package:aman_booking/features/support/bloc/support_event.dart';
import 'package:aman_booking/features/support/bloc/support_state.dart';
import 'package:aman_booking/features/support/presentation/screens/ticket_detail_screen.dart';

class CreateTicketScreen extends StatefulWidget {
  final SupportCategory? preselectedCategory;

  const CreateTicketScreen({
    super.key,
    this.preselectedCategory,
  });

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final String _mockUserId = 'user_123';

  SupportCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.preselectedCategory;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocListener<SupportBloc, SupportState>(
        listener: (context, state) {
          if (state is TicketCreatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ticket created successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TicketDetailScreen(ticket: state.ticket),
              ),
            );
          } else if (state is SupportErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<SupportBloc, SupportState>(
          builder: (context, state) {
            if (state is SupportLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildCategorySection(),
                      const SizedBox(height: 24),
                      _buildSubjectField(),
                      const SizedBox(height: 20),
                      _buildDescriptionField(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Create Support Ticket',
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Iconsax.message_add,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Help',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Our team will respond within 2 hours',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Category',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Choose the service you need help with',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        _buildCategoryDropdown(),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = CategorySupportInfo.getAllCategories();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SupportCategory>(
          isExpanded: true,
          value: _selectedCategory,
          hint: const Text('Select a category'),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: categories.map((info) {
            return DropdownMenuItem<SupportCategory>(
              value: info.category,
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(info.icon),
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    info.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSubjectField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subject',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _subjectController,
          decoration: InputDecoration(
            hintText: 'Brief description of your issue',
            prefixIcon: const Icon(Iconsax.tag),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a subject';
            }
            if (value.length < 5) {
              return 'Subject must be at least 5 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: 'Describe your issue in detail...',
            alignLabelWithHint: true,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please describe your issue';
            }
            if (value.length < 20) {
              return 'Description must be at least 20 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitTicket,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.send_2, size: 20),
            SizedBox(width: 12),
            Text(
              'Create Ticket',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a category'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      context.read<SupportBloc>().add(
            CreateTicketEvent(
              userId: _mockUserId,
              category: _selectedCategory!,
              subject: _subjectController.text,
              description: _descriptionController.text,
            ),
          );
    }
  }

  IconData _getCategoryIcon(String iconName) {
    final iconMap = {
      'help-circle': Iconsax.message_question,
      'airplane': Iconsax.airplane,
      'building': Iconsax.building_4,
      'car': Iconsax.car,
      'map': Iconsax.map_1,
      'bus': Iconsax.bus,
      'sim-card': Iconsax.simcard,
      'taxi': Iconsax.car,
      'home': Iconsax.home_2,
      'wallet': Iconsax.wallet_3,
    };
    return iconMap[iconName] ?? Iconsax.information;
  }
}
