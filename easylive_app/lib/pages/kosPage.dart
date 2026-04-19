import 'package:flutter/material.dart';
import '../../widgets/home/botton_navbar.dart';
import '../../widgets/kosPage/searching.dart'; // Pastikan file ini berisi SearchFilterWidget

class KostPage extends StatefulWidget {
  const KostPage({super.key});

  @override
  State<KostPage> createState() => _KostPageState();
}

class _KostPageState extends State<KostPage> {
  // 1. Data Master (Database lokal aplikasi)
  final List<Map<String, dynamic>> allKost = [
    {"name": "Kost Melati", "price": 650000, "image": "images/kos1.jpg", "loc": "Cengger Ayam"},
    {"name": "Kost Mawar", "price": 1200000, "image": "images/kos2.jpg", "loc": "Suhat"},
    {"name": "Kost Elite", "price": 2500000, "image": "images/kos1.jpg", "loc": "Lowokwaru"},
    {"name": "Kost Lavender", "price": 800000, "image": "images/kos2.jpg", "loc": "Sigura-gura"},
    {"name": "Kost Melati 2", "price": 700000, "image": "images/kos1.jpg", "loc": "Cengger Ayam"},
    {"name": "Kost Bangunan Baru", "price": 1500000, "image": "images/kos2.jpg", "loc": "Lowokwaru"},
  ];

  // 2. Data yang ditampilkan (hasil filter)
  List<Map<String, dynamic>> displayedKost = [];

  @override
  void initState() {
    super.initState();
    displayedKost = allKost; // Saat pertama kali buka, tampilkan semua
  }

  // 3. Fungsi Filter Utama
  void _applyFilter(String query, String location, double maxPrice) {
    setState(() {
      displayedKost = allKost.where((kost) {
        final matchesName = kost['name'].toLowerCase().contains(query.toLowerCase());
        final matchesLoc = location == "Semua" || kost['loc'] == location;
        final matchesPrice = kost['price'] <= maxPrice;

        return matchesName && matchesLoc && matchesPrice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6C9A8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. HEADER ---
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Hi Rafi,", style: TextStyle(color: Color(0xFF5E0006), fontSize: 16, fontWeight: FontWeight.bold)),
                        RichText(
                          text: const TextSpan(
                            text: "Welcome to ",
                            style: TextStyle(color: Color(0xFF5E0006), fontSize: 14),
                            children: [TextSpan(text: "EasyKost !", style: TextStyle(fontWeight: FontWeight.bold))],
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.chat_bubble_outline, color: Color(0xFF5E0006), size: 30),
                  ],
                ),
              ),

              // --- 2. SEARCH & FILTER SECTION (GANTI SEARCH BAR LAMA) ---
              SearchFilterWidget(
                onFilterChanged: (q, loc, price) => _applyFilter(q, loc, price),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 10),
                child: Text("Kost", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5E0006))),
              ),

              // --- 3. GRID VIEW KOST (DIAMBIL DARI displayedKost) ---
              displayedKost.isEmpty 
              ? const Center(child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text("Kost tidak ditemukan...", style: TextStyle(color: Color(0xFF801010))),
                ))
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: displayedKost.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final item = displayedKost[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF801010),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.asset(item['image'], width: double.infinity, fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(item['loc'], style: const TextStyle(color: Colors.white70, fontSize: 11)),
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text("Rp. ${item['price'].toString()}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: -1), 
    );
  }
}