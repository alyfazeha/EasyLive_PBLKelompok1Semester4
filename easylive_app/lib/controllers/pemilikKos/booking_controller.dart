import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikKos/booking_model.dart';

class BookingController extends ChangeNotifier {
  List<Booking> bookingList = [];
  bool isLoading = false;
  String selectedFilter = 'All';
  String searchText = '';

  final supabase = Supabase.instance.client;

  BookingController() {
    loadData();
  }

  List<Booking> get filteredList {
    return bookingList.where((b) {
      final cocokSearch =
          b.nama.toLowerCase().contains(searchText.toLowerCase()) ||
          b.kamar.toLowerCase().contains(searchText.toLowerCase());

      final cocokFilter = selectedFilter == 'All'
          ? true
          : b.status.toLowerCase() == selectedFilter.toLowerCase();

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

      // 1️⃣ Ambil semua kost milik owner
      final kostRes = await supabase
          .from('kost')
          .select('id_kost, nama_kost')
          .eq('owner_id', user.id);

      if ((kostRes as List).isEmpty) {
        bookingList = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      final Map<int, String> kostNames = {
        for (var k in kostRes)
          (k['id_kost'] as int): (k['nama_kost'] as String? ?? '-')
      };
      final kostIds = kostNames.keys.toList();

      // 2️⃣ Ambil semua booking milik kost owner
      final bookingRes = await supabase
          .from('booking_kos')
          .select('id_booking_kost, id_kost, id_profile, status_pesanan, tanggal_checkin')
          .inFilter('id_kost', kostIds)
          .order('id_booking_kost', ascending: false);

      if ((bookingRes as List).isEmpty) {
        bookingList = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      // 3️⃣ Ambil nama penyewa
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

      // 4️⃣ Gabungkan data
      bookingList = bookingRes.map((b) {
        final idKost = b['id_kost'] as int;
        final idProfile = b['id_profile'] as String? ?? '';
        final statusRaw = b['status_pesanan'] as String? ?? '-';
        final namaKost = kostNames[idKost] ?? '-';
        final namaPenyewa = profileNames[idProfile] ?? '-';
        final tanggal = b['tanggal_checkin'] as String? ?? '-';

        // Format status untuk display
        String statusDisplay;
        switch (statusRaw.toLowerCase()) {
          case 'menunggu':
            statusDisplay = 'Pending';
            break;
          case 'dikonfirmasi':
            statusDisplay = 'Aktif';
            break;
          case 'selesai':
            statusDisplay = 'Selesai';
            break;
          case 'ditolak':
            statusDisplay = 'Ditolak';
            break;
          default:
            statusDisplay = statusRaw;
        }

        return Booking(
          idBooking: b['id_booking_kost'].toString(),
          nama: namaPenyewa,
          kamar: namaKost,
          status: statusDisplay,
          idProfile: idProfile,
          tanggalCheckin: tanggal,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading booking: $e');
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
          .from('booking_kos')
          .update({'status_pesanan': 'dikonfirmasi'})
          .eq('id_booking_kost', int.parse(b.idBooking));

      b.status = 'Aktif';
      notifyListeners();
    } catch (e) {
      debugPrint('Error approve booking: $e');
    }
  }

  Future<void> reject(Booking b) async {
    try {
      await supabase
          .from('booking_kos')
          .update({'status_pesanan': 'ditolak'})
          .eq('id_booking_kost', int.parse(b.idBooking));

      b.status = 'Ditolak';
      notifyListeners();
    } catch (e) {
      debugPrint('Error reject booking: $e');
    }
  }

  Future<void> selesai(Booking b) async {
    try {
      await supabase
          .from('booking_kos')
          .update({'status_pesanan': 'selesai'})
          .eq('id_booking_kost', int.parse(b.idBooking));

      b.status = 'Selesai';
      notifyListeners();
    } catch (e) {
      debugPrint('Error update selesai: $e');
    }
  }

  Future<void> refresh() async {
    await loadData();
  }
}