import 'package:flutter/material.dart';
import '../../core/color.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/home/bottom_navbar.dart';
import '../../models/kos_model.dart';
import '../../widgets/kosPage/kos_card.dart';
import '../home/home_view.dart';

class KosView extends StatefulWidget {
  const KosView({super.key});

  @override
  State<KosView> createState() => _KosViewState();
}

class _KosViewState extends State<KosView> {
  // Controller untuk menangkap input pencarian
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil data user dan daftar kos dari controller
    final userName = HomeController.getUserName() ?? "Alyfa";
    final List<KostModel> kostList = HomeController.getKostList() ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- HEADER SECTION ---
          Stack(
            clipBehavior: Clip.none,
            children: [
              Hero(
                tag: 'header_bg',
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(25, 60, 25, 70),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D3E50), // Warna Primer
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(35),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundImage: AssetImage('assets/images/alyfa.jpeg'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, $userName',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Welcome to EasyLive !',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tombol Chat fungsional
                        IconButton(
                          onPressed: () {
                            // Navigasi ke halaman Chat/Pesan
                            print("Buka Chat");
                          },
                          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // --- SEARCH BAR DENGAN FILTER ---
              Positioned(
                left: 25,
                right: 25,
                bottom: -25,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (value) {
                      print("Mencari kos: $value");
                    },
                    decoration: InputDecoration(
                      hintText: "Search....",
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          onPressed: () {
                            // Fungsi Filter
                            print("Membuka Filter");
                          },
                          icon: const Icon(
                            Icons.filter_alt_rounded, 
                            color: Color(0xFF2D3E50), 
                            size: 30
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF0F0F0),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),

          // --- TITLE SECTION ---
          const Text(
            'See All Kost',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3E50),
            ),
          ),

          const SizedBox(height: 15),

          // --- GRID KOST ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 100, top: 10),
                itemCount: kostList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.63, 
                ),
                itemBuilder: (context, index) {
                  // Membungkus KostCard dengan InkWell untuk interaksi navigasi detail
                  return InkWell(
                    onTap: () {
                      print("Navigasi ke detail kos: ${kostList[index].name}");
                    },
                    child: KostCard(kost: kostList[index], index: index),
                  );
                },
              ),
            ),
          )
        ],
      ),
      // Navigasi bawah menggunakan BottomNav custom
      // Ganti bagian bottomNavigationBar di KosView dengan ini:
      bottomNavigationBar: BottomNav(
        currentIndex: 2, // Menandakan kita sedang di menu Kos/History
        onTap: (index) {
          if (index == 0) {
            // 1. TOMBOL RUMAH: Balik ke Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false,
            );
          } 
          else if (index == 1) {
            // 2. TOMBOL TENGAH (Logo/EasyLive): 
            // Biasanya ini balik ke Home utama atau fungsi utama aplikasi
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false,
            );
          } 
          else if (index == 2) {
            // 3. TOMBOL HISTORY/BOOKING:
            // Karena kita sudah di KosView, tidak perlu pindah (diam saja)
            print("Sudah di halaman Booking/History");
          }
        },
      ),
    );
  }
}