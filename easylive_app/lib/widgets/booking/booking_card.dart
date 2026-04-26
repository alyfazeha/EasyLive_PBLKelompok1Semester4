import 'package:flutter/material.dart';

import '../../core/color.dart';
import '../../models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
<<<<<<< HEAD
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3DEC1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
=======
<<<<<<< Updated upstream
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E3DC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black87, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  offset: Offset(0, 2),
                  blurRadius: 4,
=======
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
>>>>>>> Stashed changes
                ),
              ],
            ),
            child: const Text(
              "kost",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
>>>>>>> ailsa
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
<<<<<<< HEAD
                child: Container(
                  height: 1,
                  color: AppColors.title1.withValues(alpha: 0.45),
=======
<<<<<<< Updated upstream
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
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 1.5,
                            color: AppColors.title1.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.location,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${booking.price}/month",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
=======
                child: Container(
                  height: 1,
                  color: AppColors.primary.withOpacity(0.35),
>>>>>>> Stashed changes
>>>>>>> ailsa
                ),
              ),
            ],
          ),
<<<<<<< HEAD
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
=======
<<<<<<< Updated upstream
=======
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
>>>>>>> ailsa
          Text(
            '${booking.price}/month',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
<<<<<<< HEAD
              fontSize: 12,
              color: Color(0xFF6A4F45),
            ),
          ),
=======
              fontSize: 13,
              color: AppColors.primary,
              fontFamily: 'Montserrat',
            ),
          ),
>>>>>>> Stashed changes
>>>>>>> ailsa
        ],
      ),
    );
  }
}
