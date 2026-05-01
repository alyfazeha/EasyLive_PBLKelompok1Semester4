import 'package:flutter/material.dart';

import '../../../widgets/pemilikKos/home/dashboard_widgets.dart';

class PemilikKosDashboardView extends StatelessWidget {
  const PemilikKosDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF202020),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 4, 10, 8),
              child: Text(
                'admin kost',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white24,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: OwnerDashboardFrame(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
