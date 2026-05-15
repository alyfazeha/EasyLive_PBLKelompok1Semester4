import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikKos/dashboard_model.dart';

class DashboardController extends ChangeNotifier {
  List<Dashboard> dashboardList = [];
  bool isLoading = false;
  String errorMessage = '';

  String ownerName = '';
  int totalKost = 0;
  int kamarTersedia = 0;
  int bookingBaru = 0;
  double totalPendapatan = 0;

  String get pendapatanFormatted => 'Rp ${_formatHarga(totalPendapatan)}';

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

      final profileRes = await supabase
          .from('profiles')
          .select('username')
          .eq('id_profile', user.id)
          .single();
      ownerName = profileRes['username'] ?? 'Pemilik Kos';

      final kostRes = await supabase
          .from('kost')
          .select('id_kost, nama_kost, kamar_kosong')
          .eq('owner_id', user.id);

      totalKost = (kostRes as List).length;
      kamarTersedia = kostRes.fold(
          0, (sum, k) => sum + ((k['kamar_kosong'] as int?) ?? 0));

      if (kostRes.isEmpty) {
        dashboardList = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      final Map<int, String> kostNames = {
        for (var k in kostRes)
          (k['id_kost'] as int): (k['nama_kost'] as String? ?? '-')
      };
      final kostIds = kostNames.keys.toList();

      final bookingRes = await supabase
          .from('booking_kos')
          .select('id_booking_kost, id_kost, id_profile, total_bayar, tanggal_checkin, status_pesanan')
          .inFilter('id_kost', kostIds)
          .order('id_booking_kost', ascending: false);

      bookingBaru = (bookingRes as List)
          .where((b) => b['status_pesanan'] == 'menunggu')
          .length;

      if (bookingRes.isEmpty) {
        dashboardList = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      final bookingIds = bookingRes
          .map((b) => b['id_booking_kost'] as int)
          .toList();

      // ← tambah id_transaction dan payment_type
      final paymentRes = await supabase
          .from('payments')
          .select('id_booking_kost, gross_amount, status, id_transaction, payment_type')
          .inFilter('id_booking_kost', bookingIds)
          .eq('status', 'settlement');

      final Map<int, Map<String, dynamic>> paymentMap = {
        for (var p in (paymentRes as List))
          (p['id_booking_kost'] as int): p
      };

      totalPendapatan = (paymentRes).fold(
          0.0, (sum, p) => sum + ((p['gross_amount'] as num?)?.toDouble() ?? 0));

      final profileIds = bookingRes
          .map((b) => b['id_profile'] as String?)
          .where((id) => id != null)
          .toSet()
          .toList();

      final profilesRes = await supabase
          .from('profiles')
          .select('id_profile, username')
          .inFilter('id_profile', profileIds);

      final Map<String, String> profileNames = {
        for (var p in (profilesRes as List))
          (p['id_profile'] as String): (p['username'] as String? ?? '-')
      };

      final List<Dashboard> result = [];
      for (var booking in bookingRes) {
        final idBooking = booking['id_booking_kost'] as int;
        final payment = paymentMap[idBooking];
        if (payment == null) continue;

        final idKost = booking['id_kost'] as int;
        final idProfile = booking['id_profile'] as String? ?? '';
        final tanggal = booking['tanggal_checkin'] as String? ?? '-';
        final grossAmount = (payment['gross_amount'] as num?)?.toDouble() ?? 0;
        final transactionId = payment['id_transaction'] as String? ?? '-';
        final paymentMethod = payment['payment_type'] as String? ?? '-';

        result.add(Dashboard(
          idBooking: idBooking.toString(),
          name: profileNames[idProfile] ?? '-',
          kostName: kostNames[idKost] ?? '-',
          date: _formatTanggal(tanggal),
          price: 'Rp ${_formatHarga(grossAmount)}',
          status: 'Lunas',
          transactionId: transactionId,     // ← tambah
          paymentMethod: paymentMethod,     // ← tambah
          grossAmount: grossAmount.toInt(), // ← tambah
        ));
      }

      dashboardList = result;
    } catch (e) {
      debugPrint('Error loading dashboard: $e');
      // Pastikan error message aman untuk ditampilkan ke UI
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