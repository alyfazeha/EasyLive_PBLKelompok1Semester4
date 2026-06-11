import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/color.dart';
import '../../../controllers/pemilikKos/dashboard_controller.dart';
import '../../../widgets/pemilikKos/dashboard/dashboard_header.dart';
import '../../../widgets/pemilikKos/dashboard/dashboard_payment.dart';
import '../../../widgets/pemilikKos/home/bottom_navbar.dart';
import '../comingSoon_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late DashboardController controller;

  @override
  void initState() {
    super.initState();
    controller = DashboardController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<DashboardController>(
          builder: (context, ctrl, _) {
            return Column(
              children: [
                DashboardHeader(
                  ownerName: ctrl.ownerName,
                  totalKost: ctrl.totalKost,
                  kamarTersedia: ctrl.kamarTersedia,
                  bookingBaru: ctrl.bookingBaru,
                  pendapatan: ctrl.pendapatanFormatted,
                  userImage: ctrl.userImage,
                ),
                Expanded(
                  child: ctrl.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ctrl.dashboardList.isEmpty
                          ? const Center(
                              child: Text(
                                'Belum ada riwayat pembayaran',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black45,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(16, 70, 16, 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 1),
                                  const Text(
                                    "Riwayat Pembayaran",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.darkBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ...ctrl.dashboardList.map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/pemilik_kos/detail_pembayaran',
                                          arguments: item, // ← kirim Dashboard
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(18),
                                      child: PaymentHistoryCard(
                                        name: item.name,
                                        kost: item.kostName,
                                        date: item.date,
                                        price: item.price,
                                        status: item.status,
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: OwnerBottomNav(
          currentIndex: 0,
          onNavigate: (index) {
            if (index == 0) return;
            if (index == 3) {
              Navigator.pushReplacementNamed(context, '/pemilik_kos/history');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/pemilik_kos');
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ComingSoonView(title: "Halaman"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}