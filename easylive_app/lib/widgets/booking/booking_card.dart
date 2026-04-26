import 'package:flutter/material.dart';

import '../../core/color.dart';
import '../../models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  booking.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.primary,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.primary.withOpacity(0.35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            booking.location,
            style: TextStyle(
              color: AppColors.primary.withOpacity(0.75),
              fontSize: 13,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${booking.price}/month',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: AppColors.primary,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
