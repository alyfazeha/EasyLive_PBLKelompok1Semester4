import 'package:flutter/material.dart';
import '../../widgets/home/botton_navbar.dart';
import '../../widgets/kosPage/searching.dart';
import '../../widgets/kosPage/kos_card.dart';
import '../../controllers/kos_controller.dart';
import '../../models/kos_model.dart';
import '../../core/color.dart';

class KostView extends StatefulWidget {
  const KostView({super.key});

  @override
  State<KostView> createState() => _KostViewState();
}

class _KostViewState extends State<KostView> {
  late List<KostModel> allKost;
  List<KostModel> displayedKost = [];

  @override
  void initState() {
    super.initState();
    allKost = KostController.getAllKost();
    displayedKost = allKost;
  }

  void _applyFilter(String query, String location, double maxPrice) {
    setState(() {
      displayedKost = KostController.filterKost(
        allKost,
        query,
        location,
        maxPrice,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 600 ? 2 : 4;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            /// ================= HEADER =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi Rafi,",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Welcome to EasyKost!",
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),

            /// ================= SEARCH =================
            SearchFilterWidget(onFilterChanged: _applyFilter),

            const SizedBox(height: 10),

            /// ================= TITLE =================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kost",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// ================= GRID =================
            Expanded(
              child: displayedKost.isEmpty
                  ? const Center(
                      child: Text(
                        "Kost tidak ditemukan...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        itemCount: displayedKost.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          return KostCard(kost: displayedKost[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
