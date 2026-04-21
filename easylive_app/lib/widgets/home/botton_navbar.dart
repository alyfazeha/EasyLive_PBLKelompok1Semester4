import 'package:flutter/material.dart';
import '../../core/color.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/booking');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFDDB892),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home_rounded, 0),
          _navItem(context, Icons.book_rounded, 1),
          _navItem(context, Icons.receipt_long_rounded, 2),
          _navItem(context, Icons.person_rounded, 3),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, int index) {
    bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => _navigate(context, index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: isActive ? 28 : 24,
          color: isActive ? AppColors.titleName : Colors.black,
        ),
      ),
    );
  }
}
