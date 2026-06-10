import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/admin/history_model.dart';

class AdminHistoryController {
  final supabase = Supabase.instance.client;

  Future<List<HistoryItemModel>> getHistoryItems() async {
    final List<HistoryItemModel> result = [];

    try {
      // 1️⃣ Ambil kost yang sudah diapprove/ditolak
      final kostRes = await supabase
          .from('kost')
          .select('id_kost, nama_kost, status, profiles!inner(username, full_name)')
          .inFilter('status', ['aktif', 'ditolak'])
          .order('id_kost', ascending: false);

      for (var k in (kostRes as List)) {
        final status = k['status'] as String;
        final namaKost = k['nama_kost'] ?? '-';
        final profile = k['profiles'] as Map<String, dynamic>?;
        final fullName = (profile?['full_name'] ?? '').toString();
        final username = (profile?['username'] ?? '').toString();
        final ownerName = fullName.isNotEmpty ? fullName : username;

        result.add(HistoryItemModel(
          id: k['id_kost'].toString(),
          title: status == 'aktif'
              ? 'Kos "$namaKost" disetujui'
              : 'Kos "$namaKost" ditolak',
          subtitle: 'Pemilik: $ownerName',
          date: '-',
          icon: status == 'aktif' ? Icons.check_circle : Icons.cancel,
          iconColor:
              status == 'aktif' ? Colors.green : Colors.red,
          type: 'kos',
          status: status,
        ));
      }

      // 2️⃣ Ambil jasa yang sudah diapprove/ditolak
      final jasaRes = await supabase
          .from('jasa')
          .select('id_jasa, nama_jasa, status, profiles!inner(username, full_name)')
          .inFilter('status', ['aktif', 'ditolak'])
          .order('id_jasa', ascending: false);

      for (var j in (jasaRes as List)) {
        final status = j['status'] as String;
        final namaJasa = j['nama_jasa'] ?? '-';
        final profile = j['profiles'] as Map<String, dynamic>?;
        final fullName = (profile?['full_name'] ?? '').toString();
        final username = (profile?['username'] ?? '').toString();
        final ownerName = fullName.isNotEmpty ? fullName : username;

        result.add(HistoryItemModel(
          id: j['id_jasa'].toString(),
          title: status == 'aktif'
              ? 'Jasa "$namaJasa" disetujui'
              : 'Jasa "$namaJasa" ditolak',
          subtitle: 'Pemilik: $ownerName',
          date: '-',
          icon: status == 'aktif' ? Icons.check_circle : Icons.cancel,
          iconColor:
              status == 'aktif' ? Colors.green : Colors.red,
          type: 'jasa',
          status: status,
        ));
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }

    return result;
  }

  List<String> getTabs() {
    return ['Semua', 'Kos', 'Jasa'];
  }
}