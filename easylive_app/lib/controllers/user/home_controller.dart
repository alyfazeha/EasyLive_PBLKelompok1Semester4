import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user/kos_model.dart';

class HomeController {
  static const String _defaultImage = 'assets/images/kos1.jpg';

  /// Fetch daftar kost aktif dari Supabase.
  ///
  /// Mapping kolom (sesuai DDL):
  /// - nama_kost -> name
  /// - alamat -> address
  /// - harga -> price
  /// - gambar (text[]) -> image (ambil item pertama)
  /// - deskripsi -> description
  /// - fasilitas (text[]) -> facilities
  /// - jumlah_kamar -> availableRooms

  static Future<List<KostModel>> fetchKostList({int limit = 50}) async {
    final supabase = Supabase.instance.client;

    final res = await supabase
        .from('kost')
        .select(
          'id_kost, nama_kost, harga, gambar, deskripsi, alamat, fasilitas, jumlah_kamar, status',
        )
        .eq('status', 'aktif')
        .order('id_kost', ascending: false)
        .limit(limit);

    final list = (res as List?) ?? <dynamic>[];

    return list.map<KostModel>((item) {
      final gambar = item['gambar'];
      String imageUrl = _defaultImage;
      if (gambar is List && gambar.isNotEmpty) {
        final first = gambar.first;
        final candidate = first?.toString().trim();
        if (candidate != null && candidate.isNotEmpty) {
          // Supabase berisi URL. Kalau masih ada kemungkinan null/"", fallback.
          imageUrl = candidate;
        }
      } else if (gambar is String) {
        final candidate = gambar.trim();
        if (candidate.isNotEmpty) imageUrl = candidate;
      }

      final priceRaw = item['harga'];
      int? price;
      if (priceRaw != null) {
        if (priceRaw is num) {
          price = priceRaw.toInt();
        } else {
          price = int.tryParse(priceRaw.toString());
        }
      }

      final facilitiesRaw = item['fasilitas'];
      final facilities = facilitiesRaw is List
          ? facilitiesRaw.map((e) => e.toString()).toList()
          : null;

      final roomsRaw = item['jumlah_kamar'];
      int? availableRooms;
      if (roomsRaw != null) {
        if (roomsRaw is num) {
          availableRooms = roomsRaw.toInt();
        } else {
          availableRooms = int.tryParse(roomsRaw.toString());
        }
      }

      return KostModel(
        name: (item['nama_kost'] ?? '').toString(),
        address: (item['alamat'] ?? '').toString(),
        image: imageUrl,
        price: price,
        description: (item['deskripsi'] ?? '').toString().isEmpty
            ? null
            : (item['deskripsi'] ?? '').toString(),
        facilities: facilities,
        availableRooms: availableRooms,
      );
    }).toList();
  }

  /// Legacy untuk kompatibilitas (tidak dipakai landing lagi).
  /// Kalau masih ada tempat lain yang memanggil sync, list ini tetap ada.
  static List<KostModel> getKostList() {
    return [];
  }

  static String _userName = '';

  static void setUserData({required String username}) {
    _userName = username;
  }

  static String getUserName() {
    return _userName.isNotEmpty ? _userName : 'User';
  }
}
