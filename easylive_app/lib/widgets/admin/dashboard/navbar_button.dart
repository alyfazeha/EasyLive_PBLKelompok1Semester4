import 'package:flutter/material.dart';

class AdminNavbarButton extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AdminNavbarButton({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color navy = Color(0xFF243447);
    const Color yellow = Color(0xFFF6BE00);

    const double selectedIconSize = 28;
    const double normalIconSize = 21;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected ? navy : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: navy.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              isSelected ? selectedIcon : icon,
              size: isSelected ? selectedIconSize : normalIconSize,
              color: isSelected ? yellow : navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AdminBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Urutan sesuai gambar: History, Kost, Dashboard, Jasa, Profile
    // Ikon aktif dibuat lebih “bold” dengan varian icon yang lebih filled.
    final List<(IconData normalIcon, IconData selectedIcon, String label, int idx)> items =
        [
      (Icons.history, Icons.history, 'History', 1),
      (Icons.home_work, Icons.home, 'Kost', 2),
      (Icons.dashboard_customize_outlined, Icons.dashboard_customize, 'Dashboard', 0),
      (Icons.miscellaneous_services, Icons.miscellaneous_services, 'Jasa', 3),
      (Icons.person_outline, Icons.person, 'Profile', 4),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6BE00),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(items.length, (i) {
            final (normalIcon, selectedIcon, label, idx) = items[i];

            return Expanded(
              child: AdminNavbarButton(
                icon: normalIcon,
                selectedIcon: selectedIcon,
                label: label,
                isSelected: selectedIndex == idx,
                onTap: () => onItemTapped(idx),
              ),
            );
          }),
        ),
      ),
    );
  }
}
