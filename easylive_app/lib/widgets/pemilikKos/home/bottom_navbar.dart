import 'package:flutter/material.dart';

import '../../../core/color.dart';

class OwnerBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final Function(int)? onNavigate;

  const OwnerBottomNav({
    super.key,
    this.currentIndex = 2,
    this.onTap,
    this.onNavigate,
  });

  void _handleTap(int index) {
    onTap?.call(index);
    onNavigate?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.dashboard_customize_outlined,
                label: 'Dashboard',
                active: currentIndex == 0,
                onTap: () => _handleTap(0),
              ),
              const SizedBox(width: 20),
              _BottomNavItem(
                icon: Icons.bookmark_border_rounded,
                label: 'Bookings',
                active: currentIndex == 3,
                onTap: () => _handleTap(3),
              ),
            ],
          ),
          Positioned(
            top: -18,
            child: GestureDetector(
              onTap: () => _handleTap(2),
              child: Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: AppColors.darkBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 39,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.darkBlue
        : AppColors.darkBlue.withOpacity(0.58);

    return SizedBox(
      width: 58,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 9,
                color: color,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}