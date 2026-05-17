import 'package:flutter/material.dart';

import '../../../core/color.dart';

///
/// Untuk sekarang: menampilkan placeholder.
/// Kalau kamu punya logic favorite pemilikKos, nanti bisa dihubungkan.
///
class PemilikKosFavoriteView extends StatelessWidget {
  const PemilikKosFavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBlue.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.favorite_border_rounded,
                size: 56,
                color: AppColors.yellow,
              ),
              SizedBox(height: 12),
              Text(
                'Belum Ada Favorit',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBlue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Halaman favorit pemilikKos masih placeholder.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
