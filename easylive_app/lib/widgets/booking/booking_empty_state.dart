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
          const _EmptyPaperIllustration(),
          const SizedBox(height: 34),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.title1,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _EmptyPaperIllustration extends StatelessWidget {
  const _EmptyPaperIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 240,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.12,
            child: Transform.translate(
              offset: const Offset(-10, 18),
              child: Container(
                width: 118,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F2EC),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Transform.rotate(
            angle: 0.06,
            child: Transform.translate(
              offset: const Offset(16, 8),
              child: Container(
                width: 126,
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0EA),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFE7E0D6)),
                ),
              ),
            ),
          ),
          Container(
            width: 132,
            height: 170,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  offset: Offset(0, 5),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
          const Positioned(
            top: 22,
            left: 44,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-0.12),
              child: Icon(
                Icons.attach_file_rounded,
                size: 44,
                color: Color(0xFFD1A8A3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
