import 'package:flutter/material.dart';

import '../../../controllers/pemilikJasa/detail_jasa_controller.dart';
import '../../../core/color.dart';
import '../../../models/user/kos_model.dart';
import '../../../widgets/pemilikJasa/home/detailJasa.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';
import './editKendaraan_view.dart';

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

    int parsePrice(String priceText) {
      final digits = priceText.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(digits) ?? 0;
    }

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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditKendaraanView(jasa: jasa),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.yellow.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.yellow,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: DetailJasaWidget(jasa: jasa)),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PemilikJasaBottomNav(
                currentIndex: 2,
                onNavigate: (index) {
                  if (index == 0) {
                    Navigator.pushReplacementNamed(context, '/pemilik_jasa/dashboard');
                  } else if (index == 2) {
                    Navigator.pushReplacementNamed(context, '/pemilik_jasa');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
