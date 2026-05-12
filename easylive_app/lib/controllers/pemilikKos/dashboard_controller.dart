import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikKos/dashboard_model.dart';

class DashboardController extends ChangeNotifier {
  List<Dashboard> dashboardList = [];
  bool isLoading = false;
  String errorMessage = '';

  final supabase = Supabase.instance.client;

  DashboardController() {
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        errorMessage = 'User tidak login';
        isLoading = false;
        notifyListeners();
        return;
      }

      // 1️⃣ Ambil semua id_kost milik owner
      final kostRes = await supabase
          .from('kost')
          .select('id_kost, nama_kost')
          .eq('owner_id', user.id);

      if ((kostRes as List).isEmpty) {
        dashboardList = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      // Map id_kost → nama_kost
      final Map<int, String> kostNames = {
        for (var k in kostRes)
          (k['id_kost'] as int): (k['nama_kost'] as String? ?? '-')
      };

      final kostIds = kostNames.keys.toList();

      // 2️⃣ Ambil booking_kos yang id_kost-nya milik owner
      final bookingRes = await supabase
          .from('booking_kos')
          .select('id_booking_kost, id_kost, id_profile, total_bayar, tanggal_checkin, status_pesanan')
          .inFilter('id_kost', kostIds)
          .order('id_booking_kost', ascending: false);

      if ((bookingRes as List).isEmpty) {
        dashboardList = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      // 3️⃣ Ambil payments untuk booking tersebut
      final bookingIds = bookingRes.map((b) => b['id_booking_kost'] as int).toList();

      final paymentRes = await supabase
          .from('payments')
          .select('id_booking_kost, gross_amount, status')
          .inFilter('id_booking_kost', bookingIds)
          .eq('status', 'settlement');

      final Map<int, Map<String, dynamic>> paymentMap = {
        for (var p in (paymentRes as List))
          (p['id_booking_kost'] as int): p
      };

      // 4️⃣ Ambil nama penyewa dari profiles
      final profileIds = bookingRes
          .map((b) => b['id_profile'] as String?)
          .where((id) => id != null)
          .toSet()
          .toList();

      final profileRes = await supabase
          .from('profiles')
          .select('id_profile, username')
          .inFilter('id_profile', profileIds);

      final Map<String, String> profileNames = {
        for (var p in (profileRes as List))
          (p['id_profile'] as String): (p['username'] as String? ?? '-')
      };

      // 5️⃣ Gabungkan semua data — hanya yang sudah settlement
      final List<Dashboard> result = [];

      for (var booking in bookingRes) {
        final idBooking = booking['id_booking_kost'] as int;
        final payment = paymentMap[idBooking];

        if (payment == null) continue; // skip yang belum settlement

        final idKost = booking['id_kost'] as int;
        final idProfile = booking['id_profile'] as String? ?? '';
        final tanggal = booking['tanggal_checkin'] as String? ?? '-';
        final grossAmount = (payment['gross_amount'] as num?)?.toDouble() ?? 0;

        result.add(Dashboard(
          idBooking: idBooking.toString(),
          name: profileNames[idProfile] ?? '-',
          kostName: kostNames[idKost] ?? '-',
          date: _formatTanggal(tanggal),
          price: 'Rp ${_formatHarga(grossAmount)}',
          status: 'Lunas',
        ));
      }

      dashboardList = result;
    } catch (e) {
      debugPrint('Error loading dashboard: $e');
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
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