import 'package:flutter/material.dart';
import '../../../controllers/pemilikKos/detailKamar_controller.dart';
import '../../../widgets/pemilikKos/home/detailKamar.dart';
import '../../../widgets/pemilikKos/home/bottom_navbar.dart';
import '../../../core/color.dart';

class DetailKostView extends StatelessWidget {
  final controller = KostController();

  DetailKostView({super.key});

  @override
  Widget build(BuildContext context) {
    final kost = controller.getKostDetail();

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: EdgeInsets.all(16),
              color: AppColors.darkBlue,
              child: Row(
                children: [
                  // BACK BUTTON (KOTAK KUNING)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.darkBlue,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Detail Kost",
                    style: TextStyle(color: AppColors.background, fontSize: 18),
                  ),
                  Spacer(),
                  Icon(Icons.more_vert, color: AppColors.background),
                ],
              ),
            ),

            // 🔥 SEMUA UI DI SINI
            Expanded(child: DetailKostWidget(kost: kost)),
          ],
        ),
      ),
      bottomNavigationBar: OwnerBottomNav(
        currentIndex: 2,
        onNavigate: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/pemilik_kos/dashboard');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/pemilik_kos');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/pemilik_kos/history');
          }
        },
      ),
    );
  }
}
