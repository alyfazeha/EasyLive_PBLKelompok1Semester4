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
          rows: [
            const AdminNotificationDetailRow(label: 'Kategori', value: 'Approval Kost'),
            AdminNotificationDetailRow(
              label: 'Pengirim',
              value: notification.ownerName ?? '-',
            ),
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
          rows: [
            const AdminNotificationDetailRow(label: 'Kategori', value: 'Approval Jasa'),
            AdminNotificationDetailRow(
              label: 'Pengirim',
              value: notification.ownerName ?? '-',
            ),
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
    }
  }
}