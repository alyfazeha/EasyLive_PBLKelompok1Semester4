import 'package:flutter/material.dart';

class AdminNotificationEmptyState extends StatelessWidget {
  const AdminNotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 42,
            color: Colors.black26,
          ),
          SizedBox(height: 10),
          Text(
            'Belum ada notifikasi',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
