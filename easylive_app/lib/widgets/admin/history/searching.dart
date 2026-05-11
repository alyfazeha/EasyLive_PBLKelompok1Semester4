import 'package:flutter/material.dart';

class HistorySearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const HistorySearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Cari riwayat...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
