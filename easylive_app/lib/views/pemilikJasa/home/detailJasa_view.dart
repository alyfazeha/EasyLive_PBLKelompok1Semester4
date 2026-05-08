import 'package:flutter/material.dart';

import '../../../controllers/pemilikJasa/detail_jasa_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikJasa/home/detailJasa.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';

class DetailJasaView extends StatelessWidget {
  final String vehicleName;
  final DetailJasaController controller = DetailJasaController();

  DetailJasaView({
    super.key,
    this.vehicleName = 'Pickup',
  });

  @override
  Widget build(BuildContext context) {
    final jasa = controller.getJasaDetail(vehicleName);

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
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
                          color: AppColors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
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
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert, color: AppColors.background),
                ],
              ),
            ),
            Expanded(child: DetailJasaWidget(jasa: jasa)),
          ],
        ),
      ),
      bottomNavigationBar: PemilikJasaBottomNav(
        currentIndex: 2,
        onNavigate: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/pemilik_jasa/dashboard');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/pemilik_jasa');
          }
        },
      ),
    );
  }
}
