import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RouteCard extends StatelessWidget {
  final String? fromLocation;
  final String? toLocation;
  final DateTime selectedDate;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final ValueChanged<DateTime> onDateChanged;

  const RouteCard({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.selectedDate,
    required this.onFromTap,
    required this.onToTap,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Lokasi
          Row(
            children: [
              Column(
                children: [
                  const Icon(Icons.arrow_upward, size: 18, color: Colors.grey),
                  Container(height: 35, width: 1, color: Colors.grey[300]),
                  const Icon(Icons.arrow_downward, size: 18, color: Colors.grey),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  children: [
                    _buildLocationItem('From', fromLocation ?? 'Lowokwaru, Malang', onFromTap),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(thickness: 1, color: Color(0xFF2D3E50)),
                    ),
                    _buildLocationItem('To', toLocation ?? 'Sawojajar, Malang', onToTap),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.push_pin_rounded, color: Colors.black, size: 24),
            ],
          ),
          const SizedBox(height: 25),
          
          // Bagian Departure & Tanggal
          const Text(
            'Departure',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3E50)),
          ),
          const SizedBox(height: 15),
          
          Row(
            children: [
              // List Tanggal 26-30
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    DateTime date = DateTime(2026, 4, 26 + index);
                    bool isSelected = date.day == selectedDate.day;
                    return GestureDetector(
                      onTap: () => onDateChanged(date),
                      child: Column(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFD1DDE6) : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${date.day}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3E50)),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('E').format(date).toUpperCase(),
                            style: TextStyle(
                              fontSize: 10, 
                              color: isSelected ? Colors.black : Colors.grey,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              // Garis Vertikal Pemisah
              Container(height: 40, width: 1.5, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 15)),
              // Bulan & Tahun
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat('APR').format(selectedDate).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.amber),
                    ],
                  ),
                  Text(
                    DateFormat('2026').format(selectedDate),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 14, 
                color: Color(0xFF2D3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}