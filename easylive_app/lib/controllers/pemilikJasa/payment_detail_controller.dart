import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikJasa/payment_detail_model.dart';
import '../../models/pemilikJasa/dashboard_model.dart';

class PaymentDetailController extends ChangeNotifier {
  JasaPaymentDetailModel? detail;
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> loadFromSupabase(String idPayment) async {
    isLoading = true;
    notifyListeners();

    try {
      // 1️⃣ Ambil payment
      final paymentRes = await supabase
          .from('payments')
          .select('id_payments, id_booking_jasa, gross_amount, payment_type, id_transaction, status')
          .eq('id_payments', int.parse(idPayment))
          .single();

      final idBooking = paymentRes['id_booking_jasa'] as int;
      final grossAmount = (paymentRes['gross_amount'] as num?)?.toDouble() ?? 0;
      final paymentType = paymentRes['payment_type'] as String? ?? '-';
      final idTransaction = paymentRes['id_transaction'] as String? ?? '-';
      final status = paymentRes['status'] as String? ?? '-';

      // 2️⃣ Ambil booking jasa
      final bookingRes = await supabase
          .from('booking_jasa')
          .select('id_jasa, id_profile, tanggal, bulan, titik_penjemputan')
          .eq('id_booking_jasa', idBooking)
          .single();

      // 3️⃣ Ambil jasa
      final jasaRes = await supabase
          .from('jasa')
          .select('nama_jasa, tipe_mobil')
          .eq('id_jasa', bookingRes['id_jasa'] as int)
          .single();

      // 4️⃣ Ambil profile penyewa
      final profileRes = await supabase
          .from('profiles')
          .select('username')
          .eq('id_profile', bookingRes['id_profile'] as String)
          .single();

      final tanggal = bookingRes['tanggal'];
      final bulan = bookingRes['bulan'];
      String tanggalStr = '-';
      if (tanggal != null && bulan != null) {
        tanggalStr = '$tanggal/${bulan.toString().padLeft(2, '0')}';
      }

      detail = JasaPaymentDetailModel(
        ownerName: profileRes['username'] ?? '-',
        vehicleType: jasaRes['tipe_mobil'] ?? '-',
        location: bookingRes['titik_penjemputan'] as String? ?? '-',
        paymentDate: tanggalStr,
        paymentMethod: paymentType,
        transactionId: idTransaction,
        status: status == 'settlement' ? 'Lunas' : status,
        totalPayment: grossAmount.toInt(),
        items: [
          JasaPaymentItem(
            title: 'Sewa Jasa ${jasaRes['nama_jasa'] ?? ''}',
            amount: grossAmount.toInt(),
          ),
        ],
      );
    } catch (e) {
      debugPrint('Error loading payment detail: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Tetap ada untuk backward compatibility
  JasaPaymentDetailModel getPaymentDetail({
    required JasaPaymentHistory history,
  }) {
    return JasaPaymentDetailModel(
      ownerName: history.name,
      vehicleType: history.vehicleType,
      location: history.location,
      paymentDate: history.date,
      paymentMethod: history.paymentMethod,
      transactionId: history.transactionId,
      status: history.status,
      totalPayment: history.totalPayment,
      items: [
        JasaPaymentItem(
          title: 'Sewa Jasa ${history.jasaName}',
          amount: history.totalPayment,
        ),
      ],
    );
  }

  String formatCurrency(int value) {
    return 'Rp ${value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }
}