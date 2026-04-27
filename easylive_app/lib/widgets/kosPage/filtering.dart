import 'package:flutter/material.dart';
import '../../core/color.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(String?, RangeValues?) onApply;

  const FilterBottomSheet({super.key, required this.onApply});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String selectedFilter = "location";
  final TextEditingController locationController = TextEditingController();
  RangeValues? selectedPrice;

  Widget _buildToggle(String text, String value) {
    final isActive = selectedFilter == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.darkBlue : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _priceChip(String label, RangeValues range) {
    final isSelected = selectedPrice == range;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPrice = range;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DRAG HANDLE
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          /// TITLE
          const Text(
            "Filter",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          /// TOGGLE
          Row(
            children: [
              _buildToggle("Location", "location"),
              const SizedBox(width: 10),
              _buildToggle("Price", "price"),
            ],
          ),

          const SizedBox(height: 20),

          /// LOCATION INPUT
          if (selectedFilter == "location") ...[
            const Text("Location",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: "Search city...",
                prefixIcon: const Icon(Icons.location_on_outlined),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],

          /// PRICE CHIP
          if (selectedFilter == "price") ...[
            const Text("Popular Range",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _priceChip("< 500K", const RangeValues(0, 500000)),
                _priceChip("500K - 1M", const RangeValues(500000, 1000000)),
                _priceChip("1M - 1.5M", const RangeValues(1000000, 1500000)),
                _priceChip("1.5M - 2M", const RangeValues(1500000, 2000000)),
                _priceChip("> 2M", const RangeValues(2000000, 999999999)),
              ],
            ),
          ],

          const SizedBox(height: 25),

          /// APPLY BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              onPressed: () {
                widget.onApply(
                  selectedFilter == "location"
                      ? locationController.text
                      : null,
                  selectedFilter == "price" ? selectedPrice : null,
                );
                Navigator.pop(context);
              },
              child: const Text(
                "Apply Filter",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}