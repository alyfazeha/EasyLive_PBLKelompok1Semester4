import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../controllers/user/home_controller.dart';
import '../../../controllers/user/kos_controller.dart';
import '../../../widgets/user/home/bottom_navbar.dart';
import '../../../models/user/kos_model.dart';
import '../../../widgets/user/kosPage/kos_card.dart';
import '../kos/detailKos_view.dart';
import '../../../widgets/user/kosPage/filtering.dart';

class KosView extends StatefulWidget {
  const KosView({super.key});

  @override
  State<KosView> createState() => _KosViewState();
}

class _KosViewState extends State<KosView> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  List<KostModel> _allKostList = [];

  /// 🔥 FILTER STATE
  String? _selectedLocation;
  RangeValues? _selectedPrice;

  @override
  void initState() {
    super.initState();
    _allKostList = KostController.getAllKost();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 🔥 SEARCH + FILTER DIGABUNG
  List<KostModel> get _filteredKostList {
    return _allKostList.where((kost) {
      final matchSearch =
          kost.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          kost.address.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchLocation =
          _selectedLocation == null ||
          kost.address.toLowerCase().contains(_selectedLocation!.toLowerCase());

      final price = kost.price ?? 0;
      final matchPrice =
          _selectedPrice == null ||
          (price >= _selectedPrice!.start && price <= _selectedPrice!.end);

      return matchSearch && matchLocation && matchPrice;
    }).toList();
  }

  /// 🔥 BUKA FILTER (PAKAI WIDGET)
  void _openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => FilterBottomSheet(
        onApply: (location, priceRange) {
          setState(() {
            _selectedLocation = location;
            _selectedPrice = priceRange;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = HomeController.getUserName();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
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
                      color: AppColors.darkBlue,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(35),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, $userName',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.background,
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
                          onPressed: () {},
                          icon: const Icon(
                            Icons.chat_bubble_outline,
                            color: AppColors.background,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// 🔍 SEARCH + FILTER
              Positioned(
                left: 25,
                right: 25,
                bottom: -25,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search kos...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: _openFilter, // 🔥 DISINI
                      icon: const Icon(Icons.filter_alt_rounded),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGreyAlt,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),

          const Text(
            'See All Kost',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),

          const SizedBox(height: 15),

          /// 🔥 LIST KOS
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _filteredKostList.isEmpty
                  ? const Center(child: Text('No kos found'))
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
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
                                builder: (_) => DetailKosView(
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/history');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/booking');
          }
        },
      ),
    );
  }
}
