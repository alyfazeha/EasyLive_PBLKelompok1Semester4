import 'package:flutter/material.dart';

class SearchFilterWidget extends StatefulWidget {
  final Function(String query, String location, double maxPrice)
  onFilterChanged;

  const SearchFilterWidget({super.key, required this.onFilterChanged});

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  String query = "";
  String selectedLocation = "All Address";
  double maxPrice = 3000000;

  final List<String> locations = [
    "All Address",
    "Lowokwaru",
    "Suhat",
    "Cengger Ayam",
    "Sigura-gura",
  ];

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
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFD4B08C).withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF801010)),
            ),
            child: TextField(
              onChanged: (value) {
                query = value;
                _update();
              },
              decoration: const InputDecoration(
                hintText: "Search Kos",
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF801010)),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Dropdown Lokasi
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: DropdownMenu<String>(
              initialSelection: selectedLocation,
              onSelected: (val) {
                setState(() => selectedLocation = val!);
                _update();
              },

              expandedInsets: EdgeInsets.zero,

              width: 350,
              menuHeight: 200,

              dropdownMenuEntries: locations
                  .map(
                    (loc) => DropdownMenuEntry(
                      value: loc,
                      label: loc,
                    ),
                  )
                  .toList(),

              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFFD4B08C).withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF801010)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF801010)),
                ),
              ),

              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFFD4B08C)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
