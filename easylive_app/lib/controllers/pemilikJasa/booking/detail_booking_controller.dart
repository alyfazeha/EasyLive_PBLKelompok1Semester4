import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/pemilikJasa/detail_booking_model.dart';

class DetailBookingJasaController extends ChangeNotifier {
  final String idBooking;
  DetailBookingJasaModel? booking;
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  DetailBookingJasaController({required this.idBooking}) {
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1️⃣ Ambil booking jasa
      final bookingRes = await supabase
          .from('booking_jasa')
          .select(
            'id_booking_jasa, id_jasa, id_profile, total_bayar, tanggal, bulan, titik_penjemputan, titik_tujuan, status_pesanan',
          )
          .eq('id_booking_jasa', int.parse(idBooking))
          .single();

      // 2️⃣ Ambil data jasa
      final jasaRes = await supabase
          .from('jasa')
          .select('nama_jasa, price_km')
          .eq('id_jasa', bookingRes['id_jasa'] as int)
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
          .eq('id_booking_jasa', int.parse(idBooking))
          .maybeSingle();

      final paymentStatus =
          paymentRes != null && paymentRes['status'] == 'settlement'
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

      // 6️⃣ Format tanggal
      final tanggal = bookingRes['tanggal'];
      final bulan = bookingRes['bulan'];
      String tanggalStr = '-';
      if (tanggal != null && bulan != null) {
        tanggalStr = '$tanggal/${bulan.toString().padLeft(2, '0')}';
      }

      final totalBayar =
          (bookingRes['total_bayar'] as num?)?.toDouble() ?? 0;

      booking = DetailBookingJasaModel(
        idBooking: idBooking,
        tenantName: profileRes['username'] ?? '-',
        phone: profileRes['phone'] ?? '-',
        email: profileRes['email'] ?? '-',
        jasaName: jasaRes['nama_jasa'] ?? '-',
        titikPenjemputan:
            bookingRes['titik_penjemputan'] as String? ?? '-',
        titikTujuan: bookingRes['titik_tujuan'] as String? ?? '-',
        totalBayar: 'Rp ${_formatHarga(totalBayar)}',
        paymentStatus: paymentStatus,
        bookingStatus: bookingStatus,
        alasanPenolakan: '',
        tanggal: tanggalStr,
      );
    } catch (e) {
      debugPrint('Error loading detail booking jasa: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> konfirmasi(BuildContext context) async {
    try {
      await supabase
          .from('booking_jasa')
          .update({'status_pesanan': 'dikonfirmasi'})
          .eq('id_booking_jasa', int.parse(idBooking));

      booking = DetailBookingJasaModel(
        idBooking: booking!.idBooking,
        tenantName: booking!.tenantName,
        phone: booking!.phone,
        email: booking!.email,
        jasaName: booking!.jasaName,
        titikPenjemputan: booking!.titikPenjemputan,
        titikTujuan: booking!.titikTujuan,
        totalBayar: booking!.totalBayar,
        paymentStatus: booking!.paymentStatus,
        bookingStatus: 'Aktif',
        alasanPenolakan: '',
        tanggal: booking!.tanggal,
      );
      notifyListeners();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil dikonfirmasi')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal konfirmasi: $e')),
      );
    }
  }

  Future<void> tolak(BuildContext context, String alasan) async {
    try {
      await supabase
          .from('booking_jasa')
          .update({'status_pesanan': 'ditolak'})
          .eq('id_booking_jasa', int.parse(idBooking));

      booking = DetailBookingJasaModel(
        idBooking: booking!.idBooking,
        tenantName: booking!.tenantName,
        phone: booking!.phone,
        email: booking!.email,
        jasaName: booking!.jasaName,
        titikPenjemputan: booking!.titikPenjemputan,
        titikTujuan: booking!.titikTujuan,
        totalBayar: booking!.totalBayar,
        paymentStatus: booking!.paymentStatus,
        bookingStatus: 'Ditolak',
        alasanPenolakan: alasan,
        tanggal: booking!.tanggal,
      );
      notifyListeners();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil ditolak')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menolak: $e')),
      );
    }
  }

  Future<void> selesai(BuildContext context) async {
    try {
      await supabase
          .from('booking_jasa')
          .update({'status_pesanan': 'selesai'})
          .eq('id_booking_jasa', int.parse(idBooking));

      booking = DetailBookingJasaModel(
        idBooking: booking!.idBooking,
        tenantName: booking!.tenantName,
        phone: booking!.phone,
        email: booking!.email,
        jasaName: booking!.jasaName,
        titikPenjemputan: booking!.titikPenjemputan,
        titikTujuan: booking!.titikTujuan,
        totalBayar: booking!.totalBayar,
        paymentStatus: booking!.paymentStatus,
        bookingStatus: 'Selesai',
        alasanPenolakan: '',
        tanggal: booking!.tanggal,
      );
      notifyListeners();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking berhasil diselesaikan'),
          backgroundColor: Color(0xFF4D82FF),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e')),
      );
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