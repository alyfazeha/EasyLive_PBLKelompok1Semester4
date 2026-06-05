import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikJasa/vehicle_model.dart';

class PemilikJasaHomeController extends ChangeNotifier {
  bool isLoading = false;
  String ownerName = '';
  int totalVehicles = 0;
  int availableVehicles = 0;
  double totalIncome = 0;
  int newBookings = 0;
  List<OwnerVehicle> vehicles = [];

  String get totalIncomeFormatted => 'Rp ${_formatHarga(totalIncome)}';
  String get availableRatio => '$availableVehicles / $totalVehicles';

  final supabase = Supabase.instance.client;

  PemilikJasaHomeController() {
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

      // 1️⃣ Ambil nama owner
      final profileRes = await supabase
          .from('profiles')
          .select('username')
          .eq('id_profile', user.id)
          .single();

      ownerName = profileRes['username'] ?? 'Pemilik Jasa';

      // 2️⃣ Ambil semua jasa milik owner
      final jasaRes = await supabase
          .from('jasa')
          .select()
          .eq('owner_id', user.id)
          .order('id_jasa', ascending: false);

      totalVehicles = (jasaRes as List).length;
      availableVehicles = jasaRes
          .where((j) => j['status'] == 'aktif')
          .length;

      vehicles = jasaRes.map((j) {
        final gambar = (j['gambar'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        final status = j['status'] as String? ?? 'pending';
        final hargaKm = (j['price_km'] as num?)?.toDouble() ?? 0;

        Color statusColor;
        String statusLabel;
        switch (status) {
          case 'aktif':
            statusColor = const Color(0xFF31B75D);
            statusLabel = 'Aktif';
            break;
          case 'ditolak':
            statusColor = const Color(0xFFE53935);
            statusLabel = 'Ditolak';
            break;
          default:
            statusColor = const Color(0xFFFFAB00);
            statusLabel = 'Pending';
        }

        final image = gambar.isNotEmpty
            ? gambar[0]
            : 'assets/images/pickup-removed.png';

        return OwnerVehicle(
          idJasa: j['id_jasa'].toString(),
          name: j['nama_jasa'] ?? '-',
          image: image,
          address: j['alamat'] ?? '-',
          capacity: j['kapasitas'] ?? '-',
          availability: '-',
          income: 'Rp ${_formatHarga(hargaKm)} / km',
          status: statusLabel,
          statusColor: statusColor,
        );
      }).toList();

      // 3️⃣ Ambil booking baru (menunggu)
      if (jasaRes.isNotEmpty) {
        final jasaIds = jasaRes
            .map((j) => j['id_jasa'] as int)
            .toList();

        final bookingRes = await supabase
            .from('booking_jasa')
            .select('id_booking_jasa')
            .inFilter('id_jasa', jasaIds)
            .eq('status_pesanan', 'menunggu');

        newBookings = (bookingRes as List).length;

        // 4️⃣ Total pendapatan
        final allBookingRes = await supabase
            .from('booking_jasa')
            .select('id_booking_jasa')
            .inFilter('id_jasa', jasaIds);

        final bookingIds = (allBookingRes as List)
            .map((b) => b['id_booking_jasa'] as int)
            .toList();

        if (bookingIds.isNotEmpty) {
          final paymentRes = await supabase
              .from('payments')
              .select('gross_amount')
              .inFilter('id_booking_jasa', bookingIds)
              .eq('status', 'settlement');

          totalIncome = (paymentRes as List).fold(
            0.0,
            (sum, p) =>
                sum + ((p['gross_amount'] as num?)?.toDouble() ?? 0),
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading jasa home: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteJasa(String idJasa) async {
    try {
      await supabase
          .from('jasa')
          .delete()
          .eq('id_jasa', int.parse(idJasa));
      await loadData();
    } catch (e) {
      debugPrint('Error delete jasa: $e');
      rethrow;
    }
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