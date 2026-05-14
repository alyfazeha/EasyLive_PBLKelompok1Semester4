import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../models/pemilikKos/booking_model.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onRefresh; // ← tambah ini

  const BookingCard({
    super.key,
    required this.booking,
    this.onRefresh, // ← tambah ini
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (booking.status.toLowerCase()) {
      case 'pending':
        bgColor = const Color(0xFFFFF3D6);
        textColor = const Color(0xFFFFB200);
        break;
      case 'aktif':
        bgColor = const Color(0xFFE6F6EC);
        textColor = const Color(0xFF31B75D);
        break;
      case 'selesai':
        bgColor = const Color(0xFFEAF1FF);
        textColor = const Color(0xFF4D82FF);
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final result = await Navigator.pushNamed(
            context,
            '/pemilik_kos/detail_booking',
            arguments: booking.idBooking,
          );

          if (result == true) {
            onRefresh?.call(); // ← refresh jika ada perubahan
          }
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF5B4CF0),
                child: Text(
                  booking.nama[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.nama,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.kamar,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}