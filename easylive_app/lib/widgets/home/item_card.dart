import 'package:flutter/material.dart';
import '../../pages/kosPage.dart';

class ItemCard extends StatelessWidget {
  final String image;

  const ItemCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Logika pindah ke detail nanti di sini
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Klik item")),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFF801010), // Warna merah gelap sesuai desain
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Teks rata kiri
          children: [
            // --- BAGIAN GAMBAR ---
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            // --- BAGIAN DETAIL TEKS ---
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Kost Melati",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Jl. Cengger Ayam",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}