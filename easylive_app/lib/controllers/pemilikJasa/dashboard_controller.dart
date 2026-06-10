import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/color.dart';
import '../../models/pemilikJasa/dashboard_model.dart';

class PemilikJasaDashboardController extends ChangeNotifier {
  bool isLoading = false;
  String ownerName = '';
  int notificationCount = 0;
  List<JasaDashboardStat> stats = [];
  List<JasaPaymentHistory> payments = [];

  final supabase = Supabase.instance.client;

  PemilikJasaDashboardController() {
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      // 1. Nama owner
      final profileRes = await supabase
          .from('profiles')
          .select('username')
          .eq('id_profile', user.id)
          .single();
      ownerName = profileRes['username'] ?? 'Pemilik Jasa';

      // 2. Semua jasa milik owner
      final jasaRes = await supabase
          .from('jasa')
          .select('id_jasa, nama_jasa, status, tipe_mobil')
          .eq('owner_id', user.id);

      final totalVehicle = (jasaRes as List).length;
      final availableVehicle =
          jasaRes.where((j) => j['status'] == 'aktif').length;

      final Map<int, String> jasaNames = {
        for (var j in jasaRes)
          (j['id_jasa'] as int): (j['nama_jasa'] as String? ?? '-')
      };
      final Map<int, String> jasaTypes = {
        for (var j in jasaRes)
          (j['id_jasa'] as int): (j['tipe_mobil'] as String? ?? '-')
      };
      final jasaIds = jasaNames.keys.toList();

      // 3. Booking baru (menunggu)
      int newBookings = 0;
      if (jasaIds.isNotEmpty) {
        final bookingBaruRes = await supabase
            .from('booking_jasa')
            .select('id_booking_jasa')
            .inFilter('id_jasa', jasaIds)
            .eq('status_pesanan', 'menunggu');
        newBookings = (bookingBaruRes as List).length;
      }

      // 4. Revenue + riwayat pembayaran
      double totalRevenue = 0;
      List<JasaPaymentHistory> paymentList = [];

      if (jasaIds.isNotEmpty) {
        // Ambil semua booking jasa milik owner beserta status_pesanan
        final allBookingRes = await supabase
            .from('booking_jasa')
            .select(
              'id_booking_jasa, id_jasa, id_profile, tanggal, bulan, titik_penjemputan, status_pesanan',
            )
            .inFilter('id_jasa', jasaIds);

        final bookingIds = (allBookingRes as List)
            .map((b) => b['id_booking_jasa'] as int)
            .toList();

        final Map<int, Map<String, dynamic>> bookingDetails = {
          for (var b in allBookingRes) (b['id_booking_jasa'] as int): b
        };

        // Ambil nama penyewa
        final profileIds = allBookingRes
            .map((b) => b['id_profile'] as String?)
            .where((id) => id != null)
            .toSet()
            .toList();

        Map<String, String> profileNames = {};
        if (profileIds.isNotEmpty) {
          final profileRes = await supabase
              .from('profiles')
              .select('id_profile, username')
              .inFilter('id_profile', profileIds);

          profileNames = {
            for (var p in (profileRes as List))
              (p['id_profile'] as String): (p['username'] as String? ?? '-')
          };
        }

        if (bookingIds.isNotEmpty) {
          final paymentRes = await supabase
              .from('payments')
              .select(
                'id_payments, id_booking_jasa, gross_amount, payment_type, id_transaction',
              )
              .inFilter('id_booking_jasa', bookingIds)
              .eq('status', 'settlement');

          for (var p in (paymentRes as List)) {
            final idBooking = p['id_booking_jasa'] as int;
            final booking = bookingDetails[idBooking];

            // Skip booking yang ditolak — uang harusnya direfund
            final statusPesanan =
                booking?['status_pesanan'] as String? ?? '';
            if (statusPesanan == 'ditolak') continue;

            final grossAmount =
                (p['gross_amount'] as num?)?.toDouble() ?? 0;
            final paymentType = p['payment_type'] as String? ?? '-';
            final idTransaction = p['id_transaction'] as String? ?? '-';
            final idProfile = booking?['id_profile'] as String? ?? '';
            final idJasa = booking?['id_jasa'] as int?;
            final tanggal = booking?['tanggal'];
            final bulan = booking?['bulan'];
            final lokasi =
                booking?['titik_penjemputan'] as String? ?? '-';

            final nama = profileNames[idProfile] ?? '-';
            final namaJasa =
                idJasa != null ? (jasaNames[idJasa] ?? '-') : '-';
            final tipeJasa =
                idJasa != null ? (jasaTypes[idJasa] ?? '-') : '-';

            String tanggalStr = '-';
            if (tanggal != null && bulan != null) {
              tanggalStr =
                  '$tanggal/${bulan.toString().padLeft(2, '0')}';
            }

            totalRevenue += grossAmount;

            paymentList.add(JasaPaymentHistory(
              idPayment: p['id_payments'].toString(),
              name: nama,
              vehicleType: tipeJasa,
              location: lokasi,
              date: tanggalStr,
              price: 'Rp ${_formatHarga(grossAmount)}',
              status: 'Lunas',
              paymentMethod: paymentType,
              transactionId: idTransaction,
              totalPayment: grossAmount.toInt(),
              jasaName: namaJasa,
            ));
          }
        }
      }

      payments = paymentList;
      notificationCount = newBookings;

      stats = [
        JasaDashboardStat(
          icon: Icons.local_shipping_outlined,
          title: 'Total Vehicle',
          value: '$totalVehicle Kendaraan',
          color: AppColors.yellow,
        ),
        JasaDashboardStat(
          icon: Icons.check_circle_outline_rounded,
          title: 'Vehicle Available',
          value: '$availableVehicle Kendaraan',
          color: AppColors.yellow,
        ),
        JasaDashboardStat(
          icon: Icons.calendar_month_outlined,
          title: 'New Bookings',
          value: '$newBookings Booking',
          color: const Color(0xFF4D82FF),
        ),
        JasaDashboardStat(
          icon: Icons.paid_outlined,
          title: 'Total Revenue',
          value: 'Rp ${_formatHarga(totalRevenue)}',
          color: AppColors.yellow,
        ),
      ];
    } catch (e) {
      debugPrint('Error loading jasa dashboard: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async => await loadData();

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