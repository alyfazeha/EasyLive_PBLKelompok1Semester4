import 'package:flutter/material.dart';
import '../../core/color.dart';

class BookingEmptyState extends StatelessWidget {
  final String message;
  final bool compactTopSpacing;

  const BookingEmptyState({
    super.key,
    required this.message,
    this.compactTopSpacing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28, compactTopSpacing ? 20 : 32, 28, 40),
      child: Column(
        children: [
          if (!compactTopSpacing) const Spacer(),

          const Icon(
            Icons.description_outlined,
            size: 80,
            color: AppColors.yellow,
          ),

          const SizedBox(height: 24),

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
