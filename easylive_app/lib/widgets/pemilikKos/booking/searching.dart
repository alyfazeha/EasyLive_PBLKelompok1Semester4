import 'package:flutter/material.dart';
import '../../../core/color.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String)? onChanged;

  const SearchBarWidget({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Cari Penyewa...",
        hintStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 13,
          color: AppColors.grey,
        ),
        prefixIcon: const Icon(Icons.search, color: AppColors.grey),
        suffixIcon: const Icon(Icons.tune, color: AppColors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.darkBlue),
        ),
      ),
    );
  }
}
