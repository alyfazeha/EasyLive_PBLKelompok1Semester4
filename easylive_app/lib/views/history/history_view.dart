import 'package:flutter/material.dart';

import '../../controllers/history_controller.dart';
import '../../core/color.dart';
<<<<<<< HEAD
import '../../widgets/home/botton_navbar.dart';
=======
import '../../widgets/home/bottom_navbar.dart';
>>>>>>> ailsa
import '../../widgets/history/history_card.dart';
import '../../widgets/history/history_empty_state.dart';
import '../../widgets/history/history_filter_chip.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String selectedType = HistoryController.defaultType;

  @override
  Widget build(BuildContext context) {
    final histories = HistoryController.getHistoriesByType(selectedType);

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
<<<<<<< HEAD
                        color: AppColors.title1,
=======
                        color: AppColors.yellow,
>>>>>>> ailsa
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'History',
                          style: TextStyle(
<<<<<<< HEAD
                            color: AppColors.titleName,
=======
                            color: AppColors.yellow,
>>>>>>> ailsa
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search_rounded,
<<<<<<< HEAD
                        color: AppColors.title1,
=======
                        color: AppColors.yellow,
>>>>>>> ailsa
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
                            isSelected: selectedType == type,
                            onTap: () => setState(() => selectedType = type),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: histories.isEmpty
                  ? const HistoryEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(28, 18, 28, 20),
                      itemCount: histories.length,
                      itemBuilder: (context, index) {
                        final item = histories[index];
                        return HistoryCard(
                          item: item,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/history/detail',
                            arguments: item,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
<<<<<<< HEAD
      bottomNavigationBar: const BottomNav(currentIndex: 2),
=======
      bottomNavigationBar: const BottomNav(currentIndex: 0),
>>>>>>> ailsa
    );
  }
}
