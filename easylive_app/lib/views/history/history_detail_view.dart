import 'package:flutter/material.dart';

import '../../controllers/history_controller.dart';
import '../../models/history_model.dart';
import '../../widgets/home/bottom_navbar.dart';
import '../../core/color.dart';

class HistoryDetailView extends StatelessWidget {
  final HistoryItem item;

  const HistoryDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Biru Tua
          Container(
            padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
            decoration: const BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.golden,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.darkBlue,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    'Detail History',
                    style: TextStyle(
                      color: AppColors.golden,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Kartu Detail
          Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.darkBlue),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfo('Customer', item.customerName),
                            _buildInfo('Order', item.ownerName),
                            _buildInfo(item.type, item.title),
                            _buildInfo(
                              'Date',
                              HistoryController.formatHistoryDate(
                                item.dateTime,
                              ),
                            ),
                            const Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.golden,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                item.status,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Aksen Biru Tua di sisi kanan
                    Container(
                      width: 15,
                      decoration: const BoxDecoration(
                        color: AppColors.darkBlue,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNav(
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) return;

            if (index == 1) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            } else if (index == 2) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/booking',
                (route) => false,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            const Expanded(child: Divider(color: AppColors.darkBlue)),
          ],
        ),
        Text(value, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 15),
      ],
    );
  }
}
