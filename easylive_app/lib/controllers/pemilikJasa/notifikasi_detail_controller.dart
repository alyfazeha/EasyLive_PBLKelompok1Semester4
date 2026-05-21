import '../../../models/pemilikJasa/notifikasi_model.dart';
import '../../../models/pemilikKos/notifikasi_model.dart' as kos;
import '../../../models/pemilikKos/notifikasi_detail_model.dart';

/// Controller pemilikJasa untuk menyamakan alur & tampilan detail notifikasi
/// dengan halaman pemilikKos.
class NotificationDetailController {
  final NotificationModel notification;
  final kos.OwnerNotificationType type;

  NotificationDetailController({required OwnerNotification ownerNotification})
    : type = mapType(ownerNotification.type),
      notification = NotificationModel(
        title: ownerNotification.title,
        subtitle: ownerNotification.description,
        time: ownerNotification.time,
        property: ownerNotification.title,
        room: '-',
        checkIn:
            (ownerNotification.type == OwnerNotificationType.booking ||
                ownerNotification.type == OwnerNotificationType.payment)
            ? ownerNotification.time
            : '-',
        checkOut: '-',
        paymentMethod: ownerNotification.type == OwnerNotificationType.payment
            ? 'Transfer'
            : '',
        rejectionReason:
            ownerNotification.type == OwnerNotificationType.rejected
            ? ownerNotification.description.trim()
            : '',
        applicantName: ownerNotification.type == OwnerNotificationType.booking
            ? ownerNotification.title
            : '',
        applicantEmail: '',
        applicantPhone: '',
      );

  /// Map OwnerNotificationType pemilikJasa -> OwnerNotificationType pemilikKos
  /// supaya kondisi widget sama persis.
  static kos.OwnerNotificationType mapType(OwnerNotificationType t) {
    switch (t) {
      case OwnerNotificationType.rejected:
        return kos.OwnerNotificationType.rejected;
      case OwnerNotificationType.booking:
        return kos.OwnerNotificationType.booking;
      case OwnerNotificationType.payment:
        return kos.OwnerNotificationType.payment;

      // OwnerNotificationType pemilikJasa lainnya belum punya padanan widget.
      // Untuk maintain tampilan konsisten, kita map ke type yang paling mendekati.
      case OwnerNotificationType.checkout:
        return kos.OwnerNotificationType.approved;
      case OwnerNotificationType.reminder:
        return kos.OwnerNotificationType.booking;
      case OwnerNotificationType.cancelled:
        return kos.OwnerNotificationType.rejected;
    }
  }
}
