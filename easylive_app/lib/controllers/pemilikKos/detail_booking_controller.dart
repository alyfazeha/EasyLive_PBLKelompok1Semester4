import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikKos/detail_booking_model.dart';

class DetailBookingController extends ChangeNotifier {
  final String idBooking;
  DetailBookingModel? booking;
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  DetailBookingController({required this.idBooking}) {
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1️⃣ Ambil booking
      final bookingRes = await supabase
          .from('booking_kos')
          .select('id_booking_kost, id_kost, id_profile, total_bayar, tanggal_checkin, status_pesanan, alasan_penolakan')
          .eq('id_booking_kost', int.parse(idBooking))
          .single();

      // 2️⃣ Ambil data kost
      final kostRes = await supabase
          .from('kost')
          .select('nama_kost, harga')
          .eq('id_kost', bookingRes['id_kost'] as int)
          .single();

      // 3️⃣ Ambil data penyewa
      final profileRes = await supabase
          .from('profiles')
          .select('username, phone, email')
          .eq('id_profile', bookingRes['id_profile'] as String)
          .single();

      // 4️⃣ Cek status pembayaran
      final paymentRes = await supabase
          .from('payments')
          .select('status')
          .eq('id_booking_kost', int.parse(idBooking))
          .maybeSingle();

      final paymentStatus = paymentRes != null &&
              paymentRes['status'] == 'settlement'
          ? 'Lunas'
          : 'Belum Lunas';

      // 5️⃣ Format status booking
      final statusRaw = bookingRes['status_pesanan'] as String? ?? '';
      String bookingStatus;
      switch (statusRaw) {
        case 'menunggu':
          bookingStatus = 'Pending';
          break;
        case 'dikonfirmasi':
          bookingStatus = 'Aktif';
          break;
        case 'ditolak':
          bookingStatus = 'Ditolak';
          break;
        case 'selesai':
          bookingStatus = 'Selesai';
          break;
        default:
          bookingStatus = statusRaw;
      }

      final harga = (kostRes['harga'] as num?)?.toDouble() ?? 0;

      booking = DetailBookingModel(
        idBooking: idBooking,
        tenantName: profileRes['username'] ?? '-',
        phone: profileRes['phone'] ?? '-',
        email: profileRes['email'] ?? '-',
        kosName: kostRes['nama_kost'] ?? '-',
        checkInDate: _formatTanggal(
            bookingRes['tanggal_checkin'] as String? ?? ''),
        monthlyPrice: 'Rp ${_formatHarga(harga)} / bulan',
        paymentStatus: paymentStatus,
        bookingStatus: bookingStatus,
        alasanPenolakan: bookingRes['alasan_penolakan'] as String? ?? '',
      );
    } catch (e) {
      debugPrint('Error loading detail booking: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Konfirmasi booking (hanya jika sudah Lunas)
  Future<void> konfirmasi(BuildContext context) async {
    try {
      await supabase
          .from('booking_kos')
          .update({'status_pesanan': 'dikonfirmasi'})
          .eq('id_booking_kost', int.parse(idBooking));

      booking = DetailBookingModel(
        idBooking: booking!.idBooking,
        tenantName: booking!.tenantName,
        phone: booking!.phone,
        email: booking!.email,
        kosName: booking!.kosName,
        checkInDate: booking!.checkInDate,
        monthlyPrice: booking!.monthlyPrice,
        paymentStatus: booking!.paymentStatus,
        bookingStatus: 'Aktif',
        alasanPenolakan: booking!.alasanPenolakan,
      );
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil dikonfirmasi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal konfirmasi: $e')),
      );
    }
  }

  // Tolak booking dengan alasan
  Future<void> tolak(BuildContext context, String alasan) async {
    try {
      await supabase
          .from('booking_kos')
          .update({
            'status_pesanan': 'ditolak',
            'alasan_penolakan': alasan,
          })
          .eq('id_booking_kost', int.parse(idBooking));

      booking = DetailBookingModel(
        idBooking: booking!.idBooking,
        tenantName: booking!.tenantName,
        phone: booking!.phone,
        email: booking!.email,
        kosName: booking!.kosName,
        checkInDate: booking!.checkInDate,
        monthlyPrice: booking!.monthlyPrice,
        paymentStatus: booking!.paymentStatus,
        bookingStatus: 'Ditolak',
        alasanPenolakan: alasan,
      );
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil ditolak')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menolak: $e')),
      );
    }
  }

  String _formatTanggal(String tanggal) {
    try {
      final dt = DateTime.parse(tanggal);
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month]} ${dt.year}';
    } catch (_) {
      return tanggal;
    }
  }

  String _formatHarga(double harga) {
    return harga
        .toInt()
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}