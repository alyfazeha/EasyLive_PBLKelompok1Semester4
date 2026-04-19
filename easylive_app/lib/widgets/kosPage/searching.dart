import 'package:flutter/material.dart';

class SearchFilterWidget extends StatefulWidget {
  final Function(String query, String location, double maxPrice) onFilterChanged;

  const SearchFilterWidget({super.key, required this.onFilterChanged});

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  String query = "";
  String selectedLocation = "Semua";
  double maxPrice = 3000000; // Default 3jt

  final List<String> locations = ["Semua", "Lowokwaru", "Suhat", "Cengger Ayam", "Sigura-gura"];

  void _update() {
    widget.onFilterChanged(query, selectedLocation, maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Search Bar ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFD4B08C).withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF801010)),
            ),
            child: TextField(
              onChanged: (value) { query = value; _update(); },
              decoration: const InputDecoration(
                hintText: "Cari nama kost...",
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF801010)),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // --- Dropdown Lokasi ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLocation,
                isExpanded: true,
                items: locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                onChanged: (val) {
                  setState(() => selectedLocation = val!);
                  _update();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}