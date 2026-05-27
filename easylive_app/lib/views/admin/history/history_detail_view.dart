import 'package:flutter/material.dart';
import '../../../controllers/admin/history_detail_controller.dart';
import '../../../models/admin/history_model.dart';
import '../../../widgets/admin/history/history_detail_header_card.dart';
import '../../../widgets/admin/history/history_detail_info_card.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';

class AdminHistoryDetailView extends StatelessWidget {
  final HistoryItemModel historyItem;

  const AdminHistoryDetailView({super.key, required this.historyItem});

  @override
  Widget build(BuildContext context) {
    final controller = AdminHistoryDetailController(historyItem: historyItem);
    final data = controller.historyDetail;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F4157),
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF6BE00),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              // Back dari detail history -> kembali ke halaman admin/history (jangan logout)
              onPressed: () {
                // Kembalikan ke dashboard admin
                Navigator.pushReplacementNamed(context, '/admin');
              },
            ),
          ),
        ),
        title: const Text(
          'Detail History',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF7F7F7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminHistoryDetailHeaderCard(data: data),
                  const SizedBox(height: 28),
                  const Text(
                    'Detail',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2F4157),
                    ),
                  ),
                  const SizedBox(height: 12),
                  HistoryDetailInfoCard(data: data),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AdminBottomNavbar(
        selectedIndex: 0,
        onItemTapped: (index) {
          if (index == 0) return;
          if (index == 1) {
            Navigator.pushNamed(context, '/admin/kos_approval');
            return;
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/admin/home');
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Menu ini belum tersedia untuk Admin'),
            ),
          );
        },
      ),
    );
  }
}
