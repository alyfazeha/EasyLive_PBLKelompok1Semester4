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
          // TAMBAHKAN kolom kamar_kosong, tipe_kost, kecamatan, kota di akhir string select ini:
          'id_kost, nama_kost, harga, gambar, deskripsi, alamat, fasilitas, jumlah_kamar, status, kamar_kosong, tipe_kost, kecamatan, kota',
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

      final loc = (item['loc'] ?? '').toString();
      final kecamatan = (item['kecamatan'] ?? '').toString();
      final kota = (item['kota'] ?? '').toString();

      final emptyRoomsRaw = item['kamar_kosong'];
      int? emptyRooms;
      if (emptyRoomsRaw != null) {
        if (emptyRoomsRaw is num) {
          emptyRooms = emptyRoomsRaw.toInt();
        } else {
          emptyRooms = int.tryParse(emptyRoomsRaw.toString());
        }
      }

      final kostType = (item['tipe_kost'] ?? '').toString();

      return KostModel(
        id: item['id_kost'] as int?,
        name: (item['nama_kost'] ?? '').toString(),
        address: (item['alamat'] ?? '').toString(),
        image: imageUrl,
        price: price,
        loc: loc.isEmpty ? null : loc,
        kecamatan: kecamatan.isEmpty ? null : kecamatan,
        kota: kota.isEmpty ? null : kota,
        availableRooms: availableRooms,
        emptyRooms: emptyRooms,
        kostType: kostType.isEmpty ? null : kostType,
        description: (item['deskripsi'] ?? '').toString().isEmpty
            ? null
            : (item['deskripsi'] ?? '').toString(),
        facilities: facilities,
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
