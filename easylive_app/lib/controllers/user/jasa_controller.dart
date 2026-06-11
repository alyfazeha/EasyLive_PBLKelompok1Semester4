import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user/jasa_model.dart';
import '../../models/user/jasa_vehicle_model.dart';

class JasaController {
  final List<Map<String, String>> dates = [
    {'day': 'Mon', 'date': '21', 'status': 'inactive'},
    {'day': 'Tue', 'date': '22', 'status': 'active'},
    {'day': 'Wed', 'date': '23', 'status': 'inactive'},
    {'day': 'Thu', 'date': '24', 'status': 'inactive'},
  ];

  final List<VehicleOption> vehicles = [
    VehicleOption(
      name: 'Pick Up',
      capacity: 'Max 1.000 kg',
      icon: Icons.local_shipping,
    ),
    VehicleOption(
      name: 'Blind Van',
      capacity: 'Max 600 kg',
      icon: Icons.directions_car,
    ),
  ];

  static const String _defaultImage = 'assets/images/pickup-removed.png';

  static String _formatPrice(num? value) {
    final v = value ?? 0;
    return 'Rp ${v.toStringAsFixed(0)},-';
  }

  static String _decodeImage(String input) {
    String decoded = input.trim();
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

    if (decoded.startsWith('http://') || decoded.startsWith('https://')) {
      return decoded;
    }

    // If stored as something like assets/images/xxx.png or direct relative path
    return decoded;
  }

  /// Fetch daftar jasa aktif dari Supabase.
  /// Mapping tabel `public.jasa`:
  /// - nama_jasa -> name
  /// - alamat -> address
  /// - gambar (text[]) -> image (ambil item pertama)
  /// - price_mobil -> price (format)
  /// - deskripsi -> description
  /// - kapasitas, tipe_mobil -> specifications (best-effort)
  /// - availableUnits -> selalu 1 (sesuai permintaan)
  static Future<List<JasaVehicle>> fetchJasaList({int limit = 50}) async {
    final supabase = Supabase.instance.client;

    final res = await supabase
        .from('jasa')
        .select(
          'id_jasa, owner_id, nama_jasa, tipe_mobil, price_mobil, price_km, gambar, status, alamat, kecamatan, kota, nomor_hp, nomor_plat, kapasitas, deskripsi',
        )
        .eq('status', 'aktif')
        .order('id_jasa', ascending: false)
        .limit(limit);

    final list = (res as List?) ?? <dynamic>[];

    return list.map<JasaVehicle>((item) {
      final id = item['id_jasa'] as int?;
      final name = (item['nama_jasa'] ?? '').toString();
      final address = (item['alamat'] ?? '').toString();

      // gambar: text[]
      String imageUrl = _defaultImage;
      final gambar = item['gambar'];
      if (gambar is List && gambar.isNotEmpty) {
        final first = gambar.first;
        if (first != null) {
          final s = first.toString();
          if (s.trim().isNotEmpty) {
            imageUrl = _decodeImage(s);
          }
        }
      } else if (gambar is String) {
        if (gambar.trim().isNotEmpty) {
          imageUrl = _decodeImage(gambar);
        }
      }

      final priceRaw = item['price_mobil'];
      num? priceNum;
      if (priceRaw is num) {
        priceNum = priceRaw;
      } else {
        priceNum = num.tryParse(priceRaw.toString());
      }

      // specs (best-effort)
      final tipeMobil = (item['tipe_mobil'] ?? '').toString().trim();
      final kapasitas = (item['kapasitas'] ?? '').toString().trim();
      final nomorPlat = (item['nomor_plat'] ?? '').toString().trim();

      final specs = <String>[];
      if (tipeMobil.isNotEmpty) specs.add(tipeMobil);
      if (kapasitas.isNotEmpty) specs.add(kapasitas);
      if (nomorPlat.isNotEmpty) specs.add('Plat: $nomorPlat');

      final description = (item['deskripsi'] ?? '').toString();

      return JasaVehicle(
        id: id,
        name: name,
        address: address,
        image: imageUrl,
        price: _formatPrice(priceNum),
        description: description,
        specifications: specs,
        availableUnits: 1,
      );
    }).toList();
  }
}
