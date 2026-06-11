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

    return decoded;
  }

  /// Fetch daftar jasa aktif dari Supabase.
  /// Mengambil semua kolom relevan kecuali price_mobil.
  static Future<List<JasaVehicle>> fetchJasaList({int limit = 50}) async {
    final supabase = Supabase.instance.client;

    final res = await supabase
        .from('jasa')
        .select(
          'id_jasa, owner_id, nama_jasa, tipe_mobil, price_km, gambar, '
          'status, alamat, kecamatan, kota, nomor_hp, nomor_plat, kapasitas, deskripsi',
        )
        .eq('status', 'aktif')
        .order('id_jasa', ascending: false)
        .limit(limit);

    final list = (res as List?) ?? <dynamic>[];

    return list.map<JasaVehicle>((item) {
      final id = item['id_jasa'] as int?;
      final ownerId = item['owner_id']?.toString();
      final status = (item['status'] ?? 'aktif').toString();
      final name = (item['nama_jasa'] ?? '').toString();
      final address = (item['alamat'] ?? '').toString();
      final kecamatan = (item['kecamatan'] ?? '').toString().trim();
      final kota = (item['kota'] ?? '').toString().trim();
      final nomorHp = (item['nomor_hp'] ?? '').toString().trim();
      final nomorPlat = (item['nomor_plat'] ?? '').toString().trim();
      final description = (item['deskripsi'] ?? '').toString();

      // gambar: text[]
      String imageUrl = _defaultImage;
      final gambar = item['gambar'];
      if (gambar is List && gambar.isNotEmpty) {
        final first = gambar.first;
        if (first != null && first.toString().trim().isNotEmpty) {
          imageUrl = _decodeImage(first.toString());
        }
      } else if (gambar is String && gambar.trim().isNotEmpty) {
        imageUrl = _decodeImage(gambar);
      }

      // price_km
      final priceRaw = item['price_km'];
      num? priceNum;
      if (priceRaw is num) {
        priceNum = priceRaw;
      } else {
        priceNum = num.tryParse(priceRaw.toString());
      }

      // Spesifikasi dari tipe_mobil dan kapasitas
      final tipeMobil = (item['tipe_mobil'] ?? '').toString().trim();
      final kapasitas = (item['kapasitas'] ?? '').toString().trim();
      final specs = <String>[];
      if (tipeMobil.isNotEmpty) specs.add(tipeMobil);
      if (kapasitas.isNotEmpty) specs.add('$kapasitas kg');

      return JasaVehicle(
        id: id,
        ownerId: ownerId,
        status: status,
        name: name,
        address: address,
        kecamatan: kecamatan,
        kota: kota,
        image: imageUrl,
        price: _formatPrice(priceNum),
        description: description,
        specifications: specs,
        nomorHp: nomorHp,
        nomorPlat: nomorPlat,
      );
    }).toList();
  }
}