import 'package:flutter/material.dart';

import '../../controllers/history_controller.dart';
import '../../core/color.dart';
import '../../models/history_model.dart';
import '../../widgets/home/bottom_navbar.dart';
import '../../widgets/history/history_detail_row.dart';
import '../../widgets/history/history_filter_chip.dart';

class HistoryDetailView extends StatelessWidget {
  final HistoryItem item;

  const HistoryDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 18, 28, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.crop_free_rounded,
                        color: AppColors.yellow,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Detail History',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search_rounded,
                        color: AppColors.yellow,
                        size: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ...HistoryController.historyTypes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final type = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == HistoryController.historyTypes.length - 1 ? 0 : 12,
                          ),
                          child: HistoryFilterChip(
                            label: type,
                            isSelected: item.type == type,
                            onTap: () {},
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 18, 28, 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3DEC1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.yellow, width: 0.8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HistoryDetailRow(label: 'Customer', value: item.customerName),
                                HistoryDetailRow(label: 'Order', value: item.ownerName),
                                HistoryDetailRow(label: item.type, value: item.title),
                                HistoryDetailRow(
                                  label: 'Date',
                                  value: HistoryController.formatHistoryDate(item.dateTime),
                                ),
                                const Text(
                                  'Status',
                                  style: TextStyle(
                                    color: AppColors.yellow,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F8EC),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF6FAF54),
                                    ),
                                  ),
                                  child: Text(
                                    item.status,
                                    style: const TextStyle(
                                      color: Color(0xFF4D8B38),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
