import 'package:flutter/material.dart';

import '../../core/color.dart';
import '../../models/history_model.dart';

class HistoryCard extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onTap;

  const HistoryCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3DEC1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.title1.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.titleName,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6E625C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.price,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6E625C),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black54,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
