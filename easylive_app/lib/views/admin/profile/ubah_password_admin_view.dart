import 'package:flutter/material.dart';

class UbahPasswordAdminView extends StatelessWidget {
  const UbahPasswordAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Ubah Password Admin',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
