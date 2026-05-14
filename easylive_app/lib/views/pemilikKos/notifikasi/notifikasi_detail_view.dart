import 'package:flutter/material.dart';
import '../../../controllers/pemilikKos/notifikasi_detail_controller.dart';
import '../../../models/pemilikKos/notifikasi_model.dart';
import '../../../widgets/pemilikKos/notifikasi/action_buttons.dart';
import '../../../widgets/pemilikKos/notifikasi/detail_info_card.dart';
import '../../../widgets/pemilikKos/notifikasi/notification_header_card.dart';
import '../../../widgets/pemilikKos/notifikasi/rejection_reason_card.dart';
import '../../../widgets/pemilikKos/notifikasi/submitter_card.dart';

class NotificationDetailView extends StatelessWidget {
  final OwnerNotification ownerNotification;

  NotificationDetailView({super.key, required this.ownerNotification});

  String _getDetailText(String property) {
    switch (ownerNotification.type) {
      case OwnerNotificationType.approved:
        return 'Selamat! Kost "$property" Anda telah disetujui oleh admin dan sekarang sudah aktif.';
      case OwnerNotificationType.rejected:
        return 'Maaf, kost "$property" Anda ditolak oleh admin aplikasi. Silakan periksa alasan penolakan di bawah.';
      case OwnerNotificationType.booking:
        return 'Ada booking baru masuk untuk kost "$property". Silakan konfirmasi atau tolak booking ini.';
      case OwnerNotificationType.payment:
        return 'Pembayaran untuk kost "$property" telah berhasil diterima.';
      default:
        return 'Ada notifikasi baru untuk kost "$property".';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = NotificationDetailController(
      ownerNotification: ownerNotification,
    );
    final data = controller.notification;
    final type = ownerNotification.type;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F4157),
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Detail Notifikasi',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NotificationHeaderCard(data: data, type: type),

                const SizedBox(height: 28),

                const Text(
                  'Detail',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F4157),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  _getDetailText(data.property),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    height: 1.6,
                    color: Color(0xFF4A5568),
                  ),
                ),

                const SizedBox(height: 24),

                // Info detail dinamis berdasar type
                DetailInfoCard(
                  data: data,
                  type: type, // ← pass type
                ),

                const SizedBox(height: 24),

                // Rejection reason — hanya rejected
                if (type == OwnerNotificationType.rejected) ...[
                  RejectionReasonCard(reason: data.rejectionReason),
                  const SizedBox(height: 24),
                ],

                // Submitter — hanya booking & payment
                if (type == OwnerNotificationType.booking ||
                    type == OwnerNotificationType.payment) ...[
                  SubmitterCard(data: data),
                  const SizedBox(height: 24),
                ],

                // Action buttons — hanya booking
                if (type == OwnerNotificationType.booking) ...[
                  const ActionButtons(),
                  const SizedBox(height: 30),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}