import 'package:aman_booking/features/tours/bloc/tour_bloc.dart';
import 'package:aman_booking/core/payment/data/repositories/payment_repository_impl.dart';
import 'package:aman_booking/core/payment/domain/repositories/payment_repository.dart';
import 'package:aman_booking/features/tours/presentation/screens/tour_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aman_booking/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aman_booking/features/support/bloc/support_bloc.dart';
import 'package:aman_booking/features/support/data/repositories/support_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PaymentRepository>(
          create: (_) => PaymentRepositoryImpl(),
        ),
        RepositoryProvider<SupportRepository>(
          create: (_) => SupportRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TourBloc>(
            // ← singleton / lazy
            create: (_) => TourBloc(tourRepository: TourRepositoryImpl()),
          ),
          BlocProvider<SupportBloc>(
            create: (context) => SupportBloc(
              context.read<SupportRepository>(),
            ),
          ),
          // other providers …
        ],
        child: const TravelApp(),
      ),
    ),
  );
}
