import 'package:flutter/material.dart';
import '../widgets/home/header_slider.dart';
import '../widgets/home/category_section.dart';
import '../widgets/home/item_card.dart';
import '../widgets/home/botton_navbar.dart'; 
import '../screens/bookingPage.dart';
import '../screens/bookingPage.dart';
import '../screens/profilePage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int crossAxisCount = width < 600 ? 2 : 4;

    final List<String> kostImages = [
      "images/kos1.jpg",
      "images/kos2.jpg",
      "images/kos3.jpg",
      "images/kos1.jpg", 
      "images/kos2.jpg",
      "images/kos3.jpg",
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                
                // --- SECTION GREETING ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Hi Rafi,",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E0006),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Welcome to EasyKost !",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9B0F06),
                        ),
                      ),
                    ],
                  ),
                ),

                // SECTION SLIDER
                const HeaderSlider(),

                // SECTION CATEGORY 
                const CategorySection(),

                // SECTION GRID VIEW 
                GridView.builder(
                  shrinkWrap: true, 
                  physics: const NeverScrollableScrollPhysics(), 
                  padding: const EdgeInsets.all(16),
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return ItemCard(
                      image: kostImages[index],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}