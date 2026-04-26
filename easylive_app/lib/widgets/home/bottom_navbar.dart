import 'package:flutter/material.dart';
import '../../core/color.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  // Tambahkan baris ini agar BottomNav bisa menerima fungsi klik
  final Function(int)? onTap; 

  const BottomNav({
    super.key, 
    required this.currentIndex, 
    this.onTap // Tambahkan ini di constructor
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // 1. BAR KUNING
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    _buildItem(
                      Icons.history_rounded, 
                      "History", 
                      currentIndex == 0, 
                      () => onTap?.call(0), // Mengirim index 0 saat diklik
                    ),
                    
                    const SizedBox(width: 70), 
                    
                    _buildItem(
                      Icons.bookmark_border_rounded, 
                      "Bookings", 
                      currentIndex == 2, 
                      () => onTap?.call(2), // Mengirim index 2 saat diklik
                    ),
                  ],
                ),
              ),
            ),

            // 2. TOMBOL HOME
            Positioned(
              bottom: 5,
              child: GestureDetector(
                onTap: () => onTap?.call(1), // Home dianggap index 1 (tengah)
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home_rounded, 
                    color: Colors.white, 
                    size: 32
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque, 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              color: active ? AppColors.primary : AppColors.primary.withOpacity(0.5), 
              size: 26
            ),
            const SizedBox(height: 2),
            Text(
              label, 
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}