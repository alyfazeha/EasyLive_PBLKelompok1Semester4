import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/pemilikJasa/notifikasi_detail_controller.dart';
import '../../../models/pemilikKos/notifikasi_model.dart' as kos;
import '../../../models/pemilikJasa/notifikasi_model.dart';
import '../../../widgets/pemilikJasa/notifikasi/detail_info_card.dart';
import '../../../widgets/pemilikJasa/notifikasi/notification_header_card.dart';
import '../../../widgets/pemilikJasa/notifikasi/rejection_reason_card.dart';
import '../../../widgets/pemilikJasa/notifikasi/submitter_card.dart';

class DetailOwnerJasaNotificationView extends StatefulWidget {
  final OwnerNotification notification;

  const DetailOwnerJasaNotificationView({
    super.key,
    required this.notification,
  });

  @override
  State<DetailOwnerJasaNotificationView> createState() =>
      _DetailOwnerJasaNotificationViewState();
}

class _DetailOwnerJasaNotificationViewState
    extends State<DetailOwnerJasaNotificationView> {
  late NotificationDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = NotificationDetailController(
      ownerNotification: widget.notification,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _getDetailText(String property) {
    switch (widget.notification.type) {
      case OwnerNotificationType.approved:
        return 'Selamat! Jasa "$property" Anda telah disetujui oleh admin dan sekarang sudah aktif.';
      case OwnerNotificationType.rejected:
        return 'Maaf, jasa "$property" Anda ditolak oleh admin aplikasi. Silakan periksa alasan penolakan di bawah.';
      case OwnerNotificationType.booking:
        return 'Ada booking baru masuk untuk jasa "$property". Silakan konfirmasi atau tolak booking ini.';
      case OwnerNotificationType.payment:
        return 'Pembayaran untuk jasa "$property" telah berhasil diterima.';
      default:
        return 'Ada notifikasi baru untuk jasa "$property".';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Scaffold(
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
        body: Consumer<NotificationDetailController>(
          builder: (context, ctrl, _) {
            if (ctrl.isLoading || ctrl.notification == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = ctrl.notification!;
            final kosType = ctrl.type;

            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NotificationHeaderCard(data: data, type: kosType),

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

                      DetailInfoCard(data: data, type: kosType),

                      const SizedBox(height: 24),

                      if (kosType == kos.OwnerNotificationType.rejected) ...[
                        RejectionReasonCard(reason: data.rejectionReason),
                        const SizedBox(height: 24),
                      ],

                      if (kosType == kos.OwnerNotificationType.booking ||
                          kosType == kos.OwnerNotificationType.payment) ...[
                        SubmitterCard(data: data),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}