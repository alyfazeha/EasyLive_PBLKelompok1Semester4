import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/pemilikJasa/home_jasa_controller.dart';
import '../../../widgets/pemilikJasa/home/dashboard_widgets.dart';

class PemilikJasaHomeView extends StatefulWidget {
  const PemilikJasaHomeView({super.key});

  @override
  State<PemilikJasaHomeView> createState() => _PemilikJasaHomeViewState();
}

class _PemilikJasaHomeViewState extends State<PemilikJasaHomeView> {
  late PemilikJasaHomeController controller;

  @override
  void initState() {
    super.initState();
    controller = PemilikJasaHomeController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<PemilikJasaHomeController>(
        builder: (context, ctrl, _) {
          if (ctrl.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: PemilikJasaHomeFrame(
                ownerName: ctrl.ownerName,
                totalVehicles: ctrl.totalVehicles,
                availableVehicles: ctrl.availableVehicles,
                totalIncome: ctrl.totalIncomeFormatted,
                newBookings: ctrl.newBookings,
                availableRatio: ctrl.availableRatio,
                vehicles: ctrl.vehicles,
                userImage: ctrl.userImage,
                onRefresh: () => ctrl.refresh(),
                onDeleteJasa: (idJasa) => ctrl.deleteJasa(idJasa),

                onNavigate: (index) {
                  if (index == 0) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/pemilik_jasa/dashboard',
                    );
                  } else if (index == 3) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/pemilik_jasa/booking',
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}