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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3DEC1),
        borderRadius: BorderRadius.circular(10),
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
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.titleName,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.title1.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            booking.location,
            style: const TextStyle(
              color: Color(0xFF6A4F45),
              fontSize: 12,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            '${booking.price}/month',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Color(0xFF6A4F45),
            ),
          ),
        ],
      ),
    );
  }
}
