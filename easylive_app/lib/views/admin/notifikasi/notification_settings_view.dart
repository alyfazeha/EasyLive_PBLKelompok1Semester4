import 'package:flutter/material.dart';

class AdminNotificationSettingsView extends StatelessWidget {
  const AdminNotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Admin Notification Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
