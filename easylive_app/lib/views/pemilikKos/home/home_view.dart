import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/pemilikKos/homeKos_controller.dart';
import '../../../widgets/pemilikKos/home/dashboard_widgets.dart';

class PemilikKosHomeView extends StatefulWidget {
  const PemilikKosHomeView({super.key});

  @override
  State<PemilikKosHomeView> createState() => _PemilikKosHomeViewState();
}

class _PemilikKosHomeViewState extends State<PemilikKosHomeView> {
  late PemilikKosController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PemilikKosController(); // fresh tiap login
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/pemilik_kos/dashboard');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/pemilik_kos/history');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor:const Color.fromRGBO(45, 62, 80, 1),
        body: SafeArea(
          child: OwnerDashboardFrame(
            onNavigate: (index) => _handleNavigation(context, index),
          ),
        ),
      ),
    );
  }
}