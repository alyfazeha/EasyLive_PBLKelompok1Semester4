import 'package:flutter/material.dart';

import '../../../core/color.dart';

/// Index mapping:
/// 0 = Dashboard
/// 1 = Jasa (owner jasa)
/// 2 = Home (fab circle center)
/// 3 = Bookings
/// 4 = Profile
class PemilikJasaBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onNavigate;

  const PemilikJasaBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      height: 62,
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
                onTap: () => onNavigate?.call(0),
              ),
              _BottomNavItem(
                icon: Icons.inventory_2_outlined,
                label: 'Jasa',
                active: currentIndex == 1,
                onTap: () => onNavigate?.call(1),
              ),
              _BottomNavItem(
                icon: Icons.bookmark_border_rounded,
                label: 'Bookings',
                active: currentIndex == 3,
                onTap: () => onNavigate?.call(3),
              ),
              _BottomNavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                active: currentIndex == 4,
                onTap: () => onNavigate?.call(4),
              ),
            ],
          ),

          /// Center FAB (Home)
          Positioned(
            top: -18,
            child: GestureDetector(
              onTap: () => onNavigate?.call(2),
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
                  size: 38,
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
        : AppColors.darkBlue.withValues(alpha: 0.62);

    return SizedBox(
      width: 72,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
