import '../../../models/pemilikKos/notifikasi_detail_model.dart';

class NotificationDetailController {
  final NotificationModel notification = NotificationModel(
    title: 'Application rejected by admin',
    subtitle: 'Pengajuan Daniska Kos ditolak oleh admin aplikasi',
    time: 'Hari ini, 10:30',
    property: 'Daniska Kos',
    room: 'Kamar 03',
    checkIn: '10 Juni 2024',
    checkOut: '12 Juni 2024 (2 malam)',
    paymentMethod: 'Transfer Bank',
    rejectionReason:
        'Data yang Anda kirimkan tidak sesuai. Silakan periksa kembali informasi dan ajukan ulang.',
    applicantName: 'Andi Wijaya',
    applicantEmail: 'andiwijaya@email.com',
    applicantPhone: '+62 812-3456-7890',
  );
}