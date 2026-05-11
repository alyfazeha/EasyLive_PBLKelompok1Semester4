import 'package:flutter/material.dart';

import '../../../controllers/pemilikKos/notifikasi_detail_controller.dart';
import '../../../widgets/pemilikKos/notifikasi/action_buttons.dart';
import '../../../widgets/pemilikKos/notifikasi/detail_info_card.dart';
import '../../../widgets/pemilikKos/notifikasi/notification_header_card.dart';
import '../../../widgets/pemilikKos/notifikasi/rejection_reason_card.dart';
import '../../../widgets/pemilikKos/notifikasi/submitter_card.dart';
import '../../../widgets/pemilikKos/notifikasi/notifikasi_card.dart';

class NotificationDetailView extends StatelessWidget {
  NotificationDetailView({super.key});

  final NotificationDetailController controller =
      NotificationDetailController();

  @override
  Widget build(BuildContext context) {
    final data = controller.notification;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      // ================= APP BAR =================
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

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Notification Card
                NotificationHeaderCard(data: data),

                const SizedBox(height: 28),

                // Detail Title
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

                // Detail Description
                Text(
                  'Maaf, pengajuan Anda untuk memesan ${data.property} telah ditolak oleh admin aplikasi.',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    height: 1.6,
                    color: Color(0xFF4A5568),
                  ),
                ),

                const SizedBox(height: 24),

                // Detail Booking Info
                DetailInfoCard(data: data),

                const SizedBox(height: 24),

                // Rejection Reason
                RejectionReasonCard(
                  reason: data.rejectionReason,
                ),

                const SizedBox(height: 24),

                // Submitted By
                SubmitterCard(data: data),

                const SizedBox(height: 30),

                // Action Buttons
                const ActionButtons(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}