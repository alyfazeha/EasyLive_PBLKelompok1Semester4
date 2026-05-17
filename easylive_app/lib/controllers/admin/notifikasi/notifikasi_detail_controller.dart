import '../../../models/admin/notifikasi/notifikasi_model.dart';

class AdminNotificationDetailController {
  AdminNotificationDetail getDetail(AdminNotification notification) {
    switch (notification.type) {
      case AdminNotificationType.kostApproval:
        return AdminNotificationDetail(
          notification: notification,
          statusLabel: 'Menunggu Review',
          primaryInfoLabel: 'Nama Kost',
          primaryInfoValue: notification.targetName ?? '-',
          summary:
              'Pemilik kost mengirim data baru dan membutuhkan verifikasi admin sebelum tampil aktif di aplikasi.',
          primaryActionLabel: 'Buka Approval Kost',
          secondaryActionLabel: 'Tandai Selesai',
          rows: const [
            AdminNotificationDetailRow(
              label: 'Kategori',
              value: 'Approval Kost',
            ),
            AdminNotificationDetailRow(
              label: 'Pengirim',
              value: 'Pemilik Kost',
            ),
            AdminNotificationDetailRow(label: 'Prioritas', value: 'Tinggi'),
          ],
        );
      case AdminNotificationType.jasaApproval:
        return AdminNotificationDetail(
          notification: notification,
          statusLabel: 'Butuh Validasi',
          primaryInfoLabel: 'Nama Jasa',
          primaryInfoValue: notification.targetName ?? '-',
          summary:
              'Penyedia jasa mengirim layanan baru. Admin perlu memeriksa kelengkapan data, harga, dan status layanan.',
          primaryActionLabel: 'Buka Data Jasa',
          secondaryActionLabel: 'Tandai Selesai',
          rows: const [
            AdminNotificationDetailRow(
              label: 'Kategori',
              value: 'Approval Jasa',
            ),
            AdminNotificationDetailRow(
              label: 'Pengirim',
              value: 'Pemilik Jasa',
            ),
            AdminNotificationDetailRow(label: 'Prioritas', value: 'Sedang'),
          ],
        );
      case AdminNotificationType.payment:
        return AdminNotificationDetail(
          notification: notification,
          statusLabel: 'Berhasil',
          primaryInfoLabel: 'Transaksi',
          primaryInfoValue: notification.targetName ?? '-',
          summary:
              'Sistem menerima pembayaran baru. Admin bisa memeriksa riwayat transaksi untuk memastikan data booking tercatat.',
          primaryActionLabel: 'Buka History',
          rows: const [
            AdminNotificationDetailRow(label: 'Kategori', value: 'Pembayaran'),
            AdminNotificationDetailRow(label: 'Status', value: 'Settlement'),
            AdminNotificationDetailRow(
              label: 'Sumber',
              value: 'Payment Gateway',
            ),
          ],
        );
      case AdminNotificationType.report:
        return AdminNotificationDetail(
          notification: notification,
          statusLabel: 'Perlu Ditinjau',
          primaryInfoLabel: 'Laporan',
          primaryInfoValue: notification.targetName ?? '-',
          summary:
              'Pengguna mengirim laporan terkait data kos. Admin perlu memeriksa laporan dan menentukan tindak lanjut.',
          primaryActionLabel: 'Buka Laporan',
          secondaryActionLabel: 'Tandai Selesai',
          rows: const [
            AdminNotificationDetailRow(
              label: 'Kategori',
              value: 'Laporan Pengguna',
            ),
            AdminNotificationDetailRow(label: 'Status', value: 'Masuk'),
            AdminNotificationDetailRow(label: 'Prioritas', value: 'Tinggi'),
          ],
        );
      case AdminNotificationType.system:
        return AdminNotificationDetail(
          notification: notification,
          statusLabel: 'Informasi',
          primaryInfoLabel: 'Ringkasan',
          primaryInfoValue: notification.targetName ?? 'Sistem Admin',
          summary:
              'Ringkasan aktivitas sistem membantu admin memantau approval, notifikasi aktif, dan kondisi dashboard.',
          primaryActionLabel: 'Buka Dashboard',
          rows: const [
            AdminNotificationDetailRow(label: 'Kategori', value: 'Sistem'),
            AdminNotificationDetailRow(
              label: 'Sumber',
              value: 'EasyLive Admin',
            ),
            AdminNotificationDetailRow(label: 'Prioritas', value: 'Normal'),
          ],
        );
    }
  }

  String routeFor(AdminNotificationType type) {
    switch (type) {
      case AdminNotificationType.kostApproval:
        return '/admin/kos';
      case AdminNotificationType.jasaApproval:
        return '/admin/jasa';
      case AdminNotificationType.payment:
      case AdminNotificationType.report:
        return '/admin/history';
      case AdminNotificationType.system:
        return '/admin';
    }
  }
}
