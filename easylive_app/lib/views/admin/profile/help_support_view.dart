import 'package:flutter/material.dart';

class AdminHelpSupportView extends StatelessWidget {
  const AdminHelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Admin Help & Support',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
