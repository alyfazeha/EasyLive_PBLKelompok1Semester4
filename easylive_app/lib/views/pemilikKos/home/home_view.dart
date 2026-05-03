import 'package:flutter/material.dart';
import '../../../widgets/pemilikKos/home/dashboard_widgets.dart';

class PemilikKosHomeView extends StatelessWidget {
  const PemilikKosHomeView({super.key});

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/pemilik_kos/dashboard');
        break;
      case 2:
        // Home (current page) → do nothing
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/pemilik_kos/history');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: OwnerDashboardFrame(
          onNavigate: (index) => _handleNavigation(context, index),
        ),
      ),
    );
  }
}
