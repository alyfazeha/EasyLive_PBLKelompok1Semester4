import 'notifikasi_model.dart';

class NotificationModel {
  final String title;
  final String subtitle;
  final String time;
  final String property;
  final String room;
  final String checkIn;
  final String checkOut;
  final String paymentMethod;
  final String rejectionReason;
  final String applicantName;
  final String applicantEmail;
  final String applicantPhone;

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.property,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.paymentMethod,
    required this.rejectionReason,
    required this.applicantName,
    required this.applicantEmail,
    required this.applicantPhone,
  });

  factory NotificationModel.fromOwnerNotification(OwnerNotification n) {
    return NotificationModel(
      title: n.title,
      subtitle: n.description,
      time: n.time,
      property: n.property ?? '-',
      room: '-',
      checkIn: n.checkIn ?? '-',
      checkOut: n.checkOut ?? '-',
      paymentMethod: n.paymentMethod ?? '-',
      rejectionReason: n.rejectionReason ?? '-',
      applicantName: n.applicantName ?? '-',
      applicantEmail: n.applicantEmail ?? '-',
      applicantPhone: n.applicantPhone ?? '-',
    );
  }
}