import 'package:flutter/material.dart';

import '../../../controllers/pemilikJasa/detail_jasa_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikJasa/home/detailJasa.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';
import './editKendaraan_view.dart';

class DetailJasaView extends StatelessWidget {
  final String vehicleName;
  final DetailJasaController controller = DetailJasaController();

  DetailJasaView({super.key, this.vehicleName = 'Pickup'});

  @override
  Widget build(BuildContext context) {
    final jasa = controller.getJasaDetail(vehicleName);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER (samakan dengan pemilikKos)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.darkBlue,
              child: Row(
                children: [
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
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.darkBlue,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Detail Jasa',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditKendaraanView(jasa: jasa),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.yellow.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.background,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BODY
            Expanded(child: DetailJasaWidget(jasa: jasa)),
          ],
        ),
      ),
      // bottom nav (tetap milik pemilik jasa)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
<<<<<<< HEAD
          padding: const EdgeInsets.only(bottom: 10),
          child: PemilikJasaBottomNav(
            currentIndex: 2,
            onNavigate: (index) {
              if (index == 0) {
                Navigator.pushReplacementNamed(
                  context,
                  '/pemilik_jasa/dashboard',
                );
              } else if (index == 2) {
                Navigator.pushReplacementNamed(context, '/pemilik_jasa');
              }
            },
=======
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PemilikJasaBottomNav(
                currentIndex: 2,
                onNavigate: (index) {
                  if (index == 0) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/pemilik_jasa/dashboard',
                    );
                  } else if (index == 2) {
                    Navigator.pushReplacementNamed(context, '/pemilik_jasa');
                  }
                },
              ),
            ],
>>>>>>> rafi
          ),
        ),
      ),
    );
  }
}
