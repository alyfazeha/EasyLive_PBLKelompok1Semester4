import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/pemilikJasa/notifikasi_model.dart';
import '../../../models/pemilikKos/notifikasi_model.dart' as kos;
import '../../../models/pemilikKos/notifikasi_detail_model.dart';

class NotificationDetailController extends ChangeNotifier {
  NotificationModel? notification;
  kos.OwnerNotificationType type = kos.OwnerNotificationType.approved;
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  NotificationDetailController({required OwnerNotification ownerNotification}) {
    type = mapType(ownerNotification.type);
    _loadDetail(ownerNotification);
  }

  Future<void> _loadDetail(OwnerNotification notif) async {
    isLoading = true;
    notifyListeners();

    try {
      String property = '-';
      String checkIn = '-';
      String paymentMethod = '-';
      String rejectionReason = '-';
      String applicantName = '-';
      String applicantEmail = '-';
      String applicantPhone = '-';

      // Parse id dari notif.id
      // Format: 'jasa_approved_1', 'booking_2', 'payment_3'
      final parts = notif.id.split('_');

      if (notif.type == OwnerNotificationType.approved ||
          notif.type == OwnerNotificationType.rejected) {
        // Ambil nama jasa
        final idJasa = int.tryParse(parts.last) ?? 0;
        final jasaRes = await supabase
            .from('jasa')
            .select('nama_jasa')
            .eq('id_jasa', idJasa)
            .single();
        property = jasaRes['nama_jasa'] ?? '-';

      } else if (notif.type == OwnerNotificationType.booking) {
        // Ambil data booking + jasa + profile
        final idBooking = int.tryParse(parts.last) ?? 0;
        final bookingRes = await supabase
            .from('booking_jasa')
            .select('id_jasa, id_profile, tanggal, bulan')
            .eq('id_booking_jasa', idBooking)
            .single();

        final jasaRes = await supabase
            .from('jasa')
            .select('nama_jasa')
            .eq('id_jasa', bookingRes['id_jasa'] as int)
            .single();

        final profileRes = await supabase
            .from('profiles')
            .select('username, email, phone')
            .eq('id_profile', bookingRes['id_profile'] as String)
            .single();

        property = jasaRes['nama_jasa'] ?? '-';
        applicantName = profileRes['username'] ?? '-';
        applicantEmail = profileRes['email'] ?? '-';
        applicantPhone = profileRes['phone'] ?? '-';

        final tanggal = bookingRes['tanggal'];
        final bulan = bookingRes['bulan'];
        if (tanggal != null && bulan != null) {
          checkIn = '$tanggal/${bulan.toString().padLeft(2, '0')}';
        }

      } else if (notif.type == OwnerNotificationType.payment) {
        // Ambil data payment + booking + jasa + profile
        final idPayment = int.tryParse(parts.last) ?? 0;
        final paymentRes = await supabase
            .from('payments')
            .select('id_booking_jasa, payment_type')
            .eq('id_payments', idPayment)
            .single();

        final idBooking = paymentRes['id_booking_jasa'] as int;
        paymentMethod = paymentRes['payment_type'] as String? ?? '-';

        final bookingRes = await supabase
            .from('booking_jasa')
            .select('id_jasa, id_profile, tanggal, bulan')
            .eq('id_booking_jasa', idBooking)
            .single();

        final jasaRes = await supabase
            .from('jasa')
            .select('nama_jasa')
            .eq('id_jasa', bookingRes['id_jasa'] as int)
            .single();

        final profileRes = await supabase
            .from('profiles')
            .select('username, email, phone')
            .eq('id_profile', bookingRes['id_profile'] as String)
            .single();

        property = jasaRes['nama_jasa'] ?? '-';
        applicantName = profileRes['username'] ?? '-';
        applicantEmail = profileRes['email'] ?? '-';
        applicantPhone = profileRes['phone'] ?? '-';

        final tanggal = bookingRes['tanggal'];
        final bulan = bookingRes['bulan'];
        if (tanggal != null && bulan != null) {
          checkIn = '$tanggal/${bulan.toString().padLeft(2, '0')}';
        }
      }

      notification = NotificationModel(
        title: notif.title,
        subtitle: notif.description,
        time: notif.time,
        property: property,
        room: '-',
        checkIn: checkIn,
        checkOut: '-',
        paymentMethod: paymentMethod,
        rejectionReason: rejectionReason,
        applicantName: applicantName,
        applicantEmail: applicantEmail,
        applicantPhone: applicantPhone,
      );
    } catch (e) {
      debugPrint('Error loading notif detail jasa: $e');
      notification = NotificationModel(
        title: notif.title,
        subtitle: notif.description,
        time: notif.time,
        property: '-',
        room: '-',
        checkIn: '-',
        checkOut: '-',
        paymentMethod: '-',
        rejectionReason: '-',
        applicantName: '-',
        applicantEmail: '-',
        applicantPhone: '-',
      );
    }

    isLoading = false;
    notifyListeners();
  }

  static kos.OwnerNotificationType mapType(OwnerNotificationType t) {
    switch (t) {
      case OwnerNotificationType.rejected:
        return kos.OwnerNotificationType.rejected;
      case OwnerNotificationType.booking:
        return kos.OwnerNotificationType.booking;
      case OwnerNotificationType.payment:
        return kos.OwnerNotificationType.payment;
      case OwnerNotificationType.checkout:
        return kos.OwnerNotificationType.approved;
      case OwnerNotificationType.reminder:
        return kos.OwnerNotificationType.booking;
      case OwnerNotificationType.cancelled:
        return kos.OwnerNotificationType.rejected;
      case OwnerNotificationType.approved:
        return kos.OwnerNotificationType.approved;
    }
  }
}