import 'package:flutter/material.dart';
import '../../../core/color.dart';

class BookingFilter extends StatelessWidget {
  final Function(String)? onChanged;
  final String selectedFilter;

  const BookingFilter({
    super.key,
    this.onChanged,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilterChipWidget(
            label: 'All',
            isActive: selectedFilter == 'All',
            onTap: () => onChanged?.call('All'),
          ),
          FilterChipWidget(
            label: 'Pending',
            isActive: selectedFilter == 'Pending',
            onTap: () => onChanged?.call('Pending'),
          ),
          FilterChipWidget(
            label: 'Aktif',
            isActive: selectedFilter == 'Aktif',
            onTap: () => onChanged?.call('Aktif'),
          ),
          FilterChipWidget(
            label: 'Selesai',
            isActive: selectedFilter == 'Selesai',
            onTap: () => onChanged?.call('Selesai'),
          ),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.darkBlue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.darkBlue,
          ),
        ),
      ),
    );
  }
}
