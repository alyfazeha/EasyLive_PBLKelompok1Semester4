import 'package:flutter/material.dart';
import '../../pages/kosPage.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Categories",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5E0006),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // --- TOMBOL KOST (Bisa di-tap) ---
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    print("Tombol Kost diklik!");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KostPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAC793),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Kost",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E0006),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),

              // --- TOMBOL JASA (Bisa di-tap) ---
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Sementara kita arahkan ke halaman yang sama
                    // atau kamu bisa ganti ke JasaPage() jika sudah ada
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KostPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAC793),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Jasa",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E0006),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            " Recommendation For you",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5E0006),
            ),
          ),
        ],
      ),
    );
  }
}