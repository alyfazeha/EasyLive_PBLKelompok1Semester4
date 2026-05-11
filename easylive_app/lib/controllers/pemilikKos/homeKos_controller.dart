import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikKos/pemilikKos_model.dart';

class PemilikKosController extends ChangeNotifier {
  bool _isLoading = false;
  PemilikKosModel? _model;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  PemilikKosModel? get model => _model;
  String get errorMessage => _errorMessage;

  final supabase = Supabase.instance.client;

  PemilikKosController() {
    _loadData();
  }

  void removeKost(int index) {
    if (_model != null && index < _model!.kostList.length) {
      final list = List<KostData>.from(_model!.kostList);
      list.removeAt(index);
      _model = PemilikKosModel(
        ownerName: _model!.ownerName,
        welcomeMessage: _model!.welcomeMessage,
        totalKost: _model!.totalKost - 1,
        availableRooms: _model!.availableRooms,
        totalIncome: _model!.totalIncome,
        newBookings: _model!.newBookings,
        occupiedRooms: _model!.occupiedRooms,
        totalRooms: _model!.totalRooms,
        kostList: list,
      );
      notifyListeners();
    }
  }

  Future<void> deleteKost(String idKost) async {
    try {
      await supabase
          .from('kost')
          .delete()
          .eq('id_kost', int.parse(idKost));

      await _loadData();
    } catch (e) {
      debugPrint('Error deleting kost: $e');
      rethrow;
    }
  }

  Future<void> _loadData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        _errorMessage = 'User tidak login';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 1️⃣ Ambil nama owner dari tabel profiles
      final profileRes = await supabase
          .from('profiles')
          .select('username')
          .eq('id_profile', user.id)
          .single();

      final ownerName = profileRes['username'] ?? 'Pemilik Kos';

      // 2️⃣ Ambil semua kost milik owner
      final kostRes = await supabase
          .from('kost')
          .select()
          .eq('owner_id', user.id)
          .order('id_kost', ascending: false);

      final List<KostData> kostList = (kostRes as List).map((k) {
        final gambar = (k['gambar'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        final jumlahKamar = (k['jumlah_kamar'] as int?) ?? 0;
        final kamarKosong = (k['kamar_kosong'] as int?) ?? 0;
        final harga = (k['harga'] as num?)?.toDouble() ?? 0;
        final status = (k['status'] as String?) ?? 'pending';

        String statusLabel;
        String statusColorHex;
        switch (status.toLowerCase()) {
          case 'aktif':
            statusLabel = 'Aktif';
            statusColorHex = '0xFF31B75D';
            break;
          case 'ditolak':
            statusLabel = 'Ditolak';
            statusColorHex = '0xFFE53935';
            break;
          default:
            statusLabel = 'Pending';
            statusColorHex = '0xFFFFAB00';
        }

        return KostData(
          idKost: k['id_kost'].toString(),
          name: k['nama_kost'] ?? '-',
          gambar: gambar,
          price: 'Rp ${_formatHarga(harga)} / bulan',
          status: statusLabel,
          statusColor: statusColorHex,
          emptyRoom: '$kamarKosong Kosong',
          alamat: k['alamat'] ?? '-',
          jumlahKamar: jumlahKamar,
          kamarKosong: kamarKosong,
        );
      }).toList();

      // 3️⃣ Hitung summary dari data kost
      final totalKost = kostList.length;
      final totalKamar = kostList.fold(0, (sum, k) => sum + k.jumlahKamar);
      final totalKosong = kostList.fold(0, (sum, k) => sum + k.kamarKosong);
      final totalTerisi = totalKamar - totalKosong;

      // 4️⃣ Hitung total pendapatan dari payments settlement
      double totalPendapatan = 0;

      if (kostList.isNotEmpty) {
        final kostIds = kostList.map((k) => int.parse(k.idKost)).toList();

        final bookingRes = await supabase
            .from('booking_kos')
            .select('id_booking_kost')
            .inFilter('id_kost', kostIds);

        final bookingIds = (bookingRes as List)
            .map((b) => b['id_booking_kost'] as int)
            .toList();

        if (bookingIds.isNotEmpty) {
          final paymentRes = await supabase
              .from('payments')
              .select('gross_amount')
              .inFilter('id_booking_kost', bookingIds)
              .eq('status', 'settlement');

          totalPendapatan = (paymentRes as List).fold(
            0,
            (sum, p) => sum + ((p['gross_amount'] as num?)?.toDouble() ?? 0),
          );
        }
      }

      // 5️⃣ Hitung booking baru (status menunggu)
      int totalBookingBaru = 0;

      if (kostList.isNotEmpty) {
        final kostIds = kostList.map((k) => int.parse(k.idKost)).toList();

        final bookingBaruRes = await supabase
            .from('booking_kos')
            .select('id_booking_kost')
            .inFilter('id_kost', kostIds)
            .eq('status_pesanan', 'menunggu');

        totalBookingBaru = (bookingBaruRes as List).length;
      }

      _model = PemilikKosModel(
        ownerName: ownerName,
        welcomeMessage: 'EasyLive !',
        totalKost: totalKost,
        availableRooms: totalKosong,
        totalIncome: totalPendapatan,
        newBookings: totalBookingBaru,
        occupiedRooms: totalTerisi,
        totalRooms: totalKamar,
        kostList: kostList,
      );
    } catch (e) {
      debugPrint('Error loading pemilik kos data: $e');
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadData();
  }

  void updateNotificationCount(int count) {
    notifyListeners();
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