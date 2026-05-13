import '../../../models/pemilikKos/notifikasi_model.dart';
import '../../../models/pemilikKos/notifikasi_detail_model.dart';

class NotificationDetailController {
  final NotificationModel notification;

  NotificationDetailController({required OwnerNotification ownerNotification})
      : notification = NotificationModel.fromOwnerNotification(ownerNotification);
}