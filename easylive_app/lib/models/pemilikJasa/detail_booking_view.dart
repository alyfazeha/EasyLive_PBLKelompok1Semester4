import 'package:flutter/material.dart';
import '../../../core/color.dart';

class DetailBookingView extends StatelessWidget {
  final String tenantName;

  const DetailBookingView({super.key, required this.tenantName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan judul "Detail Booking" dan warna #2E4052
            Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColors.primary,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(18),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Detail Booking',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Area Konten
            Expanded(
              child: Center(
                child: Text(
                  'Menampilkan detail untuk: $tenantName',
                  style: const TextStyle(fontFamily: 'Montserrat'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
