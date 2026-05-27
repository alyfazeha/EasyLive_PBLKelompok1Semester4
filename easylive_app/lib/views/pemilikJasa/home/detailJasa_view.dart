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
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        top: false,
        child: Column(

          children: [
            // Header (dibuat serupa dengan halaman detail pembayaran pemilik jasa)
            Container(
height: 100,
padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              color: AppColors.primary,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(18),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Detail Jasa',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // tombol edit seperti sebelumnya
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
                        color: AppColors.yellow.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
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
          ),
        ),
      ),
    );
  }
}
