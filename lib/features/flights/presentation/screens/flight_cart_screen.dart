import 'package:aman_booking/features/flights/bloc/flights_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aman_booking/core/constants/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'dart:math' as math;

class FlightTicketCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback? onSelect;

  const FlightTicketCard({
    super.key,
    required this.flight,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd MMM');
    final dayFormat = DateFormat('EEE');

    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Main content
              Row(
                children: [
                  // Left section - Main ticket info
                  Expanded(
                    flex: 7,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Airline header
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    flight.airlineCode,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flight.airline,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      flight.flightNumber,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Route - Big airport codes
                          Row(
                            children: [
                              // From
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flight.origin
                                          .split('(')[1]
                                          .replaceAll(')', ''),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                        height: 1.0,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      flight.origin.split('(')[0].trim(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Airplane icon
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    Icon(
                                      Iconsax.airplane,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      height: 1,
                                      width: 30,
                                      color: AppColors.primary.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),

                              // To
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      flight.destination
                                          .split('(')[1]
                                          .replaceAll(')', ''),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                        height: 1.0,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      flight.destination.split('(')[0].trim(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // Bottom info row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Date & Time
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DEPARTURE',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textTertiary,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    timeFormat.format(flight.departureTime),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${dayFormat.format(flight.departureTime)}, ${dateFormat.format(flight.departureTime)}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),

                              // Duration
                              Column(
                                children: [
                                  Text(
                                    'DURATION',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textTertiary,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    flight.duration,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),

                              // Price
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'PRICE',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textTertiary,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '\$${flight.price.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Dotted separator line
                  CustomPaint(
                    size: const Size(1, double.infinity),
                    painter: DottedLinePainter(),
                  ),

                  // Right section - Stub with barcode
                  SizedBox(
                    width: 90,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top - Flight number
                          Column(
                            children: [
                              Text(
                                flight.flightNumber,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: flight.stops == 0
                                      ? AppColors.accentGreen.withOpacity(0.1)
                                      : AppColors.accentOrange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: flight.stops == 0
                                        ? AppColors.accentGreen.withOpacity(0.3)
                                        : AppColors.accentOrange
                                            .withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  flight.stops == 0
                                      ? 'Direct'
                                      : '${flight.stops} Stop',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                    color: flight.stops == 0
                                        ? AppColors.accentGreen
                                        : AppColors.accentOrange,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Middle - Route codes (vertical)
                          Column(
                            children: [
                              Text(
                                flight.origin.split('(')[1].replaceAll(')', ''),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                              Icon(
                                Iconsax.arrow_down,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              Text(
                                flight.destination
                                    .split('(')[1]
                                    .replaceAll(')', ''),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),

                          // Bottom - Small barcode
                          Column(
                            children: [
                              CustomPaint(
                                size: const Size(50, 35),
                                painter: BarcodePainter(),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'BOARDING PASS',
                                style: TextStyle(
                                  fontSize: 7,
                                  color: AppColors.textTertiary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Top notch (left)
              Positioned(
                left: -8,
                top: -8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.3),
                    ),
                  ),
                ),
              ),

              // Bottom notch (left)
              Positioned(
                left: -8,
                bottom: -8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.3),
                    ),
                  ),
                ),
              ),

              // Top notch (right)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.3),
                    ),
                  ),
                ),
              ),

              // Bottom notch (right)
              Positioned(
                right: -8,
                bottom: -8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.3),
                    ),
                  ),
                ),
              ),

              // Middle notches (for tear line)
              Positioned(
                right: 82,
                top: -8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.3),
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 82,
                bottom: -8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dotted line painter for ticket separation
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Small barcode painter
class BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern
    final lineCount = 25;
    final spacing = size.width / lineCount;

    for (int i = 0; i < lineCount; i++) {
      final width = random.nextBool() ? 1.0 : 1.5;
      final x = i * spacing;

      canvas.drawRect(
        Rect.fromLTWH(x, 0, width, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
