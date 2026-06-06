import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/pemilikJasa/booking_model.dart';

class OwnerJasaBookingController extends ChangeNotifier {
  List<Booking> bookingList = [];
  bool isLoading = false;
  String selectedFilter = 'semua';
  String searchText = '';

  final supabase = Supabase.instance.client;

  OwnerJasaBookingController() {
    loadData();
  }

  List<Booking> get filteredList {
    return bookingList.where((b) {
      final cocokSearch =
          b.nama.toLowerCase().contains(searchText.toLowerCase()) ||
          b.kendaraan.toLowerCase().contains(searchText.toLowerCase());

      final cocokFilter =
          selectedFilter == 'semua' ? true : b.status == selectedFilter;

      return cocokSearch && cocokFilter;
    }).toList();
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

      // 1️⃣ Ambil semua jasa milik owner
      final jasaRes = await supabase
          .from('jasa')
          .select('id_jasa, nama_jasa')
          .eq('owner_id', user.id);

      if ((jasaRes as List).isEmpty) {
        bookingList = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      final Map<int, String> jasaNames = {
        for (var j in jasaRes)
          (j['id_jasa'] as int): (j['nama_jasa'] as String? ?? '-')
      };
      final jasaIds = jasaNames.keys.toList();

      // 2️⃣ Ambil semua booking jasa milik owner
      final bookingRes = await supabase
          .from('booking_jasa')
          .select(
            'id_booking_jasa, id_jasa, id_profile, status_pesanan, tanggal, bulan, titik_penjemputan, titik_tujuan, total_bayar',
          )
          .inFilter('id_jasa', jasaIds)
          .order('id_booking_jasa', ascending: false);

      if ((bookingRes as List).isEmpty) {
        bookingList = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      // 3️⃣ Ambil nama & foto penyewa
      final profileIds = bookingRes
          .map((b) => b['id_profile'] as String?)
          .where((id) => id != null)
          .toSet()
          .toList();

      final profileRes = await supabase
          .from('profiles')
          .select('id_profile, username, photo')
          .inFilter('id_profile', profileIds);

      final Map<String, Map<String, dynamic>> profileMap = {
        for (var p in (profileRes as List))
          (p['id_profile'] as String): p
      };

      // 4️⃣ Gabungkan data
      bookingList = bookingRes.map((b) {
        final idBooking = b['id_booking_jasa'].toString();
        final idJasa = b['id_jasa'] as int;
        final idProfile = b['id_profile'] as String? ?? '';
        final statusRaw = b['status_pesanan'] as String? ?? 'menunggu';
        final tanggal = b['tanggal'];
        final bulan = b['bulan'];
        final totalBayar = (b['total_bayar'] as num?)?.toDouble() ?? 0;
        final titikPenjemputan = b['titik_penjemputan'] as String? ?? '-';
        final titikTujuan = b['titik_tujuan'] as String? ?? '-';

        final profile = profileMap[idProfile];
        final nama = profile?['username'] as String? ?? '-';
        final photo = profile?['photo'] as String? ?? '';

        // Format tanggal
        String tanggalStr = '-';
        if (tanggal != null && bulan != null) {
          tanggalStr = '$tanggal/${bulan.toString().padLeft(2, '0')}';
        }

        // Format status
        String statusDisplay;
        switch (statusRaw.toLowerCase()) {
          case 'menunggu':
            statusDisplay = 'pending';
            break;
          case 'dikonfirmasi':
            statusDisplay = 'aktif';
            break;
          case 'selesai':
            statusDisplay = 'selesai';
            break;
          case 'ditolak':
            statusDisplay = 'ditolak';
            break;
          default:
            statusDisplay = statusRaw;
        }

        return Booking(
          idBooking: idBooking,
          nama: nama,
          kendaraan: jasaNames[idJasa] ?? '-',
          status: statusDisplay,
          profileImage: photo.isNotEmpty ? photo : null,
          tanggal: tanggalStr,
          jam: '-',
          idProfile: idProfile,
          titikPenjemputan: titikPenjemputan,
          titikTujuan: titikTujuan,
          totalBayar: totalBayar,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading booking jasa: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void setSearch(String value) {
    searchText = value;
    notifyListeners();
  }

  Future<void> approve(Booking b) async {
    try {
      await supabase
          .from('booking_jasa')
          .update({'status_pesanan': 'dikonfirmasi'})
          .eq('id_booking_jasa', int.parse(b.idBooking));
      b.status = 'aktif';
      notifyListeners();
    } catch (e) {
      debugPrint('Error approve: $e');
    }
  }

  Future<void> reject(Booking b) async {
    try {
      await supabase
          .from('booking_jasa')
          .update({'status_pesanan': 'ditolak'})
          .eq('id_booking_jasa', int.parse(b.idBooking));
      b.status = 'ditolak';
      notifyListeners();
    } catch (e) {
      debugPrint('Error reject: $e');
    }
  }

  Future<void> selesai(Booking b) async {
    try {
      await supabase
          .from('booking_jasa')
          .update({'status_pesanan': 'selesai'})
          .eq('id_booking_jasa', int.parse(b.idBooking));
      b.status = 'selesai';
      notifyListeners();
    } catch (e) {
      debugPrint('Error selesai: $e');
    }
  }

  Future<void> refresh() async => await loadData();
}