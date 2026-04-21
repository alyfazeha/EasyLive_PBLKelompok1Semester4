import 'package:flutter/material.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/home/header_slider.dart';
import '../../widgets/home/category_section.dart';
import '../../widgets/home/item_card.dart';
import '../../widgets/home/botton_navbar.dart';
import '../../core/color.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int crossAxisCount = width < 600 ? 2 : 4;

    final kostList = HomeController.getKostList();
    final userName = HomeController.getUserName();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// GREETING SECTION
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi $userName,",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight:  FontWeight.normal,
                        color: AppColors.titleName,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Welcome to ",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.normal, 
                              color: AppColors.title1,
                            ),
                          ),
                          TextSpan(
                            text: "EasyKost !",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.bold, // Bold
                              color: AppColors.title1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// SLIDER
              const HeaderSlider(),

              /// CATEGORY
              const CategorySection(),

              /// GRID
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: kostList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final kost = kostList[index];

                  return ItemCard(
                    name: kost.name,
                    address: kost.address,
                    image: kost.image,
                  );
                },
              ),
            ],
          ),
        ),
      ),

      /// NAVBAR (Posisinya harus di sini, di bawah body)
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}