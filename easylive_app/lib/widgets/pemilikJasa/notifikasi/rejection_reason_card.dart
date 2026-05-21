import 'package:flutter/material.dart';

class RejectionReasonCard extends StatelessWidget {
  final String reason;

  const RejectionReasonCard({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alasan Penolakan',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F4157),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7F7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFAD4D4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  reason,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2F4157),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
