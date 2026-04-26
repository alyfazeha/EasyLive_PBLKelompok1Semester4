import 'package:flutter/material.dart';
import '../../core/color.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/home/bottom_navbar.dart';
import '../../models/kos_model.dart';
import '../../widgets/kosPage/kos_card.dart';
import '../home/home_view.dart';
import '../kos/detailKos_view.dart';
import '../../widgets/kosPage/detail_kos_widgets.dart';

class KosView extends StatefulWidget {
  const KosView({super.key});

  @override
  State<KosView> createState() => _KosViewState();
}

class _KosViewState extends State<KosView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<KostModel> _allKostList = [];

  @override
  void initState() {
    super.initState();
    _allKostList = HomeController.getKostList() ?? [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<KostModel> get _filteredKostList {
    if (_searchQuery.isEmpty) return _allKostList;
    return _allKostList.where((kost) {
      return kost.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          kost.address.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userName = HomeController.getUserName() ?? "Alyfa";

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
                      color: Color(0xFF2D3E50),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(35),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundImage: AssetImage(
                            'assets/images/alyfa.jpeg',
                          ),
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
                        IconButton(
                          onPressed: () {
                            print("Buka Chat");
                          },
                          icon: const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // --- SEARCH BAR ---
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
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search kos...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF2D3E50),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 18,
                      ),
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
              child: _filteredKostList.isEmpty
                  ? const Center(
                      child: Text(
                        'No kos found',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 10),
                      itemCount: _filteredKostList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.63,
                          ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailKosView(
                                  kost: _filteredKostList[index],
                                ),
                              ),
                            );
                          },
                          child: KostCard(
                            kost: _filteredKostList[index],
                            index: index,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false,
            );
          } else if (index == 2) {
            print("Sudah di halaman Booking/History");
          }
        },
      ),
    );
  }
}
