import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user/kos_model.dart';

class HomeController {
  static const String _defaultImage = 'assets/images/kos1.jpg';

  // ─── User Profile State ───────────────────────────────────────────────────

  static String _userName = '';
  static String? _userPhoto;

  /// Fetch profile user yang sedang login dari tabel `profiles`.
  /// - Nama ditampilkan: full_name → username → 'User'
  /// - Photo diambil dari Supabase Storage bucket: profile-images
  static Future<void> fetchUserProfile() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final res = await supabase
        .from('profiles')
        .select('username, full_name, photo')
        .eq('id_profile', userId)
        .maybeSingle();

    if (res == null) return;

    // Nama: prioritas full_name, fallback ke username
    final fullName = (res['full_name'] ?? '').toString().trim();
    final username = (res['username'] ?? '').toString().trim();
    _userName = fullName.isNotEmpty ? fullName : username;

    // Photo: generate public URL dari bucket profile-images
    final photoPath = (res['photo'] ?? '').toString().trim();
    if (photoPath.isNotEmpty) {
      try {
        // Jika sudah berupa URL lengkap (http/https), langsung pakai
        if (photoPath.startsWith('http://') ||
            photoPath.startsWith('https://')) {
          _userPhoto = photoPath;
        } else {
          // Asumsikan nilai di DB adalah path dalam bucket (misal: "uuid/avatar.jpg")
          _userPhoto = supabase.storage
              .from('profile-images')
              .getPublicUrl(photoPath);
        }
      } catch (_) {
        _userPhoto = null;
      }
    } else {
      _userPhoto = null;
    }
  }

  static String getUserName() => _userName.isNotEmpty ? _userName : 'User';
  static String? getUserPhoto() => _userPhoto;

  /// Untuk kompatibilitas backward — tidak dihapus.
  static void setUserData({required String username}) {
    _userName = username;
  }

  // ─── Kost List ────────────────────────────────────────────────────────────

  /// Fetch daftar kost aktif dari Supabase.
  ///
  /// Mapping kolom (sesuai DDL):
  /// - nama_kost   -> name
  /// - alamat      -> address
  /// - harga       -> price
  /// - gambar (text[]) -> image (ambil item pertama)
  /// - deskripsi   -> description
  /// - fasilitas (text[]) -> facilities
  /// - jumlah_kamar -> availableRooms
  static Future<List<KostModel>> fetchKostList({int limit = 50}) async {
    final supabase = Supabase.instance.client;

    final res = await supabase
        .from('kost')
        .select(
          'id_kost, nama_kost, harga, gambar, deskripsi, alamat, fasilitas, '
          'jumlah_kamar, status, kamar_kosong, tipe_kost, kecamatan, kota',
        )
        .eq('status', 'aktif')
        .order('id_kost', ascending: false)
        .limit(limit);

    final list = (res as List?) ?? <dynamic>[];

    return list.map<KostModel>((item) {
      // ── Gambar ──────────────────────────────────────────────────────────
      final gambar = item['gambar'];
      String imageUrl = _defaultImage;

      String _decodeImageCandidate(String candidate) {
        String decoded = candidate;
        for (var i = 0; i < 3; i++) {
          try {
            decoded = Uri.decodeComponent(decoded);
          } catch (_) {
            break;
          }
        }
        if (decoded.startsWith('assets/')) {
          decoded = decoded.substring('assets/'.length);
        }
        return decoded;
      }

      if (gambar is List && gambar.isNotEmpty) {
        final first = gambar.first;
        final candidate = first?.toString().trim() ?? '';
        if (candidate.isNotEmpty) {
          imageUrl = _decodeImageCandidate(candidate);
        }
      } else if (gambar is String) {
        final candidate = gambar.trim();
        if (candidate.isNotEmpty) {
          final decoded = _decodeImageCandidate(candidate);
          imageUrl = (decoded.startsWith('http://') ||
                  decoded.startsWith('https://'))
              ? decoded
              : _defaultImage;
        }
      }

      // ── Harga ───────────────────────────────────────────────────────────
      final priceRaw = item['harga'];
      int? price;
      if (priceRaw != null) {
        price = priceRaw is num
            ? priceRaw.toInt()
            : int.tryParse(priceRaw.toString());
      }

      // ── Fasilitas ───────────────────────────────────────────────────────
      final facilitiesRaw = item['fasilitas'];
      final facilities = facilitiesRaw is List
          ? facilitiesRaw.map((e) => e.toString()).toList()
          : null;

      // ── Jumlah Kamar ────────────────────────────────────────────────────
      final roomsRaw = item['jumlah_kamar'];
      int? availableRooms;
      if (roomsRaw != null) {
        availableRooms = roomsRaw is num
            ? roomsRaw.toInt()
            : int.tryParse(roomsRaw.toString());
      }

      // ── Kamar Kosong ────────────────────────────────────────────────────
      final emptyRoomsRaw = item['kamar_kosong'];
      int? emptyRooms;
      if (emptyRoomsRaw != null) {
        emptyRooms = emptyRoomsRaw is num
            ? emptyRoomsRaw.toInt()
            : int.tryParse(emptyRoomsRaw.toString());
      }

      // ── Lokasi ──────────────────────────────────────────────────────────
      final loc = (item['loc'] ?? '').toString();
      final kecamatan = (item['kecamatan'] ?? '').toString();
      final kota = (item['kota'] ?? '').toString();
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

  /// Legacy — tetap ada untuk kompatibilitas.
  static List<KostModel> getKostList() => [];
}