// lib/features/tours/presentation/screens/tours_main_screen.dart
import 'package:aman_booking/features/tours/bloc/tour_bloc.dart';
import 'package:aman_booking/features/tours/presentation/screens/tour_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:aman_booking/features/tours/presentation/screens/tours_list_screen.dart';
import 'package:aman_booking/features/tours/presentation/screens/tour_operator_dashboard.dart';

class ToursMainScreen extends StatelessWidget {
  final String? operatorId;

  const ToursMainScreen({super.key, this.operatorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TourBloc(
        tourRepository: TourRepositoryImpl(),
      ),
      child: operatorId == null
          ? const ToursListScreen()
          : TourOperatorDashboard(operatorId: operatorId!),
    );
  }
}
