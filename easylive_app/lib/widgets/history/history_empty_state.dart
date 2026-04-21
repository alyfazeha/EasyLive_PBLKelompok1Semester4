import 'package:flutter/material.dart';

import '../../core/color.dart';

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        children: [
          Spacer(flex: 3),
          Text(
            'You have no active set booking',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.title1,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
